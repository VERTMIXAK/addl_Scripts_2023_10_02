#!/bin/csh
set echo

matlab -nodisplay -nosplash <T_regrid.m  >T_log
matlab -nodisplay -nosplash <S_regrid.m  >S_log
matlab -nodisplay -nosplash <U_regrid.m  >U_log
matlab -nodisplay -nosplash <V_regrid.m  >V_log
matlab -nodisplay -nosplash <FLUX_regrid.m  >F_log

