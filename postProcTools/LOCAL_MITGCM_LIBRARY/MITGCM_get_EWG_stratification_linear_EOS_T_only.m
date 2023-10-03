function MODEL=MITGCM_get_mode_1_OBCs(MODEL)
EWG=load('/import/c/w/jpender/dataDir/levitus_ewg');
%%

% z-grid
% Nominal depth of model (meters)

% Density (Temperature)
clear N2* p*
%%
%keyboard
 idx = nearest(EWG.lon,MODEL.lon_strat);
 jdx = nearest(EWG.lat,MODEL.lat_strat);

S = sq(EWG.S(1,:,jdx-1:jdx+1,idx-1:idx+1));
T = sq(EWG.T(1,:,jdx-1:jdx+1,idx-1:idx+1));
P = sw_pres(EWG.z,MODEL.reflat)';
Pmax = sw_pres(MODEL.H_max,MODEL.reflat)

S=lowpass(sq(mean(mean(S,2),3)),1);
T=lowpass(sq(mean(mean(T,2),3)),1);
sig0ewg = sw_pden(S,T,P',0);Pi=linspace(P(1),P(end),500);
sig0ewgi=interp1(P,sig0ewg,Pi);
[N2ewg,~,p_ave]=sw_bfrq(S ,T ,sw_pres(EWG.z,MODEL.reflat),MODEL.reflat);
x=p_ave;y = lowpass(log10(N2ewg),1);p=polyfit(x,y,2); % fit a second order poly to the log of stratification
% orig N2_fit = 10.^(p(3)+p(2)*x+p(1)*x.^2); N2_fit=N2_fit-min(N2_fit)+10^-6.5;%shift minimum to 10e-6
x2=[x;Pmax];N2_fit2 = 10.^(p(3)+p(2)*x2+p(1)*x2.^2);

%N2_fit2=N2_fit2-min(N2_fit2)+10^-6.5;%shift minimum to 10e-6
N2_fit2=N2_fit2-min(N2_fit2)+MODEL.N2_min;

% JGP The dealio here is that we've just calculated n2 vs z on the EWG data
% set grid. Now I want to interpolate that back onto my grid, but my first
% grid point is z=0, which is not on the EWG grid.
%N2 = interp1(p_ave,N2_fit,sw_pres(MODEL.Z,MODEL.reflat)); N2(1)=N2(2);N2(end)=N2(end-1);
N2 = interp1(x2,N2_fit2   ,sw_pres(MODEL.Z(2:end),MODEL.reflat)); %N2(1)=N2(2);N2(end)=N2(end-1);

%JGP add cheat to get a value for z=0
N2 = [N2(1) N2']';

% % % dT = MODEL.delZ.*N2/9.8/MODEL.alphaT;
% % % Tnew = -cumsum([dT]);
% % % % rescale because fit is not quite right
% % % scale = [T(end)-T(1)]/Tnew(end);
% % % MODEL.Tref=scale*Tnew+T(1);
MODEL.N2=N2;
%%
aaa=5;
%keyboard
return
%%
% find best exponential to describe density that matches bottom and upper 200m using simple search
bs = 100:10:2000;cmap=jet(length(bs));stds=[];
surfidx=find(Pi<=100);
sigbot = sig0ewgi(end);sigsurf=mean(sig0ewg(surfidx));
for bdx = 1:length(bs)
	stds(bdx) = rms(sig0ewgi'-(sigbot-(sigbot-sigsurf)*exp(-Pi'/bs(bdx))));
end
b = bs(find(stds==min(stds)));
sigfit = sigbot-(sigbot-sigsurf)*exp(-Pi'/b);
figure(200);clf
plot(sig0ewgi,Pi,'k');axis ij;hold on
plot(sigfit,Pi);axis ij;hold on
N2_fit2 = interp1(sw_dpth(Pi',MODEL.reflat),(9.8/1030)*gradient(sigfit)./gradient(Pi'),sw_pres(MODEL.Z,MODEL.reflat));
N2_fit2=N2_fit2-N2_fit2(end)+10.^-6.5;
%%
