clear

load ./ROMSout.mat;
load ./zsliceStuff.mat;
load ./subGrid.mat;

zGrid=subGrid.zGrid;
range=subGrid.range;

lonUgrid=subGrid.lonUgrid;
latUgrid=subGrid.latUgrid;
lonVgrid=subGrid.lonVgrid;
latVgrid=subGrid.latVgrid;
lonRHOgrid=subGrid.lonRHOgrid;
latRHOgrid=subGrid.latRHOgrid;
fileList=subGrid.fileList;

lat_min=subGrid.lat_min;
lat_max=subGrid.lat_max;
lon_min=subGrid.lon_min;
lon_max=subGrid.lon_max;

range=subGrid.range;

gridFile=subGrid.gridFile;



%% Generate the netcdf container




%!!!!!!!!!!!!! Update for each variable


outFile = strcat('../netcdf_regrid/FLUX',range,'.nc')

mkdir ../netcdf_regrid
nc_create_empty(outFile,nc_64bit_offset_mode);

% Dimension section
nc_add_dimension(outFile,'lon_u',length(lonUgrid));
nc_add_dimension(outFile,'lat_u',length(latUgrid));
nc_add_dimension(outFile,'lon_v',length(lonVgrid));
nc_add_dimension(outFile,'lat_v',length(latVgrid));
nc_add_dimension(outFile,'lon_rho',length(lonRHOgrid));
nc_add_dimension(outFile,'lat_rho',length(latRHOgrid));
% nc_add_dimension(outFile,'z',length(zGrid));
nc_add_dimension(outFile,'ocean_time',0);

% Variables section

dum.Name = 'lon_u';
dum.Nctype = 'float';
dum.Dimension = {'lon_u'};
dum.Attribute = struct('Name',{'long_name','units','field'},'Value',{'longitude on U-grid','degrees_east','time, scalar, series'});
nc_addvar(outFile,dum);

dum.Name = 'lat_u';
dum.Nctype = 'float';
dum.Dimension = {'lat_u'};
dum.Attribute = struct('Name',{'long_name','units','field'},'Value',{'latitude on U-grid','degrees_north','time, scalar, series'});
nc_addvar(outFile,dum);

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

dum.Name = 'lon_rho';
dum.Nctype = 'float';
dum.Dimension = {'lon_rho'};
dum.Attribute = struct('Name',{'long_name','units','field'},'Value',{'longitude on RHO-grid','degrees_east','time, scalar, series'});
nc_addvar(outFile,dum);

dum.Name = 'lat_rho';
dum.Nctype = 'float';
dum.Dimension = {'lat_rho'};
dum.Attribute = struct('Name',{'long_name','units','field'},'Value',{'latitude on RHO-grid','degrees_north','time, scalar, series'});
nc_addvar(outFile,dum);



% dum.Name = 'z';
% dum.Nctype = 'float';
% dum.Dimension = {'z'};
% dum.Attribute = struct('Name',{'long_name','units','field'},'Value',{'z','meters','time, scalar, series'});
% nc_addvar(outFile,dum);

dum.Name = 'ocean_time';
dum.Nctype = 'double';
dum.Dimension = {'ocean_time'};
dum.Attribute = struct('Name',{'long_name','units','calendar','field'},'Value',{'time since initialization','seconds since 1900-01-01 00:00:00','gregorian','time, scalar, series'});
nc_addvar(outFile,dum)

dum.Name = 'shflux';
dum.Nctype = 'float';
dum.Dimension = {'ocean_time','lat_rho','lon_rho'};
dum.Attribute = struct('Name',{'long_name','units','negative_value','positive_value','time','coordinates','field'},'Value',{'surface net heat flux','watt meter-2','upward flux, cooling','downward flux, heating','ocean_time','lon_rho lat_rho ocean_time','surface heat flux, scalar, series'});
nc_addvar(outFile,dum);

