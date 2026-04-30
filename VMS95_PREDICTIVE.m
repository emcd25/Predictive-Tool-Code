function resultsTable = VMS95_PREDICTIVE(LOCATION, PLV, PAV)

% VMS95_PREDICTIVE selects the correct impact location model
%
% Inputs:
%   LOCATION - Impact location
%   PLV      - Peak Linear Velocity (1–6 m/s)
%   PAV      - Peak Angular Velocity (6–32 rad/s)
%
% Output:
%   resultsTable - Table of Regional VMS95
%
% Sample Call in Command:
%   T = VMS95_PREDICTIVE("SIDE_LOW", 4, 20);

% -------- Standardise Input --------

LOCATION = upper(strtrim(string(LOCATION)));

validLocations = ["FRONT_HIGH","TOP_FRONT","TOP_REAR", ...
                  "REAR_LOW","REAR_HIGH","SIDE_LOW","SIDE_HIGH"];

if ~ismember(LOCATION, validLocations)
    error('LOCATION must be one of the following: %s', ...
          strjoin(validLocations, ', '));
end

% -------- Route to Correct Model --------

switch LOCATION

    case "SIDE_LOW"
        resultsTable = VMS95_SIDE_LOW(PLV, PAV);

    case "SIDE_HIGH"
        resultsTable = VMS95_SIDE_HIGH(PLV, PAV);

    case "FRONT_HIGH"
        resultsTable = VMS95_FRONT_HIGH(PLV, PAV);

    case "TOP_FRONT"
        resultsTable = VMS95_TOP_FRONT(PLV, PAV);

    case "TOP_REAR"
        resultsTable = VMS95_TOP_REAR(PLV, PAV);

    case "REAR_LOW"
        resultsTable = VMS95_REAR_LOW(PLV, PAV);

    case "REAR_HIGH"
        resultsTable = VMS95_REAR_HIGH(PLV, PAV);

end

end
