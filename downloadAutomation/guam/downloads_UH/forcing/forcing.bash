#!/bin/bash

\rm *.nc*


tStart=`date --date="-15 day" "+%Y-%m-%d"`
echo $tStart
tEnd=`date --date="+15 day" "+%Y-%m-%d"`
echo $tEnd

source ~/.runROMSintel


part1='http://pae-paha.pacioos.hawaii.edu/thredds/ncss/wrf_guam/WRF_Guam_Regional_Atmospheric_Model_best.ncd?var='

part2='&disableLLSubset=on&disableProjSubset=on&horizStride=1&time_start='

part3='T00%3A00%3A00Z&time_end='

part4='T00%3A00%3A00Z&timeStride=1&addLatLon=true'




myVar='Pair'
timeVar='pair_time'
echo "$part1$myVar$part2$tStart$part3$tEnd$part4" > url.txt
wget -O $myVar.nc_ORIG -i url.txt
date=`ncdump -h $myVar.nc_ORIG  | grep time:units | rev | tr ' ' ',' | cut -d ',' -f4 | rev`
dayNumber=`grep $date ~/arch/addl_Scripts/dayConverterCommas.txt | cut -d ',' -f2`
echo "date $date   dayNumber $dayNumber"

source ~/.runPycnal
python settime.py $myVar.nc_ORIG $dayNumber time
python rescalePair.py $myVar.nc_ORIG $myVar
source ~/.runROMSintel

ncrename -O -h -d time,$timeVar                                     	$myVar.nc_ORIG
ncrename -O -h -v time,$timeVar                                    		$myVar.nc_ORIG
ncatted -O -a units,$timeVar,o,c,"days since 1900-01-01 00:00:00"     	$myVar.nc_ORIG


## begin comment
#: '


myVar='Tair'
timeVar='tair_time'
echo "$part1$myVar$part2$tStart$part3$tEnd$part4" > url.txt
wget -O $myVar.nc_ORIG -i url.txt
date=`ncdump -h $myVar.nc_ORIG  | grep time:units | rev | tr ' ' ',' | cut -d ',' -f4 | rev`
dayNumber=`grep $date ~/arch/addl_Scripts/dayConverterCommas.txt | cut -d ',' -f2`
echo "date $date   dayNumber $dayNumber"
source ~/.runPycnal
python settime.py $myVar.nc_ORIG $dayNumber time
source ~/.runROMSintel
ncrename -O -h -d time,$timeVar                                         $myVar.nc_ORIG
ncrename -O -h -v time,$timeVar                                         $myVar.nc_ORIG
ncatted -O -a units,$timeVar,o,c,"days since 1900-01-01 00:00:00"	$myVar.nc_ORIG


myVar='Qair'
timeVar='qair_time'
echo "$part1$myVar$part2$tStart$part3$tEnd$part4" > url.txt
wget -O $myVar.nc_ORIG -i url.txt
date=`ncdump -h $myVar.nc_ORIG  | grep time:units | rev | tr ' ' ',' | cut -d ',' -f4 | rev`
dayNumber=`grep $date ~/arch/addl_Scripts/dayConverterCommas.txt | cut -d ',' -f2`
echo "date $date   dayNumber $dayNumber"

source ~/.runPycnal
python settime.py $myVar.nc_ORIG $dayNumber time
python rescaleQair.py $myVar.nc_ORIG  $myVar
source ~/.runROMSintel

ncrename -O -h -d time,$timeVar                                         $myVar.nc_ORIG
ncrename -O -h -v time,$timeVar                                         $myVar.nc_ORIG
ncatted -O -a units,$timeVar,o,c,"days since 1900-01-01 00:00:00"	$myVar.nc_ORIG


myVar='Uwind'
timeVar='wind_time'
echo "$part1$myVar$part2$tStart$part3$tEnd$part4" > url.txt
wget -O $myVar.nc_ORIG -i url.txt
date=`ncdump -h $myVar.nc_ORIG  | grep time:units | rev | tr ' ' ',' | cut -d ',' -f4 | rev`
dayNumber=`grep $date ~/arch/addl_Scripts/dayConverterCommas.txt | cut -d ',' -f2`
echo "date $date   dayNumber $dayNumber"
source ~/.runPycnal
python settime.py $myVar.nc_ORIG $dayNumber time
source ~/.runROMSintel
ncrename -O -h -d time,$timeVar                                         $myVar.nc_ORIG
ncrename -O -h -v time,$timeVar                                         $myVar.nc_ORIG
ncatted -O -a units,$timeVar,o,c,"days since 1900-01-01 00:00:00"       $myVar.nc_ORIG


