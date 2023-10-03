#!/bin/bash

\rm -r roms* orig* data MER* GES*

# get rid of the first line in the GES downloads file
cat ../subset_SLV.txt | grep -v '.pdf' | grep "\S" > GES_input.txt


# download the data

if [ ! -d originalDownloads ]
then
    bash getData.bash
    mkdir originalDownloads
    mv MERRA* originalDownloads
fi

# Either execute     
#       fixExtension.bash
#       extractFields.bash
#       fixLongitude.m
# in the batch script, or comment the next two lines out and
# execute them in this script

sbatch *sbat
exit


# make new, cleaned up copies of the data in a new directory
bash fixExtension.bash


# ncrcat the variables into their own files
bash extractFields.bash

module purge
module load matlab/R2013a

matlab -nosplash -nodisplay < fixLongitude.m
