clear; close all

%% sfos grid stuff

unix('\rm -r figures');
unix('mkdir figures');

[dum1,dum2]=unix('pwd | rev |cut -d "/" -f2 | rev | cut -d "_" -f1,2');
sfos.myGrid = dum2(1:end-1);

[dum1,dum2]=unix('ls .. |grep nc');
sfos.myGridFile = ['../',dum2(1:end-1)];

[dum1,dum2]=unix('pwd | rev |cut -d "/" -f2 | rev | cut -d "_" -f1');
sfos.myPrefix = lower(dum2(1:end-1));

HISfiles  = dir('../netcdfOutput_split/*_his_*');
HIS2files = dir('../netcdfOutput_split/*_his2_*');

sfos.grid = roms_get_grid(sfos.myGridFile,['../netcdfOutput_split/',HISfiles(1).name],0,1);


%% workspace - duplicate z_r and z_w

% % % pick a spot
% % 
% % myJ=5;
% % myI=5;
% % fig(101);clf;
% % plot(sfos.grid.z_w(:,myJ,myI),sfos.grid.z_w(:,myJ,myI),'.r');
% % hold on;
% % plot(sfos.grid.z_r(:,myJ,myI),sfos.grid.z_r(:,myJ,myI),'.g')
% % 
% % N=50;
% % theta_s = 7;
% % theta_b = 2;
% % Tcline  = 250;
% % 
% % sigma_w = ( [0:1:N] -N ) /N;
% % sigma_r = ( [1:1:N] -N -.5) /N;
% % 
% % % Do surface stretching first
% % C_w = (1 - cosh(theta_s * sigma_w) ) / ( cosh(theta_s) -1 );
% % C_r = (1 - cosh(theta_s * sigma_r) ) / ( cosh(theta_s) -1 );
% % 
% % fig(102);clf;
% % plot(C_w,'.r');
% % hold on;
% % plot(C_r,'.g')
% % 
% % % Do bottom stretching next
% % C_w = (exp(theta_b * C_w) -1 ) / ( 1 - exp(-theta_b) );
% % C_r = (exp(theta_b * C_r) -1 ) / ( 1 - exp(-theta_b) );
% % 
% % fig(103);clf;
% % plot(C_w,'.r');
% % hold on;
% % plot(C_r,'.g')
% % 
% % % The HIS files contain C(sigma), and they are the same as what's
% % % calculated above
% % Cs_r = nc_varget(['../netcdfOutput_split/',HISfiles(1).name],'Cs_r');
% % Cs_w = nc_varget(['../netcdfOutput_split/',HISfiles(1).name],'Cs_w');
% % 
% % C_w - Cs_w'
% % 
% % % Now I need to use C_w and other stuff to calculate S(sigma) and then z
% % % It is confusing, but in the HIS files s_w should read "sigma_w"
% % s_w = nc_varget(['../netcdfOutput_split/',HISfiles(1).name],'s_w');
% % s_r = nc_varget(['../netcdfOutput_split/',HISfiles(1).name],'s_rho');
% % 
% % % Calculate S(sigma)
% % % The critical depth is 250m.
% % mySsigma = ( 250 * s_w +  sfos.grid.h(myJ,myI)  * Cs_w ) / (250 +  sfos.grid.h(myJ,myI));
% %  
% % % Given s_w and s_r I calculate the z values from
% % %
% % %   z_w = zeta + [ zeta + h ] * S
% % % and then do a diff to get the cell heights.
% % 
% % 
% % myZp1 = 0 + ( 0 + sfos.grid.h(myJ,myI) ) * mySsigma
% % 
% % 
% % aaa = 5;

%% Box in the voxels

% MITgcm does a better job of making the following point: the modeling volume
% consists of a bunch of building blocks all stacked up. The dimensions can
% vary from place to place. The weird thing is that there is something
% called the psi grid, and if you look at lat_psi and lon_psi these are
% exactly the lat/lon you had in mind when you created the grid in the
% first place. The other grids (lat_rho, lon_v, etc) are often offset from
% the psi grid because the points lie on one cell face or the other. In
% fact, the rho grid lies entirely on the cell faces so is larger by
% 1 point in both x and y than the number of cells.

% Most, if not all, of the variables I'm interested in are specified on the
% rho grid. What I will do is pick a psi-grid point, average T (or
% whatever) on the 4 rho-grid faces of my cell, then assign the averaged T
% to my psi cell.

% dz is easy. Both grid.z_r and grid.z_w are on the horizontal rho grid so
% I just have to diff(grid.z_w) to get grid.dz_r. This works out because
% the length of z_w is always one greater than the length of z_r.
% The hitch is that when you include zeta in the height of the water column
% you have to recalculate z_w and z_r for each point on the grid for every
% snapshot.

