#!/usr/bin/env python3.4
import requests
from bs4 import BeautifulSoup
from selenium import webdriver
from selenium.webdriver.common.keys import Keys
import time
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
import os
import random
import sys
#arguments:
username = sys.argv[1] 
password = sys.argv[2]
course_page = sys.argv[3]

#set prefrences: https://stackoverflow.com/questions/18954686/how-to-download-file-using-selenium
fp = webdriver.FirefoxProfile()
fp.set_preference("browser.download.folderList",2)
fp.set_preference("browser.download.manager.showWhenStarting",False)
fp.set_preference("browser.download.dir", os.getcwd())
fp.set_preference("browser.helperApps.neverAsk.saveToDisk",  'application/pdf')
#fp.set_preference("pdfjs.disabled", True)

driver = webdriver.Firefox(firefox_profile=fp) # set up the webdriver 

"""
So, we need a mechanism to see if a page has loaded completely before going on to do anything else.
I did some googling and I found a solution here:
http://www.obeythetestinggoat.com/how-to-get-selenium-to-wait-for-page-load-after-a-click.html
However, I've opted for something a bit more hacky... just in a diffrent way.
If you read https://selenium-python.readthedocs.org/waits.html,
you will find that it has an implict wait mechanism. This means that by setting:
"""
driver.implicitly_wait(10) # the implict wait to 10 seconds
"""
we instruct the browser to check to see if whatever we querry next with a call to something like "driver.find_element_by_xpath("//input[@id='Password']")"
for about 10 seconds. It will not continue past that instruction until it has been able to find something or until it
10 seconds has past in which case it will throw an exception.
Since I know the layout of this and the layout is rather simple, this is maintainable and easy to do.

"""
#Load login page 
driver.get("https://burkeschool.myschoolapp.com/app/#login")

#login information
webElement = driver.find_element_by_xpath("//input[@id='Username']")
webElement.send_keys(username)
webElement = driver.find_element_by_xpath("//input[@id='Password']")
webElement.send_keys(password)
webElement = driver.find_element_by_xpath("//input[@id='loginBtn']")
#time.sleep(4)  just so I can see it.
webElement.click()
webElement = driver.find_element_by_xpath("//div[@id='activity-stream']")
#we wait here to make sure the main page has laoded
#if the main page changes (about once every two year, but they have kept the activity stream since the start of time...), this will need to be changed


"""
 Topics:
https://burkeschool.myschoolapp.com/app/student#academicclass/2100248/0/topics
Based on this url, it is clear there is some structure to this:
https://burkeschool.myschoolapp.com/app/student - things the student can see
#academicclass - we are looking at an academic class - probably specified in search header
2100248 - an id for the class
0 - I don't know...
topics - clearly tell us we are in topics
Going into two adjacent topics we get this:
https://burkeschool.myschoolapp.com/app/student#topicdetail/24000/2100248/2100248/50507
https://burkeschool.myschoolapp.com/app/student#topicdetail/33422/2100248/2100248/82288
Obviously, #topicdetail is signfigant because we can use it to pick out what is relevant among a bunch of topic links
Otherwise, I have no idea about what any of those numbers mean except for the 2100248s, which tell us the related class

"""
#NOTE: WE NEED ERROR CHECKING
#given any class page url e.g topics or bulletinboard, get us topics:
class_page = course_page
base_link = class_page.split('#')[0] 
class_page = "/".join(class_page.split('/')[:-1]) + '/topics' # remove the last "/" and replace it with topics



driver.get(class_page)
driver.find_element_by_class_name('topic-detail-link') #another wait time 
topic_soup = BeautifulSoup(driver.page_source)
topic_links = [] # because variables

#finds all the topic boxes:
for x in topic_soup.find_all("a"):
    link = x.get('href')
    if('#topicdetail/' in link):
        topic_links.append(base_link + link)


def topic_detail_wait(browser):
    """
    At this point, we have run into something where neither avaliable implict nor avaliable explict waits will help us.
    Topics blocks are just so variable that there does not appear to be one single thing that I can check for the existence of.
    Moreover, I can't just check for a list of things. Instead, I'm going to check for convergance -
    that is I'm going to check if the overall number of possible items has remained constant for .5 seconds.
    If the waittime exceeds 10 seconds, we give up
    """
    constant = False
    clen_old = len(driver.find_elements_by_tag_name('a'))
    ctime = 0
    while not constant:
        time.sleep(.5)
        ctime += .5
        if(ctime >= 10):
            return False #throw exception instead but later
            
        clen_new = len(driver.find_elements_by_tag_name('a'))
        if(clen_new == clen_old):
            constant = True
        else:
            clen_old = clen_old

    return True

#types of files that we want to scrape:

driver.get(topic_links[0])
topic_detail_wait(driver)

def get_downloadables_from_topic(source):
    """
    Given a page source for a topics page, return all links that are specified as downloadable by having extensions in the membership of the list get
    """
    get = ['pdf', 'doc', 'docx', 'pages', 'jpg', 'png']
    download_targets = []
    for x in BeautifulSoup(source).find_all("a"):
        link = x.get('href')
        if(any(list(map(lambda x: x in link, get)))): #make .endswith?
            download_targets.append('https://burkeschool.myschoolapp.com' + link)
    return download_targets
#now we finally donload everything
for x in topic_links:
    print(x)
    time.sleep(2)
    driver.get(x)
    topic_detail_wait(driver)
    d = get_downloadables_from_topic(driver.page_source)
    #consider creating seperate directories/using multiple processes
    for y in d:
        print(y)
        name = y.split("/")[-1]
        command = "curl {0} > {1}".format(y,name)
        os.system(command) #c++ senses are enraged...
        #so horrible...
        r = random.uniform(0,1.6)
        print("Waiting {0} seconds".format(10 ** r))
        time.sleep(10 ** r)
        
        
    
#We have gotten all the topics!
driver.quit()




