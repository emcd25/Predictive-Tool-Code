function resultsTable = MPS_SIDE_LOW(PLV,PAV)

% SIDE_LOW estimates MPS for ALL brain regions
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
0.1103  0.0061  0.1152 -0.0064  0.1140  0.0202;  % LEFT_PARIETAL
0.1164  0.0168  0.1313 -0.0518  0.1345 -0.0307;  % RIGHT_PARIETAL
0.1063 -0.0076  0.1119 -0.0398  0.1106 -0.0467;  % LEFT_FRONTAL
0.1483 -0.0442  0.1520 -0.0908  0.1621 -0.0897;  % RIGHT_FRONTAL
0.1246  0.0280  0.1254  0.0056  0.1189  0.0288;  % LEFT_TEMPORAL
0.1168 -0.0136  0.1353 -0.0819  0.1371 -0.0532;  % RIGHT_TEMPORAL
0.1019  0.0220  0.1028 -0.0049  0.0970 -0.0007;  % LEFT_OCCIPITAL
0.0911  0.0017  0.1031 -0.0490  0.1077 -0.0702;  % RIGHT_OCCIPITAL
0.1504  0.0747  0.1522  0.1133  0.1604  0.1254;  % CEREBELLUM
0.1904  0.1257  0.1857  0.1950  0.1954  0.213;  % BRAINSTEM
0.1078 -0.0395  0.1086 -0.0226  0.1119 -0.0132]; % MIDBRAIN

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
disp('SIDE_LOW Impact Results')
disp(resultsTable)

end


