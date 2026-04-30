function resultsTable = MPS95_SIDE_LOW(PLV,PAV)

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
0.0260  0.0140  0.0249  0.0185  0.0248  0.0267;  % LEFT_PARIETAL
0.0315  0.0171  0.0313  0.0167  0.0310  0.0207;  % RIGHT_PARIETAL
0.0295  0.0179  0.0296  0.0063  0.0286  0.0047;  % LEFT_FRONTAL
0.0349  0.0056  0.0328  0.0064  0.0311  0.0121;  % RIGHT_FRONTAL
0.0318  0.0230  0.0318  0.0141  0.0314  0.0131;  % LEFT_TEMPORAL
0.0306  0.0150  0.0310  0.0099  0.0299  0.0158;  % RIGHT_TEMPORAL
0.0263  0.0244  0.0266  0.0121  0.0266  0.0075;  % LEFT_OCCIPITAL
0.0280  0.0220  0.0300  0.0021  0.0296 -0.0063;  % RIGHT_OCCIPITAL
0.0246  0.0088  0.0235  0.0126  0.0222  0.0273;  % CEREBELLUM
0.0590 -0.0033  0.0610  0.0129  0.0646  0.0166;  % BRAINSTEM
0.0235  0.0054  0.0225  0.0100  0.0221  0.0175]; % MIDBRAIN

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
disp('SIDE_LOW Impact Results')
disp(resultsTable)

end


