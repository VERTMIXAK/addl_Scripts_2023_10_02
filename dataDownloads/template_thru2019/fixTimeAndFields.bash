#!/bin/bash

dataDir='./data_PHY/'

echo "made it to start of loop"

for file in `ls $dataDir`
do
	ncrename -O -h -d time,ocean_time     	$dataDir$file
	ncrename -O -h -d depth,Z               $dataDir$file
	ncrename -O -h -d latitude,Y      		$dataDir$file
	ncrename -O -h -d longitude,X      		$dataDir$file

	ncrename -O -h -v time,ocean_time    	$dataDir$file
	ncrename -O -h -v depth,z               $dataDir$file
	
	ncrename -O -h -v thetao,temp			$dataDir$file
	ncrename -O -h -v so,salt     			$dataDir$file
	ncrename -O -h -v zos,ssh         		$dataDir$file
	ncrename -O -h -v uo,u       			$dataDir$file
	ncrename -O -h -v vo,v         			$dataDir$file

    ncrename -O -h -v mlotst,mixed_layer_thickness           $dataDir$file
    ncrename -O -h -v siconc,ice_concentration              $dataDir$file
    ncrename -O -h -v sithick,ice_thickness                $dataDir$file
    ncrename -O -h -v usi,ice_northward_velocity           $dataDir$file
    ncrename -O -h -v vsi,ice_eastward_velocity            $dataDir$file

	ncrename -O -h -v latitude,lat1d      	$dataDir$file
	ncrename -O -h -v longitude,lon1d     	$dataDir$file

	ncatted -O -a units,ocean_time,o,c,"days since 1900-01-01 00:00:00" $dataDir$file	
	
	echo "done with $file"

done

source ~/.runPycnal

for file in `ls $dataDir`
do
	python settime.py $dataDir$file
done


# Create a grid file

BB=`pwd | rev | cut -d '/' -f1 | rev | cut -d '_' -f1`
gridName=$BB"_grid.nc"

sourceFile=`ls ./data_PHY |head -1`
cp $dataDir$sourceFile $gridName

# get the footprint for the grid file

nxGrid=`ncdump -h $gridName |grep "X =" |cut -d "=" -f2 | cut -d " " -f2 `
nyGrid=`ncdump -h $gridName |grep "Y =" |cut -d "=" -f2 | cut -d " " -f2 `

echo "nx, ny =  " $nxGrid  $nyGrid

xmin=1
ymin=1
xmax=`echo "$nxGrid - 2" | bc`
ymax=`echo "$nyGrid - 2" | bc`
echo "xmax, ymax =  " $xmax $ymax

# now reduce the size of all the files in the data directory

for file in `ls $dataDir`
do
	ncks -O -d X,$xmin,$xmax -d Y,$ymin,$ymax $dataDir$file $dataDir$file
	echo "done with $dataDir$file"
done
