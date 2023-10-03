#!/bin/bash

source ~/.runROMSintel

names=("Pair" "Qair" "Tair" "rain" "lwrad_down" "swrad" "Uwind" "Vwind" )
times=("pair_time" "qair_time" "tair_time" "rain_time" "lrf_time" "srf_time" "wind_time" "wind_time" )

for nn in `seq 0 7`
do
    name=${names[$nn]}
    time=${times[$nn]}

    echo ${names[$nn]} ${times[$nn]} ${longNames[$nn]}


	part1='https://pae-paha.pacioos.hawaii.edu/thredds/ncss/wrf_guam/WRF_Guam_Regional_Atmospheric_Model_best.ncd?var='
	part2='&disableLLSubset=on&disableProjSubset=on&horizStride=1&time_start=2022-03-01T0%3A00%3A00Z&time_end=2022-04-30T21%3A00%3A00Z&timeStride=1&addLatLon=true'

	wget  $part1$name$part2 -O $name"_2022.nc"
done








exit


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





exit
    outName="GFS_"$name"_"$year".nc_ORIG"

    ncrcat out*.nc                            $outName
    ncrename -O -h -d latitude,lat           $outName
    ncrename -O -h -d longitude,lon          $outName
    ncrename -O -h -v latitude,lat           $outName
    ncrename -O -h -v longitude,lon           $outName
    \rm out*.nc

done


/bin/bash fixNamesTimes.bash


