#!/bin/bash


# cloud
outFile='MERRA_cloud.nc'

if [ -f %outFile ]
then
    \rm $outFile
fi

ncrcat -v CLDTOT data/MERRA* $outFile

ncrename -h -O -d time,cloud_time -v CLDTOT,cloud $outFile
ncatted -O -a coordinates,cloud,a,c,"lon lat" $outFile





# lwrad
outFile='MERRA_lwrad_down.nc'
\rm $outFile

ncrcat -v LWGAB data/MERRA* $outFile

ncrename -h -O -d time,lrf_time -v LWGAB,lwrad_down $outFile
ncatted -O -a coordinates,lwrad_down,a,c,"lon lat" $outFile






# swrad
outFile='MERRA_swrad.nc'
\rm $outFile

ncrcat -v SWGDN data/MERRA* $outFile

ncrename -h -O -d time,srf_time -v SWGDN,swrad $outFile
ncatted -O -a coordinates,swrad,a,c,"lon lat" $outFile



