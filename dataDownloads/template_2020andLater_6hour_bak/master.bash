#!/bin/bash

bash fixTimeAndFields.bash

module purge
. /etc/profile.d/modules.sh
module load matlab/R2013a
matlab -nodisplay -nosplash < expandLatLon.m

