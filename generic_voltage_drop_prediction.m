% Number of buses
num_bus = 5;
judge = 0;

% Initial guess for bus voltages (in p.u.), starting with Bus 5
V = ones(1, num_bus);  % Initial guess: all voltages at 1.0 p.u.
V(num_bus) = 1.0;  % Start with Bus 5 voltage at 1.0 p.u. (230V)

% Define the impedance between buses
inductance_1 = 2*(0.25 + 0.5 + 1) * 10^-3;  % Inductance (H)
resistance_1 = 2*(50 + 50 + 100) * 10^-3;   % Resistance (Ohms)
Xline_1 = 2 * pi * 50 * inductance_1;     % Inductive reactance (Ohms)
Z_1 = resistance_1 + 1i * Xline_1;        % Complex impedance (Ohms)
Zbase = 230^2 / (25 * 1000);              % Base impedance (Ohms)
Z_pu = Z_1 / Zbase;                       % Per-unit impedance

% PV power injection (real power only, no reactive power)
P_pv = 5 * 1000;  % PV power in watts (5 kW)
S_PV_pu = P_pv / (25 * 1000);  % Power in per-unit (p.u.)

% Convergence parameters
tolerance = 1e-4;  % Tolerance for Bus 1 voltage to reach 230V
step = 0.0001;        % Initial step for adjusting Bus 5 voltage
max_iterations = 500000;  % Maximum number of iterations
iteration_count = 0;  % Iteration counter

% Iteratively adjust Bus 5 voltage until Bus 1 reaches 230V
while true
    iteration_count = iteration_count + 1;  % Increment iteration count
    
    % Calculate the voltages starting from Bus 5 back to Bus 1
    for i = num_bus:-1:2
        I_pu = S_PV_pu / V(i);  % Current calculation in p.u. (I = S / V)
        deltaV_pu = I_pu * Z_pu; % Voltage drop calculation
        V(i-1) = V(i) - deltaV_pu;  % Voltage at previous bus
    end
    V_realtemp = abs(V(1));
    % Display debug information for tracking the iteration process
    fprintf('Iteration %d: Bus 5 Voltage = %.4f p.u., Bus 1 Voltage = %.4f p.u.\n', iteration_count, V(num_bus), V(1));
    
    % Check if Bus 1 has reached 1 p.u. (230V)
    if abs(V_realtemp - 1) < tolerance
        judge = 1;
        break;  % Stop the iteration if Bus 1 is within the tolerance of 230V
    elseif iteration_count > max_iterations
        warning('maximum time');
        break;  % Stop if maximum iterations are reached
    else
        % Adjust Bus 5 voltage based on Bus 1 voltage:
        if V(1) > 1.0
            % If Bus 1 voltage is greater than 1.0 p.u., decrease Bus 5 voltage
            step = -abs(step);  % Ensure step is negative to decrease voltage
        elseif V(1) < 1.0
            % If Bus 1 voltage is less than 1.0 p.u., increase Bus 5 voltage
            step = abs(step);  % Ensure step is positive to increase voltage
        end
        V(num_bus) =V(num_bus) + step;  % Limit Bus 5 voltage between 0.95 and 1.5 p.u.
    end
end

% Display the final voltage at each bus (in p.u.)
disp('Voltages at each bus (in p.u.):');
disp(V);

% Display the final voltage at each bus (in p.u.), only show magnitude and angle
disp('Voltages at each bus (in p.u.):');
for i = 1:num_bus
    magnitude_V = abs(V(i));  % Voltage magnitude in p.u.
    angle_V = rad2deg(angle(V(i)));  % Voltage angle in degrees
    
    % Convert magnitude to real voltage (V) based on base voltage (230V)
    real_voltage = magnitude_V * 230;  
    
    % Display results for both p.u. and real voltage, with angle in degrees
    fprintf('Bus %d Voltage Magnitude: %.4f p.u., %.2f V, Angle: %.2f degrees\n', ...
        i, magnitude_V, real_voltage, angle_V);
end
