function [PHI PHI2 C]=MITGCM_MODES(dz,N2,f,omega)
% USAGE: [PHI PHI2 C]=MITGCM_MODES(dz,N2,f,omega)
% Obtain vertical modes for arbitrary stratification
%
% INPUTS:
% dz  [1 x 1]   vertical spacing 
% N2  [Nz x 1]  stratification 
% f   [1 x 1]  inertial frequency
%
% OUTPUTS:
% PHI  [Nz x Nz]  orthonormal pressure and velocity structure eigenfunctions 
% PHI2 [Nz x Nz]  orthonormal buoyancy structure eigenfunctions 
% C    [Nz x 1]   group speeds (eigenvalues)
%-----------------------------------------------------------
% from Sam Kelly June 6 2012, slightly modified by HLS to make omega an
% input argument


if nargin<3
    f=9.9834e-05;
end

%omega=2*pi/(12.4*3600);
g=9.81;
N=length(N2);
H=dz*N;

% Second derivative matrix
D2=zeros(N-1,N-1);
for i=2:N-2
    D2(i,i-1)=1/dz^2;
    D2(i,i)=-2/dz^2;
    D2(i,i+1)=1/dz^2;
end
% Rigid lid
D2(1,1)=-2/dz^2; 
D2(1,2)=1/dz^2;
% Flat bottom
D2(N-1,N-1)=-2/dz^2;
D2(N-1,N-2)=1/dz^2;

% "A" Matrix
A=diag(-N2(1:N-1)/(omega^2-f^2));% Hydrostatic
%A=diag(-(N2(1:N-1)-omega^2)/(omega^2-f^2));% Non Hydrostatic

% Solve generalized eigenvalue problem
[PHI k2]=eig(D2,A);

% Sort modes by group speed
k2=diag(k2);
k2(k2<0)=Inf;
C=(1-f^2/omega^2)*omega./sqrt(k2); % group speed
C(C>1000)=0; % Remove modes with c faster 1000 m/s
[C,ind]=sort(C,1,'descend');
PHI=PHI(:,ind);

% Add in boundary values
PHI=[zeros([1 N-1]); PHI; zeros([1 N-1])]; 

% Average between points to get W structure
PHI2=(PHI(1:end-1,:)+PHI(2:end,:))/2;
 
% Take derivative to get U and P structure
PHI=-diff(PHI,1)./dz;

% Add in zeroth mode
C=[sqrt(g*H); C]; 
PHI=[ones([N 1]) PHI]; 
PHI2=[zeros([N 1]) PHI2];

% Normalize 
A=repmat(nansum(PHI.^2.*dz,1)./H,[N 1]).^(1/2);
A(A==0)=Inf;
PHI=PHI./A;
PHI(:,PHI(N,:)<0)=-PHI(:,PHI(N,:)<0);

A=repmat(nansum(PHI2.^2.*repmat(N2,[1 N])*dz,1)./H,[N 1]).^(1/2);
A(A==0)=Inf;
PHI2=PHI2./A;
PHI2(:,PHI2(N,:)<0)=-PHI2(:,PHI2(N,:)<0);

return



