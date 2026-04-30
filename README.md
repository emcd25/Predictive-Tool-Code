# Predictive-Tool-Code
These MATLAB scripts comprise the full code for the predictive tool developed in this thesis. 

For each injury metric - MPS, MPS95, MPSR95, MPSxSR95 and VMS95 - there are seperate scripts for each impact location. Each script contains the corresponding regression equations that are used to estimate the injury metric values in each anatomical brain region. For example, the script "MPS95_FRONT_HIGH.m" will give regional estimates of MPS95 for a front high impact, based on the user-input values of PLV and PAV for the impact case.

In addition to these location-specific scripts, there are metric-specific predictive tools. These allow the user to simply input the impact's location, PLV and PAV, then it calls the appropriate location-specific script. For example, "MPS95_Predictive" is the predictive tool for regional estimates of MPS95. If the user specifies a "FRONT_HIGH" impact, this tool will apply the "MPS95_FRONT_HIGH.m" script to give regional estimates of MPS95 for an impact with the user-input values of PLV and PAV.

Finally, the script "V2_Predictive_Tool.m" will provide regional estimates for all of the injury metrics. Given the impact's location, PLV and PAV, this script calls each metric-specific predictive tool - "MPS_Predictive", "MPS95_Predictive", "MPSR95_Predictive", "MPSRxSR95_Predictive" and "VMS95_Predictive". Each of these then apply the corresponding location-specific script ( e.g., "MPS_FRONT_HIGH.m", "MPS95_FRONT_HIGH.m", etc.). The output is a table containing regional estimates of all injury metrics for the specified impact case.

