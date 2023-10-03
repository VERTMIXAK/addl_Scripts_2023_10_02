%vecscale = 1e2;hheadwidth = 2;headl = 2;hshaftwidth=.15;col='r';presmoo=1;postsmoo=1;minv = 1;sub=8
%lon0 = 147;lon1 = 165;lat0=-55;lat1=-38;reflon = 147.5;reflat = -41.5;refv=10;refu=0;
smoofac = 1;
u = lowpass2d(vswap(sq(F.ta_Fu_m(mdx,:,:)),nan,0),smoofac,smoofac)/1e3;
v = lowpass2d(vswap(sq(F.ta_Fv_m(mdx,:,:)),nan,0),smoofac,smoofac)/1e3;
U = sqrt(u.^2+v.^2);%big=find(U>1e3);

m_proj('equi','lon',[lon0 lon1],'lat',[lat0 lat1] );
m_pcolor(F.lon,F.lat,U);shading flat;hold on;caxis([0,10]);hold on
m_contour(F.lon,F.lat,F.H,16,'color',[1 1 1]*.5);hold on
hls_m_vec_wrapper(reflon,reflat,refu,refv,F.lon(1,:),F.lat(:,1),u,v,sub,presmoo,postsmoo,vecscale,hheadwidth,headl,hshaftwidth,minv,col);hold on
m_grid;
%m_usercoast('TASMAN_coast','patch',[.7 .7 .4])
%m_usercoast('TASMAN_coast') 
m_coast('patch',[.5 1 0])
title([roms.exp1],'interpreter','none')
colorbar