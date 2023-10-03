prec='real*8';ieee='b';
load(MODEL.toposrcfile)
MODEL.Sref=0*MODEL.Tref;

fid=fopen('../input/delYvar','w',ieee); fwrite(fid,MODEL.delY ,prec) ; fclose(fid);
fid=fopen('../input/delXvar','w',ieee); fwrite(fid,MODEL.delX ,prec) ; fclose(fid);
fid=fopen('../input/delZvar','w',ieee); fwrite(fid,MODEL.delZ ,prec) ; fclose(fid);
fid=fopen('../input/SrefVar','w',ieee); fwrite(fid,MODEL.Sref ,prec) ; fclose(fid);
fid=fopen('../input/TrefVar','w',ieee); fwrite(fid,MODEL.Tref ,prec) ; fclose(fid);
fid=fopen('../input/T.init' ,'w',ieee); fwrite(fid,MODEL.Tinit,prec) ; fclose(fid);
fid=fopen('../input/topog.init','w',ieee); fwrite(fid,-abs(MODEL.H'),prec) ; fclose(fid);
% OB.WU = 0.1+0*OB.WU;
% OB.WV = 0.0+0*OB.WV;
% OB.EU = 0.1+0*OB.EU;
% OB.EV = 0.0+0*OB.EV;

fid=fopen('../input/NU.ob','w',ieee); fwrite(fid,OB.NU,prec); fclose(fid);
fid=fopen('../input/SU.ob','w',ieee); fwrite(fid,OB.SU,prec); fclose(fid);done('SU write')
% fid=fopen('../input/WU.ob','w',ieee); fwrite(fid,OB.WU,prec); fclose(fid);done('WU write')
% fid=fopen('../input/EU.ob','w',ieee); fwrite(fid,OB.EU,prec); fclose(fid);

fid=fopen('../input/NV.ob','w',ieee); fwrite(fid,OB.NV,prec); fclose(fid);
fid=fopen('../input/SV.ob','w',ieee); fwrite(fid,OB.SV,prec); fclose(fid);done('SV write')
% fid=fopen('../input/WV.ob','w',ieee); fwrite(fid,OB.WV,prec); fclose(fid);done('WV write')
% fid=fopen('../input/EV.ob','w',ieee); fwrite(fid,OB.EV,prec); fclose(fid);
    
fid=fopen('../input/NT.ob','w',ieee); fwrite(fid,OB.NT,prec); fclose(fid);
fid=fopen('../input/ST.ob','w',ieee); fwrite(fid,OB.ST,prec); fclose(fid);
fid=fopen('../input/WT.ob','w',ieee); fwrite(fid,OB.WT,prec); fclose(fid);
fid=fopen('../input/ET.ob','w',ieee); fwrite(fid,OB.ET,prec); fclose(fid);
    
%%
if 1 % ~BT
%     figure(501);clf
% 	if ifcartesian;sfac = 1e3;else;sfac=1;end
%  subplot(2,3,1);contourf(MODEL.Y/sfac,OB.timeD-OB.timeD(1),sq(OB.EU(:,1,:))',32);shading flat;colorbar('h');title('EU');ylabel('time');xlabel('Y');caxis(.01*OB.flux_mag*[-1,1])
%  subplot(2,3,2);contourf(MODEL.Y/sfac,OB.timeD-OB.timeD(1),sq(OB.EV(:,1,:))',32);shading flat;colorbar('h');title('EV');xlabel('Y');caxis(.01*OB.flux_mag*[-1,1])
%  subplot(2,3,3);contourf(MODEL.Y/sfac,OB.timeD-OB.timeD(1),sq(OB.ET(:,1,:))',32);shading flat;colorbar('h');title('ET');xlabel('Y');
%  subplot(2,3,4);contourf(MODEL.Y/sfac,MODEL.Z             ,sq(OB.EU(:,:,1))',32);shading flat;colorbar('h');title('EU');ylabel('Z');xlabel('Y');caxis(.01*OB.flux_mag*[-1,1])
%  subplot(2,3,5);contourf(MODEL.Y/sfac,MODEL.Z             ,sq(OB.EV(:,:,1))',32);shading flat;colorbar('h');title('EV');xlabel('Y');caxis(.01*OB.flux_mag*[-1,1])
%  subplot(2,3,6);contourf(MODEL.Y/sfac,MODEL.Z             ,sq(OB.ET(:,:,1))',32);shading flat;colorbar('h');title('ET');xlabel('Y')
%     figure(502);clf
%  subplot(2,3,1);contourf(MODEL.Y/sfac,OB.timeD-OB.timeD(1),sq(OB.WU(:,1,:))',32);shading flat;colorbar('h');title('WU');ylabel('time');xlabel('Y');caxis(.01*OB.flux_mag*[-1,1])
%  subplot(2,3,2);contourf(MODEL.Y/sfac,OB.timeD-OB.timeD(1),sq(OB.WV(:,1,:))',32);shading flat;colorbar('h');title('WV');xlabel('Y');caxis(.01*OB.flux_mag*[-1,1])
%  subplot(2,3,3);contourf(MODEL.Y/sfac,OB.timeD-OB.timeD(1),sq(OB.WT(:,1,:))',32);shading flat;colorbar('h');title('WT');xlabel('Y');
%  subplot(2,3,4);contourf(MODEL.Y/sfac,MODEL.Z             ,sq(OB.WU(:,:,1))',32);shading flat;colorbar('h');title('WU');ylabel('Z');xlabel('Y');caxis(.01*OB.flux_mag*[-1,1])
%  subplot(2,3,5);contourf(MODEL.Y/sfac,MODEL.Z             ,sq(OB.WV(:,:,1))',32);shading flat;colorbar('h');title('WV');xlabel('Y');caxis(.01*OB.flux_mag*[-1,1])
%  subplot(2,3,6);contourf(MODEL.Y/sfac,MODEL.Z             ,sq(OB.WT(:,:,1))',32);shading flat;colorbar('h');title('WT');xlabel('Y')
%     figure(503);clf
%  subplot(2,3,1);contourf(MODEL.X/sfac,OB.timeD-OB.timeD(1),sq(OB.NU(:,1,:))',32);shading flat;colorbar('h');title('NU');ylabel('time');xlabel('X');caxis(.01*OB.flux_mag*[-1,1])
%  subplot(2,3,2);contourf(MODEL.X/sfac,OB.timeD-OB.timeD(1),sq(OB.NV(:,1,:))',32);shading flat;colorbar('h');title('NV');xlabel('Y');caxis(.01*OB.flux_mag*[-1,1])
%  subplot(2,3,3);contourf(MODEL.X/sfac,OB.timeD-OB.timeD(1),sq(OB.NT(:,1,:))',32);shading flat;colorbar('h');title('NT');xlabel('Y');
%  subplot(2,3,4);contourf(MODEL.X/sfac,MODEL.Z             ,sq(OB.NU(:,:,1))',32);shading flat;colorbar('h');title('NU');ylabel('Z');xlabel('X');caxis(.01*OB.flux_mag*[-1,1])
%  subplot(2,3,5);contourf(MODEL.X/sfac,MODEL.Z             ,sq(OB.NV(:,:,1))',32);shading flat;colorbar('h');title('NV');xlabel('Y');caxis(.01*OB.flux_mag*[-1,1])
%  subplot(2,3,6);contourf(MODEL.X/sfac,MODEL.Z             ,sq(OB.NT(:,:,1))',32);shading flat;colorbar('h');title('NT');xlabel('Y')

%%
%  figure(504);clf;
% 	 subplot(2,1,1)
% 	 contourf(MODEL.Lon,MODEL.Lat,MODEL.H);hold on
% 	 contour (MODEL.Lon,MODEL.Lat,MODEL.H,[0 0],'w');colorbar
%  if ifcartesian
% 	 subplot(2,1,2)
% 	 contourf(MODEL.X/1e3,MODEL.Y/1e3,MODEL.H);colorbar;ylabel('km');xlabel('km');title('Grid in cartesian coordinates')
%  end
end

MODEL.OB=OB;
save data.mat -v7.3 -mat MODEL 

% ----------------------------------------------
%% some parameter suggestions and reminders
% ----------------------------------------------
 
 if ifcartesian
	dx_in_km = min([MODEL.delX MODEL.delY])/1e3;
else
	dx_in_km = sw_dist([MODEL.reflat MODEL.reflat],[MODEL.lon(1) MODEL.lon(2)],'km');
	src_dx_in_km = sw_dist([mean(TOPO.lat) mean(TOPO.lat)],[TOPO.lon(1) TOPO.lon(2)],'km');
end
	src_dx_in_km = sw_dist([mean(TOPO.lat) mean(TOPO.lat)],[TOPO.lon(1) TOPO.lon(2)],'km');
c_fric=0.025;
disp('---------------------------------------------------------------')
disp(' experiment specific changes to SIZE.h and namelist parameters ')
disp('---------------------------------------------------------------')
if ifcartesian
	disp('Model is in Cartesian coordinates (m)')
	disp('in data: set  usingCartesianGrid=.TRUE. ')
	disp('in data: set  usingCartesianGrid=.FALSE.')
disp('---------------------------------------------------------------')
else
	disp(' Model is in spherical coordinates (lon,lat)')
	disp('in data: set  usingCartesianGrid=.FALSE. ')
	disp('in data: set  usingCartesianGrid=.TRUE.  ')
	disp([' ygOrigin            = ',num2str(MODEL.Lat(1,1))])
	disp([' xgOrigin            = ',num2str(MODEL.Lon(1,1))])
	disp('Comment out f0 and beta in data to get internal calculated f')
disp('---------------------------------------------------------------')
end
disp([' f0                  = ',num2str(sw_f(MODEL.reflat))])
disp([' Ny                  = ',num2str(MODEL.Ny)])
disp([' Nx                  = ',num2str(MODEL.Nx)])
disp([' OB_Ieast            = ',num2str(MODEL.Ny),'*-1'])
disp([' OB_Iwest            = ',num2str(MODEL.Ny),'*-1'])
disp([' OB_Isouth           = ',num2str(MODEL.Nx),'*-1'])
disp([' OB_Inorth           = ',num2str(MODEL.Nx),'*-1'])
disp([' externForcingPeriod = ',sprintf('%3.2f',OB.dt)]) 
disp([' externForcingCycle  = ',sprintf('%3.2f',OB.Nt*OB.dt)])
disp([' spongeThickness     = ',num2str(round(50/dx_in_km)),' points for sponge thickness of 50km'])
disp([' viscAH              = ',num2str(round(c_fric*dx_in_km*1e3)),' based on a friction velocity of ',num2str(c_fric)])
disp([' diffKht             = ',num2str(round(c_fric*dx_in_km*1e3)),' based on a friction velocity of ',num2str(c_fric)])
disp([' delt                = ',num2str(round(4.5* dx_in_km*1e3/sqrt(10*4500))), ' s based on practical CFL limit on timestep of 4.5 dx/dt < sqrt(g 4500)'])
disp(' ')
disp([' source topography was smoothed over  ',num2str(2*round((MODEL.topopresmoo-1))),' gridpoints or ',num2str(2*round((MODEL.topopresmoo-1)*src_dx_in_km)), ' km prior to regridding'])
disp([' final  topography was smoothed over  ',num2str(2*round((MODEL.toposmoo-1)))    ,' gridpoints or ',num2str(2*round((MODEL.toposmoo-1)*dx_in_km)), ' km after    regridding'])
disp(' ')
%%
if ifcartesian
%%
% figure(505);clf;pcolor(MODEL.X/1e3,MODEL.Y/1e3,MODEL.H);shading flat;hold on;
%               contour(MODEL.X/1e3,MODEL.Y/1e3,MODEL.H,[1 1],'w')
%               [c,h]=contour(MODEL.X/1e3,MODEL.Y/1e3,MODEL.H,[100 300 500 1000 2000 3000 4000 5000],'k');clabel(c,h,'labelspac',720)
%               [c,h]=contour (MODEL.X/1e3,MODEL.Y/1e3,MODEL.Lon,0:1:360   ,'k:');clabel(c,h,'labelspac',720)
%               [c,h]=contour (MODEL.X/1e3,MODEL.Y/1e3,MODEL.Lat   ,-360:1:360,'k:');clabel(c,h,'labelspac',720)
%%
end
if 0
	%%
% 	jdx = nearest(MODEL.Y,455e3)
% 	 [xi,zi,x,D]=calc_ray_paths(1e2,0,MODEL.X,MODEL.H(jdx,:),MODEL.Z,MODEL.N2,10000,300e3,0,MODEL.reflat,2*pi/(12.42*3600),-1,1);
% 	 zi(zi>0)=nan;
% 	 figure(7);clf;
% 	  axes('pos',[.1,.5,.4,.4]);hformat(8)
% 	   imagesc(MODEL.X/1e3,MODEL.Y/1e3,MODEL.H);shading flat;hold on;rect;axis xy
% 	   contour(MODEL.X/1e3,MODEL.Y/1e3,MODEL.H,[1 1],'w')
% 	   [c,h]=contour(MODEL.X/1e3,MODEL.Y/1e3,MODEL.H,[100 300 500 1000 2000 3000 4000 5000],'k');clabel(c,h,'labelspac',720,'fontsi',6)
% 	   [c,h]=contour (MODEL.X/1e3,MODEL.Y/1e3,MODEL.Lon,0:1:360,'k--');clabel(c,h,'labelspac',720,'fontsi',6)
% 	   [c,h]=contour (MODEL.X/1e3,MODEL.Y/1e3,MODEL.Lat,-360:1:360,'k--');clabel(c,h,'labelspac',720,'fontsi',6)
% 	   plot(0:300,MODEL.Y(jdx)/1e3 + 0*[0:300],'k--','linew',2)
% 	   idx = nearest(MODEL.X/1e3,300);
% 	   pos=get(gca,'pos');set(gca,'pos',pos);h=colorbar('h');set(h,'pos',[.3,.9125,.3,.01],'xaxisloc','top');caxis([0,5000])
% 	  axes('pos',[.525,.5,.4,.39]);hformat(8)
% 	   pcolor(MODEL.Lon,MODEL.Lat,MODEL.H);shading flat;hold on;set(gca,'dataaspectratio',[1.1,1,1])
% 	   contour(MODEL.Lon,MODEL.Lat,MODEL.H,[1 1],'w')
% 	   [c,h]=contour(MODEL.Lon,MODEL.Lat,MODEL.H,[100 300 500 1000 2000 3000 4000 5000],'k');clabel(c,h,'labelspac',720,'fontsi',6)
% 	   plot([MODEL.Lon(jdx,1) MODEL.Lon(jdx,idx)],[MODEL.Lat(jdx,1) MODEL.Lat(jdx,idx)],'k--','linew',2)	   
% 	  axes('pos',[.125,.15,.35,.25]);hformat(8)
% 	   fill([MODEL.X(1) MODEL.X MODEL.X(end)]/1e3,[-5000 -MODEL.H(jdx,:) -5000],'k');hold on
% 	   plot(MODEL.X/1e3,-MODEL.H(jdx,:),'.','color',[.25,.25,.25]);hold on
% 	   plot(xi/1e3,zi,'r')
% 	  xlim([0,300]);ylim([-5000,0])
	%%
end
