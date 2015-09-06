#!/bin/bash
# Author_NICK : SmokingGauss

#How to use:
#open terminal
#cmd$ ./csvtojson.sh input.csv > output.json 
 
input=$1
## takes the input parameter
[ -z $1 ] && echo "GAUSS@ Error: CSV file not found" && exit 1

##checks for input file. 2nd and 3rd && parts are checked only if the value of first part is 0

[ ! -e $input ] && echo "GAUSS@ Error: couldn't find $1" && exit 1
## checks for input file

read first_line < $input         ## read command reads the first line
index=0                 
attributes=`echo $first_line | awk -F, {'print NF'}`
lines=`cat $input | wc -l`      ## -l: count lines

while [ $index -lt $attributes ]
do
        head_array[$index]=$(echo $first_line | awk -v x=$(($index + 1)) -F"," '{print $x}')
        index=$(($index+1))
done

## awk -v assigns value to specified variable

## creating the json file
ix=0
echo "{"
while [ $ix -lt $lines ]
do
        read each_line
        if [ $ix -ne 0 ]; then
                d=0
                echo -n "{"
                while [ $d -lt $attributes ]
                do
                        each_element=$(echo $each_line | awk -v y=$(($d + 1)) -F"," '{print $y}')
                        if [ $d -ne $(($attributes-1)) ]; then
                                echo -n ${head_array[$d]}":"$each_element","
                        else
                                echo -n ${head_array[$d]}":"$each_element
                        fi
                        d=$(($d+1))
                done
                if [ $ix -eq $(($lines-1)) ]; then
                        echo "}"
                else
                        echo "},"
                fi
        fi
        ix=$(($ix+1))
done < $input
echo "}"