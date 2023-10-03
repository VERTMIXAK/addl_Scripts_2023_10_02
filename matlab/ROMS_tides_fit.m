function roms=ROMS_tides_fit(roms,nm)
consts=tide_freqs;
time=(roms.ctime'-datenum(roms.year,1,1))*24;
ny=length(roms.jdx);
roms.omega = [1/consts.m2.T 1/consts.s2.T 1/consts.o1.T 1/consts.k1.T];                  % [cycles per hour]
clear amp* pha*
%%
%keyboard
%%
for mdx = [1:nm];disp(['fit weights to specific frequencies mode = ',num2str(mdx)'])
  for jj = 1:ny;%jj
        [ampu(:,mdx,jj,:),phau(:,mdx,jj,:)]=harmonic_fit(time,squeeze(roms.cu(:,mdx,jj,:)),roms.omega);
        [ampv(:,mdx,jj,:),phav(:,mdx,jj,:)]=harmonic_fit(time,squeeze(roms.cv(:,mdx,jj,:)),roms.omega);
  end % NY
end % mdx

roms.ampu=ampu;
roms.ampv=ampv;
roms.phau=phau;
roms.phav=phav;
