#!/bin/bash



outFile='MERRA_PRECCU.nc'
if [ -f %outFile ]
then
	\rm $outFile
fi

ncrcat -v PRECCU data/* $outFile

      
outFile='MERRA_PRECLS.nc'
if [ -f %outFile ]
then
    \rm $outFile
fi

ncrcat -v PRECLS data/* $outFile



      
outFile='MERRA_PRECSN.nc'
if [ -f %outFile ]
then
    \rm $outFile
fi

ncrcat -v PRECSN data/* $outFile



cp $outFile MERRA_rain.nc
ncrename -h -O -d time,rain_time -v PRECSN,rain MERRA_rain.nc
ncatted -O -a long_name,rain,o,c,"Total surface precipitation flux" MERRA_rain.nc
ncatted -O -a fullnamepath,rain,d,, -a origname,rain,d,, -a standard_name,rain,d,,  MERRA_rain.nc
ncatted -O -a coordinates,rain,a,c,"lon lat" MERRA_rain.nc



