function resultsTable = MPSxSR95_SIDE_HIGH(PLV,PAV)

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
4.1537 -4.1969  4.5577 -3.7676  4.8626 -2.9882;  % LEFT_PARIETAL
4.1720 -4.9153  4.3998 -4.6226  4.5112 -3.6773;  % RIGHT_PARIETAL
4.2904 -4.7364  4.3441 -4.2096  4.4596 -3.4267;  % LEFT_FRONTAL
4.1062 -5.1777  4.1012 -4.7573  4.1866 -4.0955;  % RIGHT_FRONTAL
3.3595 -3.5914  3.5258 -3.3159  3.7184 -2.8572;  % LEFT_TEMPORAL
5.0618 -5.7544  5.1249 -5.0348  5.1893 -4.2661;  % RIGHT_TEMPORAL
2.2634 -2.6488  2.1941 -2.4015  2.0889 -1.9531;  % LEFT_OCCIPITAL
2.7739 -3.6561  2.7765 -3.4929  2.8410 -3.2504;  % RIGHT_OCCIPITAL
4.4992 -5.4461  5.2449 -5.0600  6.0165 -4.4436;  % CEREBELLUM
18.665 -23.927  20.333 -23.879  21.734 -23.203;  % BRAINSTEM
2.2286 -2.6426  2.4775 -2.5377  2.7276 -2.2395]; % MIDBRAIN

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
disp('SIDE_HIGH Impact Results')
disp(resultsTable)

end


