import sys
from PySide import QtCore, QtGui, QtWebKit
from lxml import html, etree
from DbOperations import *
import logging

# Setup the log level
logging.basicConfig(level=logging.INFO)

# The first of the dividend on the side table on the website, a point to subset the stocks
STOP_POINT = 'METROD'

# Hardcoded sector and links
SECTOR_LINK = {
    'Energy': 'https://www.thestar.com.my/business/marketwatch/stock-list/?sector=main_energy',
    'Health care': 'https://www.thestar.com.my/business/marketwatch/stock-list/?sector=main_healthcare',
    'Technology': 'https://www.thestar.com.my/business/marketwatch/stock-list/?sector=main_technology',
    'Property': 'https://www.thestar.com.my/business/marketwatch/stock-list/?sector=main_property',
    'Utilities': 'https://www.thestar.com.my/business/marketwatch/stock-list/?sector=main_utilities',
    'Finance services': 'https://www.thestar.com.my/business/marketwatch/stock-list/?sector=main_finance',
    'Telecommunication and media': 'https://www.thestar.com.my/business/marketwatch/stock-list/?sector=main_telcomedia',
    'Consumer product and services': 'https://www.thestar.com.my/business/marketwatch/stock-list/?sector=main_consumer',
    'Construction': 'https://www.thestar.com.my/business/marketwatch/stock-list/?sector=main_construction',
    'Real Estate Investment Trust': 'https://www.thestar.com.my/business/marketwatch/stock-list/?sector=main_reits',
    'Industrial product and services': 'https://www.thestar.com.my/business/marketwatch/stock-list/?sector=main_indprod',
    'Plantation': 'https://www.thestar.com.my/business/marketwatch/stock-list/?sector=main_plantation',
    'Transportation and logistics': 'https://www.thestar.com.my/business/marketwatch/stock-list/?sector=main_transport',
    'Special purpose acquisition company': 'https://www.thestar.com.my/business/marketwatch/stock-list/?sector=main_specialpurposeact',
    'Closed end fund': 'https://www.thestar.com.my/business/marketwatch/stock-list/?sector=main_closedfund'
    }

PREFIX_URL = 'https://www.thestar.com.my'


# The MAGIC!
def load_page(page_url):
    page = QtWebKit.QWebPage()
    loop = QtCore.QEventLoop()  # Create event loop
    page.mainFrame().loadFinished.connect(loop.quit)  # Connect loadFinished to loop quit
    page.mainFrame().load(page_url)
    loop.exec_()  # Run event loop, it will end on loadFinished
    return page.mainFrame().toHtml()


app = QtGui.QApplication(sys.argv)


def clean_stocks(stocks_list):
    """
    Subset the extracted list into the list of stocks
    :param stocks_list: extracted list of stocks
    :return: a clean list of stocks
    """
    cleansed_stocks = []
    for i in range(0, len(stocks_list)):
        if i % 8 == 0:
            cleansed_stocks.append(stocks_list[i])

    return cleansed_stocks


def clean_links(links_list, length):
    """
    Clean or subset the extracted list of links into the needed list of links
    :param links_list: the extracted list of links
    :param length: the length of the clean stock list
    :return: a clean list of links
    """
    cleanLinks = links_list[:length]
    return cleanLinks


def main():
    db_op = DbOperations()
    # Loop the dictionary to crawl the list of stocks
    for sector, url in SECTOR_LINK.items():
        logging.info('Extracting %s with %s', sector, url)
        # This does the magic. Loads everything
        result = load_page(url)
        formatted_result = str(result.encode('UTF-8'))
        # Next build lxml tree from formatted result
        tree = html.fromstring(formatted_result)

        # Now using correct xpath we are fetching the URLs of the archive
        raw_stocks = tree.xpath('//tbody/tr[@class="linedlist"]/td//text()')
        raw_stocks = raw_stocks[:raw_stocks.index(STOP_POINT)]
        raw_stocks = raw_stocks[:int(len(raw_stocks) / 2)]
        raw_links = tree.xpath('//tr[@class="linedlist"]/td/a/@href')

        stocks_list = clean_stocks(raw_stocks)
        stocks_link = clean_links(raw_links, len(stocks_list))

        for sym, page_link in zip(stocks_list, stocks_link):
            db_op.insert_symlink(sym, PREFIX_URL + page_link, sector)
    db_op.close_conn()


if __name__ == '__main__':
    main()
