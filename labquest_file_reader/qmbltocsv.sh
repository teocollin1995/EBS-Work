#!/bin/bash

#The following is a horrible abberoration...
#A horrible
#Horrible
#Horrible abboeration
#don't ever do things like this
#This is ugly
#EVIL

counter=1
col=$(  xmllint --xpath "string((//ColumnMatchTag)[1]/text())" $1)

#So, let's break this up
#The string() function makes a string. This is needed because --xpath requires a string, which is then treated as an xpath expression
#so, using this, we can pass an expath expression by by placing it within string()
#In this case, the expression reads:
#(//ColumMatchTag) -> the set of all xml nodes that are <ColumnMatchTag>
#[1] -> get the first from the set (Note the 1 based indexing)
# and /text() - get a text attribute assocaited with the node
#Lastly, the $1 is a filename. --xpath takes a string and a filename
#The purpose of this code is to get the very first column header.
# the code that follows exists to get all the columns headers and print them out in the first row of the csv


if [ "$col" == "" ]; then 
    exit 1
fi
stringlistoffiles="" 


echo -n "Col Stand in," #see my notes on bindfile around line 55

while [ "$col" != "" ]; do #the xpath expression will return nothing if we go out of bounds e.g if there are 6 in the set and we go to 7
    echo -n $col","  #print the first colum
    touch "unqmblextra"$counter #create a file to store the things under it
    stringlistoffiles=$stringlistoffiles"unqmblextra"$counter" "  #keep track of the file
    counter=$(($counter + 1)) #keep track of the number of files
    col=$(  xmllint --xpath "string((//ColumnMatchTag)["$counter"]/text())" $1) #get the next one
done 
echo ""

for ((fc=1; fc <= counter; fc++)) #now, we get the columns and put them into the file we created
{
    xmllint --xpath "string((//ColumnCells)["$fc"]/text())" $1 > "unqmblextra"$fc 
    #simmilar things but column data is stored under columncell nodes
}

largestlength=$(wc -l unqmblextra* | grep -v total | awk '{print $1}' | sort -nr | head -n 1) # get the column with the largest enteries
touch bindfile #create a dumby file containing 1 through thesize of the largest file to deal with the following problem
for ((x= 1; x <= largestlength; x++))
{
    echo $x >> bindfile
}
#so the paste command has a really stupid assumption in it
#it kind of assumes that the files are all the same length or that 
#the largest file comes first
#if this doesn't happen, the end result is ugly and nonsencial.
#so, we bind the dummy bindfile and the rest of the files.
#and there is no harm in leaving it


paste -d"," bindfile $stringlistoffiles
#clean up all the mess we made; note the results are just written to stdin
rm $stringlistoffiles
rm unqmblextra*
rm bindfile
