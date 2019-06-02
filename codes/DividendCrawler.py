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
            element = tree.xpath('//*[@id="slcontent_0_ileft_0_stockprofile_dividends_tblDividend"]/tr/td//text()')
            if len(element) == 0:
                return None
            return element
        except IndexError:
            return None


def split_dividend_list(list_string):
    dividend_list = [list_string[x:x + 5] for x in range(0, len(list_string), 5)]
    return dividend_list


def main():
    start_time = time.time()
    crawler = AppCrawler(0)
    db_op = DbOperations()
    list_of_stocks = db_op.view_table(VIEW_COMPANY_DETAILS)

    for details in list_of_stocks:
        logging.info('Scraping %s', details[3])
        s = crawler.crawl(details[3])
        if s is None:
            logging.info('Information unavailable')
        else:
            dividend = split_dividend_list(s)
            for stock_dividend in dividend:
                db_op.insert_dividend(details[0], stock_dividend)
    db_op.close_conn()
    end_time = time.time()
    print('Elapsed time: {:.2f} minutes'.format((end_time - start_time) / 60))


if __name__ == '__main__':
    main()
