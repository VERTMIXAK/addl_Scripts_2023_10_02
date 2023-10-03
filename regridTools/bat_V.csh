#!/bin/csh
set echo


#limit cputime 259200


echo `date`
matlab -nodisplay -nosplash <V_regrid.m  >V_log
echo `date`


