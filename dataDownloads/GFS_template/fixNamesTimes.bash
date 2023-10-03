#!/bin/bash

source ~/.runROMSintel

# The dates are specified in the dates.txt file

year=`head -1 dates.txt | cut -d '-' -f1`
echo $year

names=("Pair" "Qair" "Tair" "rain" "lwrad_down" "swrad" "Uwind" "Vwind" "albedo" "cloud")
times=("pair_time" "qair_time" "tair_time" "rain_time" "lrf_time" "srf_time" "wind_time" "wind_time" "albedo_time" "cloud_time")


source ~/.runPycnal
python rescale.py             			GFS_albedo_$year.nc_ORIG albedo
python rescale.py             			GFS_cloud_$year.nc_ORIG cloud
echo "about to do T"
python Kelvin2Celsius.py     			GFS_Tair_$year.nc_ORIG
ncatted -O -a units,Tair,o,c,"C"     	GFS_Tair_$year.nc_ORIG
ncatted -O -a valid_range,Tair,d,,    	GFS_Tair_$year.nc_ORIG


echo "done with T"
source ~/.runROMSintel


for nn in `seq 0 9`
#for nn in `seq 1 1`
do
    name=${names[$nn]}
    time=${times[$nn]}

    echo ${names[$nn]} ${times[$nn]}

    file="GFS_"$name"_"$year".nc_ORIG"

    ncks -O -v $time,$name,lat,lon     $file $file

    baseTime=`ncdump -h $file |grep "time:units" |rev | cut -d ' ' -f2 | rev | cut -d 'T' -f1`
    baseDays=`grep $baseTime /import/VERTMIXFS/jgpender/roms-kate_svn/addl_Scripts/dayConverterCommas.txt | cut -d ',' -f2`
    echo "baseTime $baseTime    baseDays $baseDays"

    ncatted -O -a units,$time,o,c,"days since 1900-01-01 00:00:00" $file

    source ~/.runPycnal
    python settime.py $file $time $baseDays
    source ~/.runROMSintel

	if [ $name == 'albedo' ]
	then
		echo "doing albedo now"
		ncatted -O -a units,albedo,o,c,' ' $file
	fi

    if [ $name == 'cloud' ]
    then
        echo "doing cloud now"
        ncatted -O -a units,cloud,o,c,' ' $file
    fi	


done



module purge
. /etc/profile.d/modules.sh  
module load matlab/R2013a
matlab -nodisplay -nosplash < newContainer.m

