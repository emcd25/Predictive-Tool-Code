function resultsTable = MPS_REAR_HIGH(PLV,PAV)

% TOP_REAR estimates MPS for ALL brain regions
% Inputs:
%   PLV - Peak Linear Velocity (1–6 m/s)
%   PAV - Peak Angular Velocity (6–36 rad/s)

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
% Columns: [MPS_S1 MPS_Y1 MPS_S2 MPS_Y2 MPS_S3 MPS_Y3]

MPS_data = [
0.1802  0.0022  0.1781  0.0121  0.1759  0.0249;  % LEFT_PARIETAL
0.1738  0.0306  0.1782  0.0113  0.1874 -0.0273;  % RIGHT_PARIETAL
0.0794  0.0808  0.0757  0.1059  0.0702  0.1205;  % LEFT_FRONTAL
0.0863  0.2336  0.1039  0.1469  0.1187  0.0217;  % RIGHT_FRONTAL
0.0681  0.0906  0.0609  0.1279  0.0526  0.1615;  % LEFT_TEMPORAL
0.1064  0.0812  0.1058  0.0888  0.1175  0.0413;  % RIGHT_TEMPORAL
0.0837  0.0491  0.0672  0.1080  0.0649  0.1222;  % LEFT_OCCIPITAL
0.0300 -0.0115  0.0229 -0.0065  0.0164  0.0084;  % RIGHT_OCCIPITAL
0.1005  0.1315  0.1030  0.1346  0.1025  0.1458;  % CEREBELLUM
0.1512  0.1394  0.1503  0.1534  0.1484  0.1748;  % BRAINSTEM
0.1230  0.0065  0.1203  0.0186  0.1180  0.0331]; % MIDBRAIN

% -------------------- Preallocate --------------------

numRegions = length(regions);
MPS_values = zeros(numRegions,1);

% -------------------- Loop Through Regions --------------------

for i = 1:numRegions

    S1 = MPS_data(i,1);  Y1 = MPS_data(i,2);
    S2 = MPS_data(i,3);  Y2 = MPS_data(i,4);
    S3 = MPS_data(i,5);  Y3 = MPS_data(i,6);

    % MPS at each PAV level
    MPS_1 = S1*PLV + Y1;
    MPS_2 = S2*PLV + Y2;
    MPS_3 = S3*PLV + Y3;

    % Linear interpolation
    if PAV < PAV_2
        MPS = MPS_1 + (PAV-PAV_1)*((MPS_2-MPS_1)/(PAV_2-PAV_1));
    else
        MPS = MPS_2 + (PAV-PAV_2)*((MPS_3-MPS_2)/(PAV_3-PAV_2));
    end

    MPS_values(i) = round(MPS*100,3);  % Convert to %

end

% -------------------- Create Output Table --------------------

resultsTable = table(regions', MPS_values, ...
    'VariableNames', {'Region','MPS_percent'});


% -------------------- Print to Command Window --------------------

disp(' ')
disp('REAR_HIGH Impact Results')
disp(resultsTable)

end


