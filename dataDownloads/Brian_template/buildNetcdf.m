

%% swrad

oldFile = 'bak/swrad_2022.nc_ORIG';
newFile = 'swrad_2022.nc';

lon = nc_varget(oldFile,'lon');
lat = nc_varget(oldFile,'lat');
var = nc_varget(oldFile,'swrad');
time = nc_varget(oldFile,'srf_time');

nc_create_empty(newFile,nc_64bit_offset_mode);

% Dimension section
nc_add_dimension(newFile,'lon',length(lon));
nc_add_dimension(newFile,'lat',length(lat));
nc_add_dimension(newFile,'srf_time',0);

% Variables section

dum.Name = 'lon';
dum.Nctype = 'float';
dum.Dimension = {'lon'};
dum.Attribute = struct('Name',{'long_name','units','field'},'Value',{'longitude','degrees_east','time, scalar, series'});
nc_addvar(newFile,dum);

dum.Name = 'lat';
dum.Nctype = 'float';
dum.Dimension = {'lat'};
dum.Attribute = struct('Name',{'long_name','units','field'},'Value',{'latitude','degrees_north','time, scalar, series'});
nc_addvar(newFile,dum);

dum.Name = 'srf_time';
dum.Nctype = 'double';
dum.Dimension = {'srf_time'};
dum.Attribute = struct('Name',{'long_name','units','calendar','field'},'Value',{'time since initialization','days since 1900-01-01 00:00:00','gregorian','time, scalar, series'});
nc_addvar(newFile,dum)

dum.Name = 'swrad';
dum.Nctype = 'float';
dum.Dimension = {'srf_time','lat','lon'};
dum.Attribute = struct('Name',{'long_name','units','time','coordinates','field'},'Value',{'solar shortwave radiation flux','meter second-1','srf_time','lon lat srf_time','shortwave flux, scalar, series'});
nc_addvar(newFile,dum);



% Global attributes section

nc_attput(newFile,nc_global,'title', 'surface forcing data from Brian' );
nc_attput(newFile,nc_global,'type', 'ROMS/TOMS history file' );
nc_attput(newFile,nc_global,'format', 'netCDF-3 64bit offset file' );

% Fill in grid data
nc_varput(newFile,'lat'  ,lat);
nc_varput(newFile,'lon'  ,lon);
nc_varput(newFile,'swrad',var);
nc_varput(newFile,'srf_time',time);

%% rain

oldFile = 'bak/rain_2022.nc_ORIG';
newFile = 'rain_2022.nc';

lon = nc_varget(oldFile,'lon');
lat = nc_varget(oldFile,'lat');
var = nc_varget(oldFile,'rain');
time = nc_varget(oldFile,'rain_time');

nc_create_empty(newFile,nc_64bit_offset_mode);

% Dimension section
nc_add_dimension(newFile,'lon',length(lon));
nc_add_dimension(newFile,'lat',length(lat));
nc_add_dimension(newFile,'rain_time',0);

% Variables section

dum.Name = 'lon';
dum.Nctype = 'float';
dum.Dimension = {'lon'};
dum.Attribute = struct('Name',{'long_name','units','field'},'Value',{'longitude','degrees_east','time, scalar, series'});
nc_addvar(newFile,dum);

dum.Name = 'lat';
dum.Nctype = 'float';
dum.Dimension = {'lat'};
dum.Attribute = struct('Name',{'long_name','units','field'},'Value',{'latitude','degrees_north','time, scalar, series'});
nc_addvar(newFile,dum);

dum.Name = 'rain_time';
dum.Nctype = 'double';
dum.Dimension = {'rain_time'};
dum.Attribute = struct('Name',{'long_name','units','calendar','field'},'Value',{'time since initialization','days since 1900-01-01 00:00:00','gregorian','time, scalar, series'});
nc_addvar(newFile,dum)

dum.Name = 'rain';
dum.Nctype = 'float';
dum.Dimension = {'rain_time','lat','lon'};
dum.Attribute = struct('Name',{'long_name','units','time','coordinates','field'},'Value',{'rainfall rate','meter second-1','rain_time','lon lat rain_time','rainfall, scalar, series'});
nc_addvar(newFile,dum);



% Global attributes section

nc_attput(newFile,nc_global,'title', 'surface forcing data from Brian' );
nc_attput(newFile,nc_global,'type', 'ROMS/TOMS history file' );
nc_attput(newFile,nc_global,'format', 'netCDF-3 64bit offset file' );

% Fill in grid data
nc_varput(newFile,'lat'  ,lat);
nc_varput(newFile,'lon'  ,lon);
nc_varput(newFile,'rain',var);
nc_varput(newFile,'rain_time',time);

