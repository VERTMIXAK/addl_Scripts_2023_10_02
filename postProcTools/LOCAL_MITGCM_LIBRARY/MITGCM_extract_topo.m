function TOPO=MITGCM_extract_topo(lon0,lon1,lat0,lat1,skip,srcfile,destfile)
if strcmp(srcfile,'/import/c/w/jpender/dataDir/TOPO/topo30.grd')
	s_x=nc_varget(srcfile,'lon'); s_y=nc_varget(srcfile,'lat');

	% chop data down to our favorite region
	idx = find(s_x>=lon0&s_x<=lon1);jdx = find(s_y>=lat0 &s_y<=lat1 );
	z=nc_varget(srcfile,'z',[jdx(1)-1,idx(1)-1],[length(jdx),length(idx)]);z(z>0)=0;
	lon=s_x(idx);lat=s_y(jdx);

	clear s_* idx jdx
	TOPO.lon=lon(1:skip:end);TOPO.lat=lat(1:skip:end);TOPO.H=-z(1:skip:end,1:skip:end);
	clear lon lat z
	%disp(['save ',destfile,' TOPO'])
	eval(['save ',destfile,' TOPO'])
elseif strcmp(srcfile,'/import/c/w/jpender/dataDir/TTide/DATA/oz_bathy_large')
%    keyboard
    %%
    load(srcfile)
    %%
    lon=bathy.lon;lat=bathy.lat;H=bathy.H;
%    keyboard
    %% plot the whole thing at 1/10 resolution and the
    figure(1);clf
    imagesc(lon(1:10:end),lat(1:10:end),H(1:10:end,1:10:end));hold on
    plot([lon0 lon1 lon1 lon0 lon0],[lat0 lat0 lat1 lat1 lat0],'k--','linew',2);;axis tight equal xy;hold on
	%% chop data down to our favorite region
	idx = find(lon>=lon0&lon<=lon1);jdx = find(lat>=lat0 &lat<=lat1 );
	z=H(jdx,idx);z(z>0)=0;
	lon=lon(idx);lat=lat(jdx);

	clear idx jdx
	TOPO.lon=lon(1:skip:end);TOPO.lat=lat(1:skip:end);TOPO.H=-double(z(1:skip:end,1:skip:end));
	clear lon lat z
	%disp(['save ',destfile,' TOPO'])
	eval(['save ',destfile,' TOPO'])
%%
else
	error('code not yet configured to handle topo data other than topo30.grd')
end
return
figure(1);clf;colormap(jet);imagesc(TOPO.lon,TOPO.lat,-TOPO.H);axis xy equal tight
caxis([-5500,0]);shading flat;title('Source topography subset for model')
done(['extracting ',srcfile]); 