[nzRho,nyRho,nxRho] = size(sfos.grid.z_r);


%



% Here is a generalized psi mask to make it easier to do the calculation.
% Put NaNs in for zeros in case you need to do a nanmean near the land
% mask.

% sfos.mask_psi3D = zeros(nzRho,nyRho-1,nxRho-1);
% for kk=1:nzRho;
%     sfos.mask_psi3D(kk,:,:) = sfos.grid.mask_psi;
% end;
% sfos.mask_psi3D(sfos.mask_psi3D == 0) = NaN;

% Here is a 3D version of a few 3D fields 

sfos.grid.mask_rho3D = sfos.grid.mask_rho;
sfos.grid.mask_rho3D = zeros(nzRho,nyRho,nxRho);
for kk=1:nzRho;
    sfos.grid.mask_rho3D(kk,:,:) = sfos.grid.mask_rho;
end;

sfos.grid.pm3D = sfos.grid.pm;
sfos.grid.pm3D = zeros(nzRho,nyRho,nxRho);
for kk=1:nzRho;
    sfos.grid.pm3D(kk,:,:) = sfos.grid.pm;
end;

sfos.grid.pn3D = sfos.grid.pn;
sfos.grid.pn3D = zeros(nzRho,nyRho,nxRho);
for kk=1:nzRho;
    sfos.grid.pn3D(kk,:,:) = sfos.grid.pn;
end;


% I need S(sigma) to recalculate z_w for nonzero zeta. 
SofSigma = 0*sfos.grid.z_w;
for ii=1:nxRho; for jj=1:nyRho
    SofSigma(:,jj,ii) = ( ( sfos.grid.hc * sfos.grid.s_w + sfos.grid.h(jj,ii) * sfos.grid.Cs_w ) / (sfos.grid.hc +  sfos.grid.h(jj,ii))  )';
end;end;


% kludge up curvalinear coordinates for the u grid and the v grid

sfos.grid.pm_u = ( sfos.grid.pm(:,1:end-1) + sfos.grid.pm(:,2:end) )/2;
sfos.grid.pn_u = ( sfos.grid.pn(:,1:end-1) + sfos.grid.pn(:,2:end) )/2;

sfos.grid.pm_v = ( sfos.grid.pm(1:end-1,:) + sfos.grid.pm(2:end,:) )/2;
sfos.grid.pn_v = ( sfos.grid.pn(1:end-1,:) + sfos.grid.pn(2:end,:) )/2;

aaa=5;

% ROMS does not actually use x/y for anything. It uses what it calls the
% curvilinear coordinates pm and pn, which are the inverses of deltaX and
% deltaY. pm and pn sit on the rho grid which is actually kind of
% confusing. If
%       size(x_rho) = (nJ,nI)
% that means that there are
%       (nJ-1) * (nI-1) cells
% so what am I going to do with nJ*nI cell edges? To be specific, for 
%       J=5  I=0
% you have a rho grid point (x_rho(J,I), y_rho(J,I)) just fine, but
% (apparently) the rho-grid tile implied by (pm(J,I), pn(J,I)) extends to
% the left of the left hand edge of the rho grid. 

% I am going to make the simplest assumption here. Everything is on the
% rho grid. If a point on the rho grid is not under the rho land mask then
% the surface tile has 
%       area    1 / (pm * pn)
% and a well defined zeta for any given time, which means I can calculate
% z_w for that rho grid point. Doing a diff of z_w gives me all of the cell
% heights, which means I have a well defined volume for every cell in the
% water column to go with T and S.

% So for instance, the total water volume is
%  sum over i,j,k
%   mask(j,i) / pm(j,i) / pn(j,i) * ( h(j,i) + zeta(j,i,t) )



%% Calculate basin area.

% sfos

% basin area first

% disp(['Full basin area is a square about ',num2str(inKmSq),' km on a side']);

sfos.grid.mask_rho ./ sfos.grid.pm ./sfos.grid.pn ;
sfos.basinArea = nansum(ans(:));
disp(['The water surface area is ',num2str(sfos.basinArea /10^6),' km^2']);

% basin volume next

sfos.grid.h .* sfos.grid.mask_rho ./ sfos.grid.pm ./sfos.grid.pn ;
sfos.basinVolume = nansum(ans(:));
disp(['The zeta-equal-zero water volume is ',num2str(sfos.basinVolume/10^9),' km^3']);





%% Find all the averages

% Do all the snapshots or just do the first few snapshots

Nt = length(HISfiles);
% Nt = 5;

% log subsequent basin volumes

