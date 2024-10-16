% Define constants
E = 80; % Voltage (V)
I = 20; % Current (A)
N = 1700; % Speed (rpm)

% Calculate angular velocity
w = N / 60 * 6.28; % Angular velocity (rad/s)

% Calculate torque
T = 1500 / w; % Torque (Nm)

% Calculate constant K
K = T / I^2; % Constant (Nm/A^2)

% Calculate resistance
R = E / I - K * w; % Resistance (Ohm)

% Calculate efficiency
e = K * I * w / 80; % Efficiency (dimensionless)

% Plotting
N = 100:1800; % Speed range (rpm)
w = N / 60 * 6.28; % Angular velocity (rad/s)

% Calculate torque over the speed range
T = K * E^2 ./ (R + K * w).^2; % Torque (Nm)

% Calculate power over the speed range
P = T .* w; % Power (W)

% Calculate current over the speed range
I = E ./ (R + K * w); % Current (A)

% Calculate efficiency over the speed range
e = P ./ (E * I); % Efficiency (dimensionless)

% Plot Torque vs Speed
figure(1)
subplot(2,2,1)
plot(N, T)
xlabel('Speed (rpm)')
ylabel('Torque (Nm)')
title('Torque')

% Plot Current vs Speed
subplot(2,2,2)
plot(N, I)
xlabel('Speed (rpm)')
ylabel('Current (A)')
title('Current')

% Plot Power vs Speed
subplot(2,2,3)
plot(N, P)
xlabel('Speed (rpm)')
ylabel('Power (W)')
title('Power')

% Plot Efficiency vs Speed
subplot(2,2,4)
plot(N, e * 100) % Convert efficiency to percentage
xlabel('Speed (rpm)')
ylabel('Efficiency (%)')
title('Efficiency')
