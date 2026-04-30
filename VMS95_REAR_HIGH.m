function resultsTable = VMS95_REAR_HIGH(PLV,PAV)

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
27130.0 -5241.80  24977.0  22178.0  25235.0  45413.0;  % LEFT_PARIETAL
1059.90 -181.760  834.700  47.5990  561.230  987.730;  % RIGHT_PARIETAL
33327.0 -2383.90  30512.0  31380.0  30247.0  61568.0;  % LEFT_FRONTAL
1709.00 -248.100  1636.90 -438.230  1355.70  414.020;  % RIGHT_FRONTAL
11956.0 -5673.70  11018.0  4778.40  13404.0  6431.00;  % LEFT_TEMPORAL
1056.10 -45.1470  1003.30 -269.160  719.530  643.530;  % RIGHT_TEMPORAL
10495.0 -14441.0  9766.60 -12109.0  10048.0 -10932.0;  % LEFT_OCCIPITAL
903.170 -101.560  651.230  95.7490  272.110  1282.80;  % RIGHT_OCCIPITAL
42871.0 -13560.0  41404.0  17743.0  41405.0  52013.0;  % CEREBELLUM
35966.0 -13672.0  33271.0  25231.0  33614.0  64455.0;  % BRAINSTEM
1488.30 -177.590  1342.30 -436.500  952.900  676.550]; % MIDBRAIN

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

    % if the result is less than zero, set it equal to zero
    VMS95 = max(VMS95, 0);
    VMS95_values(i) = round(VMS95,3);

end

% -------------------- Create Output Table --------------------

resultsTable = table(regions', VMS95_values, ...
    'VariableNames', {'Region','VMS95_Pa'});


% -------------------- Print to Command Window --------------------

disp(' ')
disp('REAR_HIGH Impact Results')
disp(resultsTable)

end