myVar='Vwind'
timeVar='wind_time'
echo "$part1$myVar$part2$tStart$part3$tEnd$part4" > url.txt
wget -O $myVar.nc_ORIG -i url.txt
date=`ncdump -h $myVar.nc_ORIG  | grep time:units | rev | tr ' ' ',' | cut -d ',' -f4 | rev`
dayNumber=`grep $date ~/arch/addl_Scripts/dayConverterCommas.txt | cut -d ',' -f2`
echo "date $date   dayNumber $dayNumber"
source ~/.runPycnal
python settime.py $myVar.nc_ORIG $dayNumber time
source ~/.runROMSintel
ncrename -O -h -d time,$timeVar                                         $myVar.nc_ORIG
ncrename -O -h -v time,$timeVar                                         $myVar.nc_ORIG
ncatted -O -a units,$timeVar,o,c,"days since 1900-01-01 00:00:00"	$myVar.nc_ORIG


myVar='lwrad_down'
timeVar='lrf_time'
echo "$part1$myVar$part2$tStart$part3$tEnd$part4" > url.txt
wget -O $myVar.nc_ORIG -i url.txt
date=`ncdump -h $myVar.nc_ORIG  | grep time:units | rev | tr ' ' ',' | cut -d ',' -f4 | rev`
dayNumber=`grep $date ~/arch/addl_Scripts/dayConverterCommas.txt | cut -d ',' -f2`
echo "date $date   dayNumber $dayNumber"
source ~/.runPycnal
python settime.py $myVar.nc_ORIG $dayNumber time
source ~/.runROMSintel
ncrename -O -h -d time,$timeVar                                         $myVar.nc_ORIG
ncrename -O -h -v time,$timeVar                                         $myVar.nc_ORIG
ncatted -O -a units,$timeVar,o,c,"days since 1900-01-01 00:00:00"	$myVar.nc_ORIG


myVar='rain'
timeVar='rain_time'
echo "$part1$myVar$part2$tStart$part3$tEnd$part4" > url.txt
wget -O $myVar.nc_ORIG -i url.txt
date=`ncdump -h $myVar.nc_ORIG  | grep time:units | rev | tr ' ' ',' | cut -d ',' -f4 | rev`
dayNumber=`grep $date ~/arch/addl_Scripts/dayConverterCommas.txt | cut -d ',' -f2`
echo "date $date   dayNumber $dayNumber"
source ~/.runPycnal
python settime.py $myVar.nc_ORIG $dayNumber time
source ~/.runROMSintel
ncrename -O -h -d time,$timeVar                                         $myVar.nc_ORIG
ncrename -O -h -v time,$timeVar                                         $myVar.nc_ORIG
ncatted -O -a units,$timeVar,o,c,"days since 1900-01-01 00:00:00"	$myVar.nc_ORIG


myVar='swrad'
timeVar='srf_time'
echo "$part1$myVar$part2$tStart$part3$tEnd$part4" > url.txt
wget -O $myVar.nc_ORIG -i url.txt
date=`ncdump -h $myVar.nc_ORIG  | grep time:units | rev | tr ' ' ',' | cut -d ',' -f4 | rev`
dayNumber=`grep $date ~/arch/addl_Scripts/dayConverterCommas.txt | cut -d ',' -f2`
echo "date $date   dayNumber $dayNumber"
source ~/.runPycnal
python settime.py $myVar.nc_ORIG $dayNumber time
source ~/.runROMSintel
ncrename -O -h -d time,$timeVar                                         $myVar.nc_ORIG
ncrename -O -h -v time,$timeVar                                         $myVar.nc_ORIG
ncatted -O -a units,$timeVar,o,c,"days since 1900-01-01 00:00:00"	$myVar.nc_ORIG


## end comment block
#'

module purge
. /etc/profile.d/modules.sh
module load matlab/R2013a
matlab -nodisplay -nosplash < createFile.m

