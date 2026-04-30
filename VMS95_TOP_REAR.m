function resultsTable = VMS95_TOP_REAR(PLV,PAV)

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
31647.0 -18579.0  28413.0  15163.0  25575.0  52840.0;  % LEFT_PARIETAL
481.300  142.710  426.140  1235.20  542.430  1416.10;  % RIGHT_PARIETAL
39991.0 -21555.0  33994.0  22379.0  28834.0  73583.0;  % LEFT_FRONTAL
807.820  183.920  819.040  1179.50  952.820  1125.30;  % RIGHT_FRONTAL
12386.0 -8315.60  11879.0  3548.30  11258.0  17442.0;  % LEFT_TEMPORAL
607.560 -35.7740  582.940  706.610  640.920  900.520;  % RIGHT_TEMPORAL
10430.0 -14749.0  11224.0 -13278.0  11468.0 -12096.0;  % LEFT_OCCIPITAL
404.210  106.280  274.460  1217.40  378.750  1528.20;  % RIGHT_OCCIPITAL
50160.0 -34712.0  44561.0  10537.0  38931.0  66224.0;  % CEREBELLUM
39563.0 -21506.0  34003.0  27930.0  26057.0  92623.0;  % BRAINSTEM
750.070  82.5350  617.090  1166.10  744.200  1336.70]; % MIDBRAIN

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
disp('TOP_REAR Impact Results')
disp(resultsTable)

end