dum.Name = 'ssflux';
dum.Nctype = 'float';
dum.Dimension = {'ocean_time','lat_rho','lon_rho'};
dum.Attribute = struct('Name',{'long_name','units','negative_value','positive_value','time','coordinates','field'},'Value',{'surface net salt flux (E-P)*SALT','meter second-1','upward flux, freshening (net precipitation)','downward flux, salting (net evaporation)','ocean_time','lon_rho lat_rho ocean_time','surface net salt flux, scalar, series'});
nc_addvar(outFile,dum);

dum.Name = 'swrad';
dum.Nctype = 'float';
dum.Dimension = {'ocean_time','lat_rho','lon_rho'};
dum.Attribute = struct('Name',{'long_name','units','negative_value','positive_value','time','coordinates','field'},'Value',{'solar shortwave radiation flux','watt meter-2','upward flux, cooling','downward flux, heating','ocean_time','lon_rho lat_rho ocean_time','shortwave radiation, scalar, series'});
nc_addvar(outFile,dum);

dum.Name = 'lwrad';
dum.Nctype = 'float';
dum.Dimension = {'ocean_time','lat_rho','lon_rho'};
dum.Attribute = struct('Name',{'long_name','units','negative_value','positive_value','time','coordinates','field'},'Value',{'surface net longwave radiation flux','watt meter-2','upward flux, cooling','downward flux, heating','ocean_time','lon_rho lat_rho ocean_time','longwave radiation, scalar, series'});
nc_addvar(outFile,dum);

dum.Name = 'latent';
dum.Nctype = 'float';
dum.Dimension = {'ocean_time','lat_rho','lon_rho'};
dum.Attribute = struct('Name',{'long_name','units','negative_value','positive_value','time','coordinates','field'},'Value',{'surface net latent heat flux','watt meter-2','upward flux, cooling','downward flux, heating','ocean_time','lon_rho lat_rho ocean_time','latent heat flux, scalar, series'});
nc_addvar(outFile,dum);

dum.Name = 'sensible';
dum.Nctype = 'float';
dum.Dimension = {'ocean_time','lat_rho','lon_rho'};
dum.Attribute = struct('Name',{'long_name','units','negative_value','positive_value','time','coordinates','field'},'Value',{'surface net sensible heat flux','watt meter-2','upward flux, cooling','downward flux, heating','ocean_time','lon_rho lat_rho ocean_time','sensible heat flux, scalar, series'});
nc_addvar(outFile,dum);

dum.Name = 'sustr';
dum.Nctype = 'float';
dum.Dimension = {'ocean_time','lat_u','lon_u'};
dum.Attribute = struct('Name',{'long_name','units','time','coordinates','field'},'Value',{'surface u-momentum stress','newton meter-2','ocean_time','lon_u lat_u ocean_time','surface u-momentum stress, scalar, series'});
nc_addvar(outFile,dum);

dum.Name = 'svstr';
dum.Nctype = 'float';
dum.Dimension = {'ocean_time','lat_v','lon_v'};
dum.Attribute = struct('Name',{'long_name','units','time','coordinates','field'},'Value',{'surface v-momentum stress','newton meter-2','ocean_time','lon_v lat_v ocean_time','surface v-momentum stress, scalar, series'});
nc_addvar(outFile,dum);

dum.Name = 'depth';
dum.Nctype = 'float';
dum.Dimension = {'lat_rho','lon_rho'};
dum.Attribute = struct('Name',{'long_name','units','coordinates','field'},'Value',{'bathymetry on RHO-grid','meter','lon_u lat_u','bathymetry, scalar, series'});
nc_addvar(outFile,dum);


% Global attributes section

nc_attput(outFile,nc_global,'title', 'Bay of Bengal - 1/32 degree grid' );
nc_attput(outFile,nc_global,'type', 'ROMS/TOMS history file' );
nc_attput(outFile,nc_global,'format', 'netCDF-3 64bit offset file' );

