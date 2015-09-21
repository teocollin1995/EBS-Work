#!/bin/bash
cd /Applications/
#see if office and then excel are present using ls and error codes
cd Microsoft\ Office\ 2011/

if [ ! $? ]; then
    echo "<result>Excel is missing</result>"
    exit 0
fi

ls | grep "Microsoft Excel.app"
if [ ! $? ]; then
    echo "<result>Excel is missing</result>"
    exit 0
fi

echo "<result>Excel!</result>"
exit 0
