/*
** svn $Id$
*******************************************************************************
** Copyright (c) 2002-2013 The ROMS/TOMS Group
**
**   Licensed under a MIT/X style license
**
**   See License_ROMS.txt
**
*******************************************************************************
**
**  Options for Northeast Pacific (NEP6) simulation
*/


/* ROMS plus WW3 */
/* !!!!!!!!!!!!!!!!!!!!!!! */
#define ROMS_MODEL
#undef NESTING
#undef WRF_MODEL
#undef SWAN_MODEL
#define  WW3_MODEL

/* only needed for coupling experiments */
#define MCT_LIB
#undef MCT_INTERP_OC2AT
#undef MCT_INTERP_WV2AT
#define MCT_INTERP_OC2WV


/* Pull this from Hurricane Sandy example */
#ifdef ROMS_MODEL
/* Physics + numerics */
# if defined WW3_MODEL || defined SWAN_MODEL
#  define WEC_VF
#  define WDISS_WAVEMOD
#  define UV_KIRBY
# endif
#endif

/* another set to try */
#define WEC_VF
#define WDISS_WAVEMOD
#define UV_KIRBY



/* Define this because grid straddles the Greenwich Meridian */

#define GLOBAL_PERIODIC


#undef NO_HIS
#undef HISTORY2
#undef NETCDF4
#undef PARALLEL_IO
#undef OFFLINE_FLOATS

/* general */

#define CURVGRID
#define MASKING
#define NONLIN_EOS
#define SOLVE3D
#define SALINITY

#ifdef SOLVE3D
/*  # define SPLINES  discontinued  jgp*/
# define RI_SPLINES
#endif

#undef FLOATS

/* JGP undef this for now */
#undef STATIONS

#undef WET_DRY


/* jgp new stuff */
#define CHARNOK
#define CRAIG_BANNER



/* output stuff */

#define NO_WRITE_GRID
#undef OUT_DOUBLE
#define PERFECT_RESTART
#ifndef PERFECT_RESTART
# define RST_SINGLE
#endif
#undef AVERAGES
#undef AVERAGES2
#ifdef SOLVE3D
# undef AVERAGES_DETIDE
# undef DIAGNOSTICS_TS
#endif
#undef DIAGNOSTICS_UV

/* advection, dissipation, pressure grad, etc. */

#ifdef SOLVE3D
# define DJ_GRADPS
#endif

#define UV_ADV
#define UV_COR
#undef UV_SADVECTION
#undef UV_C4ADVECTION

#ifdef SOLVE3D
# define TS_U3HADVECTION
# define TS_C4VADVECTION
# undef TS_MPDATA
#endif

#define UV_VIS2
#undef UV_SMAGORINSKY
#define VISC_3DCOEF
#define MIX_S_UV
#define VISC_GRID
#undef SPONGE

#ifdef SOLVE3D
# define TS_DIF2
# define MIX_GEO_TS
# define DIFF_GRID
#endif

/* vertical mixing */

#ifdef SOLVE3D
# define WTYPE_GRID


/* jgp undef LMD */
# undef LMD_MIXING
# ifdef LMD_MIXING
#  define LMD_RIMIX
#  define LMD_CONVEC
#  define LMD_SKPP
#  define LMD_BKPP
#  define LMD_NONLOCAL
#  define LMD_SHAPIRO
#  undef LMD_DDMIX
# endif

/* jgp define GLS */
# define GLS_MIXING
# undef MY25_MIXING

# if defined GLS_MIXING || defined MY25_MIXING
#  define KANTHA_CLAYSON
#  define N2S2_HORAVG
# endif
#endif

/* surface forcing */

#ifdef SOLVE3D
# define CORE_FORCING
# define BULK_FLUXES
# define CCSM_FLUXES
# if defined BULK_FLUXES || defined CCSM_FLUXES
#  define LONGWAVE_OUT
#  undef DIURNAL_SRFLUX
#  define EMINUSP
#  undef ANA_SRFLUX
#  define SOLAR_SOURCE

/* JRA-55 version */
#  undef ALBEDO_CLOUD
#  define ALBEDO_CURVE  
#  undef ICE_ALB_EC92  
#  define ALBEDO_CSIM  
#  undef ALBEDO_FILE  


/* MERRA version 
#  undef ALBEDO
#  undef ALBEDO_CURVE
#  define ALBEDO_FILE
*/

#  undef LONGWAVE
# endif
#endif

/* surface and side corrections */

#ifdef SOLVE3D
# ifdef SALINITY
#  define SCORRECTION
# endif
# undef QCORRECTION
#endif

/* tides */

#undef LTIDES
#ifdef LTIDES

/* JGP undef this for now */
# undef FILTERED

# define SSH_TIDES
# define UV_TIDES
# define ADD_FSOBC
# define ADD_M2OBC
# undef RAMP_TIDES
# undef TIDES_ASTRO
# undef POT_TIDES

# undef UV_LDRAG
# define UV_DRAG_GRID
# define ANA_DRAG
# define LIMIT_BSTRESS
#else
# undef M2TIDE_DIFF
#endif
#define UV_QDRAG




/* point sources (rivers, line sources) */

/* there seems to be at least two methods for adding fresh water at the mouth of a river:
1) a second "rainfall" that requires a netcdf with a "runoff" field (no momentum)
		this requires the RUNOFF flag
2) a scheme that adds freshwater in a more realistic way. The netcdf file has many fields
	river_direction, river_transport, position parameters, etc
		this requirs the UV_PSOURCE flag	
	NOTE: this method also has flags deffed in the run input file 
3) presumably, if both RUNOFF and UV_PSOURCE/TS_PSOURCE are undeffed, and if the flags in
	the run input file are FALSE, the the model runs without freshwater point sources */

#ifdef SOLVE3D
# undef RUNOFF
# undef UV_PSOURCE
# undef ANA_PSOURCE
# undef TS_PSOURCE
#endif




#define RADIATION_2D

#ifdef SOLVE3D
/* Monthly average SODA is used to nudge solution in boundary bufferzone
   These data enter through the climatology arrays 
   Bufferzone characteristics must be set with mods to
   set_nudgcof.F */
# undef  M3CLIMATOLOGY
# undef  M3CLM_NUDGING
# undef  TCLIMATOLOGY
# undef  TCLM_NUDGING
#endif
#undef  M2CLIMATOLOGY
#undef  M2CLM_NUDGING
#undef  ZCLIMATOLOGY
#undef  ZCLM_NUDGING

/* roms quirks */

#ifdef SOLVE3D
# define ANA_BSFLUX
# define ANA_BTFLUX
#else
# define ANA_SMFLUX
#endif
