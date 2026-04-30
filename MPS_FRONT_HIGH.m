function resultsTable = MPS_FRONT_HIGH(PLV,PAV)

% SIDE_HIGH estimates MPS for ALL brain regions
% Inputs:
%   PLV - Peak Linear Velocity (1–6 m/s)
%   PAV - Peak Angular Velocity (6–36 rad/s)

% -------------------- Input Checks --------------------

if PLV < 1 || PLV > 6
    error('PLV must be between 1 and 6 m/s');
end

if PAV < 6 || PAV > 32
    error('PAV must be between 6 and 32 rad/s');
end

% -------------------- PAV Levels --------------------

PAV_1 = 6;
PAV_2 = 19;
PAV_3 = 32;

% -------------------- Region Data --------------------

regions = { ...
"LEFT_PARIETAL","RIGHT_PARIETAL","LEFT_FRONTAL","RIGHT_FRONTAL", ...
"LEFT_TEMPORAL","RIGHT_TEMPORAL","LEFT_OCCIPITAL","RIGHT_OCCIPITAL", ...
"CEREBELLUM","BRAINSTEM","MIDBRAIN"};

% Each row = one region
% Columns: [MPS_S1 MPS_Y1 MPS_S2 MPS_Y2 MPS_S3 MPS_Y3]

MPS_data = [
0.1310 -0.0833  0.1311 -0.0768  0.1315 -0.0607;  % LEFT_PARIETAL
0.1333 -0.0846  0.1334 -0.0785  0.1366 -0.0762;  % RIGHT_PARIETAL
0.2045 -0.0823  0.2035 -0.0768  0.2024 -0.0576;  % LEFT_FRONTAL
0.2050 -0.0835  0.2039 -0.0781  0.2027 -0.0586;  % RIGHT_FRONTAL
0.1587 -0.1122  0.1579 -0.1104  0.1589 -0.1056;  % LEFT_TEMPORAL
0.1624 -0.1143  0.1612 -0.1112  0.1623 -0.1054;  % RIGHT_TEMPORAL
0.0705 -0.0016  0.0770 -0.0264  0.0814 -0.0425;  % LEFT_OCCIPITAL
0.0754 -0.0129  0.0834 -0.0396  0.0886 -0.0593;  % RIGHT_OCCIPITAL
0.0831  0.1672  0.0862  0.1480  0.0990  0.0935;  % CEREBELLUM
0.1162  0.1716  0.1151  0.1692  0.1277  0.1104;  % BRAINSTEM
0.1615 -0.1135  0.1595 -0.1094  0.1613 -0.1061]; % MIDBRAIN

% -------------------- Preallocate --------------------

numRegions = length(regions);
MPS_values = zeros(numRegions,1);

% -------------------- Loop Through Regions --------------------

for i = 1:numRegions

    S1 = MPS_data(i,1);  Y1 = MPS_data(i,2);
    S2 = MPS_data(i,3);  Y2 = MPS_data(i,4);
    S3 = MPS_data(i,5);  Y3 = MPS_data(i,6);

    % MPS at each PAV level
    MPS_1 = S1*PLV + Y1;
    MPS_2 = S2*PLV + Y2;
    MPS_3 = S3*PLV + Y3;

    % Linear interpolation
    if PAV < PAV_2
        MPS = MPS_1 + (PAV-PAV_1)*((MPS_2-MPS_1)/(PAV_2-PAV_1));
    else
        MPS = MPS_2 + (PAV-PAV_2)*((MPS_3-MPS_2)/(PAV_3-PAV_2));
    end

    MPS_values(i) = round(MPS*100,3);  % Convert to %

end

% -------------------- Create Output Table --------------------

resultsTable = table(regions', MPS_values, ...
    'VariableNames', {'Region','MPS_percent'});


% -------------------- Print to Command Window --------------------

disp(' ')
disp('FRONT_HIGH Impact Results')
disp(resultsTable)

end


