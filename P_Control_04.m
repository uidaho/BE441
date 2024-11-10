% Define the time vector from 0 to 2000
t = 0:2000;

% Set the setpoint value
x = 50;

% Define the proportional gain
kp = 2;

% Define the integral gain
ki = 0.01;

% Define the disturbance value
d = 10;

% Create the transfer function for the controller G(s) = kp + ki/s
G = tf([kp ki], [1 0]);

% Create the transfer function for the plant F(s) = 1/(470s + 1)
F = tf(1, [470 1]);

% Calculate the closed-loop transfer function Y(s) = F(s) / (1 + G(s)F(s))
Y = F / (1 + G * F);

% Compute the step response of the closed-loop system with disturbance
y = step((x * G + d) * Y, t);

% Calculate the transfer function for the control signal U(s) = G(s) / (1 + G(s)F(s))
U = G / (1 + G * F);

% Compute the step response of the control signal
u = step(x * U, t);

% Plot the setpoint as a blue dash-dot line
plot(t, t * 0 + x, 'b-.'); % blue dash-dot

% Hold the current plot
hold on

% Plot the output response as a black line
plot(t, y, 'k'); % Black line

% Plot the control signal as a dashed line
plot(t, u, '--'); % dash line

% Add text annotation for the control signal
text(302, 83, '\leftarrow u');

% Add text annotation for the setpoint
text(80, 52, 'SP = x');

% Add text annotation for the output response
text(103, 20, '\leftarrow y');

% Label the x-axis
xlabel('Time (s)');

% Label the y-axis
ylabel('Value in % of full scale');
