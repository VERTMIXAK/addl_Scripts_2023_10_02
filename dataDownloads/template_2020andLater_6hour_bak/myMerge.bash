#!/bin/bash
module purge
. /etc/profile.d/modules.sh
module load matlab/R2013a
module load data/netCDF/4.4.1.1-pic-intel-2016b

\rm -r data_PHY
mkdir data_PHY
cd data_PHY

module load matlab/R2013a


for file in `ls ../data_T`
do
	module purge
	module load data/netCDF/4.4.1.1-pic-intel-2016b

	echo $file
	root=`echo $file | rev | cut -d '_' -f2-10 | rev`
	myN=`echo $file | rev | cut -d '_' -f1 | rev | cut -d '.' -f1` 
	myNm1=`echo " $myN - 1 " | bc `	

	for nn in `seq -w $myNm1  $myN`
	do	
		echo $nn
		source="../data_Z/"$root"_"$nn".nc"
		dest="Z_"$nn".nc"
		echo "source = $source"
		echo "dest   = $dest"

		cp $source $dest
		ls -l

		ncks -O --mk_rec_dmn time $dest $dest
	done

	ncrcat Z_*.nc Z.nc

    cp ../data_S/$file S.nc
    cp ../data_T/$file T.nc
    cp ../data_UV/$file out.nc


	module purge
	. /etc/profile.d/modules.sh
	module load matlab/R2013a
	matlab -nodisplay -nosplash < ../myMerge.m

	\rm Z*.nc S.nc T.nc UV.nc

    mv out.nc $file

done
