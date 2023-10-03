#!/bin/bash
\rm -r data_UV

year=`pwd | rev | cut -d '/' -f1 | rev | cut -d '_' -f2`
#echo $year

#grep $year- /import/VERTMIXFS/jgpender/roms-kate_svn/addl_Scripts/dayConverterCommas.txt > dates.txt
#grep $year-01 ~/arch/addl_Scripts/dayConverterCommas.txt >dates.txt
#grep $year-02 ~/arch/addl_Scripts/dayConverterCommas.txt >>dates.txt

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

bash makeMotu_UV.bash
bash motuUV.bash

exit


bash fixTimeAndFields.bash

module purge
. /etc/profile.d/modules.sh
module load matlab/R2013a
matlab -nodisplay -nosplash < expandLatLon.m

exit

bash makeMotu_WAV.bash
bash motu.bash

bash makeMotu_SL.bash
bash motu.bash

