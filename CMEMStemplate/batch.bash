\rm -r data_*

\rm *.nc

bash makeMotu_PHY.bash
bash motu.bash

bash makeMotu_WAV.bash
bash motu.bash

bash makeMotu_SL.bash
bash motu.bash

cp -r data_PHY data_PHY_ORIG
bash fixTimeAndFields.bash

module purge
module load matlab/R2013a
matlab -nosplash < expandLatLon.m