%% Tair

oldFile = 'bak/Tair_2022.nc_ORIG';
newFile = 'Tair_2022.nc';

lon = nc_varget(oldFile,'lon');
lat = nc_varget(oldFile,'lat');
var = nc_varget(oldFile,'Tair');
time = nc_varget(oldFile,'tair_time');

nc_create_empty(newFile,nc_64bit_offset_mode);

% Dimension section
nc_add_dimension(newFile,'lon',length(lon));
nc_add_dimension(newFile,'lat',length(lat));
nc_add_dimension(newFile,'tair_time',0);

% Variables section

dum.Name = 'lon';
dum.Nctype = 'float';
dum.Dimension = {'lon'};
dum.Attribute = struct('Name',{'long_name','units','field'},'Value',{'longitude','degrees_east','time, scalar, series'});
nc_addvar(newFile,dum);

dum.Name = 'lat';
dum.Nctype = 'float';
dum.Dimension = {'lat'};
dum.Attribute = struct('Name',{'long_name','units','field'},'Value',{'latitude','degrees_north','time, scalar, series'});
nc_addvar(newFile,dum);

dum.Name = 'tair_time';
dum.Nctype = 'double';
dum.Dimension = {'tair_time'};
dum.Attribute = struct('Name',{'long_name','units','calendar','field'},'Value',{'time since initialization','days since 1900-01-01 00:00:00','gregorian','time, scalar, series'});
nc_addvar(newFile,dum)

dum.Name = 'Tair';
dum.Nctype = 'float';
dum.Dimension = {'tair_time','lat','lon'};
dum.Attribute = struct('Name',{'long_name','units','time','coordinates','field'},'Value',{'air temperature at 2m','meter second-1','tair_time','lon lat tair_time','air temperature, scalar, series'});
nc_addvar(newFile,dum);



% Global attributes section

nc_attput(newFile,nc_global,'title', 'surface forcing data from Brian' );
nc_attput(newFile,nc_global,'type', 'ROMS/TOMS history file' );
nc_attput(newFile,nc_global,'format', 'netCDF-3 64bit offset file' );

% Fill in grid data
nc_varput(newFile,'lat'  ,lat);
nc_varput(newFile,'lon'  ,lon);
nc_varput(newFile,'Tair',var);
nc_varput(newFile,'tair_time',time);

%% Qair

oldFile = 'bak/Qair_2022.nc_ORIG';
newFile = 'Qair_2022.nc';

lon = nc_varget(oldFile,'lon');
lat = nc_varget(oldFile,'lat');
var = nc_varget(oldFile,'Qair');
time = nc_varget(oldFile,'qair_time');

nc_create_empty(newFile,nc_64bit_offset_mode);

% Dimension section
nc_add_dimension(newFile,'lon',length(lon));
nc_add_dimension(newFile,'lat',length(lat));
nc_add_dimension(newFile,'qair_time',0);

% Variables section

dum.Name = 'lon';
dum.Nctype = 'float';
dum.Dimension = {'lon'};
dum.Attribute = struct('Name',{'long_name','units','field'},'Value',{'longitude','degrees_east','time, scalar, series'});
nc_addvar(newFile,dum);

dum.Name = 'lat';
dum.Nctype = 'float';
dum.Dimension = {'lat'};
dum.Attribute = struct('Name',{'long_name','units','field'},'Value',{'latitude','degrees_north','time, scalar, series'});
nc_addvar(newFile,dum);

dum.Name = 'qair_time';
dum.Nctype = 'double';
dum.Dimension = {'qair_time'};
dum.Attribute = struct('Name',{'long_name','units','calendar','field'},'Value',{'time since initialization','days since 1900-01-01 00:00:00','gregorian','time, scalar, series'});
nc_addvar(newFile,dum)

dum.Name = 'Qair';
dum.Nctype = 'float';
dum.Dimension = {'qair_time','lat','lon'};
dum.Attribute = struct('Name',{'long_name','units','time','coordinates','field'},'Value',{'surface air relative humidity','meter second-1','qair_time','lon lat qair_time','surface humidity, scalar, series'});
nc_addvar(newFile,dum);



% Global attributes section

nc_attput(newFile,nc_global,'title', 'surface forcing data from Brian' );
nc_attput(newFile,nc_global,'type', 'ROMS/TOMS history file' );
nc_attput(newFile,nc_global,'format', 'netCDF-3 64bit offset file' );

% Fill in grid data
nc_varput(newFile,'lat'  ,lat);
nc_varput(newFile,'lon'  ,lon);
nc_varput(newFile,'Qair',var);
nc_varput(newFile,'qair_time',time);

%% Pair

