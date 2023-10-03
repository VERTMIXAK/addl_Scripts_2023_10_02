    % The tides to extract
    tpxofile = '/import/c/w/jpender/dataDir/OTIS_DATA/Model_tpxo7.2';
%     A=[ones([1 length(OB.timeD)]); cos(OB.omegaDM2*OB.timeD); sin(OB.omegaDM2*OB.timeD)];
    A=[ones([1 length(OB.timeD)]); 
        cos(OB.omegaDM2*OB.timeD); sin(OB.omegaDM2*OB.timeD); 
        cos(OB.omegaDS2*OB.timeD); sin(OB.omegaDS2*OB.timeD); 
        cos(OB.omegaDK1*OB.timeD); sin(OB.omegaDK1*OB.timeD); 
        cos(OB.omegaDO1*OB.timeD); sin(OB.omegaDO1*OB.timeD)
        ];
    
    % Time dependence to upload
%     input=[cos(OB.omegaDM2*OB.timeD); sin(OB.omegaDM2*OB.timeD)];
    input=[cos(OB.omegaDM2*OB.timeD); sin(OB.omegaDM2*OB.timeD); 
        cos(OB.omegaDS2*OB.timeD); sin(OB.omegaDS2*OB.timeD); 
        cos(OB.omegaDK1*OB.timeD); sin(OB.omegaDK1*OB.timeD); 
        cos(OB.omegaDO1*OB.timeD); sin(OB.omegaDO1*OB.timeD)];
    
    % Southern Boundary
    lat=MODEL.Lat(1,:);lon=MODEL.Lon(1,:);H0=MODEL.H(1,:);
    [u]=GET_TIDE_TPXO(tpxofile,OB.timeD,lon,lat,'U',[nconsts],1);
    [v]=GET_TIDE_TPXO(tpxofile,OB.timeD,lon,lat,'V',[nconsts],1);
    su=zeros([MODEL.Nx OB.Nt]);sv=zeros([MODEL.Nx OB.Nt]);
    for i=1:size(u,1)
        if ~any(isnan(u(i,:))) & H0(i)>1e-6
            B=regress(u(i,:)',A')/H0(i);
            su(i,:)=input'*B(2:end);
        end
        if ~any(isnan(v(i,:))) & H0(i)>1e-6
            B=regress(v(i,:)',A')/H0(i);
            sv(i,:)=input'*B(2:end);
        end
	end
    %keyboard
    
    % Northern Boundary
    lat=MODEL.Lat(end,:);lon=MODEL.Lon(end,:);H0=MODEL.H(end,:);
    [u]=GET_TIDE_TPXO(tpxofile,OB.timeD,lon,lat,'U',[nconsts],1);
    [v]=GET_TIDE_TPXO(tpxofile,OB.timeD,lon,lat,'V',[nconsts],1);
    nu=zeros([MODEL.Nx OB.Nt]);nv=zeros([MODEL.Nx OB.Nt]);
    for i=1:size(u,1)
        if ~any(isnan(u(i,:))) & H0(i)>1e-6
            B=regress(u(i,:)',A')/H0(i);
            nu(i,:)=input'*B(2:end);
        end
        if ~any(isnan(v(i,:))) & H0(i)>1e-6
            B=regress(v(i,:)',A')/H0(i);
            nv(i,:)=input'*B(2:end);
        end
	end

    % Western boundary
    %%
    lat=MODEL.Lat(:,1);lon=MODEL.Lon(:,1);H0=MODEL.H(:,1);
    [u]=GET_TIDE_TPXO(tpxofile,OB.timeD,lon,lat,'U',[nconsts],1);
    [v]=GET_TIDE_TPXO(tpxofile,OB.timeD,lon,lat,'V',[nconsts],1);
    wu=zeros([MODEL.Ny OB.Nt]);wv=zeros([MODEL.Ny OB.Nt]);
    for i=1:size(u,1)
        if ~any(isnan(u(i,:))) & H0(i)>1e-6
            B=regress(u(i,:)',A')/H0(i);
            wu(i,:)=input'*B(2:end);
        end
        if ~any(isnan(v(i,:))) & H0(i)>1e-6
            B=regress(v(i,:)',A')/H0(i);
            wv(i,:)=input'*B(2:end);
        end
	end
	
    %%
    % Eastern boundary
    lat=MODEL.Lat(:,end);lon=MODEL.Lon(:,end);H0=MODEL.H(:,end);
    [u]=GET_TIDE_TPXO(tpxofile,OB.timeD,lon,lat,'U',[nconsts],1);
    [v]=GET_TIDE_TPXO(tpxofile,OB.timeD,lon,lat,'V',[nconsts],1);
    eu=zeros([MODEL.Ny OB.Nt]);ev=zeros([MODEL.Ny OB.Nt]);
    for i=1:size(u,1)
        if ~any(isnan(u(i,:))) & H0(i)>1e-6
            B=regress(u(i,:)',A')/H0(i);
            eu(i,:)=input'*B(2:end);
        end
        if ~any(isnan(v(i,:))) & H0(i)>1e-6
            B=regress(v(i,:)',A')/H0(i);
            ev(i,:)=input'*B(2:end);
        end
	end
%%

	nu=demean(nu')';
	nv=demean(nv')';
	su=demean(su')';
	sv=demean(sv')';
	wu=demean(wu')';
	wv=demean(wv')';
    eu=demean(eu')';
	ev=demean(ev')';
%%    
%keyboard
% rotate vectors

if rotateit
%%
theta=deg2rad(MODEL.rotate_angle);R=[cos(theta) sin(theta);-sin(theta) cos(theta)];
tmpnu=nan*nu;
tmpnv=nan*nv;
tmpsu=nan*su;
tmpsv=nan*sv;
tmpeu=nan*eu;
tmpev=nan*ev;
tmpwu=nan*wu;
tmpwv=nan*wv;

for ii = 1:length(nu(:,1));tmp = R*[nu(ii,:);nv(ii,:)];	tmpnu(ii,:)=tmp(1,:);	tmpnv(ii,:)=tmp(2,:);end
for ii = 1:length(eu(:,1));tmp = R*[eu(ii,:);ev(ii,:)];	tmpeu(ii,:)=tmp(1,:);	tmpev(ii,:)=tmp(2,:);end
for ii = 1:length(wu(:,1));tmp = R*[wu(ii,:);wv(ii,:)];	tmpwu(ii,:)=tmp(1,:);	tmpwv(ii,:)=tmp(2,:);end
for ii = 1:length(su(:,1));tmp = R*[su(ii,:);sv(ii,:)];	tmpsu(ii,:)=tmp(1,:);	tmpsv(ii,:)=tmp(2,:);end
nu=tmpnu;
nv=tmpnv;
su=tmpsu;
nv=tmpsv;
eu=tmpeu;
ev=tmpev;
wu=tmpwu;
wv=tmpwv;
end % rotateit

% Calculate temp boundary
    OB.NT=repmat(MODEL.Tref',[MODEL.Nx 1 OB.Nt]);
    OB.ST=repmat(MODEL.Tref',[MODEL.Nx 1 OB.Nt]);
    OB.WT=repmat(MODEL.Tref',[MODEL.Ny 1 OB.Nt]);
    OB.ET=repmat(MODEL.Tref',[MODEL.Ny 1 OB.Nt]);

% Format for model
    OB.NU=permute(repmat(nu,[1 1 MODEL.Nz]),[1 3 2]);done('NU');
    OB.NV=permute(repmat(nv,[1 1 MODEL.Nz]),[1 3 2]);done('NV');
    OB.SU=permute(repmat(su,[1 1 MODEL.Nz]),[1 3 2]);done('SU');
    OB.SV=permute(repmat(sv,[1 1 MODEL.Nz]),[1 3 2]);done('SV');
%     OB.WU=permute(repmat(wu,[1 1 MODEL.Nz]),[1 3 2]);done('WU');
%     OB.WV=permute(repmat(wv,[1 1 MODEL.Nz]),[1 3 2]);done('WV');
%     OB.EU=permute(repmat(eu,[1 1 MODEL.Nz]),[1 3 2]);done('EU');
%     OB.EV=permute(repmat(ev,[1 1 MODEL.Nz]),[1 3 2]);done('EV');

% plot TPXO tides
% consts={'m2';'s2';'o1';'k1'};params={'z'}
% for cdx = 1:length(consts)
% for pdx = 1:length(params)
%         param = char(params(pdx));      const = char(consts(cdx));disp([param,' ',const])
%         [x,y,tmpamp,tmppha]=tmd_get_coeff('/import/c/w/jpender/dataDir/OTIS_DATA/Model_tpxo7.2',param,const);
%     amp.(const).(param)=tmpamp;
%     pha.(const).(param)=tmppha;
% end
% end
% clear tmp* cdx pdx
% %min(MODEL.Lon(:))
% idx=find(x>=min(MODEL.Lon(:))&x<=max(MODEL.Lon(:)));
% jdx=find(y>=min(MODEL.Lat(:))&y<=max(MODEL.Lat(:)));
% if ifplottpxo
% figure(201);clf
% m_proj('equi','lon',[min(MODEL.Lon(:)) max(MODEL.Lon(:))],'lat',[min(MODEL.Lat(:)) max(MODEL.Lat(:))] );
% %keyboard
% %%
% 	for cdx = 1:4
% 	const = char(consts(cdx))
% 	tmpamp = amp.(const).z;
% 	tmppha = pha.(const).z;
% 	subplot(2,2,cdx)
% 	m_contourf(x(idx),y(jdx),tmpamp(jdx,idx),[0:.01:2]);caxis([0,1]);shading flat;hold on;axis equal xy tight;;caxis([0,1]);pos=get(gca,'pos');
% 	if cdx==4;h=colorbar;set(h,'pos',[.925,.1,.005,.35]);end;set(gca,'pos',pos)
% 	[c,h]=m_contour(x(idx),y(jdx),tmppha(jdx,idx),5:5:355,'k');clabel(c,h,'labelsp',7200)
% 	m_coast('patch',.75*[.85 1 .5]);hold on;;m_grid;drawnow;m_fix;;title(const)
% 	drawnow
% 	end
% end
