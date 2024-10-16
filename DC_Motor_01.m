% Matlab Code for plotting

% Define constants
E = 80; % Voltage (V)
R = 1; % Resistance (Ohm)

% Define speed range
N = 0:1800; % Speed (rpm)

% Calculate angular velocity
w = N/60*6.28; % Angular velocity (rad/s)

% Define back EMF constant
kB = 0.415; % Back EMF constant (V/rad/s)

% Calculate current
I = E - kB * w; % Current (A)

% Calculate torque
T = kB * I; % Torque (Nm)

% Calculate power
P = (T - 0.83) .* w; % Power (W)

% Calculate efficiency
E = P ./ (E * I); % Efficiency (dimensionless)

% Plotting the results
figure(1)

% Plot Torque vs Speed
subplot(2,2,1)
plot(N, T)
axis([0 1800 0 40])
xlabel('Speed (rpm)')
ylabel('Torque (Nm)')
title('Torque')

% Plot Current vs Speed
subplot(2,2,2)
plot(N, I)
axis([0 1800 0 80])
xlabel('Speed (rpm)')
ylabel('Current (A)')
title('Current')

% Plot Power vs Speed
subplot(2,2,3)
plot(N, P)
axis([0 1800 0 2000])
xlabel('Speed (rpm)')
ylabel('Power (W)')
title('Power')

% Plot Efficiency vs Speed
subplot(2,2,4)
plot(N, E * 100) % Convert efficiency to percentage
axis([0 1800 0 100])
xlabel('Speed (rpm)')
ylabel('Efficiency (%)')
title('Efficiency')
