from lxml import html
import requests
from DbOperations import *
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
            element = tree.xpath('//*[@id="slcontent_0_ileft_0_stockprofile_financialresult_tblFinancial"]/tr/td//text()')
            return element
        except IndexError:
            return None


class Financial:
    # Revenue and profit_loss is in '000
    # eps is earnings per share
    def __init__(self, date_announced, financial_year_end, quarter, period_end, revenue, profit_loss, eps):
        self.date_announced = date_announced
        self.financial_year_end = financial_year_end
        self.quarter = quarter
        self.period_end = period_end
        self.revenue = revenue
        self.profit_loss = profit_loss
        self.eps = eps

    def __str__(self):
        return "Date announced: " + str(self.date_announced).strip() + "\n" + "Financial year end: " + \
               str(self.financial_year_end).strip() + "\n" + "Quarter: " + str(self.quarter).strip() + "\n" + \
               "Period_end: " + str(self.period_end).strip() + "\n" + "Revenue: " + str(self.revenue).strip()+ \
               ",000" + "\n" + "Profit and Loss: " + str(self.profit_loss).strip() + ",000" + "\n" + "EPS: " + \
               str(self.eps).strip() + "\n"


def split_financial_list(list_string):
    financial_list = [list_string[x:x + 7] for x in range(0, len(list_string), 7)]
    return financial_list


def main():
    start_time = time.time()
    crawler = AppCrawler(0)
    db_op = DbOperations()
    list_of_stocks = db_op.view_table(VIEW_COMPANY_DETAILS)

    for details in list_of_stocks:
        logging.info('Scraping %s', details[3])
        s = crawler.crawl(details[3])
        if s is None:
            logging.info('link invalid')
        else:
            financial = split_financial_list(s)
            for f in financial:
                db_op.insert_financial(details[0], f)

    db_op.close_conn()
    end_time = time.time()
    print('Elapsed time: {:.2f} minutes'.format((end_time - start_time) / 60))

if __name__ == '__main__':
    main()
