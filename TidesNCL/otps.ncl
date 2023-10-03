; Read the Global OTPS fields and load into tidal forcing file.

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin
; grid = addfile ("/u1/uaf/kate/Downloads/yellow_sea_grid.nc", "r")
; grid = addfile ("/archive/u1/uaf/kate/gridpak/Cook_inlet/Cook_Inlet_grid_1.nc", "r")
; grid = addfile ("/archive/u1/uaf/kate/gridpak/Cook_inlet/NWGOA_grid_3.nc", "r")
; grid = addfile ("/archive/u1/uaf/kate/Svalbard/gridpak/grid_Svalbard_1.nc", "r")
; grid = addfile ("/archive/u1/uaf/kate/gridpak/Beaufort/grid_Beaufort_2.nc", "r")
; grid = addfile ("/archive/u1/uaf/kate/gridpak/Beaufort/grid_Beaufort_3.nc", "r")
; grid = addfile ("/archive/u1/uaf/kate/gridpak/Palau/grid_Palau_2.nc", "r")
; grid = addfile ("/archive/u1/uaf/kate/Bering_WRF/Bering_WRF_grid.nc", "r")
; grid = addfile ("/archive/u1/uaf/kate/gridpak/Tasman/grid_Tasman_2.nc", "r")
;  grid = addfile ("/import/AKWATERS/kshedstrom//gridpak/Barrow/grid_Barrow_1.nc", "r")
  grid = addfile ("../Gridpak/NISKINEC_2km.nc", "r")
  lat2d  = grid->lat_rho
  lon2d  = grid->lon_rho
  rmask = grid->mask_rho
  Lp = dimsizes(lat2d(0,:))
  Mp = dimsizes(lat2d(:,0))

  fname = "NISKINEC_2km_tides.nc"
  out = addfile(fname, "w")

  setfileoption("bin", "ReadByteOrder", "BigEndian")
  ints = fbinrecread("/import/VERTMIXFS/jgpender/ROMS/OTIS_DATA/h_tpxo7.2", 0, -1, "integer")
  n = ints(0)
  m = ints(1)
  nc = ints(2)
; KLUDGE! we only want 8 of the 10
  nc = 8

  reals = fbinrecread("/import/VERTMIXFS/jgpender/ROMS/OTIS_DATA/h_tpxo7.2", 0, -1, "float")
  theta_min = reals(3)
  theta_max = reals(4)
  phi_min = reals(5)
  phi_max = reals(6)
  lon = fspan(phi_min, phi_max, n)
  lat = fspan(theta_min, theta_max, m)
  dx = lon(1)-lon(0)
  print(phi_min+"  "+phi_max+"   "+dx)
  ulon = lon - dx/2
  vlat = lat - dx/2

  chars = fbinrecread("/import/VERTMIXFS/jgpender/ROMS/OTIS_DATA/h_tpxo7.2", 0, -1, "character")
