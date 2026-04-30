function resultsTable = MPSxSR95_TOP_FRONT(PLV,PAV)

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
1.0686 -1.7204  1.1240 -1.5887  1.2974 -1.9635;  % LEFT_PARIETAL
1.1174 -1.8221  1.1925 -1.7451  1.3516 -2.1136;  % RIGHT_PARIETAL
0.5640 -0.8583  0.6744 -0.8774  0.8646 -1.2193;  % LEFT_FRONTAL
0.5013 -0.7459  0.5941 -0.7269  0.7928 -1.0939;  % RIGHT_FRONTAL
0.8109 -1.2801  0.9680 -1.4131  1.1182 -1.7608;  % LEFT_TEMPORAL
0.8406 -1.3395  1.0166 -1.4963  1.1852 -1.8686;  % RIGHT_TEMPORAL
2.6864 -4.1084  2.8065 -4.0176  2.8662 -4.3828;  % LEFT_OCCIPITAL
2.2580 -3.4569  2.3562 -3.3718  2.4132 -3.6964;  % RIGHT_OCCIPITAL
4.6188 -7.1284  5.0481 -7.2645  5.3108 -8.0634;  % CEREBELLUM
5.4417 -8.9963  6.1015 -9.4403  6.3889 -10.585;  % BRAINSTEM
0.5742 -0.8662  0.6958 -0.9019  0.8409 -1.2030]; % MIDBRAIN

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
disp('TOP_FRONT Impact Results')
disp(resultsTable)

end


