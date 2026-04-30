function resultsTable = VMS95_SIDE_LOW(PLV,PAV)

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
36129.0 -28866.0  37697.0 -25149.0  38494.0 -18301.0;  % LEFT_PARIETAL
2980.20  1197.00  2952.40  1086.00  2917.40  1481.10;  % RIGHT_PARIETAL
42432.0 -29183.0  44657.0 -26198.0  45384.0 -17192.0;  % LEFT_FRONTAL
3224.30  354.010  3079.20  315.030  2925.10  917.090;  % RIGHT_FRONTAL
17165.0 -16550.0  19197.0 -18039.0  20175.0 -14976.0;  % LEFT_TEMPORAL
2878.40  1090.50  2936.20  377.250  2822.10  936.810;  % RIGHT_TEMPORAL
8610.10 -3537.00  8668.20 -3535.90  8491.30 -2057.00;  % LEFT_OCCIPITAL
2608.40  2018.90  2774.70  16.1960  2726.20 -851.850;  % RIGHT_OCCIPITAL
63888.0 -59478.0  68729.0 -62485.0  70602.0 -50565.0;  % CEREBELLUM
36192.0 -32995.0  37622.0 -29325.0  38201.0  22575.0;  % BRAINSTEM
2814.40  689.400  2761.20  1008.40  2795.70  1607.70]; % MIDBRAIN

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
disp('SIDE_LOW Impact Results')
disp(resultsTable)

end