;  print(chars)

  depth1d = fbinrecread("/import/VERTMIXFS/jgpender/ROMS/OTIS_DATA/grid_tpxo7.2", 2, (/ m*n /), "float")
  mask1d = fbinrecread("/import/VERTMIXFS/jgpender/ROMS/OTIS_DATA/grid_tpxo7.2", 3, (/ m*n /), "integer")
  indy = ind(mask1d .eq. 0)
  depth1d(indy) = depth1d@_FillValue
  depth = onedtond( depth1d, (/ m, n /))
  delete(indy)

  wks  = gsn_open_wks ("ncgm", "tides")
  res = True

  z_complex = new((/ m*n, 2 /), "float")
  z_re = new((/ m, n /), "float")
  z_im = new((/ m, n /), "float")
  z_amp = new((/ nc, m, n /), "float")
  z_phase = new((/ nc, m, n /), "float")
  do i=1,nc
    z_complex = fbinrecread("/import/VERTMIXFS/jgpender/ROMS/OTIS_DATA/h_tpxo7.2", i, (/ m*n, 2/), "float")
    z_re1d = z_complex(:,0)
    z_im1d = z_complex(:,1)
    indy = ind(z_re1d .eq. 0.0 .and. z_im1d .eq. 0.0)
    z_re1d(indy) = z_re@_FillValue
    z_im1d(indy) = z_im@_FillValue
    delete(indy)

    z_re = onedtond( z_re1d, (/ m, n /))
    z_im = onedtond( z_im1d, (/ m, n /))

    z_amp(i-1,:,:) = sqrt(z_re^2 + z_im^2)
    z_phase(i-1,:,:) = atan2(-z_im, z_re) * 180/3.1415926536
    z_1d = ndtooned(z_phase)
    indy = ind(z_1d .lt. 0.0)
    z_1d(indy) = z_1d(indy) + 360.
    z_phase = onedtond(z_1d, dimsizes(z_phase))
    delete(indy)
  end do

  uv_complex = new((/ m*n, 4 /), "float")
  u_re = new((/ m, n /), "float")
  u_im = new((/ m, n /), "float")
  uminor = new((/ nc, m, n /), "float")
  umajor = new((/ nc, m, n /), "float")
  v_re = new((/ m, n /), "float")
  v_im = new((/ m, n /), "float")
  uincl = new((/ nc, m, n /), "float")
  uphase = new((/ nc, m, n /), "float")
  do i=1,nc
    uv_complex = fbinrecread("/import/VERTMIXFS/jgpender/ROMS/OTIS_DATA/u_tpxo7.2", i, (/ m*n, 4/), "float")
    u_re1d = uv_complex(:,0)
    u_im1d = uv_complex(:,1)
    v_re1d = uv_complex(:,2)
    v_im1d = uv_complex(:,3)
    indy = ind(mask1d .eq. 0)
    u_re1d(indy) = u_re@_FillValue
    u_im1d(indy) = u_im@_FillValue
    v_re1d(indy) = v_re@_FillValue
    v_im1d(indy) = v_im@_FillValue
    delete(indy)

    u_re = onedtond( u_re1d, (/ m, n /)) / depth
    u_im = onedtond( u_im1d, (/ m, n /)) / depth
    v_re = onedtond( v_re1d, (/ m, n /)) / depth
    v_im = onedtond( v_im1d, (/ m, n /)) / depth

;    t1p = u_re - v_im
;    t2p = v_re + u_im
;    t1m = u_re + v_im
;    t2m = v_re - u_im
    wp_re = .5*(u_re - v_im)
    wp_im = .5*(v_re + u_im)
    wm_re = .5*(u_re + v_im)
    wm_im = .5*(v_re - u_im)

; ap, am = amplitudes of positively and negatively rotated vectors

;    ap = 0.5 * sqrt(t1p^2 + t2p^2)
;    am = 0.5 * sqrt(t1m^2 + t2m^2)
    Wp = sqrt(wp_re^2 + wp_im^2)
    Wm = sqrt(wm_re^2 + wm_im^2)

; ep, em - phases of positively and negatively rotating vectors
    pi = 3.14159265358979
;    ep = atan2( t2p, t1p)
;    ep_1d = ndtooned(ep)
;    indy = ind(ep_1d .lt. 0.0)
;    ep_1d(indy) = ep_1d(indy) + 2 * pi
;    delete(indy)
;    ep = onedtond(ep_1d, dimsizes(ep))
;    ep = 180. * ep / pi
;    em = atan2( t2m, t1m)
;    em_1d = ndtooned(em)
;    indy = ind(em_1d .lt. 0.0)
;    em_1d(indy) = em_1d(indy) + 2 * pi
;    delete(indy)
;    em = 180. * em / pi
    THETAp = atan2( wp_im, wp_re )
    THETAm = atan2( wm_im, wm_re )

    SEMA   = Wp + Wm
    SEMI   = Wp - Wm

    PHA    = .5*(THETAm - THETAp)
    INC    = .5*(THETAm + THETAp)

    PHA    = PHA * 180./pi
    INC    = INC * 180./pi
    THETAp = THETAp * 180./pi
    THETAm = THETAm * 180./pi


;  determine the major and minor axes, phase and inclination using
;  Foreman's formula
;    umajor(i-1,:,:) = (ap + am)
;    uminor(i-1,:,:) = (ap - am)
    umajor(i-1,:,:) = Wp + Wm
    uminor(i-1,:,:) = Wp - Wm

    uincl(i-1,:,:) = INC
    uphase(i-1,:,:) = PHA
;    uincl(i-1,:,:) = 0.5 * (em + ep)
;    ui_1d = ndtooned(uincl(i-1,:,:))
;    indy = ind(ui_1d .gt. 180.)
;    if (.not. all(ismissing(indy)))
;      ui_1d(indy) = ui_1d(indy) -180.
;    end if
;    delete(indy)
;    uincl(i-1,:,:) = onedtond(ui_1d, (/ m, n /))

