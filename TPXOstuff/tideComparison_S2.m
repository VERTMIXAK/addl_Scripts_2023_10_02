%tabwindow;
clear;
warning('off','all');   % JGP the warning messages were driving me nutz
%----------------------------------------
% load tpxo ellipses
%----------------------------------------
%Note that OTIS screws up x & y convention. x(j) is the column  x index, y(i) is the row index:
base = '/import/VERTMIXFS/jgpender/ROMS/OTIS_DATA/';
ufile=[base,'u_tpxo9.v1'];
gfile=[base,'grid_tpxo9'];
mfile=[base,'Model_tpxo9.v1'];

% ufile=[base,'u_tpxo7.2'];
% gfile=[base,'grid_tpxo7.2'];
% mfile=[base,'Model_tpxo7.2'];

[~,dum] = unix('ls ../*.nc');  model.gfile = dum(1:end-1)
[~,dum] =  unix('ls ../netcdfOutput/*_his_* | head -1'); model.HISfile = dum(1:end-1)

grid = roms_get_grid(model.gfile,model.HISfile,0,1);

tpxomodel='~/archROMS/OTIS_DATA/Model_tpxo9.v1';

done('section 1')

%% Here is the stuff you want to edit

[~,dum] = unix('ls ../netcdfOutput/*.nc | tail -1 | cut -d "_" -f1');model.file_prefix = [dum(1:end-1),'_']
model.file_suffix = '';

% Use the ROMS BB to rejigger the TPXO stuff.

lon0 =  min(grid.lon_rho(:)) - .5;
lon1 =  max(grid.lon_rho(:)) + .5;

lat0 =  min(grid.lat_rho(:)) - .5;
lat1 =  max(grid.lat_rho(:)) + .5;




hskip = 4;   %!!!!!!!!!!!!!! JGP -  this was hskip = 4

myTide = 'S2';
% Single tidal component
consts = {lower(myTide)};%{'m2','s2','n2','k2','o1','p1','k1'}


% make a custom mask_rho based on a new D_min
D_min   = 100;
model.h = nc_varget(model.gfile,'h');
mask_rho = nc_varget(model.gfile,'mask_rho');
mask_u   = nc_varget(model.gfile,'mask_u');
mask_v   = nc_varget(model.gfile,'mask_v');

% fig(1);clf;pcolor(grid.lon_rho,grid.lat_rho,model.h);shading flat;colorbar
% fig(2);clf;pcolor(grid.lon_rho,grid.lat_rho,mask_rho);shading flat;colorbar
mask_rho(model.h < D_min) = 0; mask_rho(mask_rho == 0) = nan;%mask_rho=mask_rho(2:end-1,2:end-1);
fig(3);clf;pcolor(grid.lon_rho,grid.lat_rho,mask_rho);shading flat;colorbar
done('section 2')

%% Archive zeta, ubar and vbar in their own file if not already done.
if ~exist( ['./',model.file_prefix,'zeta.nc'])
    disp(['!ncrcat -v zeta -O ','../netcdfOutput/',model.file_prefix,'his2_*.nc ','./',model.file_prefix,'zeta.nc'])
    eval(['!ncrcat -v zeta -O ','../netcdfOutput/',model.file_prefix,'his2_*.nc ','./',model.file_prefix,'zeta.nc'])
%     eval(['!ncrcat -v zeta -d ocean_time,0 -O ','../netcdfOutput/',model.file_prefix,'his_*001.nc ','./',model.file_prefix,'his','_zeta.nc'])
    done('writing zeta')
    eval(['!ncrcat -v ubar -O ','../netcdfOutput/',model.file_prefix,'his2_*.nc ','./',model.file_prefix,'ubar.nc'])
%     eval(['!ncrcat -v ubar -d ocean_time,0 -O ','../netcdfOutput/',model.file_prefix,'his_*001.nc ','./',model.file_prefix,'his','_ubar.nc'])
    done('writing ubar')
    eval(['!ncrcat -v vbar                 -O ','../netcdfOutput/',model.file_prefix,'his2_*.nc ','./',model.file_prefix,'vbar.nc'])
%     eval(['!ncrcat -v vbar -d ocean_time,0 -O ','../netcdfOutput/',model.file_prefix,'his_*001.nc ','./',model.file_prefix,'his','_vbar.nc'])
    done('writing vbar')
    
