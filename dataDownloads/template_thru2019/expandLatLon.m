clear;

dataDir = './';

%% First do the grid file

[~,dum] = unix(['ls *.nc']);
gridFile = dum(1:end-1);

lat = nc_varget(gridFile,'lat1d');
lon = nc_varget(gridFile,'lon1d');
% z   = nc_varget(gridFile,'z');

nx = length(lon);
ny = length(lat);
% nz = length(z);

newLat = repmat(lat,1,nx);
newLon = (repmat(lon,1,ny))';

aaa=5;

%%

% Variables section

dum.Name = 'lon';
dum.Nctype = 'double';
dum.Dimension = {'Y','X'};
dum.Attribute = struct('Name',{'long_name','units'},'Value',{'Longitude','degrees_east'});
nc_addvar(gridFile,dum);

dum.Name = 'lat';
dum.Nctype = 'double';
dum.Dimension = {'Y','X'};
dum.Attribute = struct('Name',{'long_name','units'},'Value',{'Latitude','degrees_north'});
nc_addvar(gridFile,dum);

nc_varput(gridFile,'lon',newLon);
nc_varput(gridFile,'lat',newLat);

%% Now do the data files

HYCOMnames = dir([dataDir,'./data_PHY']);

for ii=3:length(HYCOMnames)
    dataFile = [dataDir,'data_PHY/',HYCOMnames(ii).name]
    
    lat = nc_varget(dataFile,'lat1d');
    lon = nc_varget(dataFile,'lon1d');
%     z   = nc_varget(dataFile,'z');
    
    nx = length(lon);
    ny = length(lat);
%     nz = length(z);
    
    newLat = repmat(lat,1,nx);
    newLon = (repmat(lon,1,ny))';
    
    % Variables section
    
    dum.Name = 'lon';
    dum.Nctype = 'double';
    dum.Dimension = {'Y','X'};
    dum.Attribute = struct('Name',{'long_name','units'},'Value',{'Longitude','degrees_east'});    
    nc_addvar(dataFile,dum);
    
    dum.Name = 'lat';
    dum.Nctype = 'double';
    dum.Dimension = {'Y','X'};
    dum.Attribute = struct('Name',{'long_name','units'},'Value',{'Latitude','degrees_north'});
    nc_addvar(dataFile,dum);
    
    nc_varput(dataFile,'lon',newLon);
    nc_varput(dataFile,'lat',newLat);
    

    
end;



