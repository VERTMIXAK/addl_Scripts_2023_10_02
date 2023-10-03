
# there are 11 files but the counting begins at zero

    nMax=10
    fileList=( "HC_2021_356_ic.nc" "HC_2021_bdry.nc" "rivers.nc" "lwrad_down.nc" "Pair.nc" "Qair.nc" "rain.nc" "swrad.nc" "Tair.nc" "Uwind.nc" "Vwind.nc" )
    varList=(         "dum"             "dum"         "dum"	  "lwrad_down"    "Pair"    "Qair"    "rain"    "swrad"    "Tair"    "Uwind"    "Vwind" )
    timeList=( "ocean_time" "ocean_time" "river_time" "lrf_time" "pair_time" "qair_time" "rain_time" "srf_time" "tair_time"  "wind_time" "wind_time")



# convert the timestamps to days since 1900

    for ii in `seq 0 $nMax`
    do
      	echo ${fileList[$ii] } ${timeList[$ii]}
        ncatted -O -a units,${timeList[$ii]},o,c,"days since 1900-01-01 00:00:00" ${fileList[$ii]}
    done

    source /import/home/jgpender/.runPycnal
    for ii in `seq 0 $nMax`
    do
      	echo ${fileList[$ii] } ${timeList[$ii]}
        python settime.py ${fileList[$ii] } ${timeList[$ii]}
    done



