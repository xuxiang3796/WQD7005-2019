import psycopg2
from configparser import ConfigParser
import locale
import logging
import re

# Setup the log level
logging.basicConfig(level=logging.INFO)

locale.setlocale( locale.LC_ALL, 'en_US.UTF-8' )

INSERT_LINK_SQL = '''INSERT INTO Stocks_link (symbol, link, sector) VALUES (%s,%s,%s);'''
INSERT_STOCK_PRICES = '''INSERT INTO stock_prices (date, time, stock_code, open, high, low, close, vol, buy_vol, 
        sell_vol) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s) '''
INSERT_FINANCIAL = '''INSERT INTO financial_results (stock_code, date_announced, financial_year_end, quarter, 
        period_end, revenue, profit_loss, eps) VALUES (%s, %s, %s, %s, %s, %s, %s, %s)'''
INSERT_COMPANY = '''INSERT INTO company_details (stock_code, stock_symbol, company_name, url, sector) VALUES (
                    %s, %s, %s, %s, %s);'''
INSERT_DIVIDEND = '''INSERT INTO stock_dividend (stock_code, date_announced, to_registered, paid_on, dividend, 
                     ex_dates) VALUES (%s, %s, %s, %s, %s, %s);'''
INSERT_SHARE_BUYBACK = '''INSERT INTO share_buyback (stock_code, buyback_date, shares_acquired, price_range, 
                           total_amount_paid, total_treasure_share) VALUES (%s, %s, %s, %s, %s, %s);'''
VIEW_STOCK_LINK = '''SELECT * FROM stocks_link;'''
VIEW_COMPANY_DETAILS = '''SELECT * FROM company_details;'''
VIEW_STOCK_PRICES = '''SELECT * FROM stock_prices;'''
VIEW_FINANCIAL = '''SELECT * FROM financial_results;'''
VIEW_DIVIDEND = '''SELECT * FROM stock_dividend;'''
VIEW_SHARE_BUYBACL = '''SELECT * FROM share_buyback;'''
# TRUNCATE_COMPANY_DETAILS = '''TRUNCATE TABLE company_details RESTART IDENTITY;'''
# TRUNCATE_STOCKS_PRICES = '''TRUNCATE TABLE stock_prices RESTART IDENTITY;'''
# TRUNCATE_FINANCIAL = '''TRUNCATE TABLE financial_results RESTART IDENTITY;'''
CREATE_STOCKS_LINK_TABLE = '''DROP TABLE IF EXISTS stock_link;
    CREATE TABLE stock_link (
        symbol TEXT NOT NULL PRIMARY KEY,
        link TEXT,
        sector TEXT
        );
'''
CREATE_COMPANY_DETAILS_TABLE = '''DROP TABLE IF EXISTS company_details;
    CREATE TABLE company_details (
        stock_code TEXT PRIMARY KEY,
        stock_symbol TEXT,
        company_name TEXT,
        url TEXT,
        sector TEXT
    );
'''
CREATE_STOCK_PRICES_TABLE = '''DROP TABLE IF EXISTS stock_prices;
    CREATE TABLE stock_prices (
        stock_price_id SERIAL, 
        date DATE NOT NULL,
        time TIME NOT NULL,
        stock_code TEXT NOT NULL,
        open FLOAT(3),
        high FLOAT(3),
        low FLOAT(3),
        close FLOAT(3),
        vol INTEGER,
        buy_vol TEXT,
        sell_vol TEXT,
        PRIMARY KEY (date, time, stock_code)
        );  
'''
CREATE_FINANCIAL_TABLE = '''DROP TABLE IF EXISTS financial_results;
    CREATE TABLE financial_results (
        financial_id SERIAL PRIMARY KEY,
        stock_code TEXT,
        date_announced DATE,
        financial_year_end DATE,
        quarter INTEGER,
        period_end DATE,
        revenue NUMERIC,
        profit_loss NUMERIC,
        eps FLOAT(2)
        );
'''
CREATE_DIVIDEND_TABLE = '''DROP TABLE IF EXISTS stock_dividend;
    CREATE TABLE stock_dividend (
        dividend_id SERIAL PRIMARY KEY,
        stock_code TEXT,
        date_announced DATE,
        to_registered DATE,
        paid_on DATE,
        dividend TEXT,
        ex_dates DATE
    );
'''
CREATE_SHARE_BUYBACK_TABLE='''DROP TABLE IF EXISTS share_buyback;
    CREATE TABLE share_buyback (
        share_buyback_id SERIAL PRIMARY KEY,
        stock_code TEXT,
        buyback_date DATE,
        shares_acquired NUMERIC,
        price_range NUMERIC,
        total_amount_paid NUMERIC,
        total_treasure_share NUMERIC
    );
'''

