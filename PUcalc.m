% Base parameters
V_base = 11e3;          % Base voltage in volts (V)
S_base = 100e6;         % Base power in volt-amperes (VA)

% Line parameters (per km)
R_per_km = 0.111;       % Resistance in ohms per kilometer (Ω/km)
L_per_km = 0.353e-3;    % Inductance in henries per kilometer (H/km)
f = 50;                 % Frequency in hertz (Hz)

% Calculate reactance (per km)
X_per_km = 2 * pi * f * L_per_km;   % Reactance in ohms per kilometer (Ω/km)

% Calculate base impedance
Z_base = V_base^2 / S_base;         % Base impedance in ohms (Ω)

% Calculate per-unit impedance (per km)
R_pu_per_km = R_per_km / Z_base;
X_pu_per_km = X_per_km / Z_base;

% Display results
fprintf('Per-unit resistance per km: %f pu/km\n', R_pu_per_km);
fprintf('Per-unit reactance per km: %f pu/km\n', X_pu_per_km);
