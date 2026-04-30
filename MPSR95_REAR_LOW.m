function resultsTable = MPSR95_REAR_LOW(PLV,PAV)

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
28.371 -18.644  24.082  8.6348  23.204  18.285;  % LEFT_PARIETAL
30.279 -20.744  25.205  7.6516  24.160  17.212;  % RIGHT_PARIETAL
48.134 -30.441  39.633 -1.3590  37.499  5.1806;  % LEFT_FRONTAL
48.370 -29.801  40.925 -1.9227  38.838  5.1444;  % RIGHT_FRONTAL
24.544 -16.444  21.303  1.2538  21.907  4.5649;  % LEFT_TEMPORAL
26.813 -17.382  22.952  1.3419  23.491  4.7662;  % RIGHT_TEMPORAL
15.895 -8.6215  16.148  6.1471  17.608  11.488;  % LEFT_OCCIPITAL
15.621 -7.9470  15.016  8.1371  16.254  13.350;  % RIGHT_OCCIPITAL
26.652 -12.345  28.504  2.0317  32.233  3.5699;  % CEREBELLUM
112.91 -50.079  106.56  3.0642  107.75  10.931;  % BRAINSTEM
20.009 -13.110  22.229 -5.4564  23.644 -0.2233]; % MIDBRAIN

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
disp('REAR_LOW Impact Results')
disp(resultsTable)

end


