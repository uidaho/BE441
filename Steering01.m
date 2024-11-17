% Step input for steering wheel. Steering wheel dynamics are unknown. This code collects the step response data to estimate steering parameters.
clear all
joystick = vrjoystick(1,'forcefeedback'); % Initialize joystick with force feedback

% Create a loop to continuously read input
i = 1; % Initialize loop counter

% Send steering wheel all the way to the left
force(joystick, 1, 1); % Apply maximum force to the left
pause(5); % Pause for 5 seconds to allow the joystick to reach the leftmost position
% At this location, the position should read -1
force(joystick, 1, -1); % Apply maximum force to the right
Pos = read(joystick); % Read the current position of the joystick
tic; % Start timer

while Pos(1) <= 0.98 % Continue loop until joystick position is close to the rightmost position. It may never reach 1.0 so 0.98 is selected 
    % Read the joystick data
    data(i, 1) = toc; % Record the elapsed time
    Pos = read(joystick); % Update the joystick position
    data(i, 2) = Pos(1); % Record the joystick position
    i = i + 1; % Increment loop counter
end

% Release force
force(joystick, 1, 0); % Stop applying force to the joystick

% Convert the position from -1 to 1 to percent change
y = (data(:, 2) - data(1, 2)); % Calculate the change in position
t = data(:, 1); % Extract the time data
Omega = y ./ t; % Calculate the rate of change of position
Sampling_Rate = t(end) / (length(t) - 1) * 1e6; % Calculate the sampling rate in milliseconds

% Plot the rate of change of position against time
plot(t, Omega); 
xlabel('Time (s)'); % Label x-axis
ylabel('Rate of Change of Position'); % Label y-axis
title('Step Response of Steering Wheel'); % Title of the plot
