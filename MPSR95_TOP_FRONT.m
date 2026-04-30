function resultsTable = MPSR95_TOP_FRONT(PLV,PAV)

% Estimates MPSR95 for ALL brain regions
% Inputs:
%   PLV - Peak Linear Velocity (1–6 m/s)
%   PAV - Peak Angular Velocity (6–32 rad/s)

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
% Columns: [MPSR95_S1 MPSR95_Y1 MPSR95_S2 MPSR95_Y2 MPSR95_S3 MPSR95_Y3]

MPSR95_data = [
19.821 -17.342  19.205 -11.836  19.928 -14.622;  % LEFT_PARIETAL
20.895 -19.487  20.396 -14.189  21.128 -17.283;  % RIGHT_PARIETAL
13.853 -9.7129  13.957 -6.3757  14.784 -7.4827;  % LEFT_FRONTAL
12.609 -7.9947  12.682 -4.7482  13.739 -6.6306;  % RIGHT_FRONTAL
17.186 -13.716  17.753 -10.198  18.936 -14.160;  % LEFT_TEMPORAL
17.499 -14.333  18.166 -10.911  19.427 -14.903;  % RIGHT_TEMPORAL
32.320 -22.974  31.440 -15.753  32.128 -21.576;  % LEFT_OCCIPITAL
29.215 -21.110  28.350 -14.365  29.071 -19.661;  % RIGHT_OCCIPITAL
38.256 -25.723  38.466 -17.514  39.867 -22.895;  % CEREBELLUM
37.919 -34.244  39.214 -27.192  41.147 -34.734;  % BRAINSTEM
13.089 -9.1503  13.389 -4.6149  14.451 -7.1306]; % MIDBRAIN

% -------------------- Preallocate --------------------

numRegions = length(regions);
MPSR95_values = zeros(numRegions,1);

% -------------------- Loop Through Regions --------------------

for i = 1:numRegions

    S1 = MPSR95_data(i,1);  Y1 = MPSR95_data(i,2);
    S2 = MPSR95_data(i,3);  Y2 = MPSR95_data(i,4);
    S3 = MPSR95_data(i,5);  Y3 = MPSR95_data(i,6);

    % MPSR95 at each PAV level
    MPSR95_1 = S1*PLV + Y1;
    MPSR95_2 = S2*PLV + Y2;
    MPSR95_3 = S3*PLV + Y3;

    % Linear interpolation
    if PAV < PAV_2
        MPSR95 = MPSR95_1 + (PAV-PAV_1)*((MPSR95_2-MPSR95_1)/(PAV_2-PAV_1));
    else
        MPSR95 = MPSR95_2 + (PAV-PAV_2)*((MPSR95_3-MPSR95_2)/(PAV_3-PAV_2));
    end

    MPSR95_values(i) = round(MPSR95,3);  

end

% -------------------- Create Output Table --------------------

resultsTable = table(regions', MPSR95_values, ...
    'VariableNames', {'Region','MPSR95_s^(-1)'});


% -------------------- Print to Command Window --------------------

disp(' ')
disp('TOP_FRONT Impact Results')
disp(resultsTable)

end


