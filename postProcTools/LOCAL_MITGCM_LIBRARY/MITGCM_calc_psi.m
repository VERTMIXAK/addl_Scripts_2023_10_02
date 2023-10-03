 function MITGCM_calc_psi(psifile,N2,MODEL,nmodes)
%function MITGCM_calc_psi(psifile,MODEL,nmodes)

 nmodes = 10;
 sz = [nmodes length(MODEL.RC) size(MODEL.H)];
psiarray=nan*ones(sz);P = sw_pres(-MODEL.RC,-45);
 for ii = 1:sz(4);disp(ii/sz(4))
    for jj = 1:sz(3)
        idx = find(-MODEL.RC<MODEL.H(jj,ii));
        if length(idx) >10
        [~,~,~,~,p,~,~]=VERT_STRUCTURE(MODEL.RC(idx),N2(idx),0*sw_f(-45),1:nmodes,1e3,2*pi/(12.4*3600),0);
        % should be using MITGC_MODES code because of Sam's normalization
        %
        % In the future  use dynmodes Sam's MODES code because I want the flexibility to use stretched vertical grids
        %[dyn.w,dyn.p,~]=dynmodes(N2(idx),P(idx),0);
        p=real(p);
        % normalize p
        %for kk=1:nmodes;p(:,kk)=p(:,kk)/p(1,kk);end
        psiarray(:,idx,jj,ii)=p';
        end
    end
 end
eval(['save ',psifile,' psiarray -v7.3 -mat']);
psitime=toc(tstart);
% 


