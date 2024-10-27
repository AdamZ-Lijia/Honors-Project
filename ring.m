% MATLAB Code to find optimal unit configuration for 0.6 ohm target impedance in ring topology using all 5 units

% Define resistance and inductance values for each unit in ohms and henries
R_values = [0.05, 0.1, 0.2, 0.3]; % in Ohms (50 mΩ, 100 mΩ, 200 mΩ, 300 mΩ)
L_values = [0.25e-3, 0.75e-3, 1.75e-3, 3.65e-3]; % in Henries (0.25 mH, 0.75 mH, 1.75 mH, 3.65 mH)
f = 50; % Frequency in Hz
omega = 2 * pi * f; % Angular frequency

% Calculate complex impedance for each unit
Z_units = R_values + 1i * omega * L_values; % Impedance values for each unit option

% Define target impedance for ring topology
Z_target_ring = 0.6; % Target impedance for ring topology

% Initialize variables to store best configurations
best_ring_config_path1 = [];
best_ring_config_path2 = [];
min_error_ring = inf;

% Try all combinations for two paths with 3 units in Path 1 and 2 units in Path 2
for i = 1:4
    for j = 1:4
        for k = 1:4
            Z_path1 = Z_units(i) + Z_units(j) + Z_units(k); % Sum of three units in Path 1
            
            for m = 1:4
                for n = 1:4
                    Z_path2 = Z_units(m) + Z_units(n); % Sum of two units in Path 2
                    
                    % Calculate total impedance for two parallel paths
                    Z_total_ring = 1 / (1 / Z_path1 + 1 / Z_path2);
                    
                    % Calculate error from target impedance
                    error_ring = abs(abs(Z_total_ring) - Z_target_ring);
                    
                    % Update best configuration if closer to target
                    if error_ring < min_error_ring
                        min_error_ring = error_ring;
                        best_ring_config_path1 = [i, j, k];
                        best_ring_config_path2 = [m, n];
                        Z_best_ring = Z_total_ring;
                    end
                end
            end
        end
    end
end

% Display best configuration for ring topology
disp('Optimal Configuration for Ring Topology to Achieve 0.6Ω Target Impedance using 5 units:')
unit_labels = {'50 mΩ + 0.25 mH', '100 mΩ + 0.75 mH', '200 mΩ + 1.75 mH', '300 mΩ + 3.65 mH'};
disp(['Path 1: ', unit_labels{best_ring_config_path1(1)}, ', ', unit_labels{best_ring_config_path1(2)}, ', ', unit_labels{best_ring_config_path1(3)}])
disp(['Path 2: ', unit_labels{best_ring_config_path2(1)}, ' and ', unit_labels{best_ring_config_path2(2)}])
disp(['Total Equivalent Impedance (Magnitude): ', num2str(abs(Z_best_ring)), ' Ω']);
disp(['Real Part: ', num2str(real(Z_best_ring)), ' Ω']);
disp(['Imaginary Part: ', num2str(imag(Z_best_ring)), ' Ω']);
disp(['Error from Target Impedance: ', num2str(min_error_ring), ' Ω']);
