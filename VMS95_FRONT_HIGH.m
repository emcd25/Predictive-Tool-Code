function resultsTable = VMS95_FRONT_HIGH(PLV,PAV)

% Estimates VMS95 for ALL brain regions
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
% Columns: [VMS95_S1 VMS95_Y1 VMS95_S2 VMS95_Y2 VMS95_S3 VMS95_Y3]

VMS95_data = [
20155.0 -7632.00  16918.0  20281.0  12020.0  60424.0;  % LEFT_PARIETAL
1033.70 -33.1610  995.260  54.6820  926.150  70.6710;  % RIGHT_PARIETAL
24294.0 -8599.90  19574.0  28453.0  12878.0  82263.0;  % LEFT_FRONTAL
653.760  755.750  607.740  726.550  507.070  872.220;  % RIGHT_FRONTAL
9600.00 -5909.80  9387.60  780.150  10685.0  1547.40;  % LEFT_TEMPORAL
769.840  246.920  827.150  13.6090  794.330  41.1670;  % RIGHT_TEMPORAL
6904.50 -3939.60  7441.00 -4383.60  7578.90 -4496.30;  % LEFT_OCCIPITAL
2019.60 -80.9310  2067.00 -335.720  2041.90 -691.250;  % RIGHT_OCCIPITAL
39808.0 -10583.0  32035.0  42095.0  22926.0  113795.0;  % CEREBELLUM
41801.0  2533.70  35490.0  61634.0  28690.0  137776.0;  % BRAINSTEM
889.170  524.450  838.680  421.300  741.020  671.690]; % MIDBRAIN

% -------------------- Preallocate --------------------

numRegions = length(regions);
VMS95_values = zeros(numRegions,1);

% -------------------- Loop Through Regions --------------------

for i = 1:numRegions

    S1 = VMS95_data(i,1);  Y1 = VMS95_data(i,2);
    S2 = VMS95_data(i,3);  Y2 = VMS95_data(i,4);
    S3 = VMS95_data(i,5);  Y3 = VMS95_data(i,6);

    % VMS95 at each PAV level
    VMS95_1 = S1*PLV + Y1;
    VMS95_2 = S2*PLV + Y2;
    VMS95_3 = S3*PLV + Y3;

    % Linear interpolation
    if PAV < PAV_2
        VMS95 = VMS95_1 + (PAV-PAV_1)*((VMS95_2-VMS95_1)/(PAV_2-PAV_1));
    else
        VMS95 = VMS95_2 + (PAV-PAV_2)*((VMS95_3-VMS95_2)/(PAV_3-PAV_2));
    end

    VMS95_values(i) = round(VMS95,3); 

end

% -------------------- Create Output Table --------------------

resultsTable = table(regions', VMS95_values, ...
    'VariableNames', {'Region','VMS95_Pa'});


% -------------------- Print to Command Window --------------------

disp(' ')
disp('FRONT_HIGH Impact Results')
disp(resultsTable)

end


