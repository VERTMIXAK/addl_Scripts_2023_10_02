#!/bin/bash
source ~/.runROMSintel

# This is set up somewhat differently than the UH-UH case. I am going to 
# create all the forcing files in the experiment directory instead of separately
# in a directory located in InputFiles



today=`date "+%Y-%m-%d"`
runDate=`date --date="$today - 7 day" "+%Y-%m-%d"`
prevDate=`date --date="$runDate - 1 day" "+%Y-%m-%d"`
echo $runDate
echo $prevDate

# Check the CMEMS archive dates
dayN=`grep $runDate /import/VERTMIXFS/jgpender/roms-kate_svn/addl_Scripts/dayConverterCommas.txt | cut -d ',' -f4`
dayNm1=`grep $prevDate /import/VERTMIXFS/jgpender/roms-kate_svn/addl_Scripts/dayConverterCommas.txt | cut -d ',' -f4`

lastArchive=`ls -1 /import/c1/VERTMIX/jgpender/ROMS/CMEMS/GUAM_2022/data_PHY | tail -1 | rev | cut -d '_' -f1 | cut -d '.' -f2 | rev`

fileDate=`date --date="$runDate" "+%Y_%m_%d"`
dirName="/import/c1/VERTMIX/jgpender/coawst/GUAMFinner_1km/Experiments/GUAMFinner_1km_"$fileDate"_CMEMS_GFS/"


if [[ ! -d $dirName ]]
then
	cp -R /import/c1/VERTMIX/jgpender/coawst/GUAMFinner_1km/Experiments/GUAMFinner_1km_CMEMS_GFS_template $dirName
fi


# make IC file
cd $dirName/forcing/BC_IC/ini

source ~/.runPycnal
python make_remap_weights_file.py

cp make_ic_file_template.py make_ic_file.py
sed -i "s/XXX/$dayNm1/" make_ic_file.py
python make_ic_file.py

cp make_ic_file_template.py make_ic_file.py
sed -i "s/XXX/$dayN/" make_ic_file.py
python make_ic_file.py


cp averageSnapshots_template.m averageSnapshots.m
sed -i "s/XXX/$dayNm1/" averageSnapshots.m
sed -i "s/YYY/$dayN/" averageSnapshots.m

module purge
module load matlab/R2013a
matlab -nodisplay -nosplash < averageSnapshots.m
source ~/.runPycnal


# make BC file
cd ..

for num in `seq -w $dayNm1 $lastArchive`
do
	cp /import/c1/VERTMIX/jgpender/ROMS/CMEMS/GUAM_2022/data_PHY/GLOBAL*$num.nc scheduleForDeletion
done
python make_bdry_file_All.py

source ~/.runPycnal
ncrcat GL* CMEMS_bdry.nc

\rm GL*




# Create surface forcing files
cd ..
grep $prevDate /import/VERTMIXFS/jgpender/roms-kate_svn/addl_Scripts/dayConverterCommas.txt > dates.txt
/bin/bash download.bash



# modify dir name

dirStartDay=`ncdump -v ocean_time B*/i*/C* |tail -2 | head -1 | cut -d ' ' -f4`
dirStartDate=`grep 2022- /import/VERTMIXFS/jgpender/roms-kate_svn/addl_Scripts/dayConverterCommas.txt | grep $dirStartDay | cut -d ',' -f1 | sed s/-/_/f `

newDirName="/import/c1/VERTMIX/jgpender/coawst/GUAMFinner_1km/Experiments/GUAMFinner_1km_"$fileDate"_CMEMS_GFS_todayIs_$today/"
cd ../..
mv $dirName $newDirName
cd $newDirName


sbatch *sbat




dirName="/import/c1/VERTMIX/jgpender/coawst/GUAMFinner_1km/Experiments/GUAMFinner_1km_"$fileDate"_CMEMS_GFS/"
