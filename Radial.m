% MATLAB Code to find optimal configuration for 0.6 ohm target impedance in radial topology with main line and branches

% Define resistance and inductance values for each unit in ohms and henries
R_values = [0.05, 0.1, 0.2, 0.3]; % in Ohms (50 mΩ, 100 mΩ, 200 mΩ, 300 mΩ)
L_values = [0.25e-3, 0.75e-3, 1.75e-3, 3.65e-3]; % in Henries (0.25 mH, 0.75 mH, 1.75 mH, 3.65 mH)
f = 50; % Frequency in Hz
omega = 2 * pi * f; % Angular frequency

% Calculate complex impedance for each unit
Z_units = R_values + 1i * omega * L_values; % Impedance values for each unit option

% Define target impedance for radial topology
Z_target_radial = 0.6; % Target impedance for radial topology

% Initialize variables to store best configurations
best_main_config = [];
best_branch_config = [];
min_error_radial = inf;

% Try all combinations for the main line (4 units) and branch line (1 unit)
for i = 1:4
    for j = 1:4
        for k = 1:4
            for m = 1:4
                % Main line impedance: sum of 4 units in series (1-2-3-6-5)
                Z_main = Z_units(i) + Z_units(j) + Z_units(k) + Z_units(m);

                for n = 1:4
                    % Branch line impedance: choose 1 unit for each branch (e.g., 2-4 and 3-6)
                    Z_branch_1 = Z_units(n); % Unit for branch 2-4
                    Z_branch_2 = Z_units(n); % Unit for branch 3-6
                    
                    % Calculate total branch impedance as parallel of both branches
                    Z_branch = 1 / (1 / Z_branch_1 + 1 / Z_branch_2);

                    % Calculate total equivalent impedance for radial topology
                    Z_total_radial = Z_main + Z_branch;

                    % Calculate error from target
                    error_radial = abs(abs(Z_total_radial) - Z_target_radial);

                    % Update best configuration if closer to target
                    if error_radial < min_error_radial
                        min_error_radial = error_radial;
                        best_main_config = [i, j, k, m];
                        best_branch_config = n;
                        Z_best_radial = Z_total_radial;
                    end
                end
            end
        end
    end
end

% Display best configuration for radial topology
disp('Optimal Configuration for Radial Topology to Achieve 0.6Ω Target Impedance:')
unit_labels = {'50 mΩ + 0.25 mH', '100 mΩ + 0.75 mH', '200 mΩ + 1.75 mH', '300 mΩ + 3.65 mH'};
disp(['Main Line Units: ', unit_labels{best_main_config(1)}, ', ', unit_labels{best_main_config(2)}, ', ', ...
      unit_labels{best_main_config(3)}, ', ', unit_labels{best_main_config(4)}])
disp(['Branch Units: ', unit_labels{best_branch_config}, ' (for both branches)'])
disp(['Total Equivalent Impedance (Magnitude): ', num2str(abs(Z_best_radial)), ' Ω']);
disp(['Real Part: ', num2str(real(Z_best_radial)), ' Ω']);
disp(['Imaginary Part: ', num2str(imag(Z_best_radial)), ' Ω']);
disp(['Error from Target Impedance: ', num2str(min_error_radial), ' Ω']);
