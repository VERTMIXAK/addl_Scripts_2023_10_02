#!/bin/bash

source ~/.runROMSintel

# The dates are specified in the dates.txt file

window=23
#hours=( $(seq -w 0 $window))
hours=( $(seq -w 0 3 $window))
nSnapshots=${#hours[@]}
echo "nSnapshots = $nSnapshots"

urlFile=url.txt

year=`head -1 dates.txt | cut -d '-' -f1`
echo "year = " $year

\rm GFS* out* url*


names=("Pair" "Qair" "Tair" "rain" "lwrad_down" "swrad" "Uwind" "Vwind" "albedo" "cloud")
times=("pair_time" "qair_time" "tair_time" "rain_time" "lrf_time" "srf_time" "wind_time" "wind_time" "albedo_time" "cloud_time")

longNames=names
longNames[0]="Pressure_surface"
longNames[1]="Specific_humidity_height_above_ground"
longNames[2]="Temperature_height_above_ground"
longNames[3]="Precipitation_rate_surface"
longNames[4]="Downward_Long-Wave_Radp_Flux_surface_6_Hour_Average"
longNames[5]="Downward_Short-Wave_Radiation_Flux_surface_3_Hour_Average"
longNames[6]="u-component_of_wind_height_above_ground"
longNames[7]="v-component_of_wind_height_above_ground"
longNames[8]="Albedo_surface_6_Hour_Average"
longNames[9]="Total_cloud_cover_entire_atmosphere_3_Hour_Average"

latMin=0
latMax=15
lonMin=125
lonMax=145



#for nn in `seq 0 9`
#do
#    echo "first element" ${names[$nn]} ${times[$nn]} ${longNames[$nn]}
#done




for nn in `seq 0 9`
#for nn in `seq 4 4`
do
    name=${names[$nn]}
    time=${times[$nn]}
    longName=${longNames[$nn]}

    echo ${names[$nn]} ${times[$nn]} ${longNames[$nn]}

    while read line
    do

        dum=`echo $line | cut -d ',' -f1`
        now=`date -d $dum "+%Y%m%d"`
        echo $now

        for ((ii=0;ii<$nSnapshots;ii+=1));
        do
            outFile="out_"$now"_${hours[$ii]}.nc"

            part1="https://rda.ucar.edu/thredds/ncss/grid/files/g/ds084.1/$year/"
            part2="$now/gfs.0p25."
            part3=$now"00.f0"
            part4="${hours[$ii]}.grib2?var=$longName&north=$latMax&west=$lonMin&east=$lonMax&south=$latMin&horizStride=1&time_start="
            datePlus=`date -d "$now + ${hours[$ii]} hours" "+%Y-%m-%dT%H:%M:%S"`
            part5=$datePlus"Z&time_end="
            part6=$datePlus"Z&timeStride=1&vertStride=1&accept=netcdf3&addLatLon=true"
            echo $part1$part2$part3$part4$part5$part6 > $urlFile

			echo $ii " of " $nSnapshots

            wget -O $outFile -i $urlFile

            if [ -s $outFile ];then
                timeVar=`ncdump -h $outFile | grep time | head -1 |   tr -d '\t' | cut -d ' ' -f1`
                boundsVar=`ncdump -h $outFile | grep double | grep _ | cut -d '(' -f1 | rev | cut -d ' ' -f1 | rev`
                echo "time_bounds variable " $boundsVar
                echo "length" ${#boundsVar}

                if [ ${#boundsVar} -gt 0 ];then

                    echo "found extra dimension"
                    ncks -O -x -v $boundsVar $outFile $outFile
                fi    

                   ncrename -O -h -d $timeVar,$time               $outFile
                ncrename -O -h -v $timeVar,$time             $outFile
                ncrename -O -h -v $longName,$name            $outFile
#                ncks -O -v $time,$name,latitude,longitude     $outFile $outFile

                ncks    --mk_rec_dmn $time -O               $outFile $outFile
                echo "good download"

            else
                \rm $outFile
            fi

        done
    done < dates.txt

    outName="GFS_"$name"_"$year".nc_ORIG"

    ncrcat out*.nc                            $outName
    ncrename -O -h -d latitude,lat           $outName
    ncrename -O -h -d longitude,lon          $outName
    ncrename -O -h -v latitude,lat           $outName
    ncrename -O -h -v longitude,lon           $outName
    \rm out*.nc

done


/bin/bash fixNamesTimes.bash


