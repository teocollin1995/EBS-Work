#!/bin/bash

cd /Users/
#define a teacher machine to be one with a user account that:
#starts with four letters
#ends with one number
TEACHERCOUNT=$( ls | egrep ^[A-Za-z]{4}[0-9]{1}$ | wc -l )

if [ $TEACHERCOUNT -eq 0 ]; then
    echo "<result>Non-Teacher</result>"
    exit 0
fi
    
echo "<result>Teacher</result>"
exit 0
