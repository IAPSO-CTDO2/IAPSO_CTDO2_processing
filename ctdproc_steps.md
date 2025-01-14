# Source/version: 
McTaggart et al., 2010, Notes on CTD/O2 Data Acquisition and Processing Using Sea-Bird Hardware and Software (as available). \
Uchida et al., 2010, CTD Oxygen Sensor Calibration Procedures. \
Note: Draft. "..." indicates details to be filled in. 

## A) Data quality control (primary/1QC)
1) After each cast examine differences between primary and secondary sensors over a homogenous part of the water column
2) Suspect sensors with drift over 0.002 C (T), 0.005 mS/cm (C), 15 umol/kg (O), 2 dbar (P)

## B) Data processing
1) SBE Data Conversion (raw to engineering units, outputs scan number, elapsed time, p, t0, t1, c0, c1, oxygen voltage(s), and other [e.g. optical sensor] voltages).
   Apply oxygen sensor hysteresis and time lag corections (windows size 2s)
2+3) SBE Wild edit (x2 consecutively) on CTD data
   # wildedit_pass1_nstd = 2.0
   # wildedit_pass2_nstd = 10.0
   # wildedit_pass2_mindelta = 0.000e+000
   # wildedit_npoint = 100
   # wildedit_vars = prDM t090C t190C c0S/m c1S/m
   # wildedit_excl_bad_scans = yes
4) SBE Filter on pressure and optical data
   # filter_low_pass_tc_A = 0.030
   # filter_low_pass_tc_B = 0.150
   # filter_low_pass_A_vars = turbWETntu0 spar wetStar
   # filter_low_pass_B_vars = prDM
5) SBE Align CTD (2s lag only for O2)
   # alignctd_adv = sbeox0V 2.000
6) SBE Cell Thermal Mass
   # celltm_alpha = 0.0300, 0.0300
   # celltm_tau = 7.0000, 7.0000
   # celltm_temp_sensor_use_for_cond = primary, secondary
7) SBE Loop Edit
   # loopedit_minVelocity = 0.100
   # loopedit_surfaceSoak: minDepth = 6.0, maxDepth = 25, useDeckPress = 1
   # loopedit_excl_bad_scans = yes
8) SBE Derive to compute Salinity, Pot. Temp., Dens., Oxygen (ml/L), Oxygen (umol/kg)
   # derive_time_window_docdt = seconds: 2
   # derive_ox_tau_correction = yes
9) SBE Bin Average on downcast only
   # binavg_bintype = decibars
   # binavg_binsize = 1
   # binavg_excl_bad_scans = yes
   # binavg_skipover = 0
   # binavg_omit = 0
10) SBE Bottle Summary

## C) Data corrections

### Pressure, Temperature, Conductivity
We use recently calibrated CTD sensors in pair (1 calibrated at year n, the other at year n-1)
No correction on T and P (unless significant difference between the pair of CTD)
Corrections to C calibrations
i) Use systematic comparisons between sensor data and an independent measure (Autosal water sample salinity) \
ii) Corrections can potentially vary by cast, but usually should be a very few different sets during the cruise, or slowly evolving with shifts only due to fouling or mechanical shock events \
iii) First, Autosal salinities are plotted against bottle salinities and the presence of outliers.
iv) A subsample of the salinities to be used is determined by using a standard Interquartile \
range (IQR) method excluding data outside the interval [Q1-1.5*(Q3-Q1) ; Q3+1.5*(Q3-Q1)] with Q1 and Q3 the 25th and 75th percentile of the data distribution. \
v) The distribution of Autosal versus CTD salinity is examined to evaluate if significant discrepencies are found for CTD1 or CTD2. \
vi) Salinity differences are also plotted against time, to check that no temporal drift was present. If yes, the ratio coefficient used is allow to evolve with time (based on a 5-day moving average) \
vii) The next step is the determination of the slope coefficient. For a set of samples, the slope coefficient is calculated as : (https://www.seabird.com/cms-portals/seabird_com/cms/documents/training/Module10_DataAccuracyFieldCals.pdf) \

### Oxygen (electrochemical sensors)
3) Correction to oxygen sensor calibration
i) If SBE oxygen sensor hysteresis response correction was applied in SBE data conversion, compare upcast CTD oxygen sensor data with bottle oxygens. If not, match the down- and upcast data by pressure or neutral or potential density and compare these downcast CTD sensor values with the bottle oxygens. If potential density is used the reference should not be more than 500 dbar from the bottle stops to which it is applied. In low density gradient regions use pressure matching instead. \
ii) Use data from as many stations as possible to determine a nonlinear fit minimising the squared differences between bottle data and each CTD sensor data. \
a) Owens and Millard equation ... \
b) SBE suggested equation ... \
c) ODF ... \
d) PMEL ... \
iii) residuals after calibration should be small (< 2 umol/kg) and randomly distributed as far as station number, pressure, T, and O

### Oxygen (optodes)
3) Correction to oxygen sensor calibration
...

