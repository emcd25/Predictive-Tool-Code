function resultsTable = MPSR95_TOP_REAR(PLV,PAV)

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
9.4107 -7.7824  8.2097  1.4270  8.6544  3.4188;  % LEFT_PARIETAL
9.6617 -8.1846  8.5415  0.3903  8.9110  2.3324;  % RIGHT_PARIETAL
16.885 -13.051  16.700 -6.7701  16.814 -4.1232;  % LEFT_FRONTAL
16.014 -11.775  15.850 -5.8000  16.038 -3.4621;  % RIGHT_FRONTAL
11.675 -9.2211  11.961 -5.0436  12.052 -4.7109;  % LEFT_TEMPORAL
12.506 -9.6879  12.939 -5.7025  12.922 -5.4531;  % RIGHT_TEMPORAL
6.0610 -4.3584  5.4425  2.5784  6.4033  2.1438;  % LEFT_OCCIPITAL
6.0081 -4.4176  5.1981  2.9030  6.1404  2.3633;  % RIGHT_OCCIPITAL
13.095 -10.226  13.558 -5.2107  14.462 -7.9212;  % CEREBELLUM
30.878 -13.889  32.939 -9.8446  35.556 -16.979;  % BRAINSTEM
10.367 -5.5378  11.058 -2.0645  10.424  0.1501]; % MIDBRAIN

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
disp('TOP_REAR Impact Results')
disp(resultsTable)

end


