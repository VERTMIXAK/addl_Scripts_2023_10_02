#!/bin/bash

source ~/.runPycnal

year=`pwd | rev | cut -d '/' -f1 | rev | cut -d '_' -f2`
echo $year

newDir=intermediateStage
\rm -r $newDir
mkdir $newDir

oldDir=site1

#newFile=ERA5_2019_Uwind.nc
newFile='ERA5_'$year'_Uwind.nc'

cp $oldDir/U.nc $newDir/$newFile
ncap2  -s 'time=double(time)' $newDir/$newFile dum.nc; mv dum.nc $newDir/$newFile
python settime.py $newDir/$newFile
ncatted  -a units,time,o,c,"days since 1900-01-01 00:00:00" $newDir/$newFile dum.nc; mv dum.nc $newDir/$newFile
ncrename  -h -d time,wind_time $newDir/$newFile dum.nc; mv dum.nc $newDir/$newFile
ncrename  -h -v time,wind_time $newDir/$newFile dum.nc; mv dum.nc $newDir/$newFile
ncrename  -h -d latitude,lat $newDir/$newFile dum.nc; mv dum.nc $newDir/$newFile
ncrename  -h -d longitude,lon $newDir/$newFile dum.nc; mv dum.nc $newDir/$newFile
ncrename  -h -v latitude,lat $newDir/$newFile dum.nc; mv dum.nc $newDir/$newFile
ncrename  -h -v longitude,lon $newDir/$newFile dum.nc; mv dum.nc $newDir/$newFile
ncrename  -h -v VAR_10U,Uwind $newDir/$newFile dum.nc; mv dum.nc $newDir/$newFile



#newFile=ERA5_2019_Vwind.nc
newFile='ERA5_'$year'_Vwind.nc'

cp $oldDir/V.nc $newDir/$newFile
ncap2 -O -s 'time=double(time)' $newDir/$newFile $newDir/$newFile
python settime.py $newDir/$newFile
ncatted -O -a units,time,o,c,"days since 1900-01-01 00:00:00" $newDir/$newFile
ncrename -O -h -d time,wind_time $newDir/$newFile
ncrename -O -h -v time,wind_time $newDir/$newFile
ncrename -O -h -d latitude,lat $newDir/$newFile
ncrename -O -h -d longitude,lon $newDir/$newFile
ncrename -O -h -v latitude,lat $newDir/$newFile
ncrename -O -h -v longitude,lon $newDir/$newFile
ncrename -O -h -v VAR_10V,Vwind $newDir/$newFile


#newFile=ERA5_2019_Pair.nc
newFile='ERA5_'$year'_Pair.nc'
cp $oldDir/SP.nc $newDir/$newFile

ncap2 -O -s 'time=double(time)' $newDir/$newFile $newDir/$newFile
python settime.py $newDir/$newFile
ncatted -O -a units,time,o,c,"days since 1900-01-01 00:00:00" $newDir/$newFile
ncrename -O -h -d time,pair_time $newDir/$newFile
ncrename -O -h -v time,pair_time $newDir/$newFile
ncrename -O -h -d latitude,lat $newDir/$newFile
ncrename -O -h -d longitude,lon $newDir/$newFile
ncrename -O -h -v latitude,lat $newDir/$newFile
ncrename -O -h -v longitude,lon $newDir/$newFile
ncrename -O -h -v SP,Pair $newDir/$newFile


#newFile=ERA5_2019_Tair.nc
newFile='ERA5_'$year'_Tair.nc'
cp $oldDir/T.nc $newDir/$newFile

ncap2 -O -s 'time=double(time)' $newDir/$newFile $newDir/$newFile
python settime.py $newDir/$newFile
ncatted -O -a units,time,o,c,"days since 1900-01-01 00:00:00" $newDir/$newFile
ncrename -O -h -d time,tair_time $newDir/$newFile
ncrename -O -h -v time,tair_time $newDir/$newFile
ncrename -O -h -d latitude,lat $newDir/$newFile
ncrename -O -h -d longitude,lon $newDir/$newFile
ncrename -O -h -v latitude,lat $newDir/$newFile
ncrename -O -h -v longitude,lon $newDir/$newFile
ncrename -O -h -v VAR_2T,Tair $newDir/$newFile
ncatted -O -a units,Tair,o,c,"Celsius" $newDir/$newFile
python convertT.py $newDir/$newFile
