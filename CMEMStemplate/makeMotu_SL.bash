#!/bin/bash

\rm -r data_SL
mkdir data_SL

datesFile="dates.txt"
motuFile="motu.bash"

grep "\S" dates.txt > dum
mv dum dates.txt

cutoffDate=`grep SL cutoffDates.txt | cut -d ',' -f2`
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

part4='  --variable sla --variable adt --variable ugos --variable vgos --variable ugosa --variable vgosa --variable err '

part5=' --out-dir ./data_SL '

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
		sourceFile=" SEALEVEL_GLO_PHY_L4_REP_OBSERVATIONS_008_047-TDS --product-id dataset-duacs-rep-global-merged-allsat-phy-l4 "
	else
		sourceSite=" http://nrt.cmems-du.eu/motu-web/Motu " 
		sourceFile=" SEALEVEL_GLO_PHY_L4_NRT_OBSERVATIONS_008_046-TDS --product-id dataset-duacs-nrt-global-merged-allsat-phy-l4 "
	fi

    part3=' --date-min "'$date' 00:00:00" --date-max "'$date' 00:00:00"'
    echo $part3
    part6=" --out-name CMEMS_SL_"$year"_"$day".nc"
    echo $part6

	outFile="data_SL/CMEMS_SL_"$year"_"$day".nc"
	echo $outFile

    echo "while [ ! -f $outFile ]; do $part1a$sourceSite$part1b$sourceFile$part2$part3$part4$part5$part6$part7; done" >> $motuFile
done <dates.txt
