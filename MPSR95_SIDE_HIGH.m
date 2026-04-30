function resultsTable = MPSR95_SIDE_HIGH(PLV,PAV)

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
24.095  6.8831  24.610  17.076  24.225  26.620;  % LEFT_PARIETAL
26.687 -2.7125  26.308  4.5756  25.310  15.277;  % RIGHT_PARIETAL
26.962  3.6924  25.977  13.026  24.885  22.509;  % LEFT_FRONTAL
29.443 -7.7750  28.059  1.2471  27.313  8.7791;  % RIGHT_FRONTAL
21.890  3.8500  22.235  8.7860  21.904  14.700;  % LEFT_TEMPORAL
29.957  1.9569  28.842  12.175  28.449  17.965;  % RIGHT_TEMPORAL
18.961 -1.8694  18.956  0.5449  18.454  4.2974;  % LEFT_OCCIPITAL
24.799 -11.492  24.802 -7.0915  25.278 -3.3447;  % RIGHT_OCCIPITAL
31.026 -5.6886  31.587  6.9470  31.976  19.635;  % CEREBELLUM
60.651 -4.5466  60.371  9.9261  60.536  24.962;  % BRAINSTEM
16.759  0.1460  16.856  5.6457  16.932  11.304]; % MIDBRAIN

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
disp('SIDE_HIGH Impact Results')
disp(resultsTable)

end


