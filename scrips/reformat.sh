#!/bin/bash
echo "reformatting disk"

diskutil partitionDisk /dev/disk0 GPT JHFS+ Macintosh\ HD 0b #parttion

if [ $? -ne 0 ]; then #check if something went wrong
    echo "something went horribly wrong!!!!!!!!"
    echo "Killing Casper Imaging" 
    ps -ef | grep "Casper Imaging" | head -n 1 | awk '{print $2}'| xargs kill 
    exit -1
fi

echo "disk reformat okay"
exit 0
