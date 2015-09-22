# EBS-Work
This is just an archive of programming projects that I underwent for a specific organization.

Folders:
* Class Page Scraper:
This program helps users download all pdfs, word, pages, and etc documents from a course page where they are all hosted. This page lacks a download all button or really any batch downloading ability so I wrote one. It downloads the topics pages.
Requirements:
Selenium for python3.4 and bs4 for python3.4

Usage:
./classpagescrape.py username password courseurl

* Scrips:
These are random scripts that run through jss. They bind computers to servers, add printers, disable notifications, and several other things. What they all do should be fairly obvious. They all require root, which is okay as jss runs them as root. They can all be run manually like this:

Usage:

chmod u+x script

sudo ./script

* extension_attribute_scripts:
These are random scripts that I wrote that run through jss's extension attributes features. They run some actions, collect the results, and then feed the results to jss. The results then turn into new attributes for computers (e.g. Does the machine have excel properly installed?). The results are alwalys enclosed in a command that looks like this: "echo "<result> result goes here <\result>"" These can also be run manually.

*labquest_file_reader

This is a handy script for taking the data file a labquest produces, a .qmbl and converting it into a csv. The data and names of the columns are added to the csv. The csv can be opened in excel without issue and used without any modification. 

The script is used like this:

chmod u+x qmbltocsv.sh

./qmbltocsv.sh sample.qmbl > sample_result.csv 

(Replace sample with the name of the .qmbl file produced by the labquest). 

The folder contains both sample.qmbl and sample_result.csv.  