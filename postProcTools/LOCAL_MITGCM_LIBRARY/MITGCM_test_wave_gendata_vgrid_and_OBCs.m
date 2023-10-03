function MODEL=MITGCM_test_wave_gendata_vgrid_and_OBCs(MODEL,ifplot,ifprint)
EWG=load('/home/hsimmons/DATA/levitus_ewg')
%%

% z-grid
% Nominal depth of model (meters)
Nz=ceil(MODEL.H_deep/MODEL.Res_Z);
delZ=[ones(Nz,1)*MODEL.Res_Z];
Z=[cumsum(delZ)-delZ/2];

% Density (Temperature)
clear N2* p*
%lon_strat=152.5;lat_strat=-45;
idx = nearest(EWG.lon,MODEL.lon_strat);
jdx = nearest(EWG.lat,MODEL.lat_strat);
S=EWG.S(1,:,jdx,idx);T = EWG.T(1,:,jdx,idx);P=sw_pres(EWG.z,MODEL.reflat)';
%rho2=sw_pden(S,T,P,2000);

Ti=interp1(EWG.z,T,Z,'spline');Si=interp1(EWG.z,S,Z,'spline');Pi=sw_pres(Z,MODEL.reflat);
[N2a,~,p_avea]     =sw_bfrq(Si ,Ti ,Pi                ,-45);
[N2ewg,~,p_ave_ewg]=sw_bfrq(S' ,T' ,sw_pres(EWG.z,-45),-45);
N2ai=interp1(p_avea,N2a,sw_pres(Z,-45));
N2ewgi=interp1(p_ave_ewg,N2ewg,sw_pres(Z,-45),'spline');

N2ai(N2ai<MODEL.minN2)=MODEL.minN2;N2=N2ai;
ind=find(isnan(N2));
N2(1)=N2(2);N2(end)=N2(end-1);

alphaT=2e-4;f=sw_f(MODEL.lat_strat);
omega=2*pi/(12.4*3600);
[~,MODEL.u,MODEL.v,MODEL.w,MODEL.p,MODEL.rho,MODEL.eta]=VERT_STRUCTURE(Z',N2',f,1,-MODEL.flux_mag*1e3,omega);%10e3
rho0=1030; MODEL.TdiffProf=MODEL.rho/(rho0*-alphaT);

MODEL.N2   =N2;
MODEL.Tref =Ti  ;
MODEL.Nz   =Nz  ;
MODEL.Z    =Z   ;
MODEL.delZ=delZ;

%keyboard
if ifplot
	figure(5);clf;
	semilogx(N2ewg,p_ave_ewg,'ko-');axis ij;hold on
	semilogx(N2ai,sw_pres(Z,-45),'r.-');axis ij;hold on
	legend('raw N2 from EWG','N2, splined EWG data',4);axis tight
	xlabel('N2');ylabel('depth')
end
%%

%% Vertical structure for boundary conditions
if ifplot
figure(6);clf;%hformat(12)
plot(imag(MODEL.u),MODEL.Z,'k-');hold on;axis ij
plot(real(MODEL.v),MODEL.Z,'r-');legend('u','v');title(['u v eigenfunctions, ',num2str(MODEL.flux_mag),' kW/m'])
plot(0*imag(MODEL.u),MODEL.Z,'k--');
xlabel('velocity (m/s)')
pdfprint('../FIGURES/EWG_uv_eigenfunctions')
end
%%