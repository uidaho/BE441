% Generate a time vector from 0 to 1000 seconds (1-second increments)
t = 0:1000;

% Define the setpoint value (input signal) as 50% of full scale
x = 50;

% Set the proportional gain for the controller
kp = 2;

% Create the transfer function of the plant: G(s) = 1 / (470s + 1)
F = tf(1, [470 1]); 

% Calculate the step response of the closed-loop system with an effective gain of (kp + 1),
% scaled by the setpoint value, and considering the feedback structure
y = step((kp + 1) * x * F / (1 + kp * F), t);

% Compute the control effort (u) using the proportional action: u = kp * (x - y)
u = (x - y) * kp;

% Plot the setpoint (SP) as a blue dash-dot line
plot(t, t * 0 + x, 'b-.'); % Constant line at x (setpoint)
hold on; % Hold the plot to overlay additional plots

% Plot the system response (y) as a solid black line
plot(t, y, 'k');

% Plot the control effort (u) as a dashed line
plot(t, u, '--');

% Add annotation for the control effort (u) at a specific point
text(80, 60, '\leftarrow u');

% Add annotation for the setpoint (SP) at a specific point
text(200, 52, 'SP = x');

% Add annotation for the system response (y) at a specific point
text(80, 20, '\leftarrow y');

% Label the x-axis as "Time (s)"
xlabel('Time (s)');

% Label the y-axis as "Value in % of full scale"
ylabel('Value in % of full scale');

% The resulting plot will show:
% - The setpoint (SP) as a blue dash-dot line indicating the desired target value.
% - The system response (y) as a solid black line showing how the output evolves over time.
% - The control signal (u) as a dashed line representing the proportional control action.
