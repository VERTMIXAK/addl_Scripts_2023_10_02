function [TS,D,conList]=GET_TIDE_TPXO(Model,time,lon,lat,type,conID,lon_flag)
% function [TS,D,conList]=GET_TIDE_TPXO(Model,time,lon,lat,type,conID)
% TPXO tidal time series at a given location
%
% Input:
% Model - TPXO binary file
% time - vector expressed in serial days (see 'help datenum')
% lon,lat - coordinates in degrees [-180 180],[-90 90]
% type - 'u','v' velocities [m/s],'U','V' transports [m^2/s];
% conID - consituents to include ConList=ConList(conID,:), if conID=[]
%       ALL model constituents are included
%
% Ouput:
% TS - TPXO time series
% D - Depth at lon,lat
% conList - All consituents available
%
% NOTE: This is a stripped down version of tide_pred.m in Laurie Padman's TMD 
% toolbox.  There are no dependencies.
%
%                                                            skelly 4-06-08

if nargin<6
    conID=[];
    if nargin<7
        lon_flag=0;
    end
end
if lon_flag
    if sum(lon<0)>0;lon=lon+360;end
end
if size(time,1)==1;time=time';end

% Entire function
[amp,phase,D,conList]=extract_HC(Model,lon,lat,type,conID);
HC=amp.*exp(-1i*phase);
TS=make_TS(time,HC,conList);
return;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [amp,phase,D,conList]=extract_HC(Model,lon,lat,type,conID)
% Read model file
%%
fid=fopen(Model,'r');idx=findstr(Model,'/');
hfile=[Model(1:idx(end)),fgetl(fid)]
ufile=[Model(1:idx(end)),fgetl(fid)];
gfile=[Model(1:idx(end)),fgetl(fid)];
fclose(fid);

