#!/bin/bash

year=`pwd | rev | cut -d '/' -f2 | cut -d '_' -f1 | rev`
echo $year


ncatted -O -a coordinates,swrad,o,c,"lon lat" "ERA5_"$year"_swrad.nc"
mv dum.nc "ERA5_"$year"_swrad.nc"
echo "done with swrad"

ncatted -O -a coordinates,lwrad_down,o,c,"lon lat" "ERA5_"$year"_lwrad_down.nc"  dum.nc
mv dum.nc "ERA5_"$year"_lwrad_down.nc"
echo "done with lwrad_down"

ncatted -O -a coordinates,Pair,o,c,"lon lat" "ERA5_"$year"_Pair.nc"  dum.nc
mv dum.nc "ERA5_"$year"_Pair.nc"
echo "done with Pair"

ncatted -O -a coordinates,Tair,o,c,"lon lat" "ERA5_"$year"_Tair.nc"  dum.nc
mv dum.nc "ERA5_"$year"_Tair.nc"
echo "done with Tair"

ncatted -O -a coordinates,Qair,o,c,"lon lat" "ERA5_"$year"_Qair.nc"  dum.nc
mv dum.nc "ERA5_"$year"_Qair.nc"
echo "done with Qair"

ncatted -O -a coordinates,rain,o,c,"lon lat" "ERA5_"$year"_rain.nc"  dum.nc
mv dum.nc "ERA5_"$year"_rain.nc"
echo "done with rain"

ncatted -O -a coordinates,Uwind,o,c,"lon lat" "ERA5_"$year"_Uwind.nc"  dum.nc
mv dum.nc "ERA5_"$year"_Uwind.nc"
echo "done with Uwind"

ncatted -O -a coordinates,Vwind,o,c,"lon lat" "ERA5_"$year"_Vwind.nc"  dum.nc
mv dum.nc "ERA5_"$year"_Vwind.nc"
echo "done with Vwind"

ncatted -O -a coordinates,albedo,o,c,"lon lat" "ERA5_"$year"_albedo.nc"  dum.nc
mv dum.nc "ERA5_"$year"_albedo.nc"
echo "done with albedo"


