#!/bin/bash

\rm -r data_PHY*
mkdir data_PHY

datesFile="dates.txt"
motuFile="motu.bash"


grep "\S" dates.txt > dum
mv dum dates.txt


cutoffDate=`grep PHY cutoffDates.txt | cut -d ',' -f2`
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
http://nrt.cmems-du.eu/motu-web/Motu 
part1b=' --service-id '


#  'GLOBAL_ANALYSIS_FORECAST_PHY_001_024-TDS --product-id global-analysis-forecast-phy-001-024 '
part2=' --longitude-min '$lonmin' --longitude-max '$lonmax' --latitude-min '$latmin' --latitude-max '$latmax

part4=' --depth-min 0.493 --depth-max 5727.918000000001 --variable thetao --variable so --variable zos --variable uo --variable vo'
part5=' --out-dir ./data_PHY '


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
		sourceFile=" GLOBAL_REANALYSIS_PHY_001_030-TDS --product-id global-reanalysis-phy-001-030-daily "
	else
		sourceSite=" http://nrt.cmems-du.eu/motu-web/Motu " 
		sourceFile=" GLOBAL_ANALYSIS_FORECAST_PHY_001_024-TDS --product-id global-analysis-forecast-phy-001-024  "
	fi

    part3=' --date-min "'$date' 12:00:00" --date-max "'$date' 12:00:00"'
    echo $part3
    part6=" --out-name CMEMS_PHY_"$year"_"$day".nc"
    echo $part6

	outFile="data_PHY/CMEMS_PHY_"$year"_"$day".nc"
	echo $outFile

    echo "while [ ! -f $outFile ]; do $part1a$sourceSite$part1b$sourceFile$part2$part3$part4$part5$part6$part7; done" >> $motuFile
done <dates.txt
