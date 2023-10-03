function MODEL=MITGCM_calc_modes(MODEL,OB,nmodes)

%% Get a representative ROMS output file (must be 3D).

% Get the grid.

nameTemp=dir('../netcdf_All/*_his_*');
fileList={ nameTemp.name};subGrid.fileList=fileList;


tmp = strcat('../netcdf_All/',fileList(end));
sampleHISfile = tmp{1};subGrid.sampleHISfile=sampleHISfile;
[~,gridFile]=unix('ls .. |grep ".nc"');gridFile=strcat('../',gridFile);subGrid.gridFile=gridFile;

ROMSgrid=roms_get_grid(gridFile,sampleHISfile,0,1);
save ROMSgrid ROMSgrid

% Now get zeta and u
zeta = nc_varget(sampleHISfile,'zeta');
u = nc_varget(sampleHISfile,'u');



%% Construct the basis functions.


% The way I'm going to set this up is
%   1) There will be a depth, H, which I can change as long as H <= MODEL.Hmax
%   2) I have N2(z) for all z <= MODEL.Hmax, i.e.
%       MODEL.N2 and MODEL.Z correspond
%   3) Assume that H is on a cell face. This means I
%       a) choose nInterval = *something* (this is the number of full cells)
%       b) each cell gets 2 grid points (center and bottom), plus one for z=0
%       c) interpolate 2*nInterval+1 z values from 0 to H
%       d) interpolate the corresponding values for N2
%   4) Find the pmodes and wmodes


% fig(1);clf;plot(MODEL.Z,MODEL.N2);title('N2 from stratification section')

%% The data file gives the vertical grid

sigma=sort([ROMSgrid.s_w ROMSgrid.s_rho])';
CofSigma=sort([ROMSgrid.Cs_w ROMSgrid.Cs_r])';  

sigma_r=sort(ROMSgrid.s_rho)';
CofSigma_r=sort(ROMSgrid.Cs_r)';

% fig(2);clf;plot(sigma,CofSigma);title('C(sigma) vs sigma')



% nInterval=50;
% npoints=2*nInterval;


% myMinH = 1000;

% H_vals = myMinH:1000:MODEL.H_max;
% MODEL.H_vals=H_vals;

%% %%%%%%%%%%%%%%  SIZE THESE ARRAYS !!!!!!!!!!!!!!

% size the data arrays as follows
%   data(Ny, Nx, number of points in a an oversampled vertical grid, nmodes)

[Nz Ny Nx]=size(u);

psiw   =  zeros([ Ny Nx  length(sigma_r)  nmodes ]);
psip   =  psiw;
vXfm   =  psiw;
DXfm   =  psiw;
rhoXfm =  psiw;
rhoMat =  zeros([ Ny Nx  length(sigma_r)   ]);
uSpec  =  zeros([ Ny Nx  nmodes            ]);
keSpec =  zeros([ Ny Nx  nmodes            ]);


%%