oldFile = 'bak/Pair_2022.nc_ORIG';
newFile = 'Pair_2022.nc';

lon = nc_varget(oldFile,'lon');
lat = nc_varget(oldFile,'lat');
var = nc_varget(oldFile,'Pair');
time = nc_varget(oldFile,'pair_time');

nc_create_empty(newFile,nc_64bit_offset_mode);

% Dimension section
nc_add_dimension(newFile,'lon',length(lon));
nc_add_dimension(newFile,'lat',length(lat));
nc_add_dimension(newFile,'pair_time',0);

% Variables section

dum.Name = 'lon';
dum.Nctype = 'float';
dum.Dimension = {'lon'};
dum.Attribute = struct('Name',{'long_name','units','field'},'Value',{'longitude','degrees_east','time, scalar, series'});
nc_addvar(newFile,dum);

dum.Name = 'lat';
dum.Nctype = 'float';
dum.Dimension = {'lat'};
dum.Attribute = struct('Name',{'long_name','units','field'},'Value',{'latitude','degrees_north','time, scalar, series'});
nc_addvar(newFile,dum);

dum.Name = 'pair_time';
dum.Nctype = 'double';
dum.Dimension = {'pair_time'};
dum.Attribute = struct('Name',{'long_name','units','calendar','field'},'Value',{'time since initialization','days since 1900-01-01 00:00:00','gregorian','time, scalar, series'});
nc_addvar(newFile,dum)

dum.Name = 'Pair';
dum.Nctype = 'float';
dum.Dimension = {'pair_time','lat','lon'};
dum.Attribute = struct('Name',{'long_name','units','time','coordinates','field'},'Value',{'surface air pressure','meter second-1','pair_time','lon lat pair_time','surface air pressure, scalar, series'});
nc_addvar(newFile,dum);



% Global attributes section

nc_attput(newFile,nc_global,'title', 'surface forcing data from Brian' );
nc_attput(newFile,nc_global,'type', 'ROMS/TOMS history file' );
nc_attput(newFile,nc_global,'format', 'netCDF-3 64bit offset file' );

% Fill in grid data
nc_varput(newFile,'lat'  ,lat);
nc_varput(newFile,'lon'  ,lon);
nc_varput(newFile,'Pair',var);
nc_varput(newFile,'pair_time',time);

%% lwrad_down

oldFile = 'bak/lwrad_down_2022.nc_ORIG';
newFile = 'lwrad_down_2022.nc';

lon = nc_varget(oldFile,'lon');
lat = nc_varget(oldFile,'lat');
var = nc_varget(oldFile,'lwrad_down');
time = nc_varget(oldFile,'lrf_time');

nc_create_empty(newFile,nc_64bit_offset_mode);

% Dimension section
nc_add_dimension(newFile,'lon',length(lon));
nc_add_dimension(newFile,'lat',length(lat));
nc_add_dimension(newFile,'lrf_time',0);

% Variables section

dum.Name = 'lon';
dum.Nctype = 'float';
dum.Dimension = {'lon'};
dum.Attribute = struct('Name',{'long_name','units','field'},'Value',{'longitude','degrees_east','time, scalar, series'});
nc_addvar(newFile,dum);

dum.Name = 'lat';
dum.Nctype = 'float';
dum.Dimension = {'lat'};
dum.Attribute = struct('Name',{'long_name','units','field'},'Value',{'latitude','degrees_north','time, scalar, series'});
nc_addvar(newFile,dum);

dum.Name = 'lrf_time';
dum.Nctype = 'double';
dum.Dimension = {'lrf_time'};
dum.Attribute = struct('Name',{'long_name','units','calendar','field'},'Value',{'time since initialization','days since 1900-01-01 00:00:00','gregorian','time, scalar, series'});
nc_addvar(newFile,dum)

dum.Name = 'lrf_down';
dum.Nctype = 'float';
dum.Dimension = {'lrf_time','lat','lon'};
dum.Attribute = struct('Name',{'long_name','units','time','coordinates','field'},'Value',{'net longwave radiation flux','meter second-1','lrf_time','lon lat lrf_time','net longwave flux, scalar, series'});
nc_addvar(newFile,dum);



% Global attributes section

nc_attput(newFile,nc_global,'title', 'surface forcing data from Brian' );
nc_attput(newFile,nc_global,'type', 'ROMS/TOMS history file' );
nc_attput(newFile,nc_global,'format', 'netCDF-3 64bit offset file' );

% Fill in grid data
nc_varput(newFile,'lat'  ,lat);
nc_varput(newFile,'lon'  ,lon);
nc_varput(newFile,'lwrad_down',var);
nc_varput(newFile,'lrf_time',time);

