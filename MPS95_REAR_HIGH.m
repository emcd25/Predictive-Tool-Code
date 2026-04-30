function resultsTable = MPS95_REAR_HIGH(PLV,PAV)

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
0.0119 -0.0047  0.0081  0.0017  0.0044  0.0156;  % LEFT_PARIETAL
0.0118 -0.0052  0.0083  0.0010  0.0047  0.0143;  % RIGHT_PARIETAL
0.0173 -0.0043  0.0163 -0.0051  0.0132  0.0057;  % LEFT_FRONTAL
0.0175 -0.0040  0.0165 -0.0049  0.0135  0.0051;  % RIGHT_FRONTAL
0.0111 -0.0040  0.0099 -0.0040  0.0066  0.0069;  % LEFT_TEMPORAL
0.0121 -0.0042  0.0110 -0.0048  0.0076  0.0064;  % RIGHT_TEMPORAL
0.0111 -0.0047  0.0075 -0.0008  0.0030  0.0131;  % LEFT_OCCIPITAL
0.0106 -0.0044  0.0072 -0.0006  0.0029  0.0134;  % RIGHT_OCCIPITAL
0.0126  0.0006  0.0111  0.0013  0.0082  0.0103;  % CEREBELLUM
0.0402  0.0129  0.0414  0.0162  0.0398  0.0298;  % BRAINSTEM
0.0128 -0.0045  0.0111 -0.0052  0.0069  0.0081]; % MIDBRAIN

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
disp('REAR_HIGH Impact Results')
disp(resultsTable)

end


