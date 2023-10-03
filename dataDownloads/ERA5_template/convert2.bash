#!/bin/bash

source ~/.runPycnal

year=`pwd | rev | cut -d '/' -f1 | rev | cut -d '_' -f2`
echo $year

newDir=intermediateStage
#\rm $newDir/*

oldDir=site2


#newFile=ERA5_2019_albedo.nc
newFile='ERA5_'$year'_albedo.nc'

#ncks -v msnswrfcs $oldDir/*.nc $newDir/$newFile
#ncap2 -O -s 'time=double(time)' $newDir/$newFile $newDir/$newFile
ncap2 -O -s 'time=double(time)' $oldDir/aluvp.nc $newDir/$newFile

python settime.py $newDir/$newFile
ncatted -O -a units,time,o,c,"days since 1900-01-01 00:00:00" $newDir/$newFile
ncrename -O -h -d time,albedo_time $newDir/$newFile
ncrename -O -h -v time,albedo_time $newDir/$newFile
ncrename -O -h -d latitude,lat $newDir/$newFile
ncrename -O -h -d longitude,lon $newDir/$newFile
ncrename -O -h -v latitude,lat $newDir/$newFile
ncrename -O -h -v longitude,lon $newDir/$newFile
ncrename -O -h -v aluvp,albedo $newDir/$newFile
ncatted -O -a units,albedo,o,c,"1" $newDir/$newFile





#newFile=ERA5_2019_swrad.nc
newFile='ERA5_'$year'_swrad.nc'

#ncks -v msdwswrf $oldDir/*.nc $newDir/$newFile
#ncap2 -O -s 'time=double(time)' $newDir/$newFile $newDir/$newFile
ncap2 -O -s 'time=double(time)' $oldDir/msdwswrf.nc $newDir/$newFile

python settime.py $newDir/$newFile
ncatted -O -a units,time,o,c,"days since 1900-01-01 00:00:00" $newDir/$newFile
ncrename -O -h -d time,srf_time $newDir/$newFile
ncrename -O -h -v time,srf_time $newDir/$newFile
ncrename -O -h -d latitude,lat $newDir/$newFile
ncrename -O -h -d longitude,lon $newDir/$newFile
ncrename -O -h -v latitude,lat $newDir/$newFile
ncrename -O -h -v longitude,lon $newDir/$newFile
ncrename -O -h -v msdwswrf,swrad $newDir/$newFile
ncatted -O -a units,swrad,o,c,"W m-2" $newDir/$newFile




#newFile=ERA5_2019_lwrad_down.nc
newFile='ERA5_'$year'_lwrad_down.nc'

#ncks -v msdwlwrf $oldDir/*.nc $newDir/$newFile
#ncap2 -O -s 'time=double(time)' $newDir/$newFile $newDir/$newFile
ncap2 -O -s 'time=double(time)' $oldDir/msdwlwrf.nc $newDir/$newFile

python settime.py $newDir/$newFile
ncatted -O -a units,time,o,c,"days since 1900-01-01 00:00:00" $newDir/$newFile
ncrename -O -h -d time,lrf_time $newDir/$newFile
ncrename -O -h -v time,lrf_time $newDir/$newFile
ncrename -O -h -d latitude,lat $newDir/$newFile
ncrename -O -h -d longitude,lon $newDir/$newFile
ncrename -O -h -v latitude,lat $newDir/$newFile
ncrename -O -h -v longitude,lon $newDir/$newFile
ncrename -O -h -v msdwlwrf,lwrad_down $newDir/$newFile
ncatted -O -a units,lwrad_down,o,c,"W m-2" $newDir/$newFile






#newFile=ERA5_2019_rain.nc
newFile='ERA5_'$year'_rain.nc'

#ncks -v tp $oldDir/*.nc $newDir/$newFile
#ncap2 -O -s 'time=double(time)' $newDir/$newFile $newDir/$newFile
ncap2 -O -s 'time=double(time)' $oldDir/tp.nc $newDir/$newFile

python settime.py $newDir/$newFile
ncatted -O -a units,time,o,c,"days since 1900-01-01 00:00:00" $newDir/$newFile
ncrename -O -h -d time,rain_time $newDir/$newFile
ncrename -O -h -v time,rain_time $newDir/$newFile
ncrename -O -h -d latitude,lat $newDir/$newFile
ncrename -O -h -d longitude,lon $newDir/$newFile
ncrename -O -h -v latitude,lat $newDir/$newFile
ncrename -O -h -v longitude,lon $newDir/$newFile
ncrename -O -h -v tp,rain $newDir/$newFile
ncatted -O -a units,rain,o,c,"kg m-2 s-1" $newDir/$newFile
python convertRain.py $newDir/$newFile

