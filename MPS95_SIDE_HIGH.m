function resultsTable = MPS95_SIDE_HIGH(PLV,PAV)

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
0.0321  0.0212  0.0314  0.0322  0.0304  0.0500;  % LEFT_PARIETAL
0.0308  0.0201  0.0306  0.0328  0.0293  0.0514;  % RIGHT_PARIETAL
0.0303  0.0146  0.0286  0.0259  0.0273  0.0411;  % LEFT_FRONTAL
0.0274  0.0112  0.0254  0.0227  0.0236  0.0391;  % RIGHT_FRONTAL
0.0297  0.0159  0.0284  0.0278  0.0273  0.0446;  % LEFT_TEMPORAL
0.0314  0.0173  0.0300  0.0291  0.0281  0.0462;  % RIGHT_TEMPORAL
0.0239  0.0123  0.0216  0.0158  0.0193  0.0262;  % LEFT_OCCIPITAL
0.0238  0.0149  0.0226  0.0172  0.0204  0.0260;  % RIGHT_OCCIPITAL
0.0264  0.0148  0.0259  0.0376  0.0265  0.0565;  % CEREBELLUM
0.0478  0.0212  0.0485  0.0350  0.0476  0.0556;  % BRAINSTEM
0.0263  0.0111  0.0264  0.0246  0.0263  0.0411]; % MIDBRAIN

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
disp('SIDE_HIGH Impact Results')
disp(resultsTable)

end


