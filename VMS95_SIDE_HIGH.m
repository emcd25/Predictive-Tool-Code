function resultsTable = VMS95_SIDE_HIGH(PLV,PAV)

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
51874.0 -26294.0  50942.0 -8493.00  50103.0  12810.0;  % LEFT_PARIETAL
2897.90  1280.40  2876.00  2322.70  2786.90  4028.10;  % RIGHT_PARIETAL
61562.0 -26002.0  60437.0 -1353.40  58730.0  30297.0;  % LEFT_FRONTAL
2585.30  821.600  2409.40  1654.20  2235.70  3076.50;  % RIGHT_FRONTAL
29132.0 -25513.0  27975.0 -16548.0  26845.0 -5037.60;  % LEFT_TEMPORAL
3022.60  1152.60  2927.20  21194.0  2828.90  3502.80;  % RIGHT_TEMPORAL
16245.0 -13084.0  18132.0 -14332.0  18613.0 -9653.30;  % LEFT_OCCIPITAL
2328.30  1049.60  2210.10  1433.10  2051.20  2279.10;  % RIGHT_OCCIPITAL
75004.0 -36567.0  75299.0 -14487.0  72606.0  22442.0;  % CEREBELLUM
38560.0 -20797.0  37441.0  97.4860  35921.0  27029.0;  % BRAINSTEM
3296.60  992.060  3262.20  2397.30  3244.10  4295.00]; % MIDBRAIN

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
disp('SIDE_HIGH Impact Results')
disp(resultsTable)

end


