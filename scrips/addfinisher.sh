#!/bin/bash

cd /tmp/ #make a temp directory

for X in $( ls /etc/cups/ppd/ | grep opier.ppd); do #get all the copier ppds
    echo $X #read out the files
    cp /etc/cups/ppd/$X /tmp/$X #copy them to the temp directory
    sudo sed -i '' 's/*DefaultFinisher: None/*DefaultFinisher: StapleMH/g' $X
    #^replace the finisher config line with the correct finisher
    mv $X /etc/cups/ppd/$X #move them back into place
done

