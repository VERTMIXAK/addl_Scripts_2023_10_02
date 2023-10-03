clear
load MODEL
load ROMSgrid
[Ny Nx Nz Nmodes]=size(MODEL.psip);

%% full list

[row,col,val] = find(ROMSgrid.h>4000 & ROMSgrid.h<4050);
dum=zeros(length(row),3);
dum(:,1)=row;
dum(:,2)=col;
for ii=1:length(row)
    dum(ii,3)=ROMSgrid.h(row(ii),col(ii));
end
% disp(dum)


%% OK, here is the task:
%       How far apart can a pair of depths be before the average of their
%       pmodes quits working well for the depth at the halfway point?

limitMid=3000;deltaDepth=.05*limitMid;
% deltaDepth=2000;

limitLow=limitMid-deltaDepth;limitHigh=limitMid+deltaDepth;

dum=abs(ROMSgrid.h-limitLow);
[minVal,index] = min(dum(:));
[rowLow,colLow]=ind2sub(size(dum),index);
ROMSgrid.h(rowLow,colLow);

dum=abs(ROMSgrid.h-limitHigh);
[minVal,index] = min(dum(:));
[rowHigh,colHigh]=ind2sub(size(dum),index);
ROMSgrid.h(rowHigh,colHigh);

dum=abs(ROMSgrid.h-limitMid);
[minVal,index] = min(dum(:));
[rowMid,colMid]=ind2sub(size(dum),index);
ROMSgrid.h(rowMid,colMid);


fig(1);clf;plot([1:50] *ROMSgrid.h(rowHigh,colHigh)/50,squeeze(MODEL.vXfm(rowHigh,colHigh,:,10)),'r');hold on;
plot([1:50] *ROMSgrid.h(rowLow,colLow)/50,squeeze(MODEL.vXfm(rowLow,colLow,:,10)),'b')
fig(2);clf;plot([.01:.02:.99],squeeze(MODEL.vXfm(rowHigh,colHigh,:,10)),'r');hold on;
plot([.01:.02:.99],squeeze(MODEL.vXfm(rowLow,colLow,:,10)),'b')

% fig(1);clf;plot(squeeze(MODEL.vXfm(rowLow,colLow,:,10)),'b');hold on;plot(squeeze(MODEL.vXfm(rowHigh,colHigh,:,10)),'r')


% fig(11);clf;plot([1:50],squeeze(MODEL.vXfm(rowLow,colLow,:,10)),'*');hold on;plot([1:50],squeeze(MODEL.vXfm(rowHigh,colHigh,:,10)),'+')
% fig(11);clf;plot([1:50],squeeze(MODEL.vXfm(rowLow,colLow,:,10)),'.');hold on;plot([1:50],squeeze(MODEL.vXfm(rowHigh,colHigh,:,10)),'.')
% fig(3);clf;plot(squeeze(MODEL.psip(rowLow,colLow,:,1)),'b');hold on;plot(squeeze(MODEL.psip(rowHigh,colHigh,:,1)),'r')
% fig(2);clf;plot(squeeze(MODEL.rhoXfm(rowLow,colLow,:,1)),'b');hold on;plot(squeeze(MODEL.rhoXfm(rowHigh,colHigh,:,1)),'r')

aveJGP  = squeeze( (MODEL.vXfm(rowLow,colLow,:,:)+MODEL.vXfm(rowHigh,colHigh,:,:) )/2 );
diffJGP = aveJGP - squeeze(MODEL.vXfm(rowMid,colMid,:,:) );

% fig(1);clf;plot(squeeze(MODEL.vXfm(rowLow,colLow,:,10)),'b');hold on;plot(squeeze(MODEL.vXfm(rowHigh,colHigh,:,10)),'r');hold on;plot(squeeze(MODEL.vXfm(rowMid,colMid,:,10)),'g')

myMode=6;
% fig(2);clf;plot(squeeze(MODEL.vXfm(rowMid,colMid,:,myMode)),'b');hold on;plot(squeeze(aveJGP(:,myMode)),'r')

% Plotting is all well and good, but what really matters is the spectral
% coefficients extracted from some velocity profile

% create a data vector
pmodes=squeeze(MODEL.psip(rowMid,colMid,:,:));
uHat=2*rand(1,Nmodes)-1;
sprintf('original velocity spectral coefficients');
uHat(1:min(Nmodes,length(uHat)));
dataVec=0*pmodes(:,1);
for ndat=1:length(uHat)%np
    dataVec=dataVec+uHat(ndat)/MODEL.g * pmodes(:,ndat)./ squeeze(MODEL.rho0jgp(rowMid,colMid,:));
end;
uSynthetic=dataVec';

% Find the spectral coefficients the direct way
specvXfm=(squeeze(MODEL.vXfm(rowMid,colMid,:,:))'*dataVec)';
sprintf('recover coefficients using dot product method');
specvXfm(1:Nmodes);

% Now find the spectral coefficients the direct way taking the average of
% the High and Low vXfm
avevXfm=(squeeze(aveJGP)'*dataVec)';
sprintf('recover coefficients using dot product method, and averaged transform vector');
avevXfm(1:Nmodes);

sprintf('           orig coeffs                  Mid                    (Low+High)/2')
[uHat' specvXfm' avevXfm']


%% I would say that the results are perfectly OK if the spacing is about 1% of the depth

% Try to come up with a mathematical function that describes a set of fixed
% H values I can choose as locations for spectral transform vectors to be
% used as input to ROMS. When I did this for MITgcm I used 200 values for H
% (every 50 m) with Nz=100. Something of the sort should be reasonable for
% ROMS.

hMin=20;hMax=6000;
a=1.01;                                     % this is the relative spacing
n=ceil(log(1-(hMax/hMin) *(1-a))/log(a) )     % here is the number of terms in the series

hVec=[hMin];
for ii=1:n-1
    hVec=[hVec hVec(end)*a];
end
sum(hVec)
