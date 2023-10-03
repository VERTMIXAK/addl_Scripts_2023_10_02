#!/bin/bash

# get rid of the first line in the GES downloads file
cat ../sub*INT* | grep -v '.pdf' | grep "\S" > GES_input.txt


# download the data

if [ ! -d originalDownloads ]
then
    bash getData.bash
    mkdir originalDownloads
    mv MERRA* originalDownloads
fi

sbatch *sbat
exit


# make new, cleaned up copies of the data in a new directory
bash fixExtension.bash


# ncrcat the variables into their own files
bash extractFields.bash

module purge
module load matlab/R2013a
matlab -nosplash -nodisplay < sumRainComponents.m
matlab -nosplash -nodisplay < fixLongitude.m