sfos.grid.basinVolume = zeros(1,Nt);

% put the state variables onto the psi grid by doing a nan over the 4
% adjacent points on the rho grid or the 2 adjacent points on the u or v
% grid.

% Just do the first snapshot in each file


% for tt=10:Nt
for tt=1:Nt
    
    [dum1,dum2] = roms_get_date(['../netcdfOutput_split/',HISfiles(tt).name]);
    sfos.time(tt)       = dum1(1);
    
    % read in the surface fields from the netcdf file.
    
    SSH_rho    = sq(nc_varget(['../netcdfOutput_split/',HIS2files(tt).name],'zeta',[0,0,0],[1,-1,-1]) )    .* sfos.grid.mask_rho;
    shflux_rho = sq(nc_varget(['../netcdfOutput_split/',HIS2files(tt).name],'shflux',[0,0,0],[1,-1,-1]) )  .* sfos.grid.mask_rho;
    ssflux_rho = sq(nc_varget(['../netcdfOutput_split/',HIS2files(tt).name],'ssflux',[0,0,0],[1,-1,-1]) )  .* sfos.grid.mask_rho;
    %     swrad_rho  = sq(nc_varget(['../netcdfOutput_split/',HIS2files(tt).name],'swrad',[0,0,0],[1,-1,-1]) )   .* sfos.grid.mask_rho;    
    sustr_u    = sq(nc_varget(['../netcdfOutput_split/',HIS2files(tt).name],'sustr',[0,0,0],[1,-1,-1]) )   .* sfos.grid.mask_u;
    svstr_v    = sq(nc_varget(['../netcdfOutput_split/',HIS2files(tt).name],'svstr',[0,0,0],[1,-1,-1]) )   .* sfos.grid.mask_v;

    % Calculate the dynamic water volume
    
    (sfos.grid.h + SSH_rho) .* sfos.grid.mask_rho ./ sfos.grid.pm ./sfos.grid.pn ;
    sfos.grid.basinVolume(tt) = nansum(ans(:));
    disp(['The dynamic water volume is ',num2str(sfos.grid.basinVolume(tt)/10^9),' km^3']);
    
    % Recalculate z_w on the rho grid
    
    
    
% % % % Calculate S(sigma)
% % % % The critical depth is 250m.
% % % mySsigma = ( 250 * s_w +  sfos.grid.h(myJ,myI)  * Cs_w ) / (250 +  sfos.grid.h(myJ,myI));
% % %  
% % % % Given s_w and s_r I calculate the z values from
% % % %
% % % %   z_w = zeta + [ zeta + h ] * S
% % % % and then do a diff to get the cell heights.
% % % 
% % % 
% % % myZp1 = 0 + ( 0 + sfos.grid.h(myJ,myI) ) * mySsigma
    
    
    
    for jj=1:nyRho; for ii=1:nxRho
        z_wOrig = sfos.grid.z_w(:,jj,ii);
%         1 + ( 1 + sfos.grid.h(myJ,myI) ) * SofSigma
        sfos.grid.z_w(:,jj,ii) = SSH_rho(jj,ii) + ( SSH_rho(jj,ii) + sfos.grid.h(jj,ii) ) * SofSigma(:,jj,ii);
        sfos.grid.z_w(:,jj,ii) - z_wOrig;
    end;end;
    
    % Here is dz_r on the rho grid
    
    sfos.grid.dz_rho = zeros(nzRho,nyRho,nxRho);
    for ii=1:nxRho; for jj=1:nyRho;
            sfos.grid.dz_rho(:,jj,ii) = diff(sq(sfos.grid.z_w(:,jj,ii)));
            sfos.grid.dz_rho(:,jj,ii);
    end;end;    
    
    

    Tdz_rho  = sq(nc_varget(['../netcdfOutput_split/',HISfiles(tt).name],'temp',[0,0,0,0],[1,-1,-1,-1]) )  .* sfos.grid.mask_rho3D .* sfos.grid.dz_rho;
    Sdz_rho  = sq(nc_varget(['../netcdfOutput_split/',HISfiles(tt).name],'salt',[0,0,0,0],[1,-1,-1,-1]) )  .* sfos.grid.mask_rho3D .* sfos.grid.dz_rho;
    
