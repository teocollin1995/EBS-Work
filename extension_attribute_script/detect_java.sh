#!/bin/bash

java -version 

if [ ! $? ]; then
    echo "<result>Java is missing</result>"
    exit 0
fi

java -v #runs java version - returns error is jave DNE/not working

if [ ! $? ]; then #check for the error
    echo "<result>Java is missing</result>"
    exit 0
fi

echo "<result>Java</result>"
