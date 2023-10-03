clear;

%% albedo

file = 'MERRA_albedo.nc';
var = 'albedo';

dum = nc_varget(file,var);
lon = nc_varget(file,'lon');

% find the first positive longitude

[pos,~] = find(lon>=0);
[neg,~] = find(lon<0);

newLon = lon;
newLon(1:length(pos)) = lon(pos);
newLon(length(pos)+1:end) = lon(neg)+360;

newDum = dum;
newDum(:,:,1:length(pos)) = dum(:,:,pos);
newDum(:,:,length(pos)+1:end) = dum(:,:,neg);

nc_varput(file,'lon',newLon);
nc_varput(file, var ,newDum);

