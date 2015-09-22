# EBS-Work
This is just an archive of programming projects that I underwent for a specific organization.

Folders:
* Class Page Scraper:
This program helps users download all pdfs, word, pages, and etc documents from a course page where they are all hosted. This page lacks a download all button or really any batch downloading ability so I wrote one. It downloads the topics pages.
Requirements:
Selenium for python3.4 and bs4 for python3.4

Usage:
./classpagescrape.py username password courseurl
*Scrips:
These are random scripts that run through jss. They bind computers to servers, add printers, disable notifications, and several other things. What they all do should be fairly obvious.
*extension_attribute_scripts
These are random scripts that I wrote that run through jss's extension attributes features. They run some actions, collect the results, and then feed the results to jss. The results then turn into new attributes for computers (e.g. Does the machine have excel properly installed?). The results are alwalys enclosed in a command that looks like this: "echo "<result> result goes here <\result>""

