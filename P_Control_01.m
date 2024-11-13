% An oil heating system represented by the transfer function, 1/(470s+1). The set point (SP=x) or the desired output is at 50%.
% Time in this model is measured in seconds.
% A proportional gain (kp = 2) is used to implement this algorithm. 
% Plot the setpoint x, oil temperature y and pwm imput u over time for 1000 seconds


% Below is the Matlab code to generate plant response using P-controller


% Generate a time vector from 0 to 1000 seconds (1-second increments)
t = 0:1000;

% Define the setpoint value (input signal) as 50% of full scale
x = 50;

% Set the proportional gain for the controller
kp = 2;

% Create the transfer function of the plant: G(s) = 1 / (470s + 1)
F = tf(1, [470 1]); 

% Define the closed-loop transfer function: Y(s) = (Kp * G(s)) / (1 + Kp * G(s)), see notes
Y = kp * F / (1 + kp * F);

% Calculate the step response of the closed-loop system, scaled by the setpoint value
y = step(x * Y, t);

% Compute the control signal (u), using the proportional term: u = Kp * (x - y)
u = kp * (x - y);

% Plot the setpoint (SP) as a blue dash-dot line
plot(t, t * 0 + x, 'b-.'); % Constant line at x (setpoint)
hold on; % Hold the current plot to overlay additional plots

% Plot the system response (y) as a solid black line
plot(t, y, 'k');

% Plot the control effort (u) as a dashed line
plot(t, u, '--');

% Annotate the control effort (u) on the plot at a specific point
text(100, 70, '\leftarrow u');

% Annotate the setpoint (SP) on the plot at a specific point
text(80, 52, 'SP = x');

% Annotate the system response (y) on the plot at a specific point
text(100, 16, '\leftarrow y');

% Label the x-axis as "Time (s)"
xlabel('Time (s)');

% Label the y-axis as "Value in % of full scale"
ylabel('Value in % of full scale');

% The resulting plot will show:
% - The setpoint (SP) as a blue dash-dot line indicating the desired target value.
% - The system response (y) as a solid black line showing how the system output evolves over time.
% - The control signal (u) as a dashed line, representing the proportional control effort.
