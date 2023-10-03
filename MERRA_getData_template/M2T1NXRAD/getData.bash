#!/bin/bash

while read line
do
	echo $line
	date=`echo $line |grep -Eo '[0-9]{8}'` 
	echo $date

	while [ ! -f MERRA*$date* ]
	do
		wget --load-cookies ~/.urs_cookies --save-cookies ~/.urs_cookies --auth-no-challenge=on --keep-session-cookies --content-disposition $line
	done

done < GES_input.txt

