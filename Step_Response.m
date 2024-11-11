clear all % Clears all defined MATLAB variables

u = 0.1; % Step PWM duty cycle value (between 0 and 1)
dt = 0.5; % Sampling interval in seconds
t_end = 10 * 60; % Time to record in seconds (converted from 10 minutes)
T_Safe = 120; % Safe temperature threshold in °F

% Create an Arduino object. Replace 'ComX' with the correct COM port (e.g., 'COM3')
a = arduino('ComX', 'Nano');

% Record the start time
startTime = datetime('now');

% Apply the initial PWM signal to the desired pin. Replace 'pinX' with the appropriate pin (e.g., 'D9')
writePWMDutyCycle(a, 'pinX', u);

% Initialize time tracking and data logging
Delta_t = seconds(datetime('now') - startTime); % Time elapsed in seconds
Count = 0; % Initialize counter for data points

% Main loop to record temperature until `t_end` is reached
while Delta_t < t_end
    % Read the current temperature in °F from the sensor connected to 'A0'
    PV = readVoltage(a, 'A0') * 180 + 32; % Adjust pin if necessary
    
    % Check if the temperature exceeds the safe threshold
    if PV > T_Safe
        writePWMDutyCycle(a, 'pinX', 0); % Stop the PWM signal if temperature is unsafe
        disp('Temperature exceeded safe level...Process stopped.')
        break; %Terminate the process
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

% Plot the recorded temperature data
plot(t, T);
xlabel('Time (s)');
ylabel('Temperature (°F)');
title('Step Response');
grid on;
