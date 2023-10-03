prec='real*8';ieee='b';

MODEL.Sref=0*MODEL.Tref

fid=fopen('../input/delYvar','w',ieee); fwrite(fid,MODEL.delY ,prec) ; fclose(fid);
fid=fopen('../input/delXvar','w',ieee); fwrite(fid,MODEL.delX ,prec) ; fclose(fid);
fid=fopen('../input/delZvar','w',ieee); fwrite(fid,MODEL.delZ ,prec) ; fclose(fid);
fid=fopen('../input/SrefVar','w',ieee); fwrite(fid,MODEL.Sref ,prec) ; fclose(fid);
fid=fopen('../input/TrefVar','w',ieee); fwrite(fid,MODEL.Tref ,prec) ; fclose(fid);
fid=fopen('../input/T.init' ,'w',ieee); fwrite(fid,MODEL.Tinit,prec) ; fclose(fid);
fid=fopen('../input/topog.init','w',ieee); fwrite(fid,-abs(MODEL.H'),prec) ; fclose(fid);

fid=fopen('../input/SU.ob','w',ieee); fwrite(fid,OB.SU,prec); fclose(fid);%    NV=permute(repmat(nv,[1 1 MODEL.Nz]),[1 3 2]);
fid=fopen('../input/SV.ob','w',ieee); fwrite(fid,OB.SV,prec); fclose(fid);
fid=fopen('../input/NU.ob','w',ieee); fwrite(fid,OB.NU,prec); fclose(fid);
fid=fopen('../input/NV.ob','w',ieee); fwrite(fid,OB.NV,prec); fclose(fid);
fid=fopen('../input/WU.ob','w',ieee); fwrite(fid,OB.WU,prec); fclose(fid);
fid=fopen('../input/WV.ob','w',ieee); fwrite(fid,OB.WV,prec); fclose(fid);
fid=fopen('../input/EU.ob','w',ieee); fwrite(fid,OB.EU,prec); fclose(fid);
fid=fopen('../input/EV.ob','w',ieee); fwrite(fid,OB.EV,prec); fclose(fid);
    
fid=fopen('../input/NT.ob','w',ieee); fwrite(fid,OB.NT,prec); fclose(fid);
fid=fopen('../input/ST.ob','w',ieee); fwrite(fid,OB.ST,prec); fclose(fid);
fid=fopen('../input/WT.ob','w',ieee); fwrite(fid,OB.WT,prec); fclose(fid);
fid=fopen('../input/ET.ob','w',ieee); fwrite(fid,OB.ET,prec); fclose(fid);
    
%%
if bcplots
    figure(1);clf
 x = MODEL.Lat(:,1); u=OB.EU; v=OB.EV; t=OB.ET;
 subplot(2,3,1);contourf(x,OB.timeD-OB.timeD(1),sq(u(:,1,:))',32);shading flat;colorbar('h');title('U');ylabel('time');xlabel('Y');caxis(.01*OB.flux_mag*[-1,1])
 subplot(2,3,2);contourf(x,OB.timeD-OB.timeD(1),sq(v(:,1,:))',32);shading flat;colorbar('h');title('V');xlabel('Y');caxis(.01*OB.flux_mag*[-1,1])
 subplot(2,3,3);contourf(x,OB.timeD-OB.timeD(1),sq(t(:,1,:))',32);shading flat;colorbar('h');title('T');xlabel('Y');
 subplot(2,3,4);contourf(x,MODEL.Z             ,sq(u(:,:,1))',32);shading flat;colorbar('h');title('U');ylabel('Z');xlabel('Y');caxis(.01*OB.flux_mag*[-1,1])
 subplot(2,3,5);contourf(x,MODEL.Z             ,sq(v(:,:,1))',32);shading flat;colorbar('h');title('V');xlabel('Y');caxis(.01*OB.flux_mag*[-1,1])
 subplot(2,3,6);contourf(x,MODEL.Z             ,sq(t(:,:,1))',32);shading flat;colorbar('h');title('T');xlabel('Y')
    figure(2);clf
 x = MODEL.Lat(:,1); u=OB.WU; v=OB.WV; t=OB.WT;
 subplot(2,3,1);contourf(x,OB.timeD-OB.timeD(1),sq(u(:,1,:))',32);shading flat;colorbar('h');title('U');ylabel('time');xlabel('Y');caxis(.01*OB.flux_mag*[-1,1])
 subplot(2,3,2);contourf(x,OB.timeD-OB.timeD(1),sq(v(:,1,:))',32);shading flat;colorbar('h');title('V');xlabel('Y');caxis(.01*OB.flux_mag*[-1,1])
 subplot(2,3,3);contourf(x,OB.timeD-OB.timeD(1),sq(t(:,1,:))',32);shading flat;colorbar('h');title('T');xlabel('Y');
 subplot(2,3,4);contourf(x,MODEL.Z             ,sq(u(:,:,1))',32);shading flat;colorbar('h');title('U');ylabel('Z');xlabel('Y');caxis(.01*OB.flux_mag*[-1,1])
 subplot(2,3,5);contourf(x,MODEL.Z             ,sq(v(:,:,1))',32);shading flat;colorbar('h');title('V');xlabel('Y');caxis(.01*OB.flux_mag*[-1,1])
 subplot(2,3,6);contourf(x,MODEL.Z             ,sq(t(:,:,1))',32);shading flat;colorbar('h');title('T');xlabel('Y')
%%
figure(3);clf
 x = MODEL.Lon(1,:); u=OB.SU; v=OB.SV; t=OB.ST;
 subplot(2,3,1);contourf(x,OB.timeD-OB.timeD(1),sq(u(:,1,:))',32);shading flat;colorbar('h');title('U');ylabel('time');xlabel('Y');caxis(.01*OB.flux_mag*[-1,1])
 subplot(2,3,2);contourf(x,OB.timeD-OB.timeD(1),sq(v(:,1,:))',320);shading flat;colorbar('h');title('V');xlabel('Y');caxis(.1*OB.flux_mag*[-1,1])
 subplot(2,3,3);contourf(x,OB.timeD-OB.timeD(1),sq(t(:,1,:))',32);shading flat;colorbar('h');title('T');xlabel('Y');
 subplot(2,3,4);contourf(x,MODEL.Z             ,sq(u(:,:,1))',32);shading flat;colorbar('h');title('U');ylabel('Z');xlabel('Y');caxis(.1*OB.flux_mag*[-1,1])
 subplot(2,3,5);contourf(x,MODEL.Z             ,sq(v(:,:,1))',32);shading flat;colorbar('h');title('V');xlabel('Y');caxis(.01*OB.flux_mag*[-1,1])
 subplot(2,3,6);contourf(x,MODEL.Z             ,sq(t(:,:,1))',32);shading flat;colorbar('h');title('T');xlabel('Y')
% subplot(2,3,1);contourf(MODEL.Lon(1,:),OB.timeD-OB.timeD(1),sq(OB.NU(:,1,:))',32);shading flat;colorbar('h');title('NU');ylabel('time');xlabel('X');caxis(.01*OB.flux_mag*[-1,1])
% subplot(2,3,2);contourf(MODEL.Lon(1,:),OB.timeD-OB.timeD(1),sq(OB.NV(:,1,:))',32);shading flat;colorbar('h');title('NV');xlabel('Y');caxis(.01*OB.flux_mag*[-1,1])
% subplot(2,3,3);contourf(MODEL.Lon(1,:),OB.timeD-OB.timeD(1),sq(OB.NT(:,1,:))',32);shading flat;colorbar('h');title('NT');xlabel('Y');
% subplot(2,3,4);contourf(MODEL.Lon(1,:),MODEL.Z             ,sq(OB.NU(:,:,1))',32);shading flat;colorbar('h');title('NU');ylabel('Z');xlabel('X');caxis(.01*OB.flux_mag*[-1,1])
% subplot(2,3,5);contourf(MODEL.Lon(1,:),MODEL.Z             ,sq(OB.NV(:,:,1))',32);shading flat;colorbar('h');title('NV');xlabel('Y');caxis(.01*OB.flux_mag*[-1,1])
% subplot(2,3,6);contourf(MODEL.Lon(1,:),MODEL.Z             ,sq(OB.NT(:,:,1))',32);shading flat;colorbar('h');title('NT');xlabel('Y')%


 figure(4);clf;
 contourf(MODEL.H);colorbar
end

    
    %% Save intial data for plotting later
%data.X=X;
%data.Y=Y;
%data.Z=Z;
%data.Tref=Tref;
%data.Sref=Sref;
%data.Tinit=Tinit;
%data.H=-H;
%data.N2=MODEL.N2
save data MODEL

disp(['set externForcingPeriod to ',num2str(OB.dt)])
disp(['set externforcingcycle to ',num2str(OB.period)])
disp(['set data.obcs to ',num2str(MODEL.Nx),' and ',num2str(MODEL.Ny)])
disp(['set size.H    to ',num2str(MODEL.Nx),' and ',num2str(MODEL.Ny)])
%%
% if BT
%     f3;clf;%rwb
% subplot(1,4,1);contourf(1:OB.Nt,MODEL.Lat(:,1),repmat(MODEL.H(:,1),1,Nt).*wu.*wu./wu);caxis([-1,1]*100);shading flat;;axis tight
% subplot(1,4,2);plot(MODEL.H(:,1),MODEL.Lat(:,1));axis tight
% subplot(1,4,3);contourf(1:OB.Nt,MODEL.Lat(:,1),repmat(MODEL.H(:,end),1,Nt).*eu.*eu./eu);caxis([-1,1]*100);shading flat;;axis tight
% subplot(1,4,4);plot(MODEL.H(end,:),MODEL.Lat(end,:));axis tight
% end


