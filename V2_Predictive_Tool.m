function resultsTable = V2_Predictive_Tool(LOCATION, PLV, PAV)


% V2_Predictive_Tool calculates all results for impact
%
% Inputs:
%   LOCATION - Impact location
%   ["FRONT_HIGH","TOP_FRONT","TOP_REAR","REAR_LOW","REAR_HIGH","SIDE_LOW","SIDE_HIGH"]
%   PLV      - Peak Linear Velocity (1–6 m/s)
%   PAV      - Peak Angular Velocity (6–32 rad/s)
%
% Output:
%   resultsTable - Table of Regional MPS95,VMS95,MPSR95,MPSxSR95,MPS
%
% Sample Call in Command:
%   T = V2_Predictive_Tool("SIDE_LOW", 4, 20);


% -------- Run All Models --------

T1 = MPS95_PREDICTIVE(LOCATION, PLV, PAV);
T2 = VMS95_PREDICTIVE(LOCATION, PLV, PAV);
T3 = MPSR95_PREDICTIVE(LOCATION, PLV, PAV);
T4 = MPSxSR95_PREDICTIVE(LOCATION, PLV, PAV);
T5 = MPS_PREDICTIVE(LOCATION, PLV, PAV);

% -------- Clean Region Column --------
T1.Region = string(T1.Region);
T2.Region = string(T2.Region);
T3.Region = string(T3.Region);
T4.Region = string(T4.Region);
T5.Region = string(T5.Region);

% -------- Join Tables --------

resultsTable = T1;

resultsTable = join(resultsTable, T2, 'Keys', 'Region');
resultsTable = join(resultsTable, T3, 'Keys', 'Region');
resultsTable = join(resultsTable, T4, 'Keys', 'Region');
resultsTable = join(resultsTable, T5, 'Keys', 'Region');

end