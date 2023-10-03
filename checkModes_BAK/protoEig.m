clear;

% The raw data is in ../netcdfOutput, as usual, but it's convenient to
% squash the data into single files, like this:
%   ncrcat ../netcdfOutput/TS_his_* TS_his.nc
%   ncrcat ../netcdfOutput/TS_his2_* TS_his2.nc

grid = roms_get_grid('../TS_0.25.nc','TS_his.nc',0,1);
Z_r  = -flipdim(grid.z_r,1);
Z_w  = -flipdim(grid.z_w,1);

U   = flipdim(nc_varget('./TS_his.nc','u_eastward') ,2);
V   = flipdim(nc_varget('./TS_his.nc','v_northward'),2);
RHO = flipdim(nc_varget('./TS_his.nc','rho')        ,2);
N2_w  = flipdim(nc_varget('./TS_his.nc','w')          ,2);

[nt,nz,ny,nx]=size(U);

N2_r  = .5*( N2_w(:,1:end-1,:,:) + N2_w(:,2:end,:,:) );


%% Here is a question:
%   If I were to recalculate the modes on every snapshot and then find the
%   coefficients, how different would they be from coefficients calculated
%   using the t=0 pmodes/wmodes?

% ii=30; jj=60;           % mode 1 looks good
ii=30; jj=90;          % lots of variation
% ii=5; jj=85;          % lots of variation
% ii=122; jj=62;          % lots of variation


nVel = 3;
nRho = 3;

P  = zeros(nVel,nt,nz);
PX = zeros(nVel,nt,nz);
W  = zeros(nRho,nt,nz);
WX = zeros(nRho,nt,nz);
R  = zeros(nRho,nt,nz);
RX = zeros(nRho,nt,nz);

for tt=1:nt
if ( grid.mask_rho(jj,ii) == 1 )

    z_r = Z_r(:,jj,ii);
    z_w = Z_w(:,jj,ii);
    dz  = diff(z_w);

    P_r = sw_pres(z_r,-43);
    P_w = sw_pres(z_w,-43);
    rho_r = RHO(tt,:,jj,ii)';

    n2_w = N2_w(tt,:,jj,ii)';n2_w(n2_w<1e-8)=1e-8;
    n2_r = N2_r(tt,:,jj,ii)';n2_r(n2_r<1e-8)=1e-8;

    [w, p, ce, Pout]=ROMS_dynmodes_jgp(n2_w,P_w,P_r);       
%         p = [ones(nz,1)/1030. p];    // barotropic mode

    pX = 0*p;
    for nn = 1:nVel;    % nVel modes are relevant
        p(:,nn) = p(:,nn)/sign(p(1,nn));
        pnorm = p(1,nn);
        
         p(:,nn) = p(:,nn)/pnorm;
        pX(:,nn) = p(:,nn) .* dz /sum( p(:,nn).^2 .* dz );          

        % archive
         P(nn,tt,:) =  p(:,nn);
        PX(nn,tt,:) = pX(:,nn);

    end; %nn

    wX = 0*w;
    r  = 0*w;
    rX = 0*w;
    for nn = 1:nRho;    % nRho modes are relevant
         w(:,nn) = w(:,nn)/sign(w(1,nn));

         r(:,nn) = w(:,nn).*n2_r;     
        rX(:,nn) = (w(:,nn) .* dz) /sum( w(:,nn).^2 .* n2_r .* dz);   

        % archive
         W(nn,tt,:) =  w(:,nn);
        WX(nn,tt,:) = wX(:,nn);   
         R(nn,tt,:) =  r(:,nn);
        RX(nn,tt,:) = rX(:,nn);  

    end % nn

