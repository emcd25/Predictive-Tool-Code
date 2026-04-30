function resultsTable = VMS95_REAR_LOW(PLV,PAV)

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
28150.0 -13015.0  28371.0 -1648.30  29359.0  4748.50;  % LEFT_PARIETAL
1401.20  443.570  792.480  3928.10  804.100  5356.00;  % RIGHT_PARIETAL
34121.0 -13077.0  34157.0  3618.70  35182.0  11532.0;  % LEFT_FRONTAL
1901.50  481.970  1189.60  3813.20  1199.80  4991.70;  % RIGHT_FRONTAL
12713.0 -8622.70  12357.0 -2244.30  13416.0 -2342.80;  % LEFT_TEMPORAL
1223.10  332.870  846.180  3263.10  1054.10  4007.20;  % RIGHT_TEMPORAL
5867.60 -4416.20  7584.00 -2764.70  8426.40 -208.670;  % LEFT_OCCIPITAL
754.810  853.920  376.890  4376.90  674.340  5299.40;  % RIGHT_OCCIPITAL
52870.0 -28658.0  50911.0 -8047.80  52213.0 -1599.70;  % CEREBELLUM
50344.0 -31010.0  44889.0  860.950  47392.0  5296.70;  % BRAINSTEM
1377.90  446.770  962.170  4342.90  1299.20  5508.40]; % MIDBRAIN

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
disp('REAR_LOW Impact Results')
disp(resultsTable)

end


