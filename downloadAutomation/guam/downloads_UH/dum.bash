#!/bin/bash

source ~/.runROMSintel


########
\rm *.nc forcing/*.nc forcing/*.nc_ORIG

today=`date "+%Y_%m_%d"`
dirName="/import/c1/VERTMIX/jgpender/coawst/GUAMFinner_1km/Experiments/GUAMFinner_1km_"$today"_UH_UH/"

echo $dirName

if [[ ! -d $dirName ]]
then
	cp -R /import/c1/VERTMIX/jgpender/coawst/GUAMFinner_1km/Experiments/GUAMFinner_1km_UH_UH_template $dirName
fi


startDay=`date --date="-10 day" "+%Y-%m-%d"`
nDaysMinus1=20


###########

## begin comment block
#: '


#for ii in `seq -w 0 $nDaysMinus1`
for ii in `seq 0 3`
do	
	date=`date --date="$startDay + $ii days" "+%Y-%m-%d" ` 
	outFile="source$ii.nc"
	echo $date $outFile
	part1='http://pae-paha.pacioos.hawaii.edu/thredds/ncss/pacioos/roms_native/mari/ROMS_CNMI_Regional_Ocean_Model_Native_Grid_best.ncd?'
	part2='var=ubar&var=vbar&var=zeta&var=salt&var=temp&var=u&var=v&'
	part3='north=17&west=141&east=148&south=11&disableProjSubset=on&horizStride=1&time_start='
	part4=$date'T00%3A00%3A00Z&time_end='
	part5=$date'T21%3A00%3A00Z&timeStride=1&vertCoord=&addLatLon=true'

	echo "$part1$part2$part3$part4$part5" > url.txt
	wget -O $outFile -i url.txt
	if [ -s $outFile ];then
		ncks --mk_rec_dmn time -O $outFile $outFile
	else
		\rm $outFile
	fi
done

ncrcat source* UH.nc
\rm source*.nc

bash fixUHfields.bash
bash fixUHdimensions.bash

module purge
module load matlab/R2013a
matlab -nodisplay -nosplash < fixMask.m

#exit




## download the surface forcing files
#source ~/.runROMSintel
#cd forcing
#bash forcing.bash 
#
#cp *.nc $dirName/forcing

#cd ..

###########
## end comment block
#'






# generate IC/BC


cd /import/c1/VERTMIX/jgpender/coawst/GUAMFinner_1km/InputFiles/BC_IC_UH_2022_forecastWindow
\rm *.nc
cd /import/c1/VERTMIX/jgpender/coawst/GUAMFinner_1km/InputFiles/BC_IC_UH_2022_forecastWindow/ini
\rm *.nc
pwd

ncks -d ocean_time,0 ../../downloads_UH/UH.nc UH.nc


# create IC file
source ~/.runPycnal
python make_weight_files.py
python ini.py
echo "about to copy IC file to experiment directory"
cp UH_* $dirName/forcing/UH_2022_ic_GUAMFinner_1km.nc

source ~/.runROMSintel
dirStartDay=`ncdump -v ocean_time UH_* |tail -2 | head -1 | cut -d ' ' -f4`
dirStartDate=`grep 2022- /import/VERTMIXFS/jgpender/roms-kate_svn/addl_Scripts/dayConverterCommas.txt | grep $dirStartDay | cut -d ',' -f1 | sed s/-/_/g `
echo "dirStartDay " $dirStartDay
echo "dirStartDate" $dirStartDate
source ~/.runPycnal

# create BC file
cd /import/c1/VERTMIX/jgpender/coawst/GUAMFinner_1km/InputFiles/BC_IC_UH_2022_forecastWindow
pwd
python bryDaily.py

cp UH_* $dirName/forcing/UH_2022_bdry_GUAMFinner_1km.nc




# run experiment

newDirName="/import/c1/VERTMIX/jgpender/coawst/GUAMFinner_1km/Experiments/GUAMFinner_1km_"$dirStartDate"_UH_UH_todayIs_"$today
echo "newDirName " $newDirName
mv $dirName $newDirName

cd $newDirName
pwd

exit


source /import/home/jgpender/.runROMSintel
sbatch *sbat



