function MODEL=MITGCM_get_grid(MODEL)
files=MODEL.files;
MODEL.H   = nc_varget(files.grid ,'Depth');
MODEL.XC  = nc_varget(files.grid ,'XC'   );
MODEL.YC  = nc_varget(files.grid ,'YC'   );
MODEL.RC  = nc_varget(files.grid ,'RC'   );
MODEL.drC = nc_varget(files.grid ,'drC'  );
sz=size(MODEL.H);
MODEL.Z =repmat(MODEL.RC ,[1,sz(1),sz(2)]);
MODEL.DZ=repmat(MODEL.drC,[1,sz(1),sz(2)]);

%keyboard
data=load([MODEL.base,MODEL.exp,'/matlab/data']);MODEL.data.N2=data.MODEL.N2;
