#!/bin/bash

source ~/.runROMSintel

while read line
do
	echo $line > url.txt
	date=`echo $line |grep -Eo '[0-9]{8}' | head -1` 
	echo $date

	while [ ! -f MERRA*$date* ]
	do
		wget --load-cookies ~/.urs_cookies --save-cookies ~/.urs_cookies --auth-no-challenge=on --keep-session-cookies --content-disposition -i url.txt
	done
done < GES_input.txt
