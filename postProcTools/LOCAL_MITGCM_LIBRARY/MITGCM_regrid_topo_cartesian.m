function MODEL=MITGCM_regrid_topo_cartesian(MODEL,STRETCH)

eval(['load ',MODEL.toposrcfile,' TOPO']);

MODEL.lat2km=111.3171;MODEL.reflat=MODEL.lat0;
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
%
%%

if ~MODEL.hstretch
	MODEL.delX=MODEL.dX0*ones(1,MODEL.Nx);MODEL.X=cumsum(MODEL.delX);
	MODEL.delY=MODEL.dY0*ones(1,MODEL.Ny);MODEL.Y=cumsum(MODEL.delY);
	MODEL.H=lowpass2d(MODEL.H,MODEL.toposmoo,MODEL.toposmoo);
else
%cpuhours_2km = 7*16;

LX            = MODEL.X(end);
Lcoarse2X     = LX-STRETCH.Lcoarse1X-STRETCH.LfineX;
[X,delX]=jgp_sigmoid(LX,STRETCH.Lcoarse1X,Lcoarse2X,STRETCH.LfineX,STRETCH.delXfine,STRETCH.delXcoarse,STRETCH.xsigwidth);

LY            = MODEL.Y(end);
LfineY        = MODEL.Y(end)-2*STRETCH.Lcoarse1Y+20e3;
Lcoarse2Y     = LY-STRETCH.Lcoarse1Y-LfineY;
[Y,delY]=jgp_sigmoid(LY,STRETCH.Lcoarse1Y,Lcoarse2Y,LfineY,STRETCH.delYfine,STRETCH.delXcoarse,STRETCH.xsigwidth);
H = interp2(MODEL.X,MODEL.Y,MODEL.H,X,Y');
Nx_allcoarse= (X(end)/STRETCH.delXcoarse);
Ny_allcoarse= (Y(end)/STRETCH.delXcoarse);
N_allcoarse = (Nx_allcoarse*Ny_allcoarse);

Nx_allfine= (X(end)/STRETCH.delXfine);
Ny_allfine= (Y(end)/STRETCH.delYfine);
N_allfine = (Nx_allfine*Ny_allfine);

N_actual    = length(X)*length(Y);
N_inner     = round(STRETCH.LfineX * LfineY /(STRETCH.delXfine*STRETCH.delYfine));
N_outer     = N_allcoarse-N_inner;
Nt_ratio    = STRETCH.delXcoarse/STRETCH.delXfine;
cost_allfine = N_allfine*Nt_ratio;
cost_stretch = N_actual*Nt_ratio;
disp(' ')
disp(['Nallfine/Nallcoarse Nallfine/Nactual=actual speedup'])
disp([num2str(round(N_allfine/N_allcoarse)), '                            ',num2str(round(cost_allfine/cost_stretch))]);%wysiwyg
disp(' ')
disp(['Nx_allcoarse Ny_allcoarse Nx_allfine Ny_allfine Nx_actual Ny_actual'])
disp(num2str([round(Nx_allcoarse) round(Ny_allcoarse) round(Nx_allfine) round(Ny_allfine) length(X) length(Y) ]));
	MODEL.H=interp2(MODEL.X,MODEL.Y,MODEL.H,X,Y');
	% OK, we changed X and Y, now we have to change Lon and Lat
	MODEL.Lon=interp2(MODEL.X,MODEL.Y,MODEL.Lon,X,Y');
    MODEL.Lat=interp2(MODEL.X,MODEL.Y,MODEL.Lat,X,Y');
	
	MODEL.delX=delX;MODEL.X=cumsum(MODEL.delX);
	MODEL.delY=delY;MODEL.Y=cumsum(MODEL.delY);
	MODEL.Nx=length(MODEL.delX);
	MODEL.Ny=length(MODEL.delY);
end
%% Topography

%------------------------------------------------
% Make a weighting function to smooth offshore and along North and South
%------------------------------------------------
if MODEL.offshoresmoo
	%keyboard
	figure(601);
	subplot(2,2,1);imagesc(MODEL.H);caxis([0,5000])
Hsmoo=lowpass2d(MODEL.H,MODEL.smoofac,MODEL.smoofac);
facx=(1/2+atan(1e-3*.125*(MODEL.X-MODEL.eastsmoo )/pi)/pi);facx=facx-facx(1);facx=facx/facx(end);FACX=(repmat(facx,MODEL.Ny,1));
facy=(1/2+atan(1e-3*.125*(MODEL.Y-MODEL.northsmoo)/pi)/pi)-(1/2+atan(1e-3*.125*(MODEL.Y-MODEL.southsmoo)/pi)/pi);facy=1-facy/min(facy);facy=facy/facy(end);FACY=(repmat(facy',1,MODEL.Nx));
H2 = MODEL.H.*(1-FACX) + FACX.*Hsmoo;
H2 = H2.*(1-FACY) + FACY.*Hsmoo;
	subplot(2,2,2);imagesc(H2);caxis([0,5000])
	subplot(2,2,3);imagesc(H2-MODEL.H);caxis([-100,100])
MODEL.H=H2; 
end

%keyboard
%%
figure(101);clf;colormap(flipud(jet(2*16)));
axes('pos',[.2  ,.575,.4  ,.4  ]);pcolor(MODEL.X/1e3,MODEL.Y/1e3,MODEL.H);axis equal tight;shading flat;caxis([0,5500]);
                             pos=get(gca,'pos');colorbar;nolimsx;set(gca,'pos',pos)
                             hold on;[c,h]=contourf(MODEL.X/1e3,MODEL.Y/1e3,sqrt(delY'*delX)/1e3,[0:.5:30],'k');clabel(c,h,'labelspac',720)
                             contour(MODEL.X/1e3,MODEL.Y/1e3,MODEL.H,[0,0],'k');              
                             contour(MODEL.X/1e3,MODEL.Y/1e3,MODEL.H,[100,500,1000 3000],'w');              
							 [c,h]=contour (MODEL.X/1e3,MODEL.Y/1e3,MODEL.Lon,[0:1:360]   ,'k:');clabel(c,h,'labelspac',720)
							 [c,h]=contour (MODEL.X/1e3,MODEL.Y/1e3,MODEL.Lat,[-360:1:360],'k:');clabel(c,h,'labelspac',720)
                             
axes('pos',[.2 ,.15 ,.4  ,.4  ]);pcolor(MODEL.X/1e3,MODEL.Y/1e3,sqrt(MODEL.delY'*MODEL.delX)/1e3);nolimsy
                                  axis equal tight;shading flat;
								  pos=get(gca,'pos');colorbar;nolimsx;set(gca,'pos',pos)
axes('pos',[.23,.05 ,.335   ,.075]);hformat(6);plot(MODEL.X/1e3,MODEL.delX/1e3);axis tight;ylim([0,STRETCH.delXcoarse/1e3+.1]);ytick([0:2:20]);grid on
axes('pos',[.1  ,.155,.1  ,.4  ]);hformat(6);plot(MODEL.delY/1e3,MODEL.Y/1e3);axis tight;xlim([0,STRETCH.delXcoarse/1e3+.1]);xtick([0:2:20]);grid on

