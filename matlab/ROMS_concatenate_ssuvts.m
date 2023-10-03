ssoutfile = [roms.path2,'/u_v_t_s_his2.nc'];disp(ssoutfile)
eval(['!ncrcat -v u,v,salt,temp ',roms.path1,'/',roms.exp,'_his2_*.nc ',ssoutfile])

 roms.files.ssoutfile=ssoutfile;