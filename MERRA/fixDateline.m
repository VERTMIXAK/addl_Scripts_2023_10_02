clear;

% execute these commands:
% module purge
% module load matlab/R2013a
% module load data/netCDF/4.4.1.1-foss-2016b


oldFile = 'sss_fill_2004.nc';
newFile = 'sss_fill_2004_negLons.nc';
unix(['cp ',oldFile,' ',newFile])



[~, myVar] = unix(['ncdump -h ',newFile,'  |grep "lat, lon)" | cut -d "(" -f1 |rev | cut -d " " -f1 |rev | tr -d " "']);
myVar = myVar(1:end-1);

lon = nc_varget(newFile,'lon');
var = nc_varget(newFile,myVar);

find(lon<180);pos = ans(end);

lonWest = lon(pos+1:end);
lonEast = lon(1:pos);

varWest   = var(:,:,pos+1:end);
varEast   = var(:,:,1:pos);

lonNew = lon;
lonNew(end-pos+1:end) = lonEast;
lonNew(1:end-pos)     = lonWest-360;

varNew    = var;
varNew(:,:,1:end-pos)     = varWest;
varNew(:,:,end-pos+1:end) = varEast;

nc_varput(newFile,'lon',lonNew);
nc_varput(newFile,myVar,varNew);

%%


unix('rm MERRA*negLons.nc')
files = dir('MERRA*');


for nn = 1:length(files)
    
    oldFile = files(nn).name;
    newFile = strrep(oldFile,'.nc','_negLons.nc');
    unix(['cp ',oldFile,' ',newFile])
    
    aaa=5;
    
    [~, myVar] = unix(['ncdump -h ',newFile,'  |grep "lat, lon)" | cut -d "(" -f1 |rev | cut -d " " -f1 |rev | tr -d " "']);
    myVar = myVar(1:end-1);
    
    lon = nc_varget(newFile,'lon');
    var = nc_varget(newFile,myVar);
    
    find(lon<180);pos = ans(end);
    
    lonWest = lon(pos+1:end);
    lonEast = lon(1:pos);
    
    varWest   = var(:,:,pos+1:end);
    varEast   = var(:,:,1:pos);
    
    lonNew = lon;
    lonNew(end-pos+1:end) = lonEast;
    lonNew(1:end-pos)     = lonWest-360;
    
    varNew    = var;
    varNew(:,:,1:end-pos)     = varWest;
    varNew(:,:,end-pos+1:end) = varEast;
    
    nc_varput(newFile,'lon',lonNew);
    nc_varput(newFile,myVar,varNew);
    
end;
