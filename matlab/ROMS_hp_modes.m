
%%
roms.files.hpcfile     = [roms.analysis_path,'roms_hp_c_m_',roms.latlonRange,'.mat'];
if ~exist(roms.files.hpcfile)

% cu_hp=nan*cu;
% cv_hp=nan*cv;
% cr_hp=nan*cr;
for mm=1:nm
 disp(['highpassing mode level ',num2str(mm)])
% only read in data for our region and time range
for jj = 1:ny
cu(:,mm,jj,:)=highpass(sq(cu(:,mm,jj,:)),1/36,1,6);
cv(:,mm,jj,:)=highpass(sq(cv(:,mm,jj,:)),1/36,1,6);
cr(:,mm,jj,:)=highpass(sq(cr(:,mm,jj,:)),1/36,1,6);
end % jj
end % mm
%cu_var = sq(var(cu));
%cv_var = sq(var(cv));
%cr_var = sq(var(cr));
%eval(['save -v7.3 ',roms.files.hpcfile,  ' cu cv cr  ctime'])
eval(['save -v7.3 ',roms.files.hpcfile,  ' cu cv cr  ctime'])
else
% eval(['load       ',roms.files.hpcfile, ' cu cv cr cu_var cv_var cr_var ctime'])
 eval(['load       ',roms.files.hpcfile, ' cu cv cr ctime'])
end
