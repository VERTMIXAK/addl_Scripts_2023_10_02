function MODEL=MITGCM_IJPR(MODEL,tdxs)
files=MODEL.files;
time=nc_varget(files.u,'T');
%%
%tdx=length(time)
IJPRu=nan*ones(length(tdxs),length(MODEL.YC(:,1)),length(MODEL.XC(1,:)));
IJPRv=nan*ones(length(tdxs),length(MODEL.YC(:,1)),length(MODEL.XC(1,:)));
sz=[length(MODEL.RC) size(MODEL.H)];

% set up ocean/earth mask
mask = ones(sz);
for ii = 1:sz(3);for jj = 1:sz(2)
    mask(find(-MODEL.RC>MODEL.H(jj,ii)),jj,ii)=nan;
end;end

if sz ~= size(mask);mask = mask(:,1:end-1,1:end-1); end
                              % not sure why I have to slice off northern and eastern cells weirdly u and v have the same dimension as rho already
                              % when I shift u and v to rho pts, Ihave to
                              % do this to get everything to have the same
                              % dimension
if sz ~= size(MODEL.DZ);DZ = MODEL.DZ(:,1:end-1,1:end-1);else;DZ=MODEL.DZ;end
for tdx = tdxs;disp([num2str(tdx),' of ',num2str(length(tdxs))])
%keyboard 
%%
rhop = nc_varget(files.rhop,'RHOAnoma',[tdx-1,0,0,0],[1,-1,-1,-1]);
u    = nc_varget(files.u   ,'UVEL'    ,[tdx-1,0,0,0],[1,-1,-1,-1]);u(u==0)=nan; % possibly dangerous approach to masking
v    = nc_varget(files.v   ,'VVEL'    ,[tdx-1,0,0,0],[1,-1,-1,-1]);v(v==0)=nan; % possibly dangerous approach to masking
u    = (u(:,:,1:end-1)+u(:,:,2:end))/2; % Am I on the rho pts here? 
v    = (v(:,1:end-1,:)+v(:,2:end,:))/2; % Am I on the rho pts here?
if sz ~= size(rhop); rhop = rhop(:,1:end-1,1:end-1);end% this seems odd but to have the same number of gridpoints for rho,u,v need to shaved ends of u and v
if sz ~= size(u)   ; u    = u   (:,1:end-1,:      );end 
if sz ~= size(v)   ; v    = v   (:,:      ,1:end-1);end
%
% improvements to be made:
% put everything to the appropriate C-grid location: 
% make sure I really have the non-ocean points identified properly. 

% --------------------------------------------------
% mask out non-ocean points (in the sea-bed)
%--------------------------------------------------
rhop=rhop.*mask;
% -------------------------------------------------
%keyboard
ubt = squeeze(nansum(u.*DZ)./sum(DZ)); uBT = (permute(repmat(ubt,[1,1,sz(1)]),[3,1,2]));uPR=u-uBT;
vbt = squeeze(nansum(v.*DZ)./sum(DZ)); vBT = (permute(repmat(vbt,[1,1,sz(1)]),[3,1,2]));vPR=v-vBT;
p_anom = 9.8*cumsum(rhop.*DZ);
pbt = squeeze(nansum(p_anom.*DZ)./sum(DZ)); pBT = (permute(repmat(pbt,[1,1,sz(1)]),[3,1,2]));pPR=p_anom-pBT;
IJPRu(tdx,:,:) = sq(nansum(uPR.*pPR.*DZ));
IJPRv(tdx,:,:) = sq(nansum(vPR.*pPR.*DZ));
end
%keyboard
MODEL.IJPRu=IJPRu;
MODEL.IJPRv=IJPRv;
%keyboard
disp('Need to add in creation of netcdf output here')
%%
f4;close(4)
for tdx=1:4:length(tdxs);
    f4;clf;imagesc(sq(IJPRu(tdx,:,:))/1e3);axis xy;caxis([-1,1]*50);hold on
    contour(medfilt2(MODEL.H),16,'k')
    drawnow;end
%%
time=time(tdxs);
eval(['save ',MODEL.files.IFufile,' IJPRu MODEL time -mat']);done('saving Fu')
eval(['save ',MODEL.files.IFvfile,' IJPRv MODEL time -mat']);done('saving Fv')





