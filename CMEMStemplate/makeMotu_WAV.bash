#!/bin/bash

\rm -r data_WAV
mkdir data_WAV

datesFile="dates.txt"
motuFile="motu.bash"

grep "\S" dates.txt > dum
mv dum dates.txt

cutoffDate=`grep WAV cutoffDates.txt | cut -d ',' -f2`
echo "cutoffDate $cutoffDate"


\rm $motuFile
echo 'source ~/.runPycnal' > $motuFile

lonmin=`grep lonmin latlon.txt | cut -d '=' -f2`
lonmax=`grep lonmax latlon.txt | cut -d '=' -f2`
latmin=`grep latmin latlon.txt | cut -d '=' -f2`
latmax=`grep latmax latlon.txt | cut -d '=' -f2`
echo "$lonmin  $lonmax"
echo "$latmin  $latmax"


part1a='python -m motuclient --motu '
part1b=' --service-id '

part2=' --longitude-min '$lonmin' --longitude-max '$lonmax' --latitude-min '$latmin' --latitude-max '$latmax

part4a=' --variable VHM0 --variable VTM10 --variable VTM02 --variable VMDR --variable VSDX --variable VSDY --variable VHM0_WW --variable VTM01_WW --variable VMDR_WW  '
part4b=' --variable VHM0_SW1 --variable VTM01_SW1 --variable VMDR_SW1 --variable VHM0_SW2 --variable VTM01_SW2 --variable VMDR_SW2 --variable VPED --variable VTPK '

part5=' --out-dir ./data_WAV '


part7=' --user jpender --pwd hiphopCMEMS3~'


echo $part1
echo $part2
echo $part4
echo $part5



while read line
do
    date=`echo $line | cut -d ',' -f1`
    day=`echo $line | cut -d ',' -f4`
    year=`echo $line | cut -d '-' -f1`
    day1900=`echo $line | cut -d ',' -f2`
    echo $day ' ' $date ' ' $day1900


	if [ $day1900 -lt $cutoffDate ]
	then
		sourceSite=" http://my.cmems-du.eu/motu-web/Motu "
		sourceFile=" GLOBAL_REANALYSIS_WAV_001_032-TDS --product-id global-reanalysis-wav-001-032 "
	else
		sourceSite=" http://nrt.cmems-du.eu/motu-web/Motu " 
		sourceFile=" GLOBAL_ANALYSIS_FORECAST_WAV_001_027-TDS --product-id global-analysis-forecast-wav-001-027 "
	fi

    part3=' --date-min "'$date' 12:00:00" --date-max "'$date' 12:00:00"'
    echo $part3
    part6=" --out-name CMEMS_WAV_"$year"_"$day".nc"
    echo $part6

	outFile="data_WAV/CMEMS_WAV_"$year"_"$day".nc"
	echo $outFile

    echo "while [ ! -f $outFile ]; do $part1a$sourceSite$part1b$sourceFile$part2$part3$part4a$part4b$part5$part6$part7; done" >> $motuFile
done <dates.txt
