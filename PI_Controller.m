% BE 441/541: Instrumentation and Controls
% PID controller tuning and implementation from a step response

clear all; % Clears all defined MATLAB variables

% Define PI controller parameters
Kp = 2.0; % Change this value to desired proportional gain
Ki = 0.5; % Change this value to desired integral gain

% Define other parameters
dt = 0.5; % Sampling interval in seconds
t_end = 10 * 60; % Time to record in seconds (converted from 10 minutes)
T_Safe = 120; % Safe temperature threshold in °F
SP = 100; % Setpoint temperature in °F

% Create an Arduino object. Replace 'ComX' with the correct COM port (e.g., 'COM3')
a = arduino('ComX', 'Nano');

% Record the start time
startTime = datetime('now');

% Initialize variables for PI control
integral = 0;
previous_error = 0;

% Initialize time tracking and data logging
Delta_t = seconds(datetime('now') - startTime); % Time elapsed in seconds
Count = 0; % Initialize counter for data points

% Main loop to control temperature until `t_end` is reached
while Delta_t < t_end
    % Read the current temperature in °F from the sensor connected to 'A0'
    PV = readVoltage(a, 'A0') * 180 + 32; % Adjust pin if necessary
    
    % Calculate the error
    error = SP - PV;
    
    % Update integral term
    integral = integral + error * dt;
    
    % Calculate control output
    u = Kp * error + Ki * integral;
    
    % Limit the control output to be between 0 and 1
    u = max(0, min(1, u));
    
    % Apply the control output to the heater
    writePWMDutyCycle(a, 'D3', u);
    
    % Check if the temperature exceeds the safe threshold
    if PV > T_Safe
        writePWMDutyCycle(a, 'D3', 0); % Stop the PWM signal if temperature is unsafe
        disp('Temperature exceeded safe level...Process stopped.')
        break; % Terminate the process
    end
    
    % Update the time elapsed
    Delta_t = seconds(datetime('now') - startTime);
    
    % Increment the counter and store data
    Count = Count + 1;
    t(Count) = Delta_t; % Store the time elapsed
    T(Count) = PV; % Store the temperature reading
    
    % Display the current time and temperature
    disp([t(Count), T(Count)]);
    
    % Pause for the sampling interval
    pause(dt);
end

% Save the recorded data to a .mat file
save('temperature_data.mat', 't', 'T');

% Plot the recorded temperature data
plot(t, T);
xlabel('Time (s)');
ylabel('Temperature (°F)');
title('PI Control Response');
grid on;
