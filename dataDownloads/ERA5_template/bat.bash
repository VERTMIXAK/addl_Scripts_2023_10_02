bash convert1.bash
bash convert2.bash
bash convert3.bash



cd ROMSforcing

module purge
module load matlab/R2013a
matlab -nodisplay -nosplash < reFormat.m

/bin/bash tidyUp.bash
