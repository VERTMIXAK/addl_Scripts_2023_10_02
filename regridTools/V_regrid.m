
clear


load ./ROMSout.mat;
load ./zsliceStuff.mat;
load ./subGrid.mat;

zGrid=subGrid.zGrid;
range=subGrid.range;

lonGrid=subGrid.lonVgrid;
latGrid=subGrid.latVgrid;
fileList=subGrid.fileList;

% lat_min=subGrid.lat_v_min;
% lat_max=subGrid.lat_v_max;
% lon_min=subGrid.lon_v_min;
% lon_max=subGrid.lon_v_max;
lat_min=subGrid.lat_min;
lat_max=subGrid.lat_max;
lon_min=subGrid.lon_min;
lon_max=subGrid.lon_max;

range=subGrid.range;


%%

% Consolidate all U files into a single file.
%


%!!!!!!!!!!!!! Update for each variable

outFile = strcat('../netcdf_regrid/V',range,'.nc')
unix('mkdir ../netcdf_regrid');

nc_create_empty(outFile,nc_64bit_offset_mode);

% Dimension section
nc_add_dimension(outFile,'lon_v',length(lonGrid));
nc_add_dimension(outFile,'lat_v',length(latGrid));
nc_add_dimension(outFile,'z',length(zGrid));
nc_add_dimension(outFile,'ocean_time',0);

% Variables section

dum.Name = 'lon_v';
dum.Nctype = 'float';
dum.Dimension = {'lon_v'};
dum.Attribute = struct('Name',{'long_name','units','field'},'Value',{'longitude on V-grid','degrees_east','time, scalar, series'});
nc_addvar(outFile,dum);

dum.Name = 'lat_v';
dum.Nctype = 'float';
dum.Dimension = {'lat_v'};
dum.Attribute = struct('Name',{'long_name','units','field'},'Value',{'latitude on V-grid','degrees_north','time, scalar, series'});
nc_addvar(outFile,dum);

dum.Name = 'z';
dum.Nctype = 'float';
dum.Dimension = {'z'};
dum.Attribute = struct('Name',{'long_name','units','field'},'Value',{'z','meters','time, scalar, series'});
nc_addvar(outFile,dum);

dum.Name = 'ocean_time';
dum.Nctype = 'double';
dum.Dimension = {'ocean_time'};
dum.Attribute = struct('Name',{'long_name','units','calendar','field'},'Value',{'time since initialization','seconds since 1900-01-01 00:00:00','gregorian','time, scalar, series'});
nc_addvar(outFile,dum)

dum.Name = 'v';
dum.Nctype = 'float';
dum.Dimension = {'ocean_time','z','lat_v','lon_v'};
dum.Attribute = struct('Name',{'long_name','units','time','coordinates','field'},'Value',{'v-momentum component','meter second-1','ocean_time','lon_v lat_v z ocean_time','v-velocity, scalar, series'});
nc_addvar(outFile,dum);



% Global attributes section

nc_attput(outFile,nc_global,'title', 'Bay of Bengal - 1/32 degree grid' );
nc_attput(outFile,nc_global,'type', 'ROMS/TOMS history file' );
nc_attput(outFile,nc_global,'format', 'netCDF-3 64bit offset file' );

% Fill in grid data
nc_varput(outFile,'lat_v',latGrid);
nc_varput(outFile,'lon_v',lonGrid);
nc_varput(outFile,'z'  ,zGrid);









%% Run the job

tvec=[];

for ii = [1:length(fileList)]

    tmp = strcat('../netcdf_All/',fileList(ii));
    hisFile = tmp{1};
    
    VARxieta = squeeze( nc_varget(hisFile,'v',   [0 0 0 0],[1 -1 -1 -1]) );
    VARnew = roms_zslice_var(VARxieta,zGrid,ROMSout,zsliceStuff);

    nc_varput(outFile,'v',   VARnew(1,:,lat_min:lat_max,lon_min:lon_max),[ii-1 0 0 0],[1 length(zGrid) length(latGrid) length(lonGrid) ]);disp(sprintf('done with z%i',ii))

    t=nc_varget(hisFile,'ocean_time');
    tvec = [tvec t];

end

nc_varput(outFile,'ocean_time',tvec);done('with t')



