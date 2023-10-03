#!/bin/bash

mkdir data_SL

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

dataSet="SEALEVEL_GLO_PHY_L4_REP_OBSERVATIONS_008_047-TDS"
productID="dataset-duacs-rep-global-merged-allsat-phy-l4"

part1='python -m motuclient --motu http://my.cmems-du.eu/motu-web/Motu --service-id '$dataSet' --product-id '$productID' '

part2=' --longitude-min '$lonmin' --longitude-max '$lonmax' --latitude-min '$latmin' --latitude-max '$latmax

part4='  --variable sla --variable adt --variable ugos --variable vgos --variable ugosa --variable vgosa  '

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
    echo $day ' ' $date
    year=`echo $line | cut -d '-' -f1`
    part3=' --date-min "'$date' 00:00:00" --date-max "'$date' 00:00:00"'
    echo $part3

    outName=$dataSet"_"$year"_"$day".nc"

    part6=" --out-name $outName"
    echo $part6

    echo "while [ ! -f data_SL/$outName ]"             >> $motuFile
    echo 'do'                                           >> $motuFile
    echo "$part1$part2$part3$part4$part5$part6$part7" >> $motuFile
    echo 'done'                                           >> $motuFile
done <dates.txt
