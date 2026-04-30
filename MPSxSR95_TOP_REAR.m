function resultsTable = MPSxSR95_TOP_REAR(PLV,PAV)

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
0.2251 -0.3529  0.2736 -0.2449  0.3949 -0.3523;  % LEFT_PARIETAL
0.2299 -0.3643  0.2690 -0.2549  0.3816 -0.3670;  % RIGHT_PARIETAL
0.7667 -1.2091  0.9288 -1.2267  1.0835 -1.4475;  % LEFT_FRONTAL
0.7169 -1.1174  0.8801 -1.1321  1.0589 -1.4039;  % RIGHT_FRONTAL
0.3653 -0.5800  0.4364 -0.5910  0.4908 -0.6662;  % LEFT_TEMPORAL
0.4300 -0.6822  0.5166 -0.7130  0.5769 -0.8073;  % RIGHT_TEMPORAL
0.0929 -0.1459  0.1000 -0.0455  0.1973 -0.1665;  % LEFT_OCCIPITAL
0.0991 -0.1570  0.1008 -0.0449  0.1915 -0.1572;  % RIGHT_OCCIPITAL
0.4409 -0.6878  0.5346 -0.6917  0.6390 -0.9065;  % CEREBELLUM
3.7375 -5.4318  4.3108 -5.2845  4.8973 -6.4641;  % BRAINSTEM
0.2788 -0.4165  0.3338 -0.4011  0.3835 -0.4443]; % MIDBRAIN

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
disp('TOP_REAR Impact Results')
disp(resultsTable)

end