%     eval('!ncrcat -O palau_his_zeta.nc palau_his2_zeta.nc palau_his2_zeta.nc');
%     eval('!ncrcat -O palau_his_ubar.nc palau_his2_ubar.nc palau_his2_ubar.nc');
%     eval('!ncrcat -O palau_his_vbar.nc palau_his2_vbar.nc palau_his2_vbar.nc');
    
    
    
end

eval(['outfile =  ''','./',model.file_prefix,num2str(lon0),'_',num2str(lon1),'_',num2str(lat0),'_',num2str(lat1),'_',num2str(hskip),'_',myTide,'.mat'''])

%% Do the tidal analysis (if it's not already done)

if ~exist(outfile)
    
    % TPXO stuff
    [tpxo.lon,tpxo.lat,tpxo.amp_zeta,tpxo.pha_zeta]=tmd_get_coeff(mfile,'z',myTide);
    [tpxo.lon,tpxo.lat,tpxo.amp_ubar,tpxo.pha_ubar]=tmd_get_coeff(mfile,'u',myTide);
    [tpxo.lon,tpxo.lat,tpxo.amp_vbar,tpxo.pha_vbar]=tmd_get_coeff(mfile,'v',myTide);done('loading tpxo')
    
    tpxo.amp_zeta(tpxo.amp_zeta==0) = nan;
    tpxo.amp_ubar(tpxo.amp_ubar==0) = nan;
    tpxo.amp_vbar(tpxo.amp_vbar==0) = nan;
    tpxo.pha_zeta(tpxo.pha_zeta==0) = nan;
    tpxo.pha_ubar(tpxo.pha_ubar==0) = nan;
    tpxo.pha_vbar(tpxo.pha_vbar==0) = nan;
    tpxo.amp_ubar = tpxo.amp_ubar/100;
    tpxo.amp_vbar = tpxo.amp_vbar/100;
    
    lon0TPXO = mod(360+lon0,360);
    lon1TPXO = mod(360+lon1,360);
    
    if lon0TPXO < lon1TPXO
        iTPXO = find(tpxo.lon>=lon0TPXO&tpxo.lon<=lon1TPXO);
        jTPXO = find(tpxo.lat>=lat0    &tpxo.lat<=lat1    );
   
        tpxo.lon = tpxo.lon(iTPXO);
        tpxo.lat = tpxo.lat(jTPXO);
        tpxo.amp_zeta = tpxo.amp_zeta(jTPXO,iTPXO);
        tpxo.amp_ubar = tpxo.amp_ubar(jTPXO,iTPXO);
        tpxo.amp_vbar = tpxo.amp_vbar(jTPXO,iTPXO);
        tpxo.pha_zeta = tpxo.pha_zeta(jTPXO,iTPXO);
        tpxo.pha_ubar = tpxo.pha_ubar(jTPXO,iTPXO);
        tpxo.pha_vbar = tpxo.pha_vbar(jTPXO,iTPXO);
    else
        iTPXO_1 = find(tpxo.lon>=lon0TPXO&tpxo.lon<=360);
        iTPXO_2 = find(tpxo.lon<=lon1TPXO               );
        jTPXO = find(tpxo.lat>=lat0    &tpxo.lat<=lat1    );
        
        tpxo.lon = [tpxo.lon(iTPXO_1),tpxo.lon(iTPXO_2)];
            tpxo.lon(tpxo.lon>180) = tpxo.lon(tpxo.lon>180) -360
        tpxo.lat = tpxo.lat(jTPXO);
        
        tpxo.amp_zeta = [ tpxo.amp_zeta(jTPXO,iTPXO_1) , tpxo.amp_zeta(jTPXO,iTPXO_2)];
        tpxo.amp_ubar = [ tpxo.amp_ubar(jTPXO,iTPXO_1) , tpxo.amp_ubar(jTPXO,iTPXO_2)];
        tpxo.amp_vbar = [ tpxo.amp_vbar(jTPXO,iTPXO_1) , tpxo.amp_vbar(jTPXO,iTPXO_2)];
        tpxo.pha_zeta = [ tpxo.pha_zeta(jTPXO,iTPXO_1) , tpxo.pha_zeta(jTPXO,iTPXO_2)];
        tpxo.pha_ubar = [ tpxo.pha_ubar(jTPXO,iTPXO_1) , tpxo.pha_ubar(jTPXO,iTPXO_2)];
        tpxo.pha_vbar = [ tpxo.pha_vbar(jTPXO,iTPXO_1) , tpxo.pha_vbar(jTPXO,iTPXO_2)];
    end
    
    fig(2);clf;pcolor(tpxo.lon,tpxo.lat,tpxo.amp_zeta);shading flat
    aaa=5;
    
    
    % ROMS stuff. It seems silly to take a subset of my own domain but I
    % guess this is the easiest way to get my footprint to match the TPXO
    % footprint.
    
%     tmplon2D=nc_varget(model.gfile,'lon_rho');
%     tmplon=tmplon2D(1,:);
%     tmplat2D=nc_varget(model.gfile,'lat_rho');
%     tmplat=tmplat2D(:,1);
%     idx = find(tmplon>=lon0&tmplon<=lon1); model.idx = idx;
%     jdx = find(tmplat>=lat0&tmplat<=lat1); model.jdx = jdx;
%     
%     
% 
%     
%     model.lat = tmplat(jdx(1:hskip:end));
%     model.lon = tmplon(idx(1:hskip:end));  
    
%     model.lat2D = tmplat2D(jdx(1:hskip:end),idx(1:hskip:end));
%     model.lon2D = tmplon2D(jdx(1:hskip:end),idx(1:hskip:end));
%     model.mask_rho  = mask_rho(jdx(1:hskip:end),idx(1:hskip:end));
%     model.mask_rho  = mask_rho(1:hskip:end,1:hskip:end);
    
    % Interpolate the relevant part of the TPXO data onto the ROMS xy grid.
    % Also, convert from cm/s to m/s.
    
    
    
    
%     idxs = find(tpxo.lon>=min(model.lon2D(:))&tpxo.lon<=max(model.lon2D(:))); tpxo.idxs = [min(idxs)-1,idxs,max(idxs)+1]; %tpxo.idxs=idxs;
%     jdxs = find(tpxo.lat>=min(model.lat2D(:))&tpxo.lat<=max(model.lat2D(:))); tpxo.jdxs = [min(jdxs)-1,jdxs,max(jdxs)+1]; %tpxo.jdxs=jdxs;
%     
%     tpxo.jdxs = tpxo.jdxs(2:end);
%     tpxo.idxs = tpxo.idxs(2:end);
    
%     tpxo.amp_zeta_BB = interp2(tpxo.lon(tpxo.idxs),tpxo.lat(tpxo.jdxs),tpxo.amp_zeta(tpxo.jdxs,tpxo.idxs),model.lon,model.lat);
%     tpxo.pha_zeta_BB = interp2(tpxo.lon(tpxo.idxs),tpxo.lat(tpxo.jdxs),tpxo.pha_zeta(tpxo.jdxs,tpxo.idxs),model.lon,model.lat);
%     tpxo.amp_ubar_BB = interp2(tpxo.lon(tpxo.idxs),tpxo.lat(tpxo.jdxs),tpxo.amp_ubar(tpxo.jdxs,tpxo.idxs),model.lon,model.lat);
%     tpxo.pha_ubar_BB = interp2(tpxo.lon(tpxo.idxs),tpxo.lat(tpxo.jdxs),tpxo.pha_ubar(tpxo.jdxs,tpxo.idxs),model.lon,model.lat);
%     tpxo.amp_vbar_BB = interp2(tpxo.lon(tpxo.idxs),tpxo.lat(tpxo.jdxs),tpxo.amp_vbar(tpxo.jdxs,tpxo.idxs),model.lon,model.lat);
%     tpxo.pha_vbar_BB = interp2(tpxo.lon(tpxo.idxs),tpxo.lat(tpxo.jdxs),tpxo.pha_vbar(tpxo.jdxs,tpxo.idxs),model.lon,model.lat);


    model.lat_rho = grid.lat_rho(1:hskip:end,1:hskip:end); 
    model.lat_u   = grid.lat_u(1:hskip:end,1:hskip:end); 
    model.lat_v   = grid.lat_v(1:hskip:end,1:hskip:end); 
    model.lon_rho = grid.lon_rho(1:hskip:end,1:hskip:end); 
    model.lon_u   = grid.lon_u(1:hskip:end,1:hskip:end); 
    model.lon_v   = grid.lon_v(1:hskip:end,1:hskip:end); 
    
        

    tpxo.amp_zeta_BB = interp2(tpxo.lon,tpxo.lat,tpxo.amp_zeta,model.lon_rho,model.lat_rho);
    tpxo.pha_zeta_BB = interp2(tpxo.lon,tpxo.lat,tpxo.pha_zeta,model.lon_rho,model.lat_rho);
    tpxo.amp_ubar_BB = interp2(tpxo.lon,tpxo.lat,tpxo.amp_ubar,model.lon_u,  model.lat_u);
    tpxo.pha_ubar_BB = interp2(tpxo.lon,tpxo.lat,tpxo.pha_ubar,model.lon_u,  model.lat_u);
    tpxo.amp_vbar_BB = interp2(tpxo.lon,tpxo.lat,tpxo.amp_vbar,model.lon_v,  model.lat_v);
    tpxo.pha_vbar_BB = interp2(tpxo.lon,tpxo.lat,tpxo.pha_vbar,model.lon_v,  model.lat_v);
    
    model.mask_rho   = grid.mask_rho(1:hskip:end,1:hskip:end); 
    model.mask_u     = grid.mask_u(1:hskip:end,1:hskip:end); 
    model.mask_v     = grid.mask_v(1:hskip:end,1:hskip:end); 





    % Load in zeta
    
    zeta = nc_varget(['./',model.file_prefix,'zeta.nc'],'zeta');
    model.zeta = zeta(:,1:hskip:end,1:hskip:end);
    clear zeta

    
    % Load in ubar and vbar
    
    ubar = nc_varget(['./',model.file_prefix,'ubar.nc'],'ubar');
    model.ubar = ubar(:,1:hskip:end,1:hskip:end);
    clear ubar
    vbar = nc_varget(['./',model.file_prefix,'vbar.nc'],'vbar');
    model.vbar = vbar(:,1:hskip:end,1:hskip:end);
    clear vbar
    done('ubar and vbar')
    
    
    
    
    

    times=roms_get_date(['./',model.file_prefix,'zeta.nc']);datestr(times(1:3))

    tInterval = round( (times(2)-times(1)) *24*1000 )/1000;
    
    
    
    
    % Get the area differentials for Harper's figure of merit.
    %   Try to do this right. Even if lat and lon are on a perfectly
    %   rectilinear grid, this means dx and dy will vary. If it's a
    %   telescoping grid then this is all the more true.
    %   roms_get_grid has given me x_rho, y_psi, etc etc
    
    % rho
    X  = grid.x_rho(1:hskip:end,1:hskip:end);
    Y  = grid.y_rho(1:hskip:end,1:hskip:end);
    dX = X(:,2:end) - X(:,1:end-1);
    dY = Y(2:end,:) - Y(1:end-1,:);
    model.dA_rho = dX(1:end-1,:) .* dY(:,1:end-1);
    
    % get the area area up to the proper size by duplicating the last row
    % and column
    [dumy,dumx]=size(model.dA_rho);
    dum=zeros(dumy+1,dumx+1);
    dum(1:end-1,1:end-1) = model.dA_rho;
    dum(end,1:end-1) = model.dA_rho(end,:);
    dum(1:end-1,end) = model.dA_rho(:,end);
    dum(end,end) = model.dA_rho(end,end);
    model.dA_rho = dum;
    
    % u
    X  = grid.x_u(1:hskip:end,1:hskip:end);
    Y  = grid.y_u(1:hskip:end,1:hskip:end);
    dX = X(:,2:end) - X(:,1:end-1);
    dY = Y(2:end,:) - Y(1:end-1,:);
    model.dA_u = dX(1:end-1,:) .* dY(:,1:end-1);
    
    % get the area area up to the proper size by duplicating the last row
    % and column
    [dumy,dumx]=size(model.dA_u);
    dum=zeros(dumy+1,dumx+1);
    dum(1:end-1,1:end-1) = model.dA_u;
    dum(end,1:end-1) = model.dA_u(end,:);
    dum(1:end-1,end) = model.dA_u(:,end);
    dum(end,end) = model.dA_u(end,end);
    model.dA_u = dum;
    
    % v
    X  = grid.x_v(1:hskip:end,1:hskip:end);
    Y  = grid.y_v(1:hskip:end,1:hskip:end);
    dX = X(:,2:end) - X(:,1:end-1);
    dY = Y(2:end,:) - Y(1:end-1,:);
    model.dA_v = dX(1:end-1,:) .* dY(:,1:end-1);
    
    % get the area area up to the proper size by duplicating the last row
    % and column
    [dumy,dumx]=size(model.dA_v);
    dum=zeros(dumy+1,dumx+1);
    dum(1:end-1,1:end-1) = model.dA_v;
    dum(end,1:end-1) = model.dA_v(end,:);
    dum(1:end-1,end) = model.dA_v(:,end);
    dum(end,end) = model.dA_v(end,end);
    model.dA_v = dum;
    
    
   
%% zeta section

    [NY,NX] = size(model.mask_rho);
    model.amp_zeta=nan*ones(NY,NX);model.pha_zeta=model.amp_zeta;
    for jdx = 1:NY
        disp([num2str(jdx),' of ',num2str(NY),' zeta'])
        for idx = 1:NX;
            dat = sq(model.zeta(:,jdx,idx));
            if find(1-isnan(dat))
                [name,freq,tidecon,zout] =t_tide2(dat,'start',times(1),'interval',tInterval);
                % find the correct tide
                bingo=[];
                for tdx = 1:length(name);
                    tmpname = name(tdx,1:length(myTide));
                    if strcmp(tmpname,myTide)
                        bingo=tdx;
                    end
                end
                model.amp_zeta(jdx,idx)=tidecon(bingo,1);
                model.pha_zeta(jdx,idx)=tidecon(bingo,3);
                
%                 [prediction,conList]=tmd_tide_pred(tpxomodel,times,model.lat(jdx),model.lon(idx),'z',[1]);
%                 fig(99);clf;
%                 dat - mean(dat);plot(ans(1:end));hold on;
%                 plot(prediction(1:end),'r');
%                 
%                 aaa=5;
                
            end
        end
    end
 


%     deltaPhase = mod(2*3.14159*24*freq(bingo)*midTime,360)
%     tpxo.pha_zeta_BB = mod( tpxo.pha_zeta_BB - deltaPhase,360);   
    
%% ubar section
    
    [NY,NX] = size(model.mask_u);
    model.amp_ubar=nan*ones(NY,NX);model.pha_ubar=model.amp_ubar;
    for jdx = 1:NY
        disp([num2str(jdx),' of ',num2str(NY),' ubar'])
        for idx = 1:NX;
            dat = model.ubar(:,jdx,idx);
            if find(1-isnan(dat))
                [name,freq,tidecon,zout] =t_tide2(dat,'start',times(1),'interval',tInterval);
                % find the correct tide
                bingo=[];
                for tdx = 1:length(name);
                    tmpname = name(tdx,1:length(myTide));
                    if strcmp(tmpname,myTide)
                        bingo=tdx;
                    end
                end
                model.amp_ubar(jdx,idx)=tidecon(bingo,1);
                model.pha_ubar(jdx,idx)=tidecon(bingo,3);
            end
        end
    end

%     deltaPhase = mod(2*3.14159*24*freq(bingo)*midTime,360)
%     tpxo.pha_ubar_BB = mod( tpxo.pha_ubar_BB - deltaPhase,360);    
    
%% vbar section

    [NY,NX] = size(model.mask_v);
    model.amp_vbar=nan*ones(NY,NX);model.pha_vbar=model.amp_vbar;
    for jdx = 1:NY
        disp([num2str(jdx),' of ',num2str(NY),' vbar'])
        for idx = 1:NX;
            dat = model.vbar(:,jdx,idx);
            if find(1-isnan(dat))
                [name,freq,tidecon,zout] =t_tide2(dat,'start',times(1),'interval',tInterval);
                % find the correct tide
                bingo=[];
                for tdx = 1:length(name);
                    tmpname = name(tdx,1:length(myTide));
                    if strcmp(tmpname,myTide)
                        bingo=tdx;
                    end
                end
                model.amp_vbar(jdx,idx)=tidecon(bingo,1);
                model.pha_vbar(jdx,idx)=tidecon(bingo,3);
            end
        end
    end
    
%     deltaPhase = mod(2*3.14159*24*freq(bingo)*midTime,360)
%     tpxo.pha_vbar_BB = mod( tpxo.pha_vbar_BB - deltaPhase,360);
    

    %%
    eval(['save ',outfile,' model tpxo'])
    disp(['save ',outfile,' model tpxo'])
    

else
    disp(['loading ',outfile])
    load(outfile)
end

 %% Harper's figure of merit
    
    % It'd be nice if I could put an image into these scripts. A picture's
    % worth a thousand words....
    % Anyhoo, it looks like the square root of
    %
    %   <  doubleIntegralOverArea(zeta_roms - zeta_tpxo)^2  >
    % The area differential
    %   dA = dx dy
    % is constant for this particular grid, but I want to write this up so that
    % it works on one of the telescoping grids. Assuming I've dont this
    % correctly, I have the area differential sized the same as zeta_roms and
    % zeta_tpxo.
    
    % size(model.amp_zeta)
    % size(tpxo.amp_zeta_BB)
    % size(model.mask_rho)
    % size(model.mask_rho)
    
    num=(model.amp_zeta - tpxo.amp_zeta_BB).^2 .*model.dA_rho.*model.mask_rho;
    den=model.dA_rho.*model.mask_rho;
    model.D_rho = sqrt( nansum(num(:))/nansum(den(:)) )
    
    num=(model.amp_ubar - tpxo.amp_ubar_BB).^2 .*model.dA_u.*model.mask_rho;
    den=model.dA_u.*model.mask_rho;
    model.D_u = sqrt( nansum(num(:))/nansum(den(:)) )
    
    num=(model.amp_vbar - tpxo.amp_vbar_BB).^2 .*model.dA_v.*model.mask_rho;
    den=model.dA_v.*model.mask_rho;
    model.D_v = sqrt( nansum(num(:))/nansum(den(:)) )
    
    % sqrt(sum(ans(:))/sum(model.dA(:)))
    % fig(99);pcolor(ans);shading flat;colorbar
       
    

%%  JGP plots take place here

% unix('\rm -r figures');
unix('mkdir figures');


%% Zeta tides

ampLim = [0,2];
phaLim = [50,320];
xLim = [220 226.5];
yLim = [53.5 58.5];

figure(1);clf;
subplot(2,2,1);  myMean = nanmean(model.amp_zeta(:));
pcolor(model.lon_rho,model.lat_rho,model.amp_zeta);shading flat;
caxis(ampLim);
rect;hold on
% contour(model.lon,model.lat,model.amp_zeta,[0:.05:1],'LineColor','Black','Showtext','on')
title( ['ROMS - ',myTide,' amp (mean=',num2str( myMean ),')']);colorbar;


subplot(2,2,2)
pcolor(model.lon_rho,model.lat_rho,model.pha_zeta);shading flat;
caxis(phaLim);
rect;hold on
% contour(model.lon,model.lat,model.pha_zeta,[0:30:345],'LineColor','Black','Showtext','on')
title(['ROMS - ',myTide,' phase']);colorbar

subplot(2,2,3);
tpxo.amp_zeta; myMean=nanmean(ans(:));
pcolor(model.lon_rho,model.lat_rho,tpxo.amp_zeta_BB);shading flat;
% pcolor(tpxo.lon,tpxo.lat,tpxo.amp_zeta);shading flat;
% imagesc(model.lon,model.lat,tpxo.amp_zeta_BB);axis xy;
caxis(ampLim);
rect;hold on
% contour(model.lon,model.lat,tpxo.amp_zeta_BB,[0:.05:1],'LineColor','Black','Showtext','on')
title(['TPXO, ',myTide,' amp (mean=',num2str( myMean ),')']);colorbar;


subplot(2,2,4)
% imagesc(model.lon,model.lat,tpxo.pha_zeta_BB );axis xy;
% pcolor(tpxo.lon,tpxo.lat,tpxo.pha_zeta);shading flat;
pcolor(model.lon_rho,model.lat_rho,tpxo.pha_zeta_BB);shading flat;
caxis(phaLim);
rect;hold on
% contour(model.lon,model.lat,tpxo.pha_zeta_BB ,[0:30:360],'LineColor','Black','Showtext','on')
title(['TPXO, ',myTide,' phase']);colorbar

suptitle(['Zeta    D=',num2str(model.D_rho)])
print(['figures/Zeta_',myTide,'tides'],'-djpeg');

%% Ubar tides

ampLim = [0,.3];
phaLim = [0,360];

figure(2);clf;
subplot(2,2,1);  myMean = nanmean(model.amp_ubar(:));
pcolor(model.lon_u,model.lat_u, model.amp_ubar);shading flat;
caxis(ampLim);
rect;hold on
% contour(model.lon,model.lat,model.amp_ubar,[0:.05:1],'LineColor','Black','Showtext','on')
title( ['ROMS - ',myTide,' amp (mean=',num2str( myMean ),')']);colorbar;

subplot(2,2,2)
pcolor(model.lon_u,model.lat_u,model.pha_ubar);shading flat;
caxis(phaLim);
rect;hold on
% contour(model.lon,model.lat,model.pha_ubar,[0:30:345],'LineColor','Black','Showtext','on')
title(['ROMS - ',myTide,' phase']);colorbar

subplot(2,2,3); tpxo.amp_ubar; myMean=nanmean(ans(:));
% imagesc(model.lon,model.lat,tpxo.amp_ubar_BB);axis xy;
% pcolor(tpxo.lon,tpxo.lat,tpxo.amp_ubar);shading flat;
pcolor(model.lon_u,model.lat_u,tpxo.amp_ubar_BB);shading flat;
caxis(ampLim);
rect;hold on
% contour(model.lon,model.lat,tpxo.amp_ubar_BB,[0:.05:1],'LineColor','Black','Showtext','on')
title(['TPXO, ',myTide,' amp (mean=',num2str( myMean ),')']);colorbar;

subplot(2,2,4)
% imagesc(model.lon,model.lat,tpxo.pha_ubar_BB);axis xy;
pcolor(model.lon_u,model.lat_u,tpxo.pha_ubar_BB);shading flat;
caxis(phaLim);
rect;hold on
% contour(model.lon,model.lat,tpxo.pha_ubar_BB,[0:30:360],'LineColor','Black','Showtext','on')
title(['TPXO, ',myTide,' phase']);colorbar


suptitle(['Ubar    D=',num2str(model.D_u)])
print(['figures/Ubar_',myTide,'tides'],'-djpeg');

%% Vbar tides

ampLim = [0,.4];
phaLim = [50,360];

figure(3);clf;
subplot(2,2,1);  myMean =  nanmean(model.amp_vbar(:));
pcolor(model.lon_v,model.lat_v,  model.amp_vbar);shading flat;
caxis(ampLim);
rect;hold on
% contour(model.lon,model.lat,model.amp_vbar,[0:.05:1],'LineColor','Black','Showtext','on')
title(['ROMS - ',myTide,' amp (mean=',num2str( myMean ),')']);colorbar;

subplot(2,2,2)
pcolor(model.lon_v,model.lat_v,model.pha_vbar);shading flat;
caxis(phaLim);
rect;hold on
% contour(model.lon,model.lat,model.pha_vbar,[0:30:345],'LineColor','Black','Showtext','on')
title(['ROMS - ',myTide,' phase']);colorbar

subplot(2,2,3); tpxo.amp_vbar; myMean=nanmean(ans(:));
pcolor(model.lon_v,model.lat_v,tpxo.amp_vbar_BB);shading flat;
% imagesc(model.lon,model.lat,tpxo.amp_vbar_BB);axis xy;
caxis(ampLim);
rect;hold on
% contour(model.lon,model.lat,tpxo.amp_vbar_BB,[0:.05:1],'LineColor','Black','Showtext','on')
title(['TPXO, ',myTide,' amp (mean=',num2str( myMean ),')']);colorbar;

subplot(2,2,4)
% imagesc(model.lon,model.lat,tpxo.pha_vbar_BB);axis xy;
pcolor(model.lon_v,model.lat_v,tpxo.pha_vbar_BB);shading flat;
caxis(phaLim);
rect;hold on
% contour(model.lon,model.lat,tpxo.pha_vbar_BB,[0:30:360],'LineColor','Black','Showtext','on')
title(['TPXO, ',myTide,' phase']);colorbar

suptitle(['Vbar    D=',num2str(model.D_v)])
print(['figures/Vbar_',myTide,'tides'],'-djpeg');


