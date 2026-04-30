function resultsTable = MPS95_REAR_LOW(PLV,PAV)

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
0.0126  0.0078  0.0059  0.0488  0.0064  0.0649;  % LEFT_PARIETAL
0.0132  0.0065  0.0069  0.0443  0.0067  0.0604;  % RIGHT_PARIETAL
0.0177  0.0060  0.0103  0.0401  0.0101  0.0540;  % LEFT_FRONTAL
0.0180  0.0065  0.0104  0.0415  0.0099  0.0564;  % RIGHT_FRONTAL
0.0114  0.0036  0.0083  0.0315  0.0103  0.0400;  % LEFT_TEMPORAL
0.0124  0.0037  0.0087  0.0331  0.0105  0.0417;  % RIGHT_TEMPORAL
0.0061  0.0099  0.0023  0.0490  0.0052  0.0613;  % LEFT_OCCIPITAL
0.0062  0.0099  0.0024  0.0473  0.0051  0.0596;  % RIGHT_OCCIPITAL
0.0189  0.0026  0.0161  0.0379  0.0197  0.0455;  % CEREBELLUM
0.0916  0.0005  0.0924  0.0437  0.0950  0.0518;  % BRAINSTEM
0.0102  0.0050  0.0083  0.0376  0.0112  0.0471]; % MIDBRAIN

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
disp('REAR_LOW Impact Results')
disp(resultsTable)

end