else
% % % subplot(3,1,1);plot(z_r,sq(W(1,:,:))');ylabel('wmode 1');axis([0 max(z_r) 0 1.1]);xlabel('z')
% % % subplot(3,1,2);plot(z_r,sq(W(2,:,:))');ylabel('wmode 2');axis([0 max(z_r) -1.1 1.1]);xlabel('z')
% % % subplot(3,1,3);plot(z_r,sq(W(3,:,:))');ylabel('wmode 3');axis([0 max(z_r) -1.1 1.1]);xlabel('z')
% % % subplot(3,1,1);plot(eigR_noRho0_norm(1,:));hold on;plot(eigR_noRho_norm(1,:),'r');xlabel('days');ylabel('mode 1')
% % % subplot(3,1,2);plot(eigR_noRho0_norm(2,:));hold on;plot(eigR_noRho_norm(2,:),'r');xlabel('days');ylabel('mode 2')
% % % subplot(3,1,3);plot(eigR_noRho0_norm(3,:));hold on;plot(eigR_noRho_norm(3,:),'r');xlabel('days');ylabel('mode 3')
% % % 
% % % 
% % % 
% % % 
% % % fig(4);clf;
% % % subplot(3,1,1);Wnorm(1,:,:);lim=max(ans(:));plot(z_r,sq(Wnorm(1,:,:))');ylabel('wmode 1');xlabel('z');axis([0 max(z_r) 0 lim])
% % % subplot(3,1,2);abs(Wnorm(2,:,:));lim=max(ans(:));plot(z_r,sq(Wnorm(2,:,:))');ylabel('wmode 2');xlabel('z');axis([0 max(z_r) -lim lim])
% % % subplot(3,1,3);abs(Wnorm(3,:,:));lim=max(ans(:));plot(z_r,sq(Wnorm(3,:,:))');ylabel('wmode 3');xlabel('z');axis([0 max(z_r) -lim lim])
% % % 
    'masked out'
end % if
end;% tt

% The next step is to calculate the rho eigencoefficients.
eigR0 = zeros(nRho,tt);
eigR  = zeros(nRho,tt);
eigU0 = zeros(nVel,tt);
eigU  = zeros(nVel,tt);

    tRef = 1;

for tt=1:nt; 

    n2_r = N2_r(tt,:,jj,ii)'; % n2_r(n2_r<1e-8)=1e-8;
    rho_r  =  RHO(tt,:,jj,ii)';
    u_r    =    U(tt,:,jj,ii)';
    
    for nn=1:nRho
% case 1: find the eigencoefficients from the t=0 wmodes  
        num = dot(sq(W(nn,tRef,:)) .* dz,rho_r);
        denom = sum( n2_r .* sq(W(nn,1,:)).^2 .* dz  );  
        eigR0(nn,tt) = num/denom;

% case 2: find the eigencoefficients from the updated wmodes  
        num = dot(sq(W(nn,tt,:)) .* dz,rho_r);
        denom = sum( n2_r .* sq(W(nn,tt,:)).^2 .* dz  );  
        eigR(nn,tt) = num/denom;
    end; %nn
    
    
    for nn=1:nVel
% case 1: find the eigencoefficients from the t=0 wmodes  
        eigU0(nn,tt) = dot(sq(PX(nn,1,:)),u_r);

% case 2: find the eigencoefficients from the updated wmodes 
        eigU(nn,tt) = dot(sq(PX(nn,tt,:)),u_r);
    end; %nn
    
    
    
end;

fig(1);clf;
subplot(3,1,1);plot(eigU0(1,:));hold on;plot(eigU(1,:),'r');xlabel('days');ylabel('eigU 1')
subplot(3,1,2);plot(eigU0(2,:));hold on;plot(eigU(2,:),'r');xlabel('days');ylabel('eigU 2')
subplot(3,1,3);plot(eigU0(3,:));hold on;plot(eigU(3,:),'r');xlabel('days');ylabel('eigU 3')

fig(2);clf;
subplot(3,1,1);plot(z_r,sq(P(1,:,:))');ylabel('pmode 1');axis([0 max(z_r) -1.1 1.1]);xlabel('z')
subplot(3,1,2);plot(z_r,sq(P(2,:,:))');ylabel('pmode 2');axis([0 max(z_r) -1.1 1.1]);xlabel('z')
subplot(3,1,3);plot(z_r,sq(P(3,:,:))');ylabel('pmode 3');axis([0 max(z_r) -1.1 1.1]);xlabel('z')

fig(3);clf;
subplot(3,1,1);plot(eigR0(1,:));hold on;plot(eigR(1,:),'r');xlabel('days');ylabel('eigR 1')
subplot(3,1,2);plot(eigR0(2,:));hold on;plot(eigR(2,:),'r');xlabel('days');ylabel('eigR 2')
subplot(3,1,3);plot(eigR0(3,:));hold on;plot(eigR(3,:),'r');xlabel('days');ylabel('eigR 3')

fig(4);clf;
subplot(3,1,1);plot(z_r,sq(W(1,:,:))');ylabel('wmode 1');axis([0 max(z_r) 0 1.1]);xlabel('z');title('Calculated on the fly')
subplot(3,1,2);plot(z_r,sq(W(2,:,:))');ylabel('wmode 2');axis([0 max(z_r) -1.1 1.1]);xlabel('z')
subplot(3,1,3);plot(z_r,sq(W(3,:,:))');ylabel('wmode 3');axis([0 max(z_r) -1.1 1.1]);xlabel('z')

% Conclusions:
%  1) The pmodes are generally better behaved for some reason
%  2) The more zero crossings the faster the divergence
%  3) The divergence isn't usually too bad for at least a few days

%% Here is another question:
%   Given some point (ii=30; jj=90 is good because the discrepancy between
%   the wmodes at t=0 and the wmodes at t=32 is so severe) there are 12444
%   x,y grid points in this experiment, many of which are close in depth to
%   (ii=30; jj=90) and which have somewhat different normal modes at t = 0.

myDepth=10*round(grid.h(jj,ii)/10);
binWidth = 50;

[jDepth,iDepth] = find ( abs(myDepth - grid.h) < binWidth);


P0  = zeros(nVel,length(jDepth),nz);
PX0 = P0;
W0  = P0;
WX0 = P0;
R0  = P0;
RX0 = P0;
N20 = zeros(length(jDepth),nz);

tt=1;

for mm=1:length(jDepth);
if ( grid.mask_rho(jDepth(mm),iDepth(mm)) == 1 )
    
    N20(mm,:) = N2_r(1,:,jDepth(mm),iDepth(mm));
    
    z_r = Z_r(:,jDepth(mm),iDepth(mm));
    z_w = Z_w(:,jDepth(mm),iDepth(mm));
    dz  = diff(z_w);

    P_r = sw_pres(z_r,-43);
    P_w = sw_pres(z_w,-43);
    rho_r = RHO(tt,:,jDepth(mm),iDepth(mm))';

    n2_w = N2_w(tt,:,jDepth(mm),iDepth(mm))';n2_w(n2_w<1e-8)=1e-8;
    n2_r = N2_r(tt,:,jDepth(mm),iDepth(mm))';n2_r(n2_r<1e-8)=1e-8;

    [w, p, ce, Pout]=ROMS_dynmodes_jgp(n2_w,P_w,P_r);       
%         p = [ones(nz,1)/1030. p];    // barotropic mode

    pX = 0*p;
    for nn = 1:nVel;    % nVel modes are relevant
        p(:,nn) = p(:,nn)/sign(p(1,nn));
        pnorm = p(1,nn);
        
         p(:,nn) = p(:,nn)/pnorm;
        pX(:,nn) = p(:,nn) .* dz /sum( p(:,nn).^2 .* dz );          

        % archive
         P0(nn,mm,:) =  p(:,nn);
        PX0(nn,mm,:) = pX(:,nn);

    end; %nn

    wX = 0*w;
    r  = 0*w;
    rX = 0*w;
    for nn = 1:nRho;    % nRho modes are relevant
         w(:,nn) = w(:,nn)/sign(w(1,nn));

         r(:,nn) = w(:,nn).*n2_r;     
        rX(:,nn) = (w(:,nn) .* dz) /sum( w(:,nn).^2 .* n2_r .* dz);   

        % archive
         W0(nn,mm,:) =  w(:,nn);
        WX0(nn,mm,:) = wX(:,nn);   
         R0(nn,mm,:) =  r(:,nn);
        RX0(nn,mm,:) = rX(:,nn);  

    end % nn

else
    'masked out'
end % if
end;% tt

% If you plot all the wmodes in this t = 0 set you see that they *nearly*
% span the range of wmodes at (ii=30; jj=90) for all the snapshots.
%   !!! Perhaps one of these other t=0 modes would be a better choice for
%   calculating the eigencoefficients. If so, the challenge is to figure
%   out which one to use.

fig(5);clf;
subplot(3,1,1);plot(z_r,sq(W0(1,:,:))');ylabel('wmode 1');axis([0 max(z_r) 0 1.1]);xlabel('z');title('All at t=0')
subplot(3,1,2);plot(z_r,sq(W0(2,:,:))');ylabel('wmode 2');axis([0 max(z_r) -1.1 1.1]);xlabel('z')
subplot(3,1,3);plot(z_r,sq(W0(3,:,:))');ylabel('wmode 3');axis([0 max(z_r) -1.1 1.1]);xlabel('z')

%% First of all, let's see which of the t=0 modes most resembles the
% modes as calculated on the fly.

% The target eigencoefficients at (jj,ii) for all t are
size(eigR)

% The set of wmodes at t=0 for comparable H are
size(W0)

% For reference, find the location of (jj,ii) in my list of comparable
% depths
myPoint=intersect(find(jj == jDepth),find(ii == iDepth))
% so (jj,ii) = (jDepth(myPoint),iDepth(myPoint))

% Now find out which of my W0 set gives the best eigencoefficient for each
% t.

z_w = Z_w(:,jj,ii);
dz=diff(z_w);

dum      = zeros(1,length(jDepth));
myList   = zeros(nRho,nt);
eigRbest = zeros(nRho,nt);
for tt=1:nt; for nn=1:nRho
    for mm=1:length(jDepth)
        num = dot(sq(W0(nn,mm,:)) .* dz,RHO(tt,:,jj,ii)');
        denom = sum( N2_r(tt,:,jj,ii)' .* (sq(W0(nn,mm,:)).^2) .* dz  );  
        dum(mm) = num/denom;
    end; %mm
    myList(nn,tt)=find(min(abs(dum-eigR(nn,tt)))  ==  abs(dum-eigR(nn,tt)));
    eigRbest(nn,tt)=dum(myList(nn,tt));
end;end;%nn,tt 

% How does this list of eigencoefficients perform?

fig(33);clf;suptitle('Each mode gets to choose')
subplot(3,2,1);plot(eigR0(1,:));hold on;plot(eigR(1,:),'r');xlabel('days');ylabel('eigR 1');
subplot(3,2,2);plot(eigRbest(1,:));hold on;plot(eigR(1,:),'r');xlabel('days');ylabel('eigR 1')
subplot(3,2,3);plot(eigR0(2,:));hold on;plot(eigR(2,:),'r');xlabel('days');ylabel('eigR 2')
subplot(3,2,4);plot(eigRbest(2,:));hold on;plot(eigR(2,:),'r');xlabel('days');ylabel('eigR 2')
subplot(3,2,5);plot(eigR0(3,:));hold on;plot(eigR(3,:),'r');xlabel('days');ylabel('eigR 3')
subplot(3,2,6);plot(eigRbest(3,:));hold on;plot(eigR(3,:),'r');xlabel('days');ylabel('eigR 3')


% This is a huge improvement, but the "best choice" for mode 1 at some time
% t>0 is not the same as the choices for modes 2 and 3.

fig(99);clf;plot(myList')

% What if I go with the first mode's pick?
dumMode=1;
eigRbest1 = zeros(nRho,nt);
for tt=1:nt; for nn=1:nRho
        num = dot(sq(W0(nn,myList(dumMode,tt),:)) .* dz,RHO(tt,:,jj,ii)');
        denom = sum( N2_r(tt,:,jj,ii)' .* (sq(W0(nn,myList(dumMode,tt),:)).^2) .* dz  );  
    eigRbest1(nn,tt)=num/denom;
end;end;%nn,tt   
fig(34);clf;suptitle('First mode gets to choose')
subplot(3,2,1);plot(eigR0(1,:));hold on;plot(eigR(1,:),'r');xlabel('days');ylabel('eigR 1');
subplot(3,2,2);plot(eigRbest1(1,:));hold on;plot(eigR(1,:),'r');xlabel('days');ylabel('eigR 1')
subplot(3,2,3);plot(eigR0(2,:));hold on;plot(eigR(2,:),'r');xlabel('days');ylabel('eigR 2')
subplot(3,2,4);plot(eigRbest1(2,:));hold on;plot(eigR(2,:),'r');xlabel('days');ylabel('eigR 2')
subplot(3,2,5);plot(eigR0(3,:));hold on;plot(eigR(3,:),'r');xlabel('days');ylabel('eigR 3')
subplot(3,2,6);plot(eigRbest1(3,:));hold on;plot(eigR(3,:),'r');xlabel('days');ylabel('eigR 3')

% What if I go with the second mode's pick?
dumMode=2;
eigRbest2 = zeros(nRho,nt);
for tt=1:nt; for nn=1:nRho
        num = dot(sq(W0(nn,myList(dumMode,tt),:)) .* dz,RHO(tt,:,jj,ii)');
        denom = sum( N2_r(tt,:,jj,ii)' .* (sq(W0(nn,myList(dumMode,tt),:)).^2) .* dz  );  
    eigRbest2(nn,tt)=num/denom;
end;end;%nn,tt   
fig(35);clf;suptitle('Second mode gets to choose')
subplot(3,2,1);plot(eigR0(1,:));hold on;plot(eigR(1,:),'r');xlabel('days');ylabel('eigR 1');
subplot(3,2,2);plot(eigRbest2(1,:));hold on;plot(eigR(1,:),'r');xlabel('days');ylabel('eigR 1')
subplot(3,2,3);plot(eigR0(2,:));hold on;plot(eigR(2,:),'r');xlabel('days');ylabel('eigR 2')
subplot(3,2,4);plot(eigRbest2(2,:));hold on;plot(eigR(2,:),'r');xlabel('days');ylabel('eigR 2')
subplot(3,2,5);plot(eigR0(3,:));hold on;plot(eigR(3,:),'r');xlabel('days');ylabel('eigR 3')
subplot(3,2,6);plot(eigRbest2(3,:));hold on;plot(eigR(3,:),'r');xlabel('days');ylabel('eigR 3')


% What if I go with the third mode's pick?
dumMode=3;
eigRbest3 = zeros(nRho,nt);
for tt=1:nt; for nn=1:nRho
        num = dot(sq(W0(nn,myList(dumMode,tt),:)) .* dz,RHO(tt,:,jj,ii)');
        denom = sum( N2_r(tt,:,jj,ii)' .* (sq(W0(nn,myList(dumMode,tt),:)).^2) .* dz  );  
    eigRbest3(nn,tt)=num/denom;
end;end;%nn,tt   
fig(36);clf;suptitle('Third mode gets to choose')
subplot(3,2,1);plot(eigR0(1,:));hold on;plot(eigR(1,:),'r');xlabel('days');ylabel('eigR 1');
subplot(3,2,2);plot(eigRbest3(1,:));hold on;plot(eigR(1,:),'r');xlabel('days');ylabel('eigR 1')
subplot(3,2,3);plot(eigR0(2,:));hold on;plot(eigR(2,:),'r');xlabel('days');ylabel('eigR 2')
subplot(3,2,4);plot(eigRbest3(2,:));hold on;plot(eigR(2,:),'r');xlabel('days');ylabel('eigR 2')
subplot(3,2,5);plot(eigR0(3,:));hold on;plot(eigR(3,:),'r');xlabel('days');ylabel('eigR 3')
subplot(3,2,6);plot(eigRbest3(3,:));hold on;plot(eigR(3,:),'r');xlabel('days');ylabel('eigR 3')


% I don't actually think the "best choice" is necessarily found this way.
% For example: the 20th snapshot and mode 1
myList(1,20)

fig(98);clf;plot(sq(N2_r(tt,:,jj,ii)),'Linewidth',3);hold on;plot(N20(:,:)')
fig(99);clf;plot(N2_r(tt,:,jj,ii),'r');hold on;plot(N20(18,:),'g')




%% OK, it's very clear now that the best pick for some t is going to depend
% on which mode is at state. i.e. each mode gets its own criterion. It
% seems like the obvious way to fold the mode into the batter is to take
% the dot product of the mode and N2(t). I suggest this because the modes
% get more zero crossings as the mode number increases, which has got to
% have a big effect on the dot product.

% So, given some time and location with a buoyancy N2_r(tt,jj,ii)
tt=20;

% and given that at tt=1 my suite of equi-depth sites all have some
%       dot(mode,N2)

dotModeN2 = zeros(nRho,length(jDepth) );
for mm=1:length(jDepth); for nn=1:nRho
    dotModeN2(nn,mm) = dot( sq(N20(mm,:)),sq(W0(nn,mm,:)) );
end;end;

% Which location best matches 

myDotModeN2 = dot( sq(N2_r(tt,:,jj,ii)) , sq(W(nn,tt,:)) );
find(min(abs(myDotModeN2-dotModeN2(1,:)))  ==  abs(myDotModeN2-dotModeN2(1,:)))

fig(98);clf;plot(sq(N2_r(tt,:,jj,ii)),'Linewidth',3);hold on;plot(N20(:,:)')
fig(99);clf;plot(N2_r(tt,:,jj,ii),'r');hold on;plot(N20(24,:),'b');plot(N20(18,:),'g')

aaa=5;


%%
% % % 
% % % tt=5;
% % % 
% % % diffs = zeros(length(jDepth),1);
% % % for mm=1:length(jDepth)
% % %     sq(W(1,tt,:))-sq(W0(1,mm,:));
% % %     diffs(mm)=dot(ans,ans);
% % % end; %mm
% % % % fig(10);clf;plot(diffs)
% % % 
% % % % My test point (ii=30; jj=90) is the 5th point in my t=0 set, but the
% % % % sixth point is a much better match for the t=32 wmode_1.
% % % % [jDepth(5) iDepth(5)]
% % % myMin = find(diffs == min(diffs))
% % % 
% % % fig(11);clf;plot(sq(W0(1,:,:))');hold on;plot(sq(W(1,1,:)),'LineWidth',3);plot(sq(W(1,end,:)),'r','LineWidth',3);title('w1 at t=0 and t=32 vs wmodes at t=0 at comparable depths')
% % % fig(12);clf;plot(sq(W(1,:,:))');hold on;plot(sq(W(1,1,:)),'LineWidth',3);plot(sq(W(1,end,:)),'r','LineWidth',3);title(['Evolution of w1 at jj=' num2str(jj) ',ii=' num2str(ii)])
% % % 
% % % fig(13);clf;plot(sq(W(1,tt,:)));hold on;plot(sq(W(1,1,:)),'r');plot(sq(W0(1,myMin,:)),'g')
% % % 
% % % num = dot(sq(W0(1,myMin,:)) .* dz,RHO(tt,:,jj,ii)');
% % % denom = sum( N2_r(tt,:,jj,ii)' .* (sq(W0(1,myMin,:)).^2) .* dz  );  
% % % myEig = num/denom
% % % 
% % % % num = dot(sq(W(1,end,:)) .* dz,RHO(tt,:,jj,ii)');
% % % % denom = sum( N2_r(end,:,jj,ii)' .* (sq(W(1,end,:)).^2) .* dz  );  
% % % % myEig = num/denom
% % % 
% % % % num = dot(sq(W(1,end,:)) .* dz,RHO(tt,:,jj,ii)');
% % % % denom = sum( N2_r(end,:,jj,ii)' .* (sq(W(1,end,:)).^2) .* dz  );  
% % % % myEig = num/denom
% % % 
% % % eigR(1,tt)
% % % eigR0(1,tt)
% % % 
% % % %% So is there a way to identify the 6th point as "best" without having to
% % % % calculate the t=32 wmodes? I need to pick something internal to ROMS, the
% % % % best candidate being N2.
% % % 
% % % % Specifically, given this ammo
% % % %   locations (jDepth(i), iDepth(i) with depth comparable to H(jj,ii)
% % % %   N20     the buoyancy at these places at t=0
% % % %   W0      the wmodes at these places at t=0
% % % % can I, using the current N2_r (for instance) at (jj,ii) and t>0, pick the
% % % % element of W0 that is closest to the actually wmodes for (jj,ii) and t>0?
% % % 
% % % tt=5;
% % % 
% % % myN2  = sq(N2_r(tt,:,jj,ii))';
% % % myz_r = Z_r(:,jj,ii);
% % % myz_w = Z_w(:,jj,ii);
% % % mydz  = diff(myz_w);
% % % 
% % % fig(99);plot(N20(:,1:end)');hold on;plot(myN2,'LineWidth',3)
% % % 
% % % 
% % % % Try area under curve, weighted by dz
% % % myAreaUnder = dot(myN2,mydz);
% % % areaUnder = zeros(length(jDepth),1);
% % % for mm=1:length(jDepth)
% % %     areaUnder(mm)=dot(N20(mm,:),dz);
% % % end; %mm
% % % min(abs(myAreaUnder-areaUnder) );find(ans== abs(myAreaUnder-areaUnder) );
% % % 
% % % % Try area under curve, unweighted by dz
% % % myAreaUnder = sum(myN2);
% % % areaUnder = zeros(length(jDepth),1);
% % % for mm=1:length(jDepth)
% % %     areaUnder(mm)=sum(N20(mm,:));
% % % end; %mm
% % % min(abs(myAreaUnder-areaUnder) );bestPick=find(ans== abs(myAreaUnder-areaUnder) );
% % % 
% % % % OK, replot the eigencoefficient as a function of time but add in a line
% % % % which is calculated in this new way.
% % % 
% % % eigRnew = 0*eigR;
% % % 
% % % for tt=1:nt
% % %     myAreaUnder  = sum(sq(N2_r(tt,:,jj,ii)) );
% % %     for mm=1:length(jDepth)
% % %         areaUnder(mm)=sum(N2_r(1,:,jDepth(mm),iDepth(mm)));
% % %     end;%mm
% % %     min(abs(myAreaUnder-areaUnder) );
% % %     bestPick=find(ans == abs(myAreaUnder-areaUnder) );
% % %     num = dot(sq(W0(1,bestPick,:)) .* dz,RHO(tt,:,jj,ii)');
% % %     denom = sum( N2_r(tt,:,jj,ii)' .* (sq(W0(1,bestPick,:)).^2) .* dz  );  
% % %     eigRnew(1,tt) = num/denom;
% % %     
% % % end;%tt
% % % 
% % % 
% % % fig(20);clf;
% % % subplot(3,2,1);plot(eigR0(1,:));hold on;plot(eigR(1,:),'r');xlabel('days');ylabel('eigR 1')
% % % subplot(3,2,2);plot(eigRnew(1,:));hold on;plot(eigR(1,:),'r');xlabel('days');ylabel('eigR 2');ylim(10^6*[2 4])
% % % subplot(3,2,3);plot(eigR0(2,:));hold on;plot(eigR(2,:),'r');xlabel('days');ylabel('eigR 2')
% % % subplot(3,2,5);plot(eigR0(3,:));hold on;plot(eigR(3,:),'r');xlabel('days');ylabel('eigR 3')
% % % 