%     done('reading in data')  
    
 
    % Calculate the averages.
    
    
    SSH_rho    .* sfos.grid.mask_rho ./ sfos.grid.pm ./ sfos.grid.pn;
    sfos.SSH_BasinAve(tt)    = nansum(ans(:)) / sfos.basinArea;
    
    
    shflux_rho .* sfos.grid.mask_rho ./ sfos.grid.pm ./ sfos.grid.pn;
    sfos.shflux_BasinAve(tt) = nansum(ans(:)) / sfos.basinArea;
    
    ssflux_rho .* sfos.grid.mask_rho ./ sfos.grid.pm ./ sfos.grid.pn;
    sfos.ssflux_BasinAve(tt) = nansum(ans(:)) / sfos.basinArea;
    
    %             swrad_rho  .* sfos.grid.mask_rho ./ sfos.grid.pm(1,:,:) .* sfos.grid.pn(1,:,:);
    % 	sfos.swrad_BasinAve(tt) = nansum(ans(:)) / sfos.basinArea;
    
    sustr_u  .* sfos.grid.mask_u ./ sfos.grid.pm_u ./ sfos.grid.pn_u;
    sfos.sustr_BasinAve(tt)  = nansum(ans(:)) / sfos.basinArea;
    
    svstr_v  .* sfos.grid.mask_v ./ sfos.grid.pm_v ./ sfos.grid.pn_v;
    sfos.svstr_BasinAve(tt)  = nansum(ans(:)) / sfos.basinArea;
    
    
    
    sq(Tdz_rho(end,:,:)) .* sfos.grid.mask_rho ./ sfos.grid.pm ./ sfos.grid.pn ./ sq(sfos.grid.dz_rho(end,:,:));
    sfos.SST_BasinAve(tt) = nansum(ans(:)) / sfos.basinArea;
    
    sq(Sdz_rho(end,:,:)) .* sfos.grid.mask_rho ./ sfos.grid.pm ./ sfos.grid.pn ./ sq(sfos.grid.dz_rho(end,:,:));
    sfos.SSS_BasinAve(tt) = nansum(ans(:)) / sfos.basinArea;
     
    Tdz_rho  .* sfos.grid.mask_rho3D ./ sfos.grid.pm3D ./ sfos.grid.pn3D;
    sfos.Temp_BasinAve(tt) = nansum(ans(:)) / sfos.grid.basinVolume(tt);
    
    Sdz_rho  .* sfos.grid.mask_rho3D ./ sfos.grid.pm3D ./ sfos.grid.pn3D;
    sfos.Salt_BasinAve(tt) = nansum(ans(:)) / sfos.grid.basinVolume(tt);

    
    
%     done('finding basin averages')
    
end;


%% Save the important stuff

% save('basinAve.mat','-struct','sfos');


%% Plots

fig(20);plot(sfos.time,sfos.grid.basinVolume/10^9);title('Total basin water volume (km^3)');;
datetick('x','mm/dd','keepticks')
print('figures/Temp_BasinAve','-djpeg');

fig(1);plot(sfos.time,sfos.Temp_BasinAve);title('Basin-average temperature');;
datetick('x','mm/dd','keepticks')
print('figures/Temp_BasinAve','-djpeg');

fig(2);plot(sfos.time,sfos.Salt_BasinAve);title('Basin-average salinity');
datetick('x','mm/dd','keepticks')
print('figures/Salt_BasinAve','-djpeg');

fig(3);plot(sfos.time,sfos.SSH_BasinAve);title('Basin-average zeta');
datetick('x','mm/dd','keepticks')
print('figures/SSH_BasinAve' ,'-djpeg');

fig(4);plot(sfos.time,sfos.SST_BasinAve);title('Basin-average surface temperature');
datetick('x','mm/dd','keepticks')
print('figures/SST_BasinAve' ,'-djpeg');

fig(5);plot(sfos.time,sfos.SSS_BasinAve);title('Basin-average surface salinity');
datetick('x','mm/dd','keepticks')
print('figures/SSS_BasinAve' ,'-djpeg');



fig(6);plot(sfos.time,sfos.shflux_BasinAve);title('Basin-average shflux');
datetick('x','mm/dd','keepticks')
print('figures/shflux_BasinAve' ,'-djpeg');

fig(7);plot(sfos.time,sfos.ssflux_BasinAve);title('Basin-average ssflux');
datetick('x','mm/dd','keepticks')
print('figures/ssflux_BasinAve' ,'-djpeg');

% fig(8);plot(sfos.time,sfos.swrad_BasinAve);title('Basin-average swrad');
% datetick('x','mm/dd','keepticks')
% print('figures/swrad_BasinAve' ,'-djpeg');

fig(9);plot(sfos.time,sfos.sustr_BasinAve);title('Basin-average sustr');
datetick('x','mm/dd','keepticks')
print('figures/sustr_BasinAve' ,'-djpeg');

fig(10);plot(sfos.time,sfos.svstr_BasinAve);title('Basin-average svstr');
datetick('x','mm/dd','keepticks')
print('figures/svstr_BasinAve' ,'-djpeg');


