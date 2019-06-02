from lxml import html
import requests
from DbOperations import *
from DbOperations import VIEW_COMPANY_DETAILS
import logging
import time

# Setup the log level
logging.basicConfig(level=logging.INFO)


class AppCrawler:
    def __init__(self, depth):
        self.depth = depth
        self.apps = []

    def crawl(self, url_param):
        return self.get_app_from_link(url_param)

    def get_app_from_link(self, link):
        start_page = requests.get(link)
        tree = html.fromstring(start_page.text)

        try:
            date = tree.xpath('//*[@id="slcontent_0_ileft_0_datetxt"]/text()')[0]
            time = tree.xpath('//*[@id="slcontent_0_ileft_0_timetxt"]/text()')[0]
            name = tree.xpath('//h1[@class="stock-profile f16"]/text()')[0]
            open_price = tree.xpath('//td[@id="slcontent_0_ileft_0_opentext"]/text()')[0]
            high = tree.xpath('//td[@id="slcontent_0_ileft_0_hightext"]/text()')[0]
            low = tree.xpath('//td[@id="slcontent_0_ileft_0_lowtext"]/text()')[0]
            close = tree.xpath('//td[@id="slcontent_0_ileft_0_lastdonetext"]/text()')[0]
            code = tree.xpath('//li[@class="f14"]/text()')[1]
            vol = tree.xpath('//*[@id="slcontent_0_ileft_0_voltext"]/text()')[0]
            buy_vol = tree.xpath('//*[@id="slcontent_0_ileft_0_buyvol"]/text()')[0]
            sell_vol = tree.xpath('//*[@id="slcontent_0_ileft_0_sellvol"]/text()')[0]

            stock = Stock(date[10: -2], time, name, code[3:], open_price, high, low, close, vol, buy_vol, sell_vol)
            return stock
        except IndexError:
            return None


class Stock:
    def __init__(self, date, time, name, code, open, high, low, close, vol, buy_vol, sell_vol):
        self.date = date
        self.time = time
        self.name = name
        self.code = code
        self.open = open
        self.high = high
        self.low = low
        self.close = close
        self.vol = vol
        self.buy_vol = buy_vol
        self.sell_vol = sell_vol

    def __str__(self):
        return "Stock: " + str(self.name).strip() + "\n" + "Stock Code: " + str(self.code).strip() + "\n" + \
               "Open: " + str(self.open).strip() + "\n" + "High: " + str(self.high).strip() + "\n" + "Low: " + \
               str(self.low).strip() + "\n" + "Close: " + str(self.close).strip() + "\n" + "Volume: " + \
               str(self.vol).strip() + "\n" + "Buy vol: " + str(self.buy_vol).strip() + "\n" + "Sell vol: " + \
               str(self.sell_vol).strip() + "\n" + "Date: " + str(self.date).strip() + "\n" + "Time: " + \
               str(self.time).strip() + "\n"


def clean_dash_num(dash_string):
    """
    Handle the NA value which is in '-'
    :param dash_string: possible dash or number
    :return: 0 or the original number
    """
    if dash_string == '-':
        return 0
    else:
        return dash_string


def main():
    start_time = time.time()
    crawler = AppCrawler(0)
    db_op = DbOperations()
    stocks_sym = db_op.view_table(VIEW_COMPANY_DETAILS)

    for details in stocks_sym:
        s = crawler.crawl(details[3])
        logging.info('Scraping %s', details[3])
        if s is None:
            logging.info('Link Invalid. Skipped.')
        else:
            db_op.insert_stock_prices(s.date, s.time, s.code, clean_dash_num(s.open), clean_dash_num(s.high),
                                      clean_dash_num(s.low), clean_dash_num(s.close), s.vol, s.buy_vol, s.sell_vol)
    db_op.close_conn()
    end_time = time.time()
    print('Elapsed time: {:.2f} minutes'.format((end_time - start_time) / 60))


if __name__ == '__main__':
    main()