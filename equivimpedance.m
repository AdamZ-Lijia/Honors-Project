% MATLAB Code to find optimal unit configuration for 0.6 ohm target impedance in mesh topology

% Define resistance and inductance values for each unit in ohms and henries
R_values = [0.05, 0.1, 0.2, 0.3]; % in Ohms (50 mΩ, 100 mΩ, 200 mΩ, 300 mΩ)
L_values = [0.25e-3, 0.75e-3, 1.75e-3, 3.65e-3]; % in Henries (0.25 mH, 0.75 mH, 1.75 mH, 3.65 mH)
f = 50; % Frequency in Hz
omega = 2 * pi * f; % Angular frequency

% Calculate complex impedance for each unit
Z_units = R_values + 1i * omega * L_values; % Impedance values for each unit option

% Define target impedance
Z_target = 0.6; % Adjusted target equivalent impedance in ohms

% Possible configurations for each path in the mesh topology
% Path 1 and Path 2 will have 2 units, Path 3 will have 1 unit

% Initialize variables to store best configurations
best_config_path1 = [];
best_config_path2 = [];
best_config_path3 = [];
min_error = inf; % Initialize minimum error to a large value

% Try all combinations for Path 1 and Path 2 (2 units each), and Path 3 (1 unit)
for i = 1:4
    for j = 1:4
        Z_path1 = Z_units(i) + Z_units(j); % Sum for two units in Path 1
        Z_path2 = Z_units(i) + Z_units(j); % Sum for two units in Path 2
        
        for k = 1:4
            Z_path3 = Z_units(k); % Single unit in Path 3
            
            % Calculate total impedance for three parallel paths
            Z_total = 1 / (1 / Z_path1 + 1 / Z_path2 + 1 / Z_path3);
            
            % Calculate the error from target impedance
            error = abs(abs(Z_total) - Z_target);
            
            % Update best configuration if this is closer to target
            if error < min_error && abs(Z_path1 - Z_path2) < 0.1 % Ensuring symmetry between Path 1 and Path 2
                min_error = error;
                best_config_path1 = [i, j];
                best_config_path2 = [i, j];
                best_config_path3 = k;
                Z_best_total = Z_total;
            end
        end
    end
end

% Display best configurations for each path and the resulting total impedance
disp('Optimal Configuration for Mesh Topology to Achieve 0.6Ω Target Impedance:')
disp(['Path 1: Unit ', num2str(best_config_path1(1)), ' and Unit ', num2str(best_config_path1(2))])
disp(['Path 2: Unit ', num2str(best_config_path2(1)), ' and Unit ', num2str(best_config_path2(2))])
disp(['Path 3: Unit ', num2str(best_config_path3)])

disp('Resulting Impedance:')
disp(['Total Equivalent Impedance (Magnitude): ', num2str(abs(Z_best_total)), ' Ω']);
disp(['Real Part: ', num2str(real(Z_best_total)), ' Ω']);
disp(['Imaginary Part: ', num2str(imag(Z_best_total)), ' Ω']);
disp(['Error from Target Impedance: ', num2str(min_error), ' Ω']);

% Display details of selected units for each path
unit_labels = {'50 mΩ + 0.25 mH', '100 mΩ + 0.75 mH', '200 mΩ + 1.75 mH', '300 mΩ + 3.65 mH'};
disp(['Selected Units for Path 1: ', unit_labels{best_config_path1(1)}, ' and ', unit_labels{best_config_path1(2)}])
disp(['Selected Units for Path 2: ', unit_labels{best_config_path2(1)}, ' and ', unit_labels{best_config_path2(2)}])
disp(['Selected Unit for Path 3: ', unit_labels{best_config_path3}])
