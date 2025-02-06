# Source/version: 
McTaggart et al., 2010, Notes on CTD/O2 Data Acquisition and Processing Using Sea-Bird Hardware and Software (as available). \
Uchida et al., 2010, CTD Oxygen Sensor Calibration Procedures. \
+ICES WGOH CTD Intercomparison Project: Methodology Document
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
   - derive_time_window_docdt = seconds: 2
   - derive_ox_tau_correction = yes
6) SBE Bin Average: Apply 1 dbar binning 
7) SBE Split the output of SBE Bin Average into down- and upcast
8) SBE Data Conversion again with Create file types = create bottle file only
9) SBE Bottle Summary

## C) Data corrections

### Pressure, Temperature, Conductivity
We use recently calibrated CTD sensors in pair
No correction on T and P (unless significant difference between the pair of CTD)
Corrections to C calibrations
i) Use systematic comparisons between sensor data and an independent measure (Autosal water sample salinity) \
ii) Corrections can potentially vary by cast, but usually should be a very few different sets during the cruise, or slowly evolving with shifts only due to fouling or mechanical shock events \
iii) Compare and derive adjustments to salinity. Inspect the residuals to identify and flag outliers/bad salinometer values. After excluding these values as well as the top 500 m, for each CTD, calculate a slope as the factor between the sum over samples of CTD x bottle and the sum over samples of CTD x CTD. conductivity (not salinity). the slope coefficient is calculated as : (https://www.seabird.com/cms-portals/seabird_com/cms/documents/training/Module10_DataAccuracyFieldCals.pdf) \
iv) The xmlcon files are then edited with corrected slope coeficient and files are reprocessed to obtain corrected salinity profiles (re-running steps in B).
 
### Oxygen (electrochemical sensors)
SBE43 oxygen values are adjusted with an iterative procedure.
i) SBE_Oxygen value (O2_SBE43) is calculated based on this equation for each sample where there is a O2_Winkler sample (O2_W). The sum of the square distance between each O2_W and O2_SBE_43 is computed. \
ii) This sum is then minimised using the evolutionary Excel solver function by adjusting the SOC, Offset and E parameters of the Seabird equation. \
iii) For each sample, the value of the distance between the O2W and O2SBE43 is computed and any distance greater that +/-2*Sd is removed. \
iv) The solver function is run again until there are no more distance value greater than +/-2*Sd. It can take several iterations, in this case it took 10 iterations. \
v) The adjusted SOC, Offset and E value are then used in the xlmcon file to generate the new adjusted profiles
[following SBE Application Note AN64-2] (re-running steps in B).\


