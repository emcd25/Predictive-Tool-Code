function resultsTable = MPS95_TOP_FRONT(PLV,PAV)

% Estimates MPS95 for ALL brain regions
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
% Columns: [MPS95_S1 MPS95_Y1 MPS95_S2 MPS95_Y2 MPS95_S3 MPS95_Y3]

MPS95_data = [
0.0115 -0.0008  0.0108  0.0082  0.0123  0.0062;  % LEFT_PARIETAL
0.0116 -0.0015  0.0111  0.0067  0.0124  0.0047;  % RIGHT_PARIETAL
0.0073  0.0031  0.0068  0.0125  0.0090  0.0107;  % LEFT_FRONTAL
0.0069  0.0041  0.0064  0.0135  0.0088  0.0112;  % RIGHT_FRONTAL
0.0096 -0.0008  0.0096  0.0055  0.0112  0.0023;  % LEFT_TEMPORAL
0.0095 -0.0007  0.0096  0.0060  0.0114  0.0026;  % RIGHT_TEMPORAL
0.0147 -0.0002  0.0144  0.0055  0.0154  0.0013;  % LEFT_OCCIPITAL
0.0138   2e-05  0.0134  0.0057  0.0144  0.0019;  % RIGHT_OCCIPITAL
0.0205 -0.0004  0.0206  0.0073  0.0223  0.0012;  % CEREBELLUM
0.0313 -0.0160  0.0256  0.0186  0.0323 -0.0102;  % BRAINSTEM
0.0083  0.0008  0.0081  0.0010  0.0102  0.0070]; % MIDBRAIN

% -------------------- Preallocate --------------------

numRegions = length(regions);
MPS95_values = zeros(numRegions,1);

% -------------------- Loop Through Regions --------------------

for i = 1:numRegions

    S1 = MPS95_data(i,1);  Y1 = MPS95_data(i,2);
    S2 = MPS95_data(i,3);  Y2 = MPS95_data(i,4);
    S3 = MPS95_data(i,5);  Y3 = MPS95_data(i,6);

    % MPS95 at each PAV level
    MPS95_1 = S1*PLV + Y1;
    MPS95_2 = S2*PLV + Y2;
    MPS95_3 = S3*PLV + Y3;

    % Linear interpolation
    if PAV < PAV_2
        MPS95 = MPS95_1 + (PAV-PAV_1)*((MPS95_2-MPS95_1)/(PAV_2-PAV_1));
    else
        MPS95 = MPS95_2 + (PAV-PAV_2)*((MPS95_3-MPS95_2)/(PAV_3-PAV_2));
    end

    MPS95_values(i) = round(MPS95*100,3);  % Convert to %

end

% -------------------- Create Output Table --------------------

resultsTable = table(regions', MPS95_values, ...
    'VariableNames', {'Region','MPS95_percent'});


% -------------------- Print to Command Window --------------------

disp(' ')
disp('TOP_FRONT Impact Results')
disp(resultsTable)

end


