# Source/version: 
C Langdon oxygen processing\
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
1) SBE Data Conversion (raw to engineering units, outputs scan number, elapsed time, p, t0, t1, c0, c1, density (simga-theta), oxygen in umol/kg units. Apply SBE43 oxygen sensor hysteresis and tau corections. Convert downcast only.
2) SBE Align CTD
3) SBE Bin Average


## C) Data corrections

### Pressure, Temperature, Conductivity
1) Adjust pressure using the deviation of the equilibrated surface pressure (10 minutes after power on) from atmospheric; generally only do this at the start of the cruise
2) Corrections to T and C calibrations
i) Use systematic comparisons between sensor data and an independent measure (e.g. SBE35, water sample salinity) \
ii) Corrections can potentially vary by cast, but usually should be a very few different sets during the cruise, or slowly evolving with shifts only due to fouling or mechanical shock events \
iii) Apply a viscous heating correction of -0.0006 C to T. Look for a slow linear drift in calibration. If no SBE35 is available, incorporate the pre- and post-cruise calibrations into a linear fit, then apply the value at the cruise midpoint as a single adjustment.  If SBE35 is available, remove pressure dependence of SBE35 vs SBE3+. Examine residual differences for other drifts. \
iv) Apply adjustments to conductivity (not salinity). First finalise CTD pressure and temperature. Then compare, at bottle closures, a) primary and secondary CTD conductivity, and b) each CTD conductivity with conductivity derived from bottle sample salinity and CTD T and P. Use a) to check for package wake effects. Look for a linear or quadratic fit to conductivity residuals, possibly also including a linear or quadratic pressure dependence, generally of the form C_cor = C + cp2*P^2 + cp1*P + c2*C^2 + c1*C + c0. Outliers are removed iteratively using a standard deviation-based threshold. Regression coefficients should be calculated per-station, but where possible a single set of regression coefficients, possibly including a slow time or station-number dependence, per sensor should be used. Not all the terms will necessarily be used. Either sudden changes in sensor residuals (requiring more than one set of coefficients) or drifts in time may be incorporated. Use deep T-S properties to look out for bottle data issues. Post-cruise laboratory calibrations can be used to check the sensors but bottle data should be used to apply calibrations.  

### Oxygen (electrochemical sensors)

1) Match downcast oxygen sensor data to bottle oxygen using potential density as key

2) Use data from as many stations as possible to determine linear fit minimising the squared differences between bottle data and each CTD sensor data. 

3) Residuals after calibration should be small (< 3 umol/kg) and randomly distributed as far as station number, pressure, T, and O