;    uphase(i-1,:,:) = - 0.5*(ep-em)
;    up_1d = ndtooned(uphase(i-1,:,:))
;    indy = ind(up_1d .lt. 0.)
;    if (.not. all(ismissing(indy)))
;      up_1d(indy) = up_1d(indy) + 360.
;    end if
;    delete(indy)
;    indy = ind(up_1d .ge. 360.)
;    if (.not. all(ismissing(indy)))
;      up_1d(indy) = up_1d(indy) - 360.
;    end if
;    delete(indy)
;    uphase(i-1,:,:) = onedtond(up_1d, (/ m, n /))

  end do

    gsn_define_colormap(wks,"rainbow")
    res@cnFillOn          = True
    res@lbLabelAutoStride = True

; Create the arrays on the ROMS grid and populate them
  roms_zphase = new((/ nc, Mp, Lp /), "float")
  roms_zamp = new((/ nc, Mp, Lp /), "float")
  roms_umajor = new((/ nc, Mp, Lp /), "float")
  roms_uminor = new((/ nc, Mp, Lp /), "float")
  roms_uincl = new((/ nc, Mp, Lp /), "float")
  roms_uphase = new((/ nc, Mp, Lp /), "float")
  cyclic = False
  do i=0,nc-1
    phase_1d = linint2_points(lon, lat, z_phase(i,:,:), cyclic, ndtooned(lon2d), ndtooned(lat2d), 0)
    amp_1d = linint2_points(lon, lat, z_amp(i,:,:), cyclic, ndtooned(lon2d), ndtooned(lat2d), 0)

    printVarSummary(rmask)
    printVarSummary(phase_1d)
    roms_zphase(i,:,:) = onedtond(phase_1d, (/ Mp, Lp /)) * dble2flt(rmask)
    roms_zamp(i,:,:) = onedtond(amp_1d, (/ Mp, Lp /)) * dble2flt(rmask)

    umajor_1d = linint2_points(lon, lat, umajor(i,:,:), cyclic, ndtooned(lon2d), ndtooned(lat2d), 0)
    uminor_1d = linint2_points(lon, lat, uminor(i,:,:), cyclic, ndtooned(lon2d), ndtooned(lat2d), 0)
    uincl_1d = linint2_points(lon, lat, uincl(i,:,:), cyclic, ndtooned(lon2d), ndtooned(lat2d), 0)
    uphase_1d = linint2_points(lon, lat, uphase(i,:,:), cyclic, ndtooned(lon2d), ndtooned(lat2d), 0)

    roms_umajor(i,:,:) = onedtond(umajor_1d, (/ Mp, Lp /)) * dble2flt(rmask)
    roms_uminor(i,:,:) = onedtond(uminor_1d, (/ Mp, Lp /)) * dble2flt(rmask)
    roms_uincl(i,:,:) = onedtond(uincl_1d, (/ Mp, Lp /)) * dble2flt(rmask)
    roms_uphase(i,:,:) = onedtond(uphase_1d, (/ Mp, Lp /)) * dble2flt(rmask)

   end do

; Now get them sorted in the ROMS order:
;               Q1, O1, P1, K1, N2, M2, S2, K2
; OTPS order is m2, s2, n2, k2, k1, o1, p1, q1

   tide_Eamp = new((/ nc, Mp, Lp /), "float")
   tide_Ephase = new((/ nc, Mp, Lp /), "float")
   tide_Cmax = new((/ nc, Mp, Lp /), "float")
   tide_Cmin = new((/ nc, Mp, Lp /), "float")
   tide_Cangle = new((/ nc, Mp, Lp /), "float")
   tide_Cphase = new((/ nc, Mp, Lp /), "float")

; Q1
   tide_Eamp(0,:,:) = roms_zamp(7,:,:)
   tide_Ephase(0,:,:) = roms_zphase(7,:,:)
   tide_Cmax(0,:,:) = roms_umajor(7,:,:)
   tide_Cmin(0,:,:) = roms_uminor(7,:,:)
   tide_Cangle(0,:,:) = roms_uincl(7,:,:)
   tide_Cphase(0,:,:) = roms_uphase(7,:,:)

; 01
   tide_Eamp(1,:,:) = roms_zamp(5,:,:)
   tide_Ephase(1,:,:) = roms_zphase(5,:,:)
   tide_Cmax(1,:,:) = roms_umajor(5,:,:)
   tide_Cmin(1,:,:) = roms_uminor(5,:,:)
   tide_Cangle(1,:,:) = roms_uincl(5,:,:)
   tide_Cphase(1,:,:) = roms_uphase(5,:,:)

