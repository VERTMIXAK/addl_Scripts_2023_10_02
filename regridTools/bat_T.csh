#!/bin/csh
set echo


#limit cputime 259200


echo `date`
matlab -nodisplay -nosplash <T_regrid.m  >T_log
echo `date`


