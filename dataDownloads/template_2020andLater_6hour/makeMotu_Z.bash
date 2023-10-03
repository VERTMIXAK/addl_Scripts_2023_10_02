#!/bin/bash

dataDir="./data_Z/"

mkdir $dataDir
echo "dataDir = "  $dataDir

date1=`head -1 dates.txt`
echo $date1
nLine=`grep -n $date1 /import/home/jgpender/addl_Scripts/dayConverterCommas.txt | cut -d ':' -f1`
date0=`head -$nLine /import/home/jgpender/addl_Scripts/dayConverterCommas.txt | tail -2 | head -1`

echo $date0 > datesZ.txt
cat dates.txt >> datesZ.txt



datesFile="datesZ.txt"
motuFile="motuZ.bash"

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

dataSet="GLOBAL_ANALYSIS_FORECAST_PHY_001_024-TDS"
productID="global-analysis-forecast-phy-001-024-hourly-t-u-v-ssh"

part1='python -m motuclient --motu https://nrt.cmems-du.eu/motu-web/Motu --service-id  '$dataSet' --product-id '$productID' '
part2=' --longitude-min '$lonmin' --longitude-max '$lonmax' --latitude-min '$latmin' --latitude-max '$latmax

part4a=' --depth-min 0.494 --depth-max .4941 --variable zos  '

# optional ice fields
#part4b=' --variable siconc --variable sithick --variable usi --variable vsi'
part4b=' '


part5=' --out-dir ' 



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
    part3=' --date-min "'$date' 00:30:00" --date-max "'$date' 23:30:00"'
    echo $part3

    outName=$dataSet"_"$year"_"$day".nc"

    part6=" --out-name $outName"
    echo $part6

    echo "while [ ! -f $dataDir/$outName ]"             				>> $motuFile
    echo 'do'                                           				>> $motuFile
    echo "$part1$part2$part3$part4a$part4b$part5$dataDir$part6$part7"	>> $motuFile
    echo 'done'                                         				>> $motuFile
done <datesZ.txt