% Fill in grid data
nc_varput(outFile,'lat_u',latUgrid);
nc_varput(outFile,'lon_u',lonUgrid);
nc_varput(outFile,'lat_v',latVgrid);
nc_varput(outFile,'lon_v',lonVgrid);
nc_varput(outFile,'lat_rho',latRHOgrid);
nc_varput(outFile,'lon_rho',lonRHOgrid);
% nc_varput(outFile,'z'  ,zGrid);

%% Get the bathymetry and write to the regrid file

h = nc_varget(gridFile,'h');
nc_varput(outFile,'depth',h(lat_min:lat_max,lon_min:lon_max))



%% Run the job - First do everything in the 2D history files
%   Each file has a day's worth of hourly data, so 24 snapshots per file

nameTemp=dir('../netcdf_All/*_his2_*');
fileList={ nameTemp.name};

clearvars VARxieta;
tvec=[];

mask = ROMSout.mask_rho;
dry = find(mask==0);
mask(dry) = NaN;

for ii = [1:length(fileList)]

    tmp = strcat('../netcdf_All/',fileList(ii));
    his2File = tmp{1};
    
    
        VARxieta = squeeze( nc_varget(his2File,'shflux',   [0 0 0],[-1 -1 -1]) );     
        for tt = [1:24]
            VARnew(1,:,:) = squeeze(VARxieta(tt,:,:)).*mask;
%             nc_varput(outFile,'shflux',   VARnew(1,lat_min:lat_max,lon_min:lon_max),[tt-1 0 0],[1 length(latGrid) length(lonGrid) ]);        
            nc_varput(outFile,'shflux',   VARnew(1,lat_min:lat_max,lon_min:lon_max),[24*(ii-1)+tt-1 0 0],[1 length(latRHOgrid) length(lonRHOgrid) ]);
        end
        
        VARxieta = squeeze( nc_varget(his2File,'ssflux',   [0 0 0],[-1 -1 -1]) );     
        for tt = [1:24]
            VARnew(1,:,:) = squeeze(VARxieta(tt,:,:)).*mask;
%             nc_varput(outFile,'shflux',   VARnew(1,lat_min:lat_max,lon_min:lon_max),[tt-1 0 0],[1 length(latGrid) length(lonGrid) ]);        
            nc_varput(outFile,'ssflux',   VARnew(1,lat_min:lat_max,lon_min:lon_max),[24*(ii-1)+tt-1 0 0],[1 length(latRHOgrid) length(lonRHOgrid) ]);
        end

        VARxieta = squeeze( nc_varget(his2File,'swrad',   [0 0 0],[-1 -1 -1]) );     
        for tt = [1:24]
            VARnew(1,:,:) = squeeze(VARxieta(tt,:,:)).*mask;
%             nc_varput(outFile,'shflux',   VARnew(1,lat_min:lat_max,lon_min:lon_max),[tt-1 0 0],[1 length(latGrid) length(lonGrid) ]);        
            nc_varput(outFile,'swrad',   VARnew(1,lat_min:lat_max,lon_min:lon_max),[24*(ii-1)+tt-1 0 0],[1 length(latRHOgrid) length(lonRHOgrid) ]);
        end    
        
        VARxieta = squeeze( nc_varget(his2File,'lwrad',   [0 0 0],[-1 -1 -1]) );     
        for tt = [1:24]
            VARnew(1,:,:) = squeeze(VARxieta(tt,:,:)).*mask;
%             nc_varput(outFile,'shflux',   VARnew(1,lat_min:lat_max,lon_min:lon_max),[tt-1 0 0],[1 length(latGrid) length(lonGrid) ]);        
            nc_varput(outFile,'lwrad',   VARnew(1,lat_min:lat_max,lon_min:lon_max),[24*(ii-1)+tt-1 0 0],[1 length(latRHOgrid) length(lonRHOgrid) ]);
        end        

        VARxieta = squeeze( nc_varget(his2File,'latent',   [0 0 0],[-1 -1 -1]) );     
        for tt = [1:24]
            VARnew(1,:,:) = squeeze(VARxieta(tt,:,:)).*mask;
