function resultsTable = MPS_REAR_LOW(PLV,PAV)

% TOP_REAR estimates MPS for ALL brain regions
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
0.2530 -0.0804  0.2121  0.0401  0.2119  0.0223;  % LEFT_PARIETAL
0.2352 -0.0251  0.1945  0.1172  0.1885  0.1404;  % RIGHT_PARIETAL
0.1162  0.0226  0.1480 -0.0202  0.1513 -0.0034;  % LEFT_FRONTAL
0.1162  0.0195  0.1319  0.0453  0.1264  0.1122;  % RIGHT_FRONTAL
0.1457 -0.1007  0.1214  0.0309  0.1376  0.0398;  % LEFT_TEMPORAL
0.1134  0.2369  0.1004  0.3438  0.0949  0.3985;  % RIGHT_TEMPORAL
0.0404 -0.0151  0.0600  0.0058  0.0707  0.0345;  % LEFT_OCCIPITAL
0.0547 -0.0313  0.0710  0.0039  0.0823  0.0258;  % RIGHT_OCCIPITAL
0.2337  0.0778  0.2052  0.2063  0.2073  0.2185;  % CEREBELLUM
0.2867  0.1533  0.1987  0.4390  0.1975  0.4384;  % BRAINSTEM
0.1973 -0.0569  0.1524  0.0700  0.1527  0.0556]; % MIDBRAIN

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
disp('REAR_LOW Impact Results')
disp(resultsTable)

end


