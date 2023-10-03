#!/bin/bash

mkdir data_PHY

datesFile="dates.txt"
motuFile="motu.bash"

\rm $motuFile
echo 'source ~/.runPycnal' > $motuFile

lonmin=`grep lonmin latlon.txt | cut -d '=' -f2`
lonmax=`grep lonmax latlon.txt | cut -d '=' -f2`
latmin=`grep latmin latlon.txt | cut -d '=' -f2`
latmax=`grep latmax latlon.txt | cut -d '=' -f2`
echo "$lonmin  $lonmax"
echo "$latmin  $latmax"

year=`pwd | rev | cut -d '/' -f1 | rev | cut -d '_' -f2`
echo $year

dataSet="GLOBAL_REANALYSIS_PHY_001_030-TDS"
productID="global-reanalysis-phy-001-030-daily"

part1='python -m motuclient --motu http://my.cmems-du.eu/motu-web/Motu --service-id '$dataSet' --product-id '$productID' '
part2=' --longitude-min '$lonmin' --longitude-max '$lonmax' --latitude-min '$latmin' --latitude-max '$latmax

part4a=' --depth-min 0.493 --depth-max 5727.918000000001 --variable thetao --variable so --variable zos --variable uo --variable vo --variable mlotst '

# optional ice fields
#part4b=' --variable siconc --variable sithick --variable usi --variable vsi'
part4b=' '


part5=' --out-dir ./data_PHY '


part7=' --user jpender --pwd hiphopCMEMS3~'


echo $part1
echo $part2
echo $part4a
echo $part4b
echo $part5



while read line
do
    date=`echo $line | cut -d ',' -f1`
    day=`echo $line | cut -d ',' -f4`
    year=`echo $line | cut -d '-' -f1`
    echo $day ' ' $date
    part3=' --date-min "'$date' 12:00:00" --date-max "'$date' 12:00:00"'
    echo $part3

    outName=$dataSet"_"$year"_"$day".nc"

    part6=" --out-name $outName"
    echo $part6

    echo "while [ ! -f data_PHY/$outName ]"             		>> $motuFile
    echo 'do'                                           		>> $motuFile
    echo "$part1$part2$part3$part4a$part4b$part5$part6$part7"   >> $motuFile
    echo 'done'                                         		>> $motuFile
done <dates.txt
