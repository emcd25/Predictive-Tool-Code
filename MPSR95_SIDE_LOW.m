function resultsTable = MPSR95_SIDE_LOW(PLV,PAV)

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
20.414 -5.4847  21.798 -4.3762  21.388  2.0820;  % LEFT_PARIETAL
29.620 -7.3407  29.687 -2.4693  28.535  1.3361;  % RIGHT_PARIETAL
24.773 -5.7063  25.425 -11.887  24.187 -11.110;  % LEFT_FRONTAL
32.910 -18.564  33.375 -16.921  31.582 -8.4191;  % RIGHT_FRONTAL
25.517 -5.1209  26.121 -10.061  24.746 -8.3905;  % LEFT_TEMPORAL
26.520 -8.3641  27.272 -8.6572  26.511 -2.8659;  % RIGHT_TEMPORAL
21.605 -1.5818  22.426 -7.1862  21.300 -6.9844;  % LEFT_OCCIPITAL
18.468  3.4322  19.792 -5.2794  20.234 -9.6356;  % RIGHT_OCCIPITAL
22.523 -11.788  23.448 -7.9308  23.586  0.2611;  % CEREBELLUM
73.297 -57.499  74.328 -38.444  78.002 -28.720;  % BRAINSTEM
13.478 -0.0148  13.479  0.1596  13.110  3.4797]; % MIDBRAIN

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
disp('SIDE_LOW Impact Results')
disp(resultsTable)

end


