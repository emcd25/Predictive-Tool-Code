function resultsTable = MPS_TOP_FRONT(PLV,PAV)

% TOP_FRONT estimates MPS for ALL brain regions
% Inputs:
%   PLV - Peak Linear Velocity (1–6 m/s)
%   PAV - Peak Angular Velocity (6–36 rad/s)

% -------------------- Input Checks --------------------

if PLV < 1 || PLV > 6
    error('PLV must be between 1 and 6 m/s');
end

if PAV < 6 || PAV > 36
    error('PAV must be between 6 and 32 rad/s');
end

% -------------------- PAV Levels --------------------

PAV_1 = 6;
PAV_2 = 19;
PAV_3 = 36;

% -------------------- Region Data --------------------

regions = { ...
"LEFT_PARIETAL","RIGHT_PARIETAL","LEFT_FRONTAL","RIGHT_FRONTAL", ...
"LEFT_TEMPORAL","RIGHT_TEMPORAL","LEFT_OCCIPITAL","RIGHT_OCCIPITAL", ...
"CEREBELLUM","BRAINSTEM","MIDBRAIN"};

% Each row = one region
% Columns: [MPS_S1 MPS_Y1 MPS_S2 MPS_Y2 MPS_S3 MPS_Y3]

MPS_data = [
0.1727 -0.0478  0.1747 -0.0426  0.1770 -0.0427;  % LEFT_PARIETAL
0.1743 -0.0445  0.1754 -0.0389  0.1775 -0.0377;  % RIGHT_PARIETAL
0.2045 -0.0145  0.2071 -0.0048  0.2124 -0.0175;  % LEFT_FRONTAL
0.2044 -0.0150  0.2077 -0.0069  0.2129 -0.0192;  % RIGHT_FRONTAL
0.1475 -0.0743  0.1507 -0.0711  0.1544 -0.0830;  % LEFT_TEMPORAL
0.1493 -0.0727  0.1528 -0.0695  0.1562 -0.0809;  % RIGHT_TEMPORAL
0.0644 -0.0251  0.0643 -0.0004  0.0676 -0.0247;  % LEFT_OCCIPITAL
0.0627 -0.0246  0.0565  0.0112  0.0610 -0.0169;  % RIGHT_OCCIPITAL
0.0852  0.1809  0.0804  0.2262  0.0811  0.2286;  % CEREBELLUM
0.0990  0.0489  0.1240  0.0299  0.1057  0.0562;  % BRAINSTEM
0.1466 -0.0709  0.1496 -0.0668  0.1532 -0.0784]; % MIDBRAIN

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
disp('TOP_FRONT Impact Results')
disp(resultsTable)

end