class DbOperations:
    def __init__(self, configfile='database.ini', section='postgresql'):
        # Create a parser
        parser = ConfigParser()
        # Read the config file
        parser.read(configfile)

        # Get section, default to postgresql
        db = {}
        if parser.has_section(section):
            logging.info('Reading database config file')
            params = parser.items(section)
            for param in params:
                db[param[0]] = param[1]
        else:
            logging.error('Section {0} not found in {1} file'. format(section, configfile))

        logging.info('Connecting to database...')
        self.conn = psycopg2.connect(**db)

    def create_table(self, create_script):
        """
        Create a database table
        :param create_script: sql script to create the table
        :return: void
        """
        cur = self.conn.cursor()
        cur.execute(create_script)

    def insert_symlink(self, symbol, link, sector):
        """
        Insert a record into the stocks_link table
        :param symbol: stock symbol
        :param link: the link to the stock page
        :param sector: sector of the stock
        :return: void
        """
        cur = self.conn.cursor()
        cur.execute(INSERT_LINK_SQL, (symbol, link, sector))

    def insert_stock_prices(self, date, time, code, open, high, low, close, vol, buy_vol, sell_vol):
        """
        Inserting a stock details into stock table
        :param date: date last updated
        :param time: time last updated
        :param code: the code of the company in KLSE
        :param open: the opening price of the stock on that day
        :param high: the highest price of the stock on that day
        :param low: the lowest price of the stock on that day
        :param close: the closing price of the stock on that day
        :param vol: the volume of the stock on that day
        :param buy_vol: the stock volume bought on that day
        :param sell_vol: the stock volume sold on that day
        :return: void
        """
        cur = self.conn.cursor()
        try:
            cur.execute(INSERT_STOCK_PRICES, (date, time, code, open, high, low, close, clean_comma_num(vol),
                                              buy_vol, sell_vol))
            self.conn.commit()
        except psycopg2.IntegrityError as e:
            logging.error('Record {0}, {1}, {2} already exists.'.format(date, time, code))
            self.conn.rollback()

    def insert_financial(self, code, financial):
        """
        Insert the financial results into database
        :param code: the stock code
        :param financial: a list that contains the financial results
        :return:
        """
        cur = self.conn.cursor()
        try:
            cur.execute(INSERT_FINANCIAL, (code, financial[0], financial[1], financial[2], financial[3],
                                           clean_comma_num(financial[4]), clean_comma_num(financial[5]), financial[6]))
            self.conn.commit()
        except (ValueError, IndexError) as e:
            logging.error('The record may have some empty values. Skipped.')
            self.conn.rollback()

    def insert_company(self, code, sym, name, link, sector):
        cur = self.conn.cursor()
        try:
            cur.execute(INSERT_COMPANY, (code, sym, name, link, sector))
            self.conn.commit()
        except psycopg2.IntegrityError as e:
            logging.error('Record {0} already exists'.format(code))
            self.conn.rollback()

    def insert_dividend(self, code, dividend):
        """
        Insert dividend information into database table
        :param code: stock code
        :param dividend: a list that contains the dividend information
        :return:
        """
        cur = self.conn.cursor()
        cur.execute(INSERT_DIVIDEND, (code, dividend[0], dividend[1], dividend[2], dividend[3], dividend[4]))

    def insert_share_buyback(self, code, buyback):
        """
        Insert share buyback information into database table
        :param code: stock_code
        :param buyback: a list that contain the buyback information
        :return:
        """
        cur = self.conn.cursor()
        cur.execute(INSERT_SHARE_BUYBACK, (code, dash_str(buyback[0]), str_to_float(dash_str(buyback[1], 0)),
                                           dash_str(buyback[2], 0), str_to_float(dash_str(buyback[3], 0)),
                                           str_to_float(dash_str(buyback[4], 0))))

    def view_table(self, select_script):
        """
        View the content of a table
        :param select_script: the sql script to select items from the table
        :return: the list of records
        """
        cur = self.conn.cursor()
        cur.execute(select_script)
        result = cur.fetchall()
        return result

    def clear_table(self, truncate_script):
        """
        Clear all the content of the table
        :param truncate_script: the sql script to truncate the table
        :return: void
        """
        cur = self.conn.cursor()
        cur.execute(truncate_script)

    def close_conn(self):
        """
        Commit and close the database connection
        :return: void
        """
        logging.info('Committing changes and close database connection.')
        self.conn.commit()
        self.conn.close()


def clean_comma_num(numstr):
    if type(numstr) is int:
        return numstr
    else:
        return locale.atoi(numstr)


def str_to_float(str):
    """
    Change number in string to float. Remove the comma and convert to float
    :param str: number in string
    :return: float
    """
    num = re.sub(',', '', str)
    return float(num)


def dash_str(dash_str, is_date = 1):
    """
    If the date is '-', handle this kind of NA
    :param date_str: possible dash or date
    :return:
    """
    if dash_str == '-' and is_date == 1:
        return '1 Jan 2001'
    elif dash_str == '-' and is_date == 0:
        return '0'
    else:
        return dash_str


def is_it_code(code, name):
    if re.match('^\d', code) and len(code) < 7:
        return code
    else:
        return name


def main():
    db_op = DbOperations()
    # Create tables
    # db_op.create_table(DROP_STOCKS_LINK_TABLE, CREATE_STOCKS_LINK_SQL)
    # db_op.create_table(DROP_STOCKS_TABLE, CREATE_STOCKS_TABLE)
    # db_op.create_table(CREATE_FINANCIAL_TABLE)

    # Record inserting test
    # db_op.insert_symlink('sapura2', 'star/business/sapura', 'sector')
    # db_op.insert_stocks('28 Feb 2019', '5:00 pm', '5211', 'sapura holdings', 10.0, 1.20, 1.01, 1.15, 12500,
    #                     '0.101 / 125', '0.111 / 153')

    # Truncate the table
    # db_op.clear_table(TRUNCATE_FINANCIAL)
    # db_op.clear_table(TRUNCATE_STOCKS)

    # Viewing the records in the table
    # records = db_op.view_table(VIEW_STOCKS)
    # records = db_op.view_table(VIEW_STOCKS_LINK)
    # print(len(records))
    # for record in records:
    #     print(record)
    db_op.close_conn()


if __name__ == '__main__':
    main()
