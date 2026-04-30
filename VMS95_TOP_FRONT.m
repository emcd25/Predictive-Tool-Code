function resultsTable = VMS95_TOP_FRONT(PLV,PAV)

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
21335.0 -5035.80  17582.0  26525.0  5452.90  104845.0;  % LEFT_PARIETAL
1219.80 -353.150  1129.00  513.780  1268.30  104.600;  % RIGHT_PARIETAL
28141.0 -6973.10  22773.0  35160.0  8829.60  126978.0;  % LEFT_FRONTAL
769.980  245.150  715.510  1121.30  954.370  699.330;  % RIGHT_FRONTAL
9120.20 -3207.90  7314.00  9740.10  4012.80  31717.0;  % LEFT_TEMPORAL
1020.70 -181.790  1016.80  393.450  1163.40 -5.14890;  % RIGHT_TEMPORAL
6128.40 -4032.20  5939.70 -1765.10  7158.30 -1307.00;  % LEFT_OCCIPITAL
1419.50 -100.140  1346.80  530.620  1476.60 -99.3430;  % RIGHT_OCCIPITAL
36650.0 -19281.0  26979.0  43793.0  12577.0  144725.0;  % CEREBELLUM
37018.0 -6801.80  26385.0  68028.0  16660.0  151876.0;  % BRAINSTEM
1133.90 -140.200  1091.40  830.700  1330.80  353.320]; % MIDBRAIN

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
disp('TOP_FRONT Impact Results')
disp(resultsTable)

end