%             nc_varput(outFile,'shflux',   VARnew(1,lat_min:lat_max,lon_min:lon_max),[tt-1 0 0],[1 length(latGrid) length(lonGrid) ]);        
            nc_varput(outFile,'latent',   VARnew(1,lat_min:lat_max,lon_min:lon_max),[24*(ii-1)+tt-1 0 0],[1 length(latRHOgrid) length(lonRHOgrid) ]);
        end
        
        VARxieta = squeeze( nc_varget(his2File,'sensible',   [0 0 0],[-1 -1 -1]) );     
        for tt = [1:24]
            VARnew(1,:,:) = squeeze(VARxieta(tt,:,:)).*mask;
%             nc_varput(outFile,'shflux',   VARnew(1,lat_min:lat_max,lon_min:lon_max),[tt-1 0 0],[1 length(latGrid) length(lonGrid) ]);        
            nc_varput(outFile,'sensible',   VARnew(1,lat_min:lat_max,lon_min:lon_max),[24*(ii-1)+tt-1 0 0],[1 length(latRHOgrid) length(lonRHOgrid) ]);
        end
        
%         VARxieta = squeeze( nc_varget(his2File,'sustr',   [0 0 0],[-1 -1 -1]) );     
%         for tt = [1:24]
%             VARnew(1,:,:) = squeeze(VARxieta(tt,:,:)).*mask;
% %             nc_varput(outFile,'shflux',   VARnew(1,lat_min:lat_max,lon_min:lon_max),[tt-1 0 0],[1 length(latGrid) length(lonGrid) ]);        
%             nc_varput(outFile,'sustr',   VARnew(1,lat_min:lat_max,lon_min:lon_max),[24*(ii-1)+tt-1 0 0],[1 length(latUgrid) length(lonUgrid) ]);
%         end 
%         
%         VARxieta = squeeze( nc_varget(his2File,'svstr',   [0 0 0],[-1 -1 -1]) );     
%         for tt = [1:24]
%             VARnew(1,:,:) = squeeze(VARxieta(tt,:,:)).*mask;
% %             nc_varput(outFile,'shflux',   VARnew(1,lat_min:lat_max,lon_min:lon_max),[tt-1 0 0],[1 length(latGrid) length(lonGrid) ]);        
%             nc_varput(outFile,'svstr',   VARnew(1,lat_min:lat_max,lon_min:lon_max),[24*(ii-1)+tt-1 0 0],[1 length(latVgrid) length(lonVgrid) ]);
%         end   

end


clearvars VARxieta VARnew;
tvec=[];

mask = ROMSout.mask_u;
dry = find(mask==0);
mask(dry) = NaN;

for ii = [1:length(fileList)]

    tmp = strcat('../netcdf_All/',fileList(ii));
    his2File = tmp{1};
    
        VARxieta = squeeze( nc_varget(his2File,'sustr',   [0 0 0],[-1 -1 -1]) );     
        for tt = [1:24]
            VARnew(1,:,:) = squeeze(VARxieta(tt,:,:)).*mask;
%             nc_varput(outFile,'shflux',   VARnew(1,lat_min:lat_max,lon_min:lon_max),[tt-1 0 0],[1 length(latGrid) length(lonGrid) ]);        
            nc_varput(outFile,'sustr',   VARnew(1,lat_min:lat_max,lon_min:lon_max),[24*(ii-1)+tt-1 0 0],[1 length(latUgrid) length(lonUgrid) ]);
        end 

end

clearvars VARxieta VARnew;
tvec=[];

mask = ROMSout.mask_v;
dry = find(mask==0);
mask(dry) = NaN;

