clear

% cd /import/archive/u1/uaf/hsimmons/PROJ_ACAD/MODELS/ROMS/SCS2
% run proc.csh
% batch_stage SCS_grid_1.nc or you will be sad
% run proc.csh


cd ~/PROJ/SCS/MFILES/
roms.base = '/import/c/w/jpender/ROMS/realWork/SCS/'
roms.expn = 'SCS_Day121';
roms.exppath = [roms.base,roms.expn,'/'];
roms.files.infile = [roms.exppath,'/ocean_scs.in']
exist(roms.files.infile)
[~,tmp]=grep('GRDNAME',roms.files.infile);tmp=char(tmp.match(1,:));roms.files.gfile=tmp(min(strfind(tmp,'/')):end);
disp(['recommend batch_stage(''',roms.files.gfile,''')'])
files2d = dir([roms.exppath,'scs_his2*.nc']);
for fdx = 1:length(files2d);roms.files.files2d{fdx}=[roms.exppath,files2d(fdx).name];end
clear fdx files2d tmp
datenum('1900-01-01 00:00:00')+nc_varget(char(roms.files.files2d(1)),'ocean_time')/86400

%%
roms.files.gfile = [roms.base,'SCS_grid_1.nc'];
%%


roms.files.ufile = [roms.base,'u/u.nc'];
roms.files.vfile = [roms.base,'v/v.nc'];
roms.files.sfile = [roms.base,'salt/salt.nc'];
roms.files.tfile = [roms.base,'temp/temp.nc'];
roms.stime = datenum('1900-01-01 00:00:00')+nc_varget(roms.files.sfile,'ocean_time')/86400;
roms.ttime = datenum('1900-01-01 00:00:00')+nc_varget(roms.files.tfile,'ocean_time')/86400;
roms.utime = datenum('1900-01-01 00:00:00')+nc_varget(roms.files.ufile,'ocean_time')/86400;
roms.vtime = datenum('1900-01-01 00:00:00')+nc_varget(roms.files.vfile,'ocean_time')/86400;

%%
%[~,tdxs] = sort(roms.time);
%tdxs=find(diff(sort(roms.time))>.8)
clear tdxs*
time=roms.utime;
tdxs1=[1:20]
tdxs2=[28:40]
tdxs3=[46:length(time)];
tdxs=[tdxs1 tdxs2 tdxs3]
f1;clf
subplot(3,1,1)
plot(1:length(time),time-time(1),'o');ytick(1:length(time));grid on;hold on;xtick(1:length(time));grid on;hold on
plot(tdxs1,time(tdxs1)-time(1),'ro','markerfacec','r')
plot(tdxs2,time(tdxs2)-time(1),'bo','markerfacec','b')
plot(tdxs3,time(tdxs3)-time(1),'ko','markerfacec','k')
subplot(3,1,2);plot(1:length(tdxs),time(tdxs)-time(1),'go','markerfacec','g')
subplot(3,1,3);plot(diff(sort(time)),'o');hold on;plot(diff(sort(time(tdxs))),'r.')
%%
roms.lonu = nc_varget(roms.files.gfile,'lon_u');
roms.lonv = nc_varget(roms.files.gfile,'lon_v');
roms.lonr = nc_varget(roms.files.gfile,'lon_rho');
roms.latr = nc_varget(roms.files.gfile,'lat_rho');
roms.lon=roms.lonr(1,:);
roms.lat=roms.latr(:,1);
disp('starting u');roms.ssu = single(nc_varget(roms.files.ufile,'u'      ));done('u')
disp('starting v');roms.ssv = single(nc_varget(roms.files.vfile,'v'      ));done('v')
disp('starting s');roms.sss = single(nc_varget(roms.files.sfile,'salt'   ));done('salt')
disp('starting t');roms.sst = single(nc_varget(roms.files.tfile,'temp'   ));done('temp')
%roms.T = nc_varget(roms.files.tfile,'temp');
%%
f1;clf;colormap(bone)
idxs=find(roms.lon>=116&roms.lon<=124);
jdxs=find(roms.lat>=14&roms.lat<=26);
for tdx = tdxs'
%subplot(3,1,1);
 imagesc(sq(roms.ssu  (tdx,jdxs,idxs)));axis xy;caxis([-1,1]/4);rect;drawnow
end
%%

lon0 = roms.lon(1);lon1 = roms.lon(end);lat0 = roms.lat(1);lat1 = roms.lat(end);
lon0 = 110;lon1 = 130;lat0 = 10;lat1 = 25;
lon0 = 115-2.5;lon1 = 130-2.5;lat0 = 12.5;lat1 = 25;

%%
lon0 = 116;lon1 = 124;lat0 = 18;lat1 = 25;
idx=nearest(roms.lon,lon0):nearest(roms.lon,lon1);
jdx=nearest(roms.lat,lat0):nearest(roms.lat,lat1);
for tdx=tdxs([1 end]);
figure(tdx);clf;
hformat(8);dx=5;colormap((ssec).^1.5);brighten(0);
 dat = sq(roms.sst(tdx,jdx,idx));
 imagesc(roms.lon(idx),roms.lat(jdx),dat+2*gradient(dat));shading flat;caxis([20 31]);colorbar;drawnow;axis xy
end

%%

m_proj('equi','lon',[lon0,lon1],'lat',[lat0,lat1])

lon0 = 116;lon1 = 124;lat0 = 18;lat1 = 25;
idx=nearest(roms.lon,lon0):nearest(roms.lon,lon1);
jdx=nearest(roms.lat,lat0):nearest(roms.lat,lat1);dx=2;dy=1
m_proj('equi','lon',roms.lon(idx([1 end])),'lat',roms.lat(jdx([1 end]))')
% m_gshhs_i('save','ROMS_coast');
% m_usercoast('ROMS_coast','patch',[.7 .7 .4]);
cnt=0;
time=roms.stime;
  sub = 6;vecscale = 8;hheadwidth = 1.5;headl=1.5;hshaftwidth=.5;minv=-1000;presmoo=3;postsmoo=1;col=[1 1 1]*.25;
  ifvecs= 1;
for tdx=tdxs%([1 end]);
    cnt=cnt+1;
figure(tdx);clf;
axes('pos',[.1 .145 .4 .4])
hformat(8);colormap((ssec).^1.5);brighten(0);%N=128*8;x=1:N;y = sin(pi*x/(N/9));colormap(jet(N).*abs([y;y;y]').^.125)
 dat = sq(roms.sss(tdx,jdx,idx));
 m_imagesc(roms.lon(idx),roms.lat(jdx),dat+1*gradient(dat));shading flat;hold on
 
 tmpu=double(sq(roms.ssu(tdx,jdx,idx)));tmpv=double(sq(roms.ssv(tdx,jdx,idx)));
          if ifvecs;hls_m_vec_wrapper(roms.lon(idx),roms.lat(jdx),tmpu,tmpv,sub,presmoo,postsmoo,vecscale,hheadwidth,headl,hshaftwidth,minv,col);end
 m_plot(cruise_dat.station.lon,cruise_dat.station.lat,'ko','markerfacec','w','markersi',3)
 caxis([33.1 34.8])
 %m_gshhs_i('save','ROMS_coast');
 m_usercoast('ROMS_coast','patch',[.7 .7 .4]);%m_coast('patch',[.7 .7 .4]);
 m_grid('ytick',[0:dx:50],'xtick',[105:dx:134]);m_fix;
 title(['SSS ',datestr(time(tdx),'dd mmm yyyy'),', YD = ',num2str(date2doy(floor(time(tdx)))) ]);
 h=colorbar('h');set(h,'pos',[.13 .1 .35 .01]);%set(get(h,'xlabel'),'string','SSS')
axes('pos',[.485 .145 .4 .4])
hformat(8);colormap((ssec).^1.5);brighten(0);%N=128*8;x=1:N;y = sin(pi*x/(N/9));colormap(jet(N).*abs([y;y;y]').^.125)
 dat = sq(roms.sst(tdx,jdx,idx));
 m_imagesc(roms.lon(idx),roms.lat(jdx),dat+1*gradient(dat));shading flat;hold on
          if ifvecs;hls_m_vec_wrapper(roms.lon(idx),roms.lat(jdx),tmpu,tmpv,sub,presmoo,postsmoo,vecscale,hheadwidth,headl,hshaftwidth,minv,col);end
 m_plot(cruise_dat.station.lon,cruise_dat.station.lat,'ko','markerfacec','w','markersi',3)
 caxis([20 31])
 %m_gshhs_i('save','ROMS_coast');
 m_usercoast('ROMS_coast','patch',[.7 .7 .4]);%m_coast('patch',[.7 .7 .4]);
 m_grid('ytick',[0:dx:50],'xtick',[105:dx:134],'ytickl',[]);m_fix;
 title(['SST ',datestr(time(tdx),'dd mmm yyyy'),', YD = ',num2str(date2doy(floor(time(tdx)))) ]);
 h=colorbar('h');set(h,'pos',[.51 .1 .35 .01]);%set(get(h,'xlabel'),'string','SST')
drawnow
!mkdir -p ../FIGURES/pics/ROMS
if ifvecs
    file = ['../FIGURES/pics/ROMS/ROMS_SSS_SST_vecs_',num2str(tdx)]
else
    file = ['../FIGURES/pics/ROMS/ROMS_SSS_SST_',num2str(tdx)]
end
eval(['print -dpng -r250 ',file,'.png'])
end
%%
%!tar -cvf ~/foo.tar ../FIGURES/pics/ROMS/ROMS_SSS_SST_vec*
%!tonivalis ~/foo.tar 
%%
lon0 = roms.lon(1);lon1 = roms.lon(end);lat0 = roms.lat(1);lat1 = roms.lat(end);
lon0 = 110;lon1 = 130;lat0 = 10;lat1 = 25;


m_proj('equi','lon',[lon0,lon1],'lat',[lat0,lat1])

idx=nearest(roms.lon,lon0):nearest(roms.lon,lon1);
jdx=nearest(roms.lat,lat0):nearest(roms.lat,lat1);
m_proj('equi','lon',roms.lon(idx([1 end])),'lat',roms.lat(jdx([1 end]))')
% m_gshhs_i('save','ROMS_coast');
% m_usercoast('ROMS_coast','patch',[.7 .7 .4]);
for tdx=1%tdxs;
figure(tdx);clf;hformat(16);
subplot(2,2,1);colormap(jet)%colormap((flipud(gray)));ifvecs=1;
 dat = sq(roms.sss(tdx,jdx,idx));
 m_pcolor(roms.lon(idx),roms.lat(jdx),dat+0*gradient(dat));shading flat
 caxis([33 34.9])
 %m_gshhs_i('save','ROMS_coast');
 m_coast('patch',[.7 .7 .4]);
 m_grid('ytick',[0:dx:50],'xtick',[105:dx:134],'xtickl',[]);m_fix;title('ROMS')
subplot(2,2,2);
 dat = sq(hycom.sss(tdx,:,:));lon = hycom.lon(1,:);lat = hycom.lat(:,1);
 m_pcolor(hycom.lon(1,:),hycom.lat(:,1),dat+0*gradient(dat));shading flat;
 m_coast('patch',[.7 .7 .4]);
 caxis([33 34.9])
 m_grid('ytick',[0:dx:50],'ytickl',[],'xtick',[105:dx:134],'xtickl',[]);m_fix;title('HYCOM')
subplot(2,2,3);colormap(jet)%colormap((flipud(gray)));ifvecs=1;
 dat = sq(roms.sst(tdx,jdx,idx));
 m_pcolor(roms.lon(idx),roms.lat(jdx),dat+0*gradient(dat));shading flat
 caxis([14 30])
 m_coast('patch',[.7 .7 .4]);
 m_grid('ytick',[0:dx:50],'xtick',[105:dx:134]);m_fix;
subplot(2,2,4);
 dat = sq(hycom.T(tdx,:,:));lon = hycom.lon(1,:);lat = hycom.lat(:,1);
 m_pcolor(hycom.lon(1,:),hycom.lat(:,1),dat+0*gradient(dat));shading flat;
 caxis([14 30])
 m_coast('patch',[.7 .7 .4]);
 m_grid('ytick',[0:dx:50],'ytickl',[],'xtick',[105:dx:134]);m_fix;
 drawnow;
end
%%
f1;clf;cmin=33;cmax=34.9;
subplot(2,1,1);imagesc(lon(idx),lat(jdx),dat+0*gradient(dat));caxis([cmin,cmax])
 N=128*4;x=1:N;y = sin(pi*x/(N/9));colormap(jet(N).*abs([y;y;y]').^.125);colorbar;axis xy
%%
subplot(2,1,2);contourf(lon(idx),lat(jdx),dat+0*gradient(dat),N/2);caxis([cmin,cmax]);axis xy