% % % % for H = 100:100:MODEL.H_max
% % % % for H = MODEL.H_max/10:MODEL.H_max/10% % % % if nInterval < 10
% % % %     (pmodes ./ repmat(MODEL.rho0ofZ(1:np)',[1,np]) ) / MODEL.g;  vXfmShort=inv(ans');
% % % % end;
% % % % if nInterval < 12
% % % %     DXfmShort=inv(wmodes');
% % % %     repmat(MODEL.N2(1:nw),[1,nw]) .* wmodes;  rhoXfmShort=inv(ans');
% % % % end;

% % % for Hindex = 1:length(H_vals)
% % %     H = H_vals(Hindex);
    
% ii=50;jj=50;
% for ii = 50:50; 
%     for jj = 50:50
for ii = 1:Nx; 
    for jj = 1:Ny
        ii

    % find a new z vector, then N2 and rho on this grid
    
    depth=ROMSgrid.h(jj,ii);
    S = (ROMSgrid.Tcline*sigma + depth*CofSigma)/(ROMSgrid.Tcline + depth)';
    z=depth*S;z=sort(-z);
    
    z_r=z(2:2:end);
    z_w=z(1:2:end);
    delz_w=diff(z_w);
    
%     fig(3);clf;plot(sigma,z);title('z(sigma) vs sigma')
    nz= length(z);
    
    N2= interp1(MODEL.Z,MODEL.N2,z);
    N2_r=N2(2:2:end);
%     N2(1) = N2(2);
%     N2(nz)= N2(nz-1);
    %N2 = 0*N2 +  4*10^-6;                   % make N2 constant
    
    %JGP reconstruct the density from N2, realizing this is a bit half-assed
    rho0=OB.rho0;
    for iii=1:nz-1
        drho0=rho0(iii)*N2(iii)/9.81*(z(iii+1)-z(iii) );
        rho0(iii+1)=rho0(iii)+drho0;
    end;
    
    rho0_r=rho0(2:2:end)';
    rhoMat(jj,ii,:)=rho0_r;
% % % %     N2(1:nz-1) - diff(rho0) ./ diff(z)  ./rho0(1:end-1) *9.8;MODEL.rho0ofZ
%     MODEL.rho0ofZ=rho0(2:2:end);
    
aaa=5;    

% !!!!!! NOTE: the modes are on the cell-center grid only !!
[wmodes,pmodes,ke] = dynmodes_hls(N2,z, OB );

% scale the pmodes
pmodes = pmodes * MODEL.g * MODEL.rho0;

nw=length(wmodes);
np=length(pmodes);


% populate data matrices
psiw (jj,ii,:,:) = wmodes(:,1:nmodes);
psip (jj,ii,:,:) = pmodes(:,2:nmodes+1);
keMat(jj,ii,:)   = ke(1:nmodes);
% % % psiw(1:nw,1:min(nw,nmodes),npoints)=wmodes(1:nw,1:min(nw,nmodes));
% % % psip(1:np,1:min(np-1,nmodes),npoints)=pmodes(1:np,1+1:min(np,nmodes+1));
% % % keMat(1:min(nw,nmodes),npoints)=ke(1:min(nw,nmodes));



% Find the various transforms
pDenom=0*(1:np);
wDenom=0*(1:nw);
vXfmShort  =0*pmodes;
DXfmShort  =0*wmodes;
rhoXfmShort=0*wmodes;

% calculate the denominator for the transforms involving p modes
pDenom=0*pDenom;
for nn=1:np;
    for pp=1:np
% % % % %         pDenom(nn)=pDenom(nn) + pmodes(pp,nn)^2 * MODEL.delZ(pp) /MODEL.rho0ofZ(pp);
        pDenom(nn)=pDenom(nn) + pmodes(pp,nn)^2 * delz_w(pp) / rho0_r(pp);
    end;end;

% finish calculating the velocity transform
for nn=1:np;
    for pp=1:np
% % % %         vXfmShort(pp,nn)=pmodes(pp,nn) * MODEL.delZ(pp) / pDenom(nn) * MODEL.g;
        vXfmShort(pp,nn)=pmodes(pp,nn) * delz_w(pp) / pDenom(nn) * MODEL.g;
    end;end;

% calculate the denominator for the transforms involving w modes
wDenom=0*wDenom;
for nn=1:nw; for pp=1:np
% % % %         wDenom(nn)=wDenom(nn) + wmodes(pp,nn)^2 * MODEL.delZ(pp) * MODEL.rho0ofZ(pp) * MODEL.N2(pp);
        wDenom(nn)=wDenom(nn) + wmodes(pp,nn)^2 * delz_w(pp) * rho0_r(pp) * N2_r(pp);
    end;end;

% finish calculating the displacement and density transform
for nn=1:nw; for pp=1:np
% % % %         DXfmShort(pp,nn)  =wmodes(pp,nn) * MODEL.rho0ofZ(pp) * MODEL.N2(pp) * MODEL.delZ(pp) / wDenom(nn) ;
% % % %         rhoXfmShort(pp,nn)=wmodes(pp,nn) * MODEL.rho0ofZ(pp)                * MODEL.delZ(pp) / wDenom(nn);
        DXfmShort(pp,nn)  =wmodes(pp,nn) * rho0_r(pp) * N2_r(pp) * delz_w(pp) / wDenom(nn) ;
        rhoXfmShort(pp,nn)=wmodes(pp,nn) * rho0_r(pp)            * delz_w(pp) / wDenom(nn);
    end;end;

% % % % % 	% Taking the inverse works better for small nInterval
% % % % if nInterval < 10
% % % %     (pmodes ./ repmat(MODEL.rho0ofZ(1:np)',[1,np]) ) / MODEL.g;  vXfmShort=inv(ans');
% % % % end;
% % % % if nInterval < 12
% % % %     DXfmShort=inv(wmodes');
% % % %     repmat(MODEL.N2(1:nw),[1,nw]) .* wmodes;  rhoXfmShort=inv(ans');
% % % % end;

% % % % if max(rhoXfmShort(:)) > 50000
% % % %     keyboard
% % % % end;

% % % % vXfm  (1:np,1:min(np-1,nmodes),npoints)=  vXfmShort(1:np,1+1:min(np,nmodes+1));
% % % % DXfm  (1:nw,1:min(np,nmodes),npoints)=  DXfmShort(1:nw,1:min(nw,nmodes));
% % % % rhoXfm(1:nw,1:min(np,nmodes),npoints)=rhoXfmShort(1:nw,1:min(nw,nmodes));
vXfm  (jj,ii,:,:) =   vXfmShort(:, 1+1:nmodes+1);
DXfm  (jj,ii,:,:) =   DXfmShort(:,   1:nmodes);
rhoXfm(jj,ii,:,:) = rhoXfmShort(:,   1:nmodes);


vXfmShort'*u(:,jj,ii);uSpec(jj,ii,:)=ans(1:nmodes);


% %%         velocity DIAGNOSTIC
% 
%         % create a data vector
%         uHat=2*rand(1,min(nmodes,np))-1;
%         sprintf('original velocity spectral coefficients')
%         uHat(1:min(nmodes,length(uHat)))
%         dataVec=0*pmodes(:,1);
%         for ndat=1:length(uHat)%np
%              dataVec=dataVec+uHat(ndat)/MODEL.g * pmodes(:,ndat)./rho0_r(1:np);
%         end;
%         uSynthetic=dataVec';
% 
%         % Find the spectral coefficients the direct way
%         specvXfm=(vXfmShort'*dataVec)';
%         sprintf('recover coefficients using dot product method')
%         specvXfm(1:min(np,nmodes))%np);
% 
%         % Linear regression does a fine job of recovering the coefficients
%         sprintf('recover coefficients using linear regression')
%         specLR=(pmodes(:,1:min(np,nmodes))\dataVec)';
%         specLR(1:min(np,nmodes))%np)
% 
%         %end diagnostic


%%         Displacement DIAGNOSTIC
%
%         % create a data vector
%
%         dataCoeff=2*rand(1,min(nmodes,np))-1;
%         sprintf('original Displacement spectral coefficients')
%         dataCoeff(1:min(nmodes,length(dataCoeff)))
%         dataVec=0*wmodes(:,1);
%         for ndat=1:length(dataCoeff)%np
%              dataVec=dataVec+dataCoeff(ndat)*wmodes(:,ndat);
%         end;
%         uSynthetic=dataVec';
%
%         % Find the spectral coefficients the direct way
%         specDXfm=(DXfmShort'*dataVec)';
%         sprintf('recover coefficients using dot product method')
%         specDXfm(1:min(np,nmodes))%np)
%
% %         % Linear regression does a fine job of recovering the coefficients
% %         sprintf('recover coefficients using linear regression')
% %         specLR=(wmodes(:,1:min(np,nmodes))\dataVec)';
% %         specLR(1:min(np,nmodes))%np)
%
%         % end diagnostic


%%         Density anomaly DIAGNOSTIC
%
%         % create a data vector
%         dataCoeff=2*rand(1,min(nmodes,nw))-1;
%         sprintf('original density anomaly spectral coefficients')
%         dataCoeff(1:min(nmodes,length(dataCoeff)))
%         dataVec=0*wmodes(:,1);
%         for ndat=1:length(dataCoeff)%np
%              dataVec=dataVec+dataCoeff(ndat)*wmodes(:,ndat).*MODEL.N2(1:nw);
%         end;
%         rhoSynthetic=dataVec';
%
%         % Find the spectral coefficients the direct way
%         specrhoXfm=(rhoXfmShort'*dataVec)';
%         sprintf('recover coefficients using dot product method')
%         specrhoXfm(1:min(nw,nmodes))%np);
%
% %         % Linear regression does a fine job of recovering the coefficients
% %         sprintf('recover coefficients using linear regression')
% %         specLR=(wmodes(:,1:min(nw,nmodes))\dataVec)';
% %         specLR(1:min(nw,nmodes))%np)
%
%         % end dianostic

aaa=4;

%% finish up


% % % %  end;

%% Tidy up
MODEL.psiw=psiw;
MODEL.psip=psip;
MODEL.vXfm=vXfm;
MODEL.DXfm=DXfm;
MODEL.rhoXfm=rhoXfm;
MODEL.ke=keMat;
MODEL.rho0jgp=rhoMat;
MODEL.uSpec=uSpec;

aaa=23;         % a stopping place for the debuggerer

end;end;

