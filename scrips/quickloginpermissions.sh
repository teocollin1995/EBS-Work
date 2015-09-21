#!/bin/bash


cd /Applications/

IFS=$'\n'
for X in $( ls ); do #this loop makes every single app inccessible to quicklogin
    echo "$X"
    sudo chmod -R +a "quicklogin deny execute" "$X" 
done
#This part manually makes certain apps accesible to quicklogin
sudo chmod -R -a "quicklogin deny execute" Microsoft\ Office\ 2011/
sudo chmod -R -a "quicklogin deny execute" Google\ Chrome.app Firefox.app Safari.app
sudo chmod -R -a "quicklogin deny execute" DataStudio.app Google\ Earth\ Pro.app Tracker.app
