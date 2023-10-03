#!/bin/bash

mkdir data_WAV

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

dataSet="GLOBAL_ANALYSIS_FORECAST_WAV_001_027-TDS"
productID="global-analysis-forecast-wav-001-027"

part1='python -m motuclient --motu https://nrt.cmems-du.eu/motu-web/Motu --service-id '$dataSet' --product-id '$productID' '
part2=' --longitude-min '$lonmin' --longitude-max '$lonmax' --latitude-min '$latmin' --latitude-max '$latmax

part4a=' --variable VHM0 --variable VTM10 --variable VTM02 --variable VMDR --variable VSDX --variable VSDY --variable VHM0_WW --variable VTM01_WW --variable VMDR_WW  '
part4b=' --variable VHM0_SW1 --variable VTM01_SW1 --variable VMDR_SW1 --variable VHM0_SW2 --variable VTM01_SW2 --variable VMDR_SW2 --variable VPED --variable VTPK '

part5=' --out-dir ./data_WAV '


part7=' --user jpender --pwd hiphopCMEMS3~'




while read line
do
    date=`echo $line | cut -d ',' -f1`
    day=`echo $line | cut -d ',' -f4`
    echo $day ' ' $date
    year=`echo $line | cut -d '-' -f1`
    part3=' --date-min "'$date' 00:00:00" --date-max "'$date' 21:00:00"'
    echo $part3

    outName=$dataSet"_"$year"_"$day".nc"

    part6=" --out-name $outName"
    echo $part6

    echo "while [ ! -f data_WAV/$outName ]"             >> $motuFile
    echo 'do'                                           >> $motuFile
    echo "$part1$part2$part3$part4a$part4b$part5$part6$part7" >> $motuFile
    echo 'done'                                         >> $motuFile
done <dates.txt

