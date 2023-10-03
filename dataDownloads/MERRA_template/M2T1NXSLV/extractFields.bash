#!/bin/bash



# Pair
outFile='MERRA_Pair.nc'

if [ -f %outFile ]
then
    \rm $outFile
fi

ncrcat -v SLP data/MERRA* $outFile

ncrename -h -O -d time,pair_time -v SLP,Pair $outFile
ncatted -O -a coordinates,Pair,a,c,"lon lat" $outFile




# Qair
outFile='MERRA_Qair.nc'

if [ -f %outFile ]
then
    \rm $outFile
fi

ncrcat -v QV2M data/MERRA* $outFile

ncrename -h -O -d time,qair_time -v QV2M,Qair $outFile
ncatted -O -a coordinates,Qair,a,c,"lon lat" $outFile


# Tair
outFile='MERRA_Tair.nc'

if [ -f %outFile ]
then
    \rm $outFile
fi

ncrcat -v T2M data/MERRA* $outFile

ncrename -h -O -d time,tair_time -v T2M,Tair $outFile
ncatted -O -a units,Tair,o,c,"Celsius" $outFile
ncatted -O -a coordinates,Tair,a,c,"lon lat" $outFile


# Uwind
outFile='MERRA_Uwind.nc'

if [ -f %outFile ]
then
    \rm $outFile
fi

ncrcat -v U2M data/MERRA* $outFile

ncrename -h -O -d time,wind_time -v U2M,Uwind $outFile
ncatted -O -a coordinates,Uwind,a,c,"lon lat" $outFile


# Vwind
outFile='MERRA_Vwind.nc'

if [ -f %outFile ]
then
    \rm $outFile
fi
	

ncrcat -v V2M data/MERRA* $outFile

ncrename -h -O -d time,wind_time -v V2M,Vwind $outFile
ncatted -O -a coordinates,Vwind,a,c,"lon lat" $outFile

