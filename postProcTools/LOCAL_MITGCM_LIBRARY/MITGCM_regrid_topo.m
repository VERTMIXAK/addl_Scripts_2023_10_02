function MODEL=MITGCM_test_wave_gendata_regrid_topo(MODEL,ifplot,printit,ifJ)

eval(['load ',MODEL.toposrcfile,' TOPO'])

MODEL.lat2km=111.3171;
MODEL.lon2km=sw_dist([MODEL.reflat MODEL.reflat],[0 1],'km')     ;

delX = MODEL.dX0*ones(1,MODEL.Nx);MODEL.X=cumsum(delX);
delY = MODEL.dY0*ones(1,MODEL.Ny);MODEL.Y=cumsum(delY);

% Rotate coordinates and determine lat and lon
ii=complex(0,1);

[xi yi]=meshgrid(MODEL.X*1e-3,MODEL.Y*1e-3); xi=xi'; yi=yi';
coord=xi+ii*yi;
coord=coord*exp(ii*pi*MODEL.rotate_angle/180);
coord=real(coord)./MODEL.lon2km+ii*imag(coord)/MODEL.lat2km;
coord=coord+MODEL.lon0+ii*MODEL.lat0;
MODEL.Lon=real(coord)'; MODEL.Lat=imag(coord)';

% Interpolate bathymetry onto grid 
%%
MODEL.H=interp2(TOPO.lon',TOPO.lat',TOPO.H,MODEL.Lon,MODEL.Lat);
MODEL.H(MODEL.H>=MODEL.H_deep)=MODEL.H_deep;
land = 1-vswap(MODEL.H./MODEL.H,nan,0);
%keyboard
MODEL.H(MODEL.H<=2*MODEL.Res_Z)=2*MODEL.Res_Z;MODEL.H(land==1)=0;
%%
%keyboard
% rotate the GOLD fluxes
if ifJ
	load TASMAN_J ;
	tmpJu=interp2(J.lon',J.lat',J.IJPRu,MODEL.Lon,MODEL.Lat);
	tmpJv=interp2(J.lon',J.lat',J.IJPRv,MODEL.Lon,MODEL.Lat);

% since Ju and Jv are vectors we also have to rotate them as well
theta = atan2(tmpJu,tmpJv) + deg2rad(-MODEL.rotate_angle);

MODEL.Ju = tmpJu.*cos(theta) + tmpJv.*sin(theta);
MODEL.Jv = tmpJv.*cos(theta) - tmpJu.*sin(theta);
end
% this is the window that we apply to center the beam on the eastern
% boundary.
MODEL.flux_window = exp(-((MODEL.Y/1e3 - 335)/120).^2);
%% Make a weighting function to smooth offshore and along North and South
Hsmoo=lowpass2d(MODEL.H,MODEL.smoofac,MODEL.smoofac);
facx=(1/2+atan(.125*(MODEL.X/1e3-MODEL.eastsmoo)/pi)/pi);facx=facx-facx(1);facx=facx/facx(end);FACX=(repmat(facx,MODEL.Ny,1));
facy=(1/2+atan(.125*(MODEL.Y/1e3-MODEL.northsmoo)/pi)/pi)-(1/2+atan(.125*(MODEL.Y/1e3-MODEL.southsmoo)/pi)/pi);facy=1-facy/min(facy);facy=facy/facy(end);FACY=(repmat(facy',1,MODEL.Nx));
H2 = MODEL.H.*(1-FACX) + FACX.*Hsmoo;
H2 = H2.*(1-FACY) + FACY.*Hsmoo;
MODEL.Hsmoo=H2;
%%
