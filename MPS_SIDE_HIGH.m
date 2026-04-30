function resultsTable = MPS_SIDE_HIGH(PLV,PAV)

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
0.1552  0.0261  0.1536  0.0588  0.1530  0.0963;  % LEFT_PARIETAL
0.1796 -0.0291  0.1765  0.0124  0.1731  0.0647;  % RIGHT_PARIETAL
0.1492  0.0144  0.1478  0.0445  0.1476  0.0806;  % LEFT_FRONTAL
0.1793 -0.0569  0.1840 -0.0288  0.1856 -0.0079;  % RIGHT_FRONTAL
0.1062  0.0934  0.1041  0.1225  0.1039  0.1546;  % LEFT_TEMPORAL
0.1726  0.0448  0.1589  0.1224  0.1559  0.1551;  % RIGHT_TEMPORAL
0.0673  0.0792  0.0586  0.1241  0.0549  0.1504;  % LEFT_OCCIPITAL
0.1283 -0.0386  0.1310 -0.0193  0.1382 -0.0151;  % RIGHT_OCCIPITAL
0.1314  0.1587  0.1332  0.2018  0.1347  0.2407;  % CEREBELLUM
0.1641  0.2310  0.1626  0.2806  0.1660  0.3272;  % BRAINSTEM
0.1277 -0.0038  0.1236  0.0395  0.1262  0.0679]; % MIDBRAIN

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
disp('SIDE_HIGH Impact Results')
disp(resultsTable)

end