; P1
   tide_Eamp(2,:,:) = roms_zamp(6,:,:)
   tide_Ephase(2,:,:) = roms_zphase(6,:,:)
   tide_Cmax(2,:,:) = roms_umajor(6,:,:)
   tide_Cmin(2,:,:) = roms_uminor(6,:,:)
   tide_Cangle(2,:,:) = roms_uincl(6,:,:)
   tide_Cphase(2,:,:) = roms_uphase(6,:,:)

; K1
   tide_Eamp(3,:,:) = roms_zamp(4,:,:)
   tide_Ephase(3,:,:) = roms_zphase(4,:,:)
   tide_Cmax(3,:,:) = roms_umajor(4,:,:)
   tide_Cmin(3,:,:) = roms_uminor(4,:,:)
   tide_Cangle(3,:,:) = roms_uincl(4,:,:)
   tide_Cphase(3,:,:) = roms_uphase(4,:,:)

; N2
   tide_Eamp(4,:,:) = roms_zamp(2,:,:)
   tide_Ephase(4,:,:) = roms_zphase(2,:,:)
   tide_Cmax(4,:,:) = roms_umajor(2,:,:)
   tide_Cmin(4,:,:) = roms_uminor(2,:,:)
   tide_Cangle(4,:,:) = roms_uincl(2,:,:)
   tide_Cphase(4,:,:) = roms_uphase(2,:,:)

; M2
   tide_Eamp(5,:,:) = roms_zamp(0,:,:)
   tide_Ephase(5,:,:) = roms_zphase(0,:,:)
   tide_Cmax(5,:,:) = roms_umajor(0,:,:)
   tide_Cmin(5,:,:) = roms_uminor(0,:,:)
   tide_Cangle(5,:,:) = roms_uincl(0,:,:)
   tide_Cphase(5,:,:) = roms_uphase(0,:,:)

; S2
   tide_Eamp(6,:,:) = roms_zamp(1,:,:)
   tide_Ephase(6,:,:) = roms_zphase(1,:,:)
   tide_Cmax(6,:,:) = roms_umajor(1,:,:)
   tide_Cmin(6,:,:) = roms_uminor(1,:,:)
   tide_Cangle(6,:,:) = roms_uincl(1,:,:)
   tide_Cphase(6,:,:) = roms_uphase(1,:,:)

; K1
   tide_Eamp(7,:,:) = roms_zamp(3,:,:)
   tide_Ephase(7,:,:) = roms_zphase(3,:,:)
   tide_Cmax(7,:,:) = roms_umajor(3,:,:)
   tide_Cmin(7,:,:) = roms_uminor(3,:,:)
   tide_Cangle(7,:,:) = roms_uincl(3,:,:)
   tide_Cphase(7,:,:) = roms_uphase(3,:,:)

   out->tide_Eamp = (/ tide_Eamp /)
   out->tide_Ephase = (/ tide_Ephase /)
   out->tide_Cmax = (/ tide_Cmax /)
   out->tide_Cmin = (/ tide_Cmin /)
   out->tide_Cangle = (/ tide_Cangle /)
   out->tide_Cphase = (/ tide_Cphase /)

   tide_Eamp@lat2d=lat2d
   tide_Ephase@lon2d=lon2d

;   res@cnLineLabelsOn         = False              ; no contour labels
;   res@cnFillDrawOrder        = "PreDraw"          ; put continents on top
;   res@gsnSpreadColors        = True               ; use total colormap
;   res@mpProjection        = "LambertConformal"
;   res@mpLambertParallel1F = grid->PLAT(0)
;   res@mpLambertParallel2F = grid->PLAT(1)
;   res@mpLambertMeridianF  = 180 ; res@mpLambertMeridianF  = grid->PLONG
;
;   res@mpLimitMode         = "Corners"             ; choose range of map
;   res@mpLeftCornerLatF    = 48.0
;   res@mpLeftCornerLonF    = 165.0
;   res@mpRightCornerLatF   = 66.5
;   res@mpRightCornerLonF   = 210.0
;
;   plot = gsn_csm_contour_map(wks,tide_Eamp(5,:,:),res)
;   plot = gsn_csm_contour_map(wks,tide_Ephase(5,:,:),res)
;   plot = gsn_csm_contour_map(wks,m2_phase,res)
;   plot = gsn_csm_contour_map(wks,m2_amp,res)

end
