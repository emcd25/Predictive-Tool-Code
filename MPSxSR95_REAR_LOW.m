function resultsTable = MPSxSR95_REAR_LOW(PLV,PAV)

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
1.3725 -1.5683  1.7351 -0.6424  2.0447  0.3736;  % LEFT_PARIETAL
1.5252 -1.7857  1.8945 -0.9979  2.1245  0.1050;  % RIGHT_PARIETAL
3.4059 -3.8651  3.6788 -3.0867  3.7380 -1.8123;  % LEFT_FRONTAL
3.5329 -3.9638  3.8652 -3.1886  3.9703 -1.9299;  % RIGHT_FRONTAL
1.0202 -1.1821  1.4570 -1.1328  1.8505 -0.9383;  % LEFT_TEMPORAL
1.2261 -1.4079  1.6502 -1.2507  2.0319 -0.9849;  % RIGHT_TEMPORAL
0.4830 -0.4778  0.8073  0.0845  1.2940  0.3204;  % LEFT_OCCIPITAL
0.4624 -0.4463  0.7232  0.2191  1.1864  0.4480;  % RIGHT_OCCIPITAL
1.8286 -1.9711  3.3114 -2.9820  4.4535 -2.9358;  % CEREBELLUM
43.837 -49.805  64.047 -73.300  68.470 -66.204;  % BRAINSTEM
0.8033 -0.9293  1.3880 -1.0481  1.8206 -0.6839]; % MIDBRAIN

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
disp('REAR_LOW Impact Results')
disp(resultsTable)

end


