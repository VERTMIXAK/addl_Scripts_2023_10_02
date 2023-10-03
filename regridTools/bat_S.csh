#!/bin/csh
set echo


#limit cputime 259200


echo `date`
matlab -nodisplay -nosplash <S_regrid.m  >S_log
echo `date`