%% Uwind

oldFile = 'bak/Uwind_2022.nc_ORIG';
newFile = 'Uwind_2022.nc';

lon = nc_varget(oldFile,'lon');
lat = nc_varget(oldFile,'lat');
var = nc_varget(oldFile,'Uwind');
time = nc_varget(oldFile,'wind_time');

nc_create_empty(newFile,nc_64bit_offset_mode);

% Dimension section
nc_add_dimension(newFile,'lon',length(lon));
nc_add_dimension(newFile,'lat',length(lat));
nc_add_dimension(newFile,'wind_time',0);

% Variables section

dum.Name = 'lon';
dum.Nctype = 'float';
dum.Dimension = {'lon'};
dum.Attribute = struct('Name',{'long_name','units','field'},'Value',{'longitude','degrees_east','time, scalar, series'});
nc_addvar(newFile,dum);

dum.Name = 'lat';
dum.Nctype = 'float';
dum.Dimension = {'lat'};
dum.Attribute = struct('Name',{'long_name','units','field'},'Value',{'latitude','degrees_north','time, scalar, series'});
nc_addvar(newFile,dum);

dum.Name = 'wind_time';
dum.Nctype = 'double';
dum.Dimension = {'wind_time'};
dum.Attribute = struct('Name',{'long_name','units','calendar','field'},'Value',{'time since initialization','days since 1900-01-01 00:00:00','gregorian','time, scalar, series'});
nc_addvar(newFile,dum)

dum.Name = 'Uwind';
dum.Nctype = 'float';
dum.Dimension = {'wind_time','lat','lon'};
dum.Attribute = struct('Name',{'long_name','units','time','coordinates','field'},'Value',{'u-wind component at 10m','meter second-1','wind_time','lon lat wind_time','u-wind velocity, scalar, series'});
nc_addvar(newFile,dum);



% Global attributes section

nc_attput(newFile,nc_global,'title', 'surface forcing data from Brian' );
nc_attput(newFile,nc_global,'type', 'ROMS/TOMS history file' );
nc_attput(newFile,nc_global,'format', 'netCDF-3 64bit offset file' );

% Fill in grid data
nc_varput(newFile,'lat'  ,lat);
nc_varput(newFile,'lon'  ,lon);
nc_varput(newFile,'Uwind',var);
nc_varput(newFile,'wind_time',time);

%% Vwind

oldFile = 'bak/Vwind_2022.nc_ORIG';
newFile = 'Vwind_2022.nc';

lon = nc_varget(oldFile,'lon');
lat = nc_varget(oldFile,'lat');
var = nc_varget(oldFile,'Vwind');
time = nc_varget(oldFile,'wind_time');

nc_create_empty(newFile,nc_64bit_offset_mode);

% Dimension section
nc_add_dimension(newFile,'lon',length(lon));
nc_add_dimension(newFile,'lat',length(lat));
nc_add_dimension(newFile,'wind_time',0);

% Variables section

dum.Name = 'lon';
dum.Nctype = 'float';
dum.Dimension = {'lon'};
dum.Attribute = struct('Name',{'long_name','units','field'},'Value',{'longitude','degrees_east','time, scalar, series'});
nc_addvar(newFile,dum);

dum.Name = 'lat';
dum.Nctype = 'float';
dum.Dimension = {'lat'};
dum.Attribute = struct('Name',{'long_name','units','field'},'Value',{'latitude','degrees_north','time, scalar, series'});
nc_addvar(newFile,dum);

dum.Name = 'wind_time';
dum.Nctype = 'double';
dum.Dimension = {'wind_time'};
dum.Attribute = struct('Name',{'long_name','units','calendar','field'},'Value',{'time since initialization','days since 1900-01-01 00:00:00','gregorian','time, scalar, series'});
nc_addvar(newFile,dum)

dum.Name = 'Vwind';
dum.Nctype = 'float';
dum.Dimension = {'wind_time','lat','lon'};
dum.Attribute = struct('Name',{'long_name','units','time','coordinates','field'},'Value',{'v-wind component at 10m','meter second-1','wind_time','lon lat wind_time','u-wind velocity, scalar, series'});
nc_addvar(newFile,dum);



% Global attributes section

nc_attput(newFile,nc_global,'title', 'surface forcing data from Brian' );
nc_attput(newFile,nc_global,'type', 'ROMS/TOMS history file' );
nc_attput(newFile,nc_global,'format', 'netCDF-3 64bit offset file' );

% Fill in grid data
nc_varput(newFile,'lat'  ,lat);
nc_varput(newFile,'lon'  ,lon);
nc_varput(newFile,'Vwind',var);
nc_varput(newFile,'wind_time',time);

