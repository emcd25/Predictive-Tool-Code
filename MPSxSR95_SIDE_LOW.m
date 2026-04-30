function resultsTable = MPSxSR95_SIDE_LOW(PLV,PAV)

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
2.8616 -3.5626  3.1109 -3.8344  3.1379 -3.2018;  % LEFT_PARIETAL
5.0226 -6.0194  5.1304 -6.1853  4.9774 -5.6105;  % RIGHT_PARIETAL
4.0083 -4.6288  3.7779 -4.9387  3.5043 -4.7623;  % LEFT_FRONTAL
5.3925 -7.1994  5.3289 -7.2025  5.0978 -6.4070;  % RIGHT_FRONTAL
4.4126 -4.9746  4.2309 -5.2317  4.0088 -5.0612;  % LEFT_TEMPORAL
4.3448 -5.3953  4.4535 -5.8082  4.3336 -5.1317;  % RIGHT_TEMPORAL
3.2713 -3.4608  3.1730 -3.8872  2.9309 -3.6643;  % LEFT_OCCIPITAL
2.8943 -2.7844  2.7806 -3.4187  2.5747 -3.5063;  % RIGHT_OCCIPITAL
2.8228 -3.8510  3.0813 -4.1144  3.2723 -3.5328;  % CEREBELLUM
25.875 -42.160  29.087 -43.790  31.881 -44.507;  % BRAINSTEM
1.5635 -1.8874  1.5963 -1.9358  1.6501 -1.7960]; % MIDBRAIN

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
disp('SIDE_LOW Impact Results')
disp(resultsTable)

end


