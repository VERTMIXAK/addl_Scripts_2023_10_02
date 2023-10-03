#!/bin/csh
set echo


#limit cputime 259200


echo `date`
matlab -nodisplay -nosplash <FLUX_regrid.m  >F_log
echo `date`


