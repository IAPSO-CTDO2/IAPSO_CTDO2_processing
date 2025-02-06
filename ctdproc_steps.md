# Source/version: 
ICES WGOH CTD Intercomparison Project: Methodology Document
(Draft translation from .pdf by YLF, to be edited by KS)

## A) Data quality control (primary/1QC)
1) After each cast examine differences between primary and secondary sensors over a homogenous part of the water column
2) Compare CTD C and Oxy to sample data as they become available (use to flag bottle salinity/oxygen)
3) Suspect sensors with drift over 0.002 °C (T), 0.005 mS/cm (C), 15 umol/kg (O)

## B) Data processing
1) SBE Data Conversion (raw to engineering units, outputs scan number, elapsed time, p, t0, t1, c0, c1, oxygen voltage(s), and other [e.g. optical sensor] voltages). Include Latitute and Longitude in the selected output variables (are needed for LADCP processing)  
2) SBE Align CTD, using a 3 second lag for oxygen sensor and optical sensors. 
3) SBE Cell Thermal Mass using default parameters (0.03 for thermal anomaly amplitude and 7 for thermal anomaly time constant). 
4) SBE Derive: Compute additional variables like salinity, potential temperature, density, oxygen saturation, oxygen in µmol/kg and apply hysteresis correction if profiles exceed 1000 m depth.
5) SBE Bin Average: Apply 1 dbar binning 
6) SBE Split the output of SBE Bin Average into down- and upcast
7) SBE Data Conversion again with Create file types = create bottle file only
8) SBE Bottle Summary

## C) Data corrections

### Pressure, Temperature, Conductivity
1) Pressure: no correction
2) Corrections to T and C calibrations
i) Use systematic comparisons between sensor data and an independent measure (e.g. SBE35, water sample salinity) \
ii) Corrections can potentially vary by cast, but usually should be a very few different sets during the cruise, or slowly evolving with shifts only due to fouling or mechanical shock events \
iii) Over the whole cruise, compare two CTD T sensors, and compare each vs SBE35 data, first as functions of pressure then as functions of time. If mean differences are within the expected accuracy as listed by McTaggart et al., 2010, apply no calibration. \
iv) Compare and derive adjustments to salinity. Inspect the residuals to identify and flag outliers/bad salinometer values. After excluding these values as well as the top 500 m, for each CTD, calculate a slope as the factor between the sum over samples of CTD x bottle and the sum over samples of CTD x CTD. conductivity (not salinity).  \
v) Apply to data by modifying the coefficients in the XMLCON file(s) according to these slopes, and re-running steps in B.
 
### Oxygen (electrochemical sensors)
3) Correction to oxygen sensor calibration
i) Convert CTD oxygen to umol/kg (?)\
ii) For each CTD, compare residuals of Winkler - CTD, as a function of pressure; exclude outlier stations or samples based on inspection (qualitative?)\
iii) Plot the ratios Winkler/CTD and exclude any additional outlier measurements\
iv) For each CTD, minimize the residual of the squared differences between Winkler and CTD oxygen by using excel's solver function starting with the SBE default coefficients for SOC (slope), VOffset, and E (pressure correction) [following SBE Application Note AN64-2] to find new coefficients for the conversion from oxygen voltage to engineering units. This may be done for all stations or a group of stations. \
v) Apply to data by modifying the SOC, VOffset, and E coefficients in XMLCON file(s), and re-running steps in B.

7) Use ODV to inspect processed (averaged, downcast) data [only after steps in C?] to flag very low salinity (or large sensor-sensor salinity differences) or negative oxygen values. 
... source document is for post-cruise processing; fill in details for operation/QC on a cruise or othewise ...
   Use ODV or similar visualization tools to identify anomalies, particularly in surface layers and regions with strong gradients.
