% An oil heating system represented by the transfer function, 1/(470s+1), it was desired to maintain the output (x) at 50%.
% Time in this model is measured in seconds.
% A proportional gain (kp = 2) is used to implement this algorithm. 
% A time delay of 5 minutes was observed between the step input and the start of the increase of the temperature.
% Plot the setpoint x, oil temperature y and pwm imput u over time for 1.5 hours.

% Matlab code to generate plant response using P-controller


% Generate a time vector from 0 to 1.5 hours (1-second increments)
t = 0:1.5*3600;


% Define the setpoint value (input signal) as 50% of full scale
x = 50;

% Set the proportional gain for the controller
kp = 2;

% Create the transfer function of the plant: G(s) = 1 / (470s + 1)
syms s;
F = tf(1, [470 1],'Inputdelay',300); 


% Define the closed-loop transfer function: Y(s) = (Kp * G(s)) / (1 + Kp * G(s)), see notes
Y = kp * F / (1 + kp * F);
U = kp / (1 + kp * F);

% Calculate the step response of the closed-loop system, scaled by the setpoint value
y = step(x * Y, t);
u = step(x * U, t);

% Plot the setpoint (SP) as a blue dash-dot line
% Time in mintues for plotting
tm = t/60;
plot(tm, t * 0 + x, 'b-.'); % Constant line at x (setpoint)
hold on; % Hold the current plot to overlay additional plots

% Plot the system response (y) as a solid black line
plot(tm, y, 'k');

% Plot the control effort (u) as a dashed line
plot(tm, u, '--');

% Annotate the control effort (u) on the plot at a specific point
text(5, 70, 'u');

% Annotate the setpoint (SP) on the plot at a specific point
text(30, 52, 'SP = 50');

% Annotate the system response (y) on the plot at a specific point
text(5, 16, 'y');

% Label the x-axis as "Time (minutes)"
xlabel('Time (minutes)');

% Label the y-axis as "Value in % of full scale"
ylabel('Value in % of full scale');

% Add a title
title('Proportional Control with Delay');


% The resulting plot will show:
% - The setpoint (SP) as a blue dash-dot line indicating the desired target value.
% - The system response (y) as a solid black line showing how the system output evolves over time.
% - The control signal (u) as a dashed line, representing the proportional control effort.