% Read tidal constituents
fid=fopen(ufile,'r','b');
fread(fid,3,'long');
nc=fread(fid,1,'long');
fread(fid,4,'float');
conList=char(reshape(fread(fid,nc*4,'uchar'),4,nc)');
fclose(fid);
if isempty(conID),conID=1:size(conList,1);end
conList=conList(conID,:);

% Read grid file
fid=fopen(gfile,'r','b');
fseek(fid,4,'bof');
n=fread(fid,1,'long');
m=fread(fid,1,'long');
lats=fread(fid,2,'float');
lons=fread(fid,2,'float');
ll_lims=[lons ; lats ];
fread(fid,1,'float');
nob=fread(fid,1,'long');
if nob==0,
    fseek(fid,20,'cof');
else
    fseek(fid,8,'cof');
    fread(fid,[2,nob],'long');
    fseek(fid,8,'cof');
end
H=fread(fid,[n,m],'float');
H(H==0)=NaN;
fclose(fid);

% Linearly interpolate depth because u and v are not at same points at H
mz=H>0; 
mu([2:n 1],:)=mz.*mz([2:n 1],:); 
mv(:,[2:m 1])=mz.*mz(:,[2:m 1]); 
hu=mu.*(H+H([n,1:n-1],:))/2;
hu(hu==0)=NaN;
hv=mv.*(H+H(:,[m,1:m-1]))/2;
hv(hv==0)=NaN;

% Get grids
dx=(ll_lims(2)-ll_lims(1))/n;
dy=(ll_lims(4)-ll_lims(3))/m;
x=ll_lims(1)+dx/2:dx:ll_lims(2)-dx/2;
y=ll_lims(3)+dy/2:dy:ll_lims(4)-dy/2;
[Xu,Yu]=meshgrid(x-dx/2,y);
[Xv,Yv]=meshgrid(x,y-dy/2);

amp=ones(length(conID),size(lon,1),size(lon,2))*NaN;
phase=ones(length(conID),size(lon,1),size(lon,2))*NaN;
for k=1:length(conID)
    fprintf('Interpolating constituent %s... \n',conList(k,:));
    
    % Load transport file
    fid=fopen(ufile,'r','b');
    temp=fread(fid,4,'long');
    fread(fid,4,'float');
    nskip=(conID(k)-1)*(temp(2)*temp(3)*16+8)+8+temp(1)-28;
    fseek(fid,nskip,'cof');
    htemp=fread(fid,[4*temp(2),temp(3)],'float');
    ur=htemp(1:4:4*temp(2)-3,:);
    ui=htemp(2:4:4*temp(2)-2,:);
    vr=htemp(3:4:4*temp(2)-1,:);
    vi=htemp(4:4:4*temp(2),:);
    u=ur+1i*ui;
    v=vr+1i*vi;
    fclose(fid);

    % Interpolate
    u(u==0)=NaN;v(v==0)=NaN;
    if type=='u',u=u./hu;end
    if type=='v',v=v./hv;end
    if type=='u' || type=='U',
        u1=interp2(Xu,Yu,u',lon,lat);u1=conj(u1);
        if k==1 % Get depth only once
            D=interp2(Xu,Yu,hu',lon,lat);
            if sum(isnan(u1))>0,
                D(isnan(u1))=BLinterp(x-dx/2,y,hu,lon(isnan(u1)),lat(isnan(u1)));
            end
        end
        % Correct near NaNs
        if sum(isnan(u1))>0
            u1(isnan(u1))=BLinterp(x-dx/2,y,u,lon(isnan(u1)),lat(isnan(u1)));
        end
        amp(k,:,:)=abs(u1);
        phase(k,:,:)=atan2(-imag(u1),real(u1));
    elseif type=='v' || type=='V',
        v1=interp2(Xv,Yv,v',lon,lat);v1=conj(v1);
        if k==1 % Get depth only once
            D=interp2(Xv,Yv,hv',lon,lat);
            if sum(isnan(v1))>0
                D(isnan(v1))=BLinterp(x,y-dy/2,hv,lon(isnan(v1)),lat(isnan(v1)));
            end
        end
        % Correct near NaNs
        if sum(isnan(v1))>0
            v1(isnan(v1))=BLinterp(x,y-dy/2,v,lon(isnan(v1)),lat(isnan(v1)));
        end
        amp(k,:,:)=abs(v1);
        phase(k,:,:)=atan2(-imag(v1),real(v1));
    end
end
phase(phase<0)=phase(phase<0)+2*pi;
return;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [TS]=make_TS(time,HC,conList)
% Get constituent properties (Everything is in this order)
names_data={'m2  ';'s2  ';'k1  ';'o1  '; ...
    'n2  ';'p1  ';'k2  ';'q1  '; ...
    '2n2 ';'mu2 ';'nu2 ';'l2  '; ...
    't2  ';'j1  ';'no1 ';'oo1 '; ...
    'rho1';'mf  ';'mm  ';'ssa ';'m4  '};

% frequencies
omega_data=[1.405189e-04;1.454441e-04;7.292117e-05;6.759774e-05; ...
    1.378797e-04;7.252295e-05;1.458423e-04;6.495854e-05; ...
    1.352405e-04;1.355937e-04;1.382329e-04;1.431581e-04; ...
    1.452450e-04;7.556036e-05;7.028195e-05;7.824458e-05; ...
    6.531174e-05;0.053234e-04;0.026392e-04;0.003982e-04;2.81038e-04];

% astronomical arguments (relative to t0 = 1 Jan 0:00 1992]
phase_data=[ 1.731557546;0.000000000;0.173003674;1.558553872;...
    6.050721243;6.110181633;3.487600001;5.877717569;
    4.086699633;3.463115091;5.427136701;0.553986502;
    0.052841931;2.137025284;2.436575100;1.929046130;
    5.254133027;1.756042456;1.964021610;3.487600001;
    3.463115091];

% determine nodal corrections f and u
omegaN=125.0445-0.05295377*(time-51544.4993);% mean longitude of ascending lunar node
p=83.3535+0.11140353*(time-51544.4993);% mean longitude of lunar perigee
sinn = sin(omegaN*pi/180);
cosn = cos(omegaN*pi/180);
sin2n = sin(2*omegaN*pi/180);
cos2n = cos(2*omegaN*pi/180);
sin3n = sin(3*omegaN*pi/180);

f=ones(length(time),11);
f(:,1)=sqrt((1.-.03731*cosn+.00052*cos2n).^2+(.03731*sinn-.00052*sin2n).^2); 
f(:,2)=1;
f(:,3)=sqrt((1.+.1158*cosn-.0029*cos2n).^2+(.1554*sinn-.0029*sin2n).^2); 
f(:,4)=sqrt((1.0+0.189*cosn-0.0058*cos2n).^2+(0.189*sinn-0.0058*sin2n).^2);
f(:,5)=sqrt((1.-.03731*cosn+.00052*cos2n).^2+(.03731*sinn-.00052*sin2n).^2);
f(:,6)=1;
f(:,7)=sqrt((1.+.2852*cosn+.0324*cos2n).^2+(.3108*sinn+.0324*sin2n).^2); 
f(:,8)=sqrt((1.+.188*cosn).^2+(.188*sinn).^2);
f(:,9)=sqrt((1.-.03731*cosn+.00052*cos2n).^2+(.03731*sinn-.00052*sin2n).^2);
f(:,10)=sqrt((1.-.03731*cosn+.00052*cos2n).^2+(.03731*sinn-.00052*sin2n).^2);
f(:,11)=sqrt((1.-.03731*cosn+.00052*cos2n).^2+(.03731*sinn-.00052*sin2n).^2);
temp1=1.-0.25*cos(2*p*pi/180)-0.11*cos((2*p-omegaN)*pi/180)-0.04*cosn;
temp2=0.25*sin(2*p*pi/180)+0.11*sin((2*p-omegaN)*pi/180)+ 0.04*sinn;
f(:,12)=sqrt(temp1.^2 + temp2.^2);             
f(:,13)=1;
f(:,14)=sqrt((1.+.169*cosn).^2+(.227*sinn).^2);
tmp1=1.36*cos(p*pi/180)+.267*cos((p-omegaN)*pi/180);% Ray's
tmp2=0.64*sin(p*pi/180)+.135*sin((p-omegaN)*pi/180);
f(:,15)=sqrt(tmp1.^2 + tmp2.^2);                
f(:,16)=sqrt((1.0+0.640*cosn+0.134*cos2n).^2+(0.640*sinn+0.134*sin2n).^2 );
f(:,17)=sqrt((1.+.188*cosn).^2+(.188*sinn).^2);
f(:,18)=1.043 + 0.414*cosn;          
f(:,19)=1-0.130*cosn;           
f(:,20)=1;
f(:,21)=(1.-.03731*cosn+.00052*cos2n).^2+(.03731*sinn-.00052*sin2n).^2;

u=zeros(length(time),11);
u(:,1)=atan((-.03731*sinn+.00052*sin2n)./(1.-.03731*cosn+.00052*cos2n))/pi/180;                                     % M2
u(:,2)=0;
u(:,3)=atan((-.1554*sinn+.0029*sin2n)./(1.+.1158*cosn-.0029*cos2n))/pi/180;
u(:,4)=10.8*sinn-1.3*sin2n+0.2*sin3n;
u(:,5)=atan((-.03731*sinn+.00052*sin2n)./(1.-.03731*cosn+.00052*cos2n))/pi/180;
u(:,6)=0;
u(:,7)=atan(-(.3108*sinn+.0324*sin2n)./(1.+.2852*cosn+.0324*cos2n))/pi/180;
u(:,8)=atan(.189*sinn./(1.+.189*cosn))/pi/180;
u(:,9)=atan((-.03731*sinn+.00052*sin2n)./(1.-.03731*cosn+.00052*cos2n))/pi/180;
u(:,10)=atan((-.03731*sinn+.00052*sin2n)./(1.-.03731*cosn+.00052*cos2n))/pi/180;
u(:,11)=atan((-.03731*sinn+.00052*sin2n)./(1.-.03731*cosn+.00052*cos2n))/pi/180;
u(:,12) = atan(-temp2./temp1)/pi/180 ;
u(:,13) = 0;
u(:,14) = atan(-.227*sinn./(1.+.169*cosn))/pi/180; 
u(:,15) = atan2(tmp2,tmp1)/pi/180;
u(:,16) = atan(-(.640*sinn+.134*sin2n)./(1.+.640*cosn+.134*cos2n))/pi/180;  
u(:,17) = atan(.189*sinn./(1.+.189*cosn))/pi/180; 
u(:,18) = -23.7*sinn + 2.7*sin2n - 0.4*sin3n;
u(:,19) = 0;
u(:,20) = 0;
u(:,21) = (atan((-.03731*sinn+.00052*sin2n)./ ...
           (1.-.03731*cosn+.00052*cos2n))/pi/180)*2;
       
% Make the timeseries
time=time-datenum(1992,1,1);
time=repmat(time,[1 size(HC,2) size(HC,3)]);time=permute(time,[2 3 1]);
TS=zeros(size(HC,2),size(HC,3),size(time,3));
for k=1:size(conList,1)
    % Get the needed parameters
    kk=find(strcmp(names_data,conList(k,:))==1);
    omega=omega_data(kk);
    phase=phase_data(kk);    
    pu=u(:,kk)*pi/180;
    pf=f(:,kk);
    % Adjust sizes to fit TS
    pu=repmat(pu,[1 size(HC,2) size(HC,3)]);pu=permute(pu,[2 3 1]);
    pf=repmat(pf,[1 size(HC,2) size(HC,3)]);pf=permute(pf,[2 3 1]);
    reHC=squeeze(real(HC(k,:,:)));if size(reHC,1)~=size(HC,2);reHC=reHC';end
    reHC=repmat(reHC,[1 1 size(time,3)]);
    imHC=squeeze(imag(HC(k,:,:)));if size(imHC,1)~=size(HC,2);imHC=imHC';end
    imHC=repmat(imHC,[1 1 size(time,3)]); 
    TS=TS+pf.*reHC.*cos(omega*time*86400+phase+pu)...
        -pf.*imHC.*sin(omega*time*86400+phase+pu);    
end
TS=squeeze(TS);
return;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Interpolate when neghboring points are NaNs
function [hi]=BLinterp(x,y,h,xt,yt)
h(isnan(h))=0;
mz=(h~=0);
[X,Y]=meshgrid(x,y);
q=1/(4+2*sqrt(2));
q1=q/sqrt(2);
h1=q1*h(1:end-2,1:end-2)+q*h(1:end-2,2:end-1)+q1*h(1:end-2,3:end)+...
   q1*h(3:end,1:end-2)+q*h(3:end,2:end-1)+q1*h(3:end,3:end)+...
   q*h(2:end-1,1:end-2)+q*h(2:end-1,3:end);
mz1=q1*mz(1:end-2,1:end-2)+q*mz(1:end-2,2:end-1)+q1*mz(1:end-2,3:end)+...
   q1*mz(3:end,1:end-2)+q*mz(3:end,2:end-1)+q1*mz(3:end,3:end)+...
   q*mz(2:end-1,1:end-2)+q*mz(2:end-1,3:end);
mz1(mz1==0)=1;
h2=h;
h2(2:end-1,2:end-1)=h1./mz1;
h2(mz==1)=h(mz==1);
h2(h2==0)=NaN;
hi=interp2(X,Y,h2',xt,yt);
hi=conj(hi);
return;