for ii = [1:length(fileList)]

    tmp = strcat('../netcdf_All/',fileList(ii));
    his2File = tmp{1};
    
        VARxieta = squeeze( nc_varget(his2File,'svstr',   [0 0 0],[-1 -1 -1]) );     
        for tt = [1:24]
            VARnew(1,:,:) = squeeze(VARxieta(tt,:,:)).*mask;
%             nc_varput(outFile,'shflux',   VARnew(1,lat_min:lat_max,lon_min:lon_max),[tt-1 0 0],[1 length(latGrid) length(lonGrid) ]);        
            nc_varput(outFile,'svstr',   VARnew(1,lat_min:lat_max,lon_min:lon_max),[24*(ii-1)+tt-1 0 0],[1 length(latVgrid) length(lonVgrid) ]);
        end      
        
        
        
        t=nc_varget(his2File,'ocean_time');
        tvec = [tvec t];

end


nc_varput(outFile,'ocean_time',tvec(:));done('with t')
tvec2D = tvec;


%% %% Now do the surface stresses in the 3D history files
% %   Each file has a one snapshot
% Bac code. Get sustr and svstr from the 2D source files
% 
% % nameTemp=dir('../netcdf_All/*_his_*');
% % fileList={ nameTemp.name};
% fileList=subGrid.fileList;
% tvec=[];
% 
% for ii = [1:length(fileList)]
% 
%     tmp = strcat('../netcdf_All/',fileList(ii));
%     hisFile = tmp{1};
%  
%     clearvars VARxieta;    
%     VARxieta(1,:,:) = nc_varget(hisFile,'sustr');
%     nc_varput(outFile,'sustr',   VARxieta(1,lat_min:lat_max,lon_min:lon_max),[ii-1 0 0],[1 length(latUgrid) length(lonUgrid) ]);
%  
%     clearvars VARxieta;    
%     VARxieta(1,:,:) = nc_varget(hisFile,'svstr');
%     nc_varput(outFile,'svstr',   VARxieta(1,lat_min:lat_max,lon_min:lon_max),[ii-1 0 0],[1 length(latVgrid) length(lonVgrid) ]);
% 
%     t=nc_varget(hisFile,'ocean_time');
%     tvec = [tvec t];
% 
% end






% %% check results from a few 3D HIS files
% 
% % get new regridded file
% dataRegrid = nc_varget(outFile,'sustr');
% tRegrid = nc_varget(outFile,'ocean_time');
% 
% % get data from some his file
% for fileN = [3:10]; 
%     romsFile = char(strcat('../netcdf_All/',fileList(fileN)))
%     dataROMS = nc_varget(romsFile,'sustr');     % sustr is on the u grid
%     tROMS =  nc_varget(romsFile,'ocean_time');
% 
%     ind = find(tROMS == tRegrid)
%     dum = squeeze(dataRegrid(ind,:,:)) - dataROMS(subGrid.lat_u_min:subGrid.lat_u_max,subGrid.lon_u_min:subGrid.lon_u_max);max(abs(dum(:)))
% 
% end
    


%% check results from a 2D HIS2 file

% % get new regridded file
% dataRegrid = nc_varget(outFile,'swrad');
% tRegrid = nc_varget(outFile,'ocean_time');
% 
% % get data from some his file
% 
% fileN = 317;%%%%%%%%%%%%%%%%
% romsFile = strcat('../netcdf_All/BoB_his2_2013_daily_0',int2str(fileN),'.nc');  %%%%%%%%%%%%%%%%%%
% 
% dataROMS = nc_varget(romsFile,'swrad');
% tROMS    = nc_varget(romsFile,'ocean_time');
% 
% for tt = [1:length(tROMS)]
% 
%     ind = find(tROMS(tt) == tRegrid)
%      dum = squeeze(dataRegrid(ind,:,:)) - squeeze(dataROMS(tt,lat_min:lat_max,lon_min:lon_max-1) );max(abs(dum(:)))
% 
% end
    

