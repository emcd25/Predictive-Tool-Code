function resultsTable = MPSR95_REAR_HIGH(PLV,PAV)

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
15.361 -10.175  13.894 -6.8186  13.894 -5.7906;  % LEFT_PARIETAL
15.986 -10.854  14.333 -7.4963  13.447 -6.5330;  % RIGHT_PARIETAL
28.510 -20.557  28.126 -18.415  27.622 -17.417;  % LEFT_FRONTAL
29.057 -21.249  28.553 -19.516  27.854 -18.714;  % RIGHT_FRONTAL
14.412 -10.215  14.199 -7.8750  13.811 -6.4498;  % LEFT_TEMPORAL
16.283 -11.817  16.061 -9.6124  15.454 -7.6339;  % RIGHT_TEMPORAL
9.8400 -6.6931  8.4193 -4.1887  7.9600 -3.8729;  % LEFT_OCCIPITAL
9.7588 -6.6711  8.4024 -4.2550  7.5040 -3.0104;  % RIGHT_OCCIPITAL
13.382 -5.9180  13.885 -4.9716  14.464 -6.1932;  % CEREBELLUM
54.021 -25.530  55.432 -27.803  55.744 -28.987;  % BRAINSTEM
14.208 -11.880  13.203 -6.5610  12.675 -3.4917]; % MIDBRAIN

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
disp('REAR_HIGH Impact Results')
disp(resultsTable)

end


