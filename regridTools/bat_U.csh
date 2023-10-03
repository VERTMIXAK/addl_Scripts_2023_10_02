#!/bin/csh
set echo


#limit cputime 259200


echo `date`
matlab -nodisplay -nosplash <U_regrid.m  >U_log
echo `date`


