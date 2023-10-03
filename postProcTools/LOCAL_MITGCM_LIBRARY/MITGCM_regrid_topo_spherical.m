function MODEL=MITGCM_regrid_topo_spherical(MODEL)
%%
load(MODEL.toposrcfile)
	MODEL.delX=[MODEL.dX0*ones(1,MODEL.Nx)]';
	MODEL.delY=[MODEL.dY0*ones(1,MODEL.Ny)]';
	MODEL.lon = cumsum(MODEL.delX)-MODEL.delX(1)+MODEL.lon0;
	MODEL.lat = cumsum(MODEL.delY)-MODEL.delY(1)+MODEL.lat0;
	MODEL.Y=MODEL.lat;MODEL.X=MODEL.lon;
	MODEL.reflat=(MODEL.lat(1)+MODEL.lat(end))/2;
	[MODEL.Lon,MODEL.Lat]=meshgrid(MODEL.lon,MODEL.lat);
	MODEL.H=interp2(TOPO.lon',TOPO.lat',lowpass2d(TOPO.H,MODEL.topopresmoo,MODEL.topopresmoo),MODEL.Lon,MODEL.Lat,'nearest');MODEL.H(MODEL.H>=MODEL.H_max)=MODEL.H_max;
	MODEL.H=lowpass2d(MODEL.H,MODEL.toposmoo,MODEL.toposmoo);
	MODEL.delX=[MODEL.dX0*ones(1,MODEL.Nx)]';
	MODEL.delY=[MODEL.dY0*ones(1,MODEL.Ny)]';

	
% 	figure(101);clf
% 	subplot(2,1,1);imagesc(TOPO.lon,TOPO.lat,TOPO.H)	;axis xy;hold on
% 	               contour(TOPO.lon,TOPO.lat,TOPO.H,[0 0],'w')	;axis xy;hold on
% 	subplot(2,1,2);imagesc(MODEL.lon,MODEL.lat,MODEL.H) ;axis xy;hold on
% 	               contour(MODEL.lon,MODEL.lat,MODEL.H,[0 0],'w')	;axis xy;hold on
	