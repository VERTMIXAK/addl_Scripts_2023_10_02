#!/bin/bash



outFile='MERRA_PRECCU_YYYY.nc'
if [ -f %outFile ]
then
	\rm $outFile
fi

ncrcat -v PRECCU data/* $outFile

      
outFile='MERRA_PRECLS_YYYY.nc'
if [ -f %outFile ]
then
    \rm $outFile
fi

ncrcat -v PRECLS data/* $outFile



      
outFile='MERRA_PRECSN_YYYY.nc'
if [ -f %outFile ]
then
    \rm $outFile
fi

ncrcat -v PRECSN data/* $outFile



cp $outFile MERRA_rain_3hours_YYYY.nc
ncrename -h -O -d time,rain_time -v PRECSN,rain MERRA_rain_3hours_YYYY.nc
ncatted -O -a long_name,rain,o,c,"Total surface precipitation flux" MERRA_rain_3hours_YYYY.nc
ncatted -O -a fullnamepath,rain,d,, -a origname,rain,d,, -a standard_name,rain,d,,  MERRA_rain_3hours_YYYY.nc



