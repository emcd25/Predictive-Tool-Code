function resultsTable = MPSR95_FRONT_HIGH(PLV,PAV)

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
17.365 -11.948  17.035 -10.850  16.493 -11.388;  % LEFT_PARIETAL
18.094 -13.482  17.878 -12.480  17.152 -12.761;  % RIGHT_PARIETAL
11.771 -6.7872  12.022 -5.9297  11.765 -5.3950;  % LEFT_FRONTAL
11.201 -5.2936  11.215 -4.7330  10.750 -4.5250;  % RIGHT_FRONTAL
13.259 -12.279  13.587 -10.022  13.901 -9.9165;  % LEFT_TEMPORAL
13.224 -12.503  13.629 -10.337  14.016 -10.324;  % RIGHT_TEMPORAL
44.054 -37.588  43.696 -32.511  43.304 -31.622;  % LEFT_OCCIPITAL
40.276 -33.808  39.445 -27.878  39.109 -28.071;  % RIGHT_OCCIPITAL
22.278 -19.618  23.709 -18.083  24.649 -18.614;  % CEREBELLUM
34.603 -12.991  32.984 -7.8903  33.589 -12.831;  % BRAINSTEM
9.2278 -8.0042  8.8441 -4.0669  10.197 -6.6381]; % MIDBRAIN

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
disp('FRONT_HIGH Impact Results')
disp(resultsTable)

end


