function resultsTable = MPS_TOP_REAR(PLV,PAV)

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
0.1572  0.0944  0.1500  0.1303  0.1632  0.0742;  % LEFT_PARIETAL
0.1822 -0.0254  0.1793 -0.0113  0.1847 -0.0251;  % RIGHT_PARIETAL
0.0891  0.1844  0.0848  0.2202  0.0938  0.1749;  % LEFT_FRONTAL
0.0779 -0.0334  0.0655  0.0211  0.0664  0.0206;  % RIGHT_FRONTAL
0.0911  0.1243  0.0818  0.1792  0.0803  0.1837;  % LEFT_TEMPORAL
0.1058 -0.0304  0.1005  0.0080  0.1048 -4e-006;  % RIGHT_TEMPORAL
0.0374  0.0091  0.0301  0.0312  0.0174  0.0840;  % LEFT_OCCIPITAL
0.0152 -0.0056  0.0202  0.0051  0.0240  0.0048;  % RIGHT_OCCIPITAL
0.0515 -0.0007  0.0389  0.1050  0.0496  0.1101;  % CEREBELLUM
0.0876  0.0769  0.0783  0.1777  0.0991  0.1220;  % BRAINSTEM
0.1066 -0.0308  0.1006  0.0095  0.1076 -0.0117]; % MIDBRAIN

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
disp('TOP_REAR Impact Results')
disp(resultsTable)

end


