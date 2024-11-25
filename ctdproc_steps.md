# Source/version: 
C Langdon oxygen processing
McTaggart et al., 2010, Notes on CTD/O2 Data Acquisition and Processing Using Sea-Bird Hardware and Software (as available). \
Uchida et al., 2010, CTD Oxygen Sensor Calibration Procedures. \
Note: Draft. "..." indicates details to be filled in. 

## A) Data quality control (primary/1QC)
1) After each cast examine differences between primary and secondary sensors over a homogenous part of the water column
2) Compare SBE35 data with CTD temperature at bottle stops
3) Examine pre- and post-cast on-deck pressure over the course of the cruise
4) Compare data from most recent cast to previous casts
5) Compare CTD C and O to sample data as they become available
6) Suspect sensors with drift over 0.002 C (T), 0.005 mS/cm (C), 15 umol/kg (O), 2 dbar (P)

## B) Data processing
1) SBE Data Conversion (raw to engineering units, outputs scan number, elapsed time, p, t0, t1, c0, c1, oxygen voltage(s), and other [e.g. optical sensor] voltages). Optionally, remove surface soak time at this stage, and apply oxygen sensor hysteresis and time lag corections (using nominal coefficients is not recommended). May correct for oxygen sensor hysteresis at this stage. 
2) SBE Align CTD
3) SBE Bottle Summary
4) SBE Wild Edit
5) SBE Filter
6) SBE Cell Thermal Mass
7) SBE Loop Edit
8) SBE Derive
9) SBE Bin Average
10) SBE Translate

## C) Data corrections

### Pressure, Temperature, Conductivity
1) Adjust pressure using the deviation of the equilibrated surface pressure (10 minutes after power on) from atmospheric; generally only do this at the start of the cruise
2) Corrections to T and C calibrations
i) Use systematic comparisons between sensor data and an independent measure (e.g. SBE35, water sample salinity) \
ii) Corrections can potentially vary by cast, but usually should be a very few different sets during the cruise, or slowly evolving with shifts only due to fouling or mechanical shock events \
iii) Apply a viscous heating correction of -0.0006 C to T. Look for a slow linear drift in calibration. If no SBE35 is available, incorporate the pre- and post-cruise calibrations into a linear fit, then apply the value at the cruise midpoint as a single adjustment.  If SBE35 is available, remove pressure dependence of SBE35 vs SBE3+. Examine residual differences for other drifts. \
iv) Apply adjustments to conductivity (not salinity). First finalise CTD pressure and temperature. Then compare, at bottle closures, a) primary and secondary CTD conductivity, and b) each CTD conductivity with conductivity derived from bottle sample salinity and CTD T and P. Use a) to check for package wake effects. Look for a linear or quadratic fit to conductivity residuals, possibly also including a linear or quadratic pressure dependence, generally of the form C_cor = C + cp2*P^2 + cp1*P + c2*C^2 + c1*C + c0. Outliers are removed iteratively using a standard deviation-based threshold. Regression coefficients should be calculated per-station, but where possible a single set of regression coefficients, possibly including a slow time or station-number dependence, per sensor should be used. Not all the terms will necessarily be used. Either sudden changes in sensor residuals (requiring more than one set of coefficients) or drifts in time may be incorporated. Use deep T-S properties to look out for bottle data issues. Post-cruise laboratory calibrations can be used to check the sensors but bottle data should be used to apply calibrations.  

### Oxygen (electrochemical sensors)
3) Correction to oxygen sensor calibration
i) If SBE oxygen sensor hysteresis response correction was applied in SBE data conversion, compare upcast CTD oxygen sensor data with bottle oxygens. If not, match the down- and upcast data by pressure or neutral or potential density and compare these downcast CTD sensor values with the bottle oxygens. If potential density is used the reference should not be more than 500 dbar from the bottle stops to which it is applied. In low density gradient regions use pressure matching instead. \
ii) Use data from as many stations as possible to determine a nonlinear fit minimising the squared differences between bottle data and each CTD sensor data. \
a) Owens and Millard equation ... \
b) SBE suggested equation ... \
c) ODF ... \
d) PMEL ... \
iii) residuals after calibration should be small (< 2 umol/kg) and randomly distributed as far as station number, pressure, T, and O



