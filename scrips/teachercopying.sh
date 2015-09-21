#!/bin/bash #student copying is similar enough to ommit
cd /tmp
lpinfo -m > pdrive #get list of printer drivers
#set variables for the paths to the drivers that we need
TOSH1="Library/Printers/PPDs/Contents/Resources/TOSHIBA_ColorMFP_X7.gz TOSHIBA ColorMFP-X7"
TOSH2="Library/Printers/PPDs/Contents/Resources/en.lproj/TOSHIBA_ColorMFP_X7USA.gz TOSHIBA ColorMFP-X7 USA"
TOSH3="Library/Printers/PPDs/Contents/Resources/TOSHIBA_MonoMFP_X7.gz TOSHIBA MonoMFP-X7"
TOSH4="Library/Printers/PPDs/Contents/Resources/en.lproj/TOSHIBA_MonoMFP_X7USA.gz TOSHIBA MonoMFP-X7 USA"
#check for each driver like this:
cat pdrive | grep "$TOSH1" > /dev/null
if [ ! $? ]; then
    echo "Printer drivers missing"
    exit 1 
fi
cat pdrive | grep "$TOSH2" > /dev/null
if [ ! $? ]; then
    echo "Printer drivers missing"
    exit 1 
fi
cat pdrive | grep "$TOSH3" > /dev/null
if [ ! $? ]; then
    echo "Printer drivers missing"
    exit 1 
fi
cat pdrive | grep "$TOSH4" > /dev/null
if [ ! $? ]; then
    echo "Printer drivers missing"
    exit 1 
fi
echo "All drivers exist"

lpstat -a | grep opier | awk '{print $1}' > cucp #get a list of copier ppds

for X in $( cat cucp ); do
    lpadmin -x $X #remove all the copiers
done

#readd the copiers that we care about in such a manner:
echo "Installing College Copier"
lpadmin -p College_Copier -m /Library/Printers/PPDs/Contents/Resources/TOSHIBA_MonoMFP_X7.gz  -E -v socket://10.0.0.60
echo "Installed College Copier"
echo "Installing Hobbes Copier"
lpadmin -p Hobbes_Faculty_Lounge_Copier -m /Library/Printers/PPDs/Contents/Resources/TOSHIBA_MonoMFP_X7.gz  -E -v socket://10.0.0.59
echo "Installed Hobbes Copier"
echo "Installing Calvin Copier"
lpadmin -p Calvin_Faculty_Lounge_Copier -m /Library/Printers/PPDs/Contents/Resources/TOSHIBA_MonoMFP_X7.gz  -E -v socket://10.0.0.61
echo "Installed Calvin Copier"
echo "Installing Library Copier"
lpadmin -p Library_Copier -m /Library/Printers/PPDs/Contents/Resources/TOSHIBA_MonoMFP_X7.gz  -E -v socket://10.0.0.66
echo "Installed Library Copier"
echo "Installing Color Copier"
lpadmin -p Color_Copier -m /Library/Printers/PPDs/Contents/Resources/TOSHIBA_ColorMFP_X7.gz -E -v socket://10.0.0.63
echo "Installed Color Copier"

#set the finishers, see addfinisher.sh
cd /tmp/

for X in $( ls /etc/cups/ppd/ | grep opier.ppd); do
    echo $X
    cp /etc/cups/ppd/$X /tmp/$X
    sudo sed -i '' 's/*DefaultFinisher: None/*DefaultFinisher: StapleMH/g' $X
    mv $X /etc/cups/ppd/$X
done
