

#   Make the river forcing file

    echo "starting river"
    cd ../Runoff
    \rm river*
    mv ../perigreeBulkData/rivers.nc riversLO.nc
    pwd
    ls
    module purge
    module load matlab/R2013a
    matlab -nodisplay -nosplash < fixRiver.m


