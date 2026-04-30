function resultsTable = MPSxSR95_REAR_HIGH(PLV,PAV)

% Estimates MPSxSR95 for ALL brain regions
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
% Columns: [MPSxSR95_S1 MPSxSR95_Y1 MPSxSR95_S2 MPSxSR95_Y2 MPSxSR95_S3 MPSxSR95_Y3]

MPSxSR95_data = [
0.7752 -1.1704  0.5906 -0.8945  0.5125 -0.7133;  % LEFT_PARIETAL
0.8138 -1.2444  0.6168 -0.9426  0.5355 -0.7690;  % RIGHT_PARIETAL
2.4460 -3.7892  2.2827 -3.5432  2.1189 -3.2740;  % LEFT_FRONTAL
2.5225 -3.8905  2.3189 -3.6034  2.1552 -3.3747;  % RIGHT_FRONTAL
0.7203 -1.1225  0.6650 -1.0296  0.6003 -0.8917;  % LEFT_TEMPORAL
0.9058 -1.4140  0.8450 -1.3143  0.7541 -1.1341;  % RIGHT_TEMPORAL
0.4705 -0.7186  0.2908 -0.4619  0.2116 -0.2954;  % LEFT_OCCIPITAL
0.4659 -0.7174  0.2942 -0.4696  0.2050 -0.2776;  % RIGHT_OCCIPITAL
0.7878 -1.0836  0.7250 -0.9902  0.7006 -0.9481;  % CEREBELLUM
12.475 -17.407  13.533 -19.165  14.012 -20.063;  % BRAINSTEM
0.7931 -1.2531  0.6785 -1.0482  0.5787 -0.8223]; % MIDBRAIN

% -------------------- Preallocate --------------------

numRegions = length(regions);
MPSxSR95_values = zeros(numRegions,1);

% -------------------- Loop Through Regions --------------------

for i = 1:numRegions

    S1 = MPSxSR95_data(i,1);  Y1 = MPSxSR95_data(i,2);
    S2 = MPSxSR95_data(i,3);  Y2 = MPSxSR95_data(i,4);
    S3 = MPSxSR95_data(i,5);  Y3 = MPSxSR95_data(i,6);

    % MPSxSR95 at each PAV level
    MPSxSR95_1 = S1*PLV + Y1;
    MPSxSR95_2 = S2*PLV + Y2;
    MPSxSR95_3 = S3*PLV + Y3;

    % Linear interpolation
    if PAV < PAV_2
        MPSxSR95 = MPSxSR95_1 + (PAV-PAV_1)*((MPSxSR95_2-MPSxSR95_1)/(PAV_2-PAV_1));
    else
        MPSxSR95 = MPSxSR95_2 + (PAV-PAV_2)*((MPSxSR95_3-MPSxSR95_2)/(PAV_3-PAV_2));
    end

    % if the result is less than zero, set it equal to zero
    MPSxSR95 = max(MPSxSR95, 0);
    MPSxSR95_values(i) = round(MPSxSR95,3);

    MPSxSR95_values(i) = round(MPSxSR95,3);  % Convert to %

end

% -------------------- Create Output Table --------------------

resultsTable = table(regions', MPSxSR95_values, ...
    'VariableNames', {'Region','MPSxSR95_s^(-1)'});


% -------------------- Print to Command Window --------------------

disp(' ')
disp('REAR_HIGH Impact Results')
disp(resultsTable)

end


