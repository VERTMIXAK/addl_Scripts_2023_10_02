#!/bin/bash

\rm -r data_*

echo " "
echo "Here are the lat/lon settings:"
echo " "
cat latlon.txt
echo " "

read -r -p "Is this what you want? [y/n] " latLonCheck

case $latLonCheck in
   [nN][oO]|[nN])
echo 'redo lat/lon'
exit 1
     ;;
esac

echo "latLon.txt is presumed OK."

bash makeMotu_S.bash
bash motuS.bash &

bash makeMotu_T.bash
bash motuT.bash &

bash makeMotu_UV.bash
bash motuUV.bash &

bash makeMotu_Z.bash
bash motuZ.bash &

wait

echo 'done with all'
/bin/bash myMerge.bash


bash fixTimeAndFields.bash

module purge
. /etc/profile.d/modules.sh
module load matlab/R2013a
matlab -nodisplay -nosplash < expandLatLon.m


mkdir scheduleForDeletion
mv data_S scheduleForDeletion
mv data_T scheduleForDeletion
mv data_UV scheduleForDeletion
mv data_Z scheduleForDeletion

