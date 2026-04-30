function resultsTable = MPSxSR95_FRONT_HIGH(PLV,PAV)

% Estimates MPSxSR95 for ALL brain regions
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
% Columns: [MPSxSR95_S1 MPSxSR95_Y1 MPSxSR95_S2 MPSxSR95_Y2 MPSxSR95_S3 MPSxSR95_Y3]

MPSxSR95_data = [
0.8646 -1.3194  0.8355 -1.3005  0.7672 -1.2620;  % LEFT_PARIETAL
0.9004 -1.4104  0.8836 -1.4103  0.8051 -1.3498;  % RIGHT_PARIETAL
0.4100 -0.5584  0.4246 -0.6087  0.4053 -0.6073;  % LEFT_FRONTAL
0.3867 -0.4835  0.3869 -0.5290  0.3556 -0.5189;  % RIGHT_FRONTAL
0.4916 -0.7827  0.5432 -0.8776  0.5507 -0.9051;  % LEFT_TEMPORAL
0.5008 -0.8087  0.5571 -0.9132  0.5693 -0.9484;  % RIGHT_TEMPORAL
5.3319 -8.3511  5.3318 -8.2606  5.1408 -8.1588;  % LEFT_OCCIPITAL
4.4650 -7.0012  4.4150 -6.8401  4.1969 -6.6715;  % RIGHT_OCCIPITAL
1.4912 -2.3989  1.7398 -2.7834  1.8415 -2.9956;  % CEREBELLUM
6.7521 -9.3303  6.3162 -8.3366  6.1963 -8.6359;  % BRAINSTEM
0.3013 -0.4530  0.3174 -0.4770  0.3486 -0.5432]; % MIDBRAIN

% -------------------- Preallocate --------------------

numRegions = length(regions);
MPSxSR95_values = zeros(numRegions,1);

% -------------------- Loop Through Regions --------------------

for i = 1:numRegions

    S1 = MPSxSR95_data(i,1);  Y1 = MPSxSR95_data(i,2);
    S2 = MPSxSR95_data(i,3);  Y2 = MPSxSR95_data(i,4);
    S3 = MPSxSR95_data(i,5);  Y3 = MPSxSR95_data(i,6);

    % MPSxSR95 at each PAV level
    MPSxSR95_1 = S1*PLV + Y1;
    MPSxSR95_2 = S2*PLV + Y2;
    MPSxSR95_3 = S3*PLV + Y3;

    % Linear interpolation
    if PAV < PAV_2
        MPSxSR95 = MPSxSR95_1 + (PAV-PAV_1)*((MPSxSR95_2-MPSxSR95_1)/(PAV_2-PAV_1));
    else
        MPSxSR95 = MPSxSR95_2 + (PAV-PAV_2)*((MPSxSR95_3-MPSxSR95_2)/(PAV_3-PAV_2));
    end

    % if the result is less than zero, set it equal to zero
    MPSxSR95 = max(MPSxSR95, 0);
    MPSxSR95_values(i) = round(MPSxSR95,3);

    MPSxSR95_values(i) = round(MPSxSR95,3);  % Convert to %

end

% -------------------- Create Output Table --------------------

resultsTable = table(regions', MPSxSR95_values, ...
    'VariableNames', {'Region','MPSxSR95_s^(-1)'});


% -------------------- Print to Command Window --------------------

disp(' ')
disp('FRONT_HIGH Impact Results')
disp(resultsTable)

end


