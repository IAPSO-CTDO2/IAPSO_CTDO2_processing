# Source/version: 

NOC-OCP Mexec/ocp_hydro_matlab
https://github.com/NOC-OCP/ocp_hydro_matlab

## A) Data quality control (primary/1QC)

1) After each cast examine differencees between primary and secondary sensors over a homogenous part of the water column
2) Compare SBE35 data with CTD temperature at bottle stops
3) Examine pre- and post-cast on-deck pressure over the course of the cruise
4) Compare data from most recent cast to previous casts
5) Compare CTD C and O to sample data as they become available
6) Suspect sensors with drift over 0.002 C (T), 0.005 mS/cm (C), 15 umol/kg (O), 2 dbar (P)

## B) Data processing

1) SBE Data Conversion (raw to engineering units, outputs scan number, elapsed time, p, t0, t1, c0, c1, oxygen voltage(s), and other [e.g. optical sensor] voltages). Optionally, apply oxygen sensor hysteresis; apply time lag corections at this stage (using nominal coefficients). 
2) Optionally: SBE Align CTD
3) Optionally: SBE Cell Thermal Mass
4) Read into Matlab, apply whichever of Align, Cell Thermal Mass, and Oxygen Hysteresis adjustments were not done above (nominal coefficients by default; oxygen hysteresis coefficients may be customised). Apply user-selected calibrations (when available) to T, C, O. 
5) Wild Edit equivalent: inspect 24 Hz data and set parameters for automatic edits (e.g. despiking, cutting out scan ranges) or select points to remove using a GUI. Apply optional automatic (e.g. despiking) or previously-selected manual edits. 
6) Compute salinity, average to 1 Hz
7) Remove start and end of cast, and check bottom of cast detection
8) Bottle Summary equivalent: Extract bottle firing data (settable time interval)
9) Bin Average equivalent: Compute 2 dbar down and upcast profiles (settable averaging method), optionally applying Loop Edit equivalent to downcast data before averaging.
10) Data at various steps are saved to .nc files; 2 dbar downcast data as well as bottle summary data are output to exchange-format .csv files (options to also output e.g. 1Hz data for LADCP processing, customised bottle summary files for chemists, etc.)


## C) Data corrections
### Pressure, Temperature, Conductivity
1) Adjust pressure using the deviation of the equilibrated surface pressure (10 minutes after power on) from atmospheric; generally only do this at the start of the cruise
2) Corrections to T and C calibrations
i) Use systematic comparisons between sensor data and an independent measure (e.g. SBE35, water sample salinity) \
ii) Corrections can potentially vary by cast, but usually should be a very few different sets during the cruise, or slowly evolving with shifts only due to fouling or mechanical shock events\
iii) If no SBE35 is available, there is usually no adjustment to the pre-cruise laboratory calibration coefficients. If SBE35 is available, examine residual differences for pressure dependence or time drifts. \
iv) Apply adjustments to conductivity (not salinity). First finalise CTD pressure and temperature. Then compare, at bottle closures, a) primary and secondary CTD conductivity, and b) each CTD conductivity with conductivity derived from bottle sample salinity and CTD T and P. Use the gradient of the CTD profile in the neighbouring several meters, as well as variance at the bottle stop, to decide which points have lower confidence for comparison; use a) to detect package wake effects. For each sensor, look for a conductivity factor that varies slowly in pressure (often piecewise linear) and usually slowly in time (but may have shifts) and minimises the width of the distribution of residuals (accounting for points with lower confidence). Use a), deep T-S properties, and other parameters where available to look out for bottle data issues. Apply calibrations in B4. \

## Oxygen (electrochemical sensors)
3) Correction to oxygen sensor calibration
i) If SBE oxygen sensor hysteresis response correction was applied in SBE data conversion, compare upcast CTD oxygen sensor data with bottle oxygens. If not, match the down- and upcast data by pressure or neutral or potential density and compare these downcast CTD sensor values with the bottle oxygens. If potential density is used the reference should not be more than 500 dbar from the bottle stops to which it is applied. In low density gradient regions use pressure matching instead. \
ii) Use data from as many stations as possible to determine a nonlinear fit, possibly a function of pressure and time (or, rarely, temperature instead), minimising the width of the distribution of ratios between bottle data and each CTD sensor data (after excluding residuals and high-gradient/high-variance points). \
iii) residuals after calibration should be small (< 2 umol/kg) and randomly distributed as far as station number, pressure, T, and O\

