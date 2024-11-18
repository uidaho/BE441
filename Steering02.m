% Pid controls of the steering wheel.  This code will implement the PID controller for gaming steering wheel to drive around "Circuit of the Americas" race track in Austin, TX.
clear all
close all

% Convert speed from mph to m/s
Speed = 200 * 0.44704; % mph to m/s
kp = 1.05; % Proportional gain for the controller
ki = 0.1; % Integral gain for the controller

% Calculate the time step based on speed
dt = 5 / Speed;

% Initialize joystick with force feedback
Wheel = vrjoystick(1, 'forcefeedback');

% Load the track data
load Americas;

% Add end point before the first point and first point after the end
Track = [Track(end, :); Track; Track(1, :)];
Center = [Track(:, 1) Track(:, 2)];
Left = [Track(:, 3) Track(:, 4)];
Right = [Track(:, 5) Track(:, 6)];

% Create the main plot with road boundary in red and center line in cyan
plot(Left(:, 1), Left(:, 2), 'r');
hold on
plot(Right(:, 1), Right(:, 2), 'r');
plot(Center(:, 1), Center(:, 2), '--k');
scatter(Center(1, 1), Center(1, 2), 'filled');
text(Center(1, 1), Center(1, 2), 'Start');

buffer = 20;
axis([min(Center(:, 1)) - buffer, max(Center(:, 1)) + buffer, min(Center(:, 2)) - buffer, max(Center(:, 2)) + buffer]);

% Generate vectors connecting each point to calculate turn angle
V = diff(Center);
L = hypot(V(:, 1), V(:, 2));
Vn = V ./ L; % Normalize to unit length
vperpn = [-Vn(:, 2), Vn(:, 1)]; % Perpendicular vector to Vn

% Calculate the turn angle at each point
% The cosine of the angle can be calculated using the dot product
% cos(theta) = (A dot B) of normal vectors A and B
% The left or right turn can be determined from the cross product

dot = sum([Vn(1:end-1, 1), Vn(1:end-1, 2)] .* [Vn(2:end, 1), Vn(2:end, 2)], 2);
cross = Vn(1:end-1, 2) .* Vn(2:end, 1) - Vn(1:end-1, 1) .* Vn(2:end, 2);

% SP = (sign(cross) .* acosd(dot)) / 30;

% Create animated line to track the car path
p1 = animatedline('Color', [0, 1, 0], 'LineWidth', 2);
addpoints(p1, Center(1, 1), Center(1, 2));

% Create zoomed-in plot
zoom = 50;
p2 = axes('Position', [.6, .15, .3, 0.3]); % Adjust position and size as needed
plot(Left(:, 1), Left(:, 2), 'r');
hold on
plot(Right(:, 1), Right(:, 2), 'r');
plot(Center(:, 1), Center(:, 2), '--k');
scatter(Center(1, 1), Center(1, 2), 'filled');
xticklabels([]);
yticklabels([]);
xlim(p2, [Center(1, 1) - zoom, Center(1, 1) + zoom]); % Set x-axis limits
ylim(p2, [Center(1, 2) - zoom, Center(1, 2) + zoom]); % Set y-axis limits

p3 = animatedline('Color', [.1, 1, .2], 'LineWidth', 1);

% Initialize variables for the control loop
esum = 0;
Last_Position = Track(1, 1:2); % Set last point to end point

% Main control loop
for i = 2:length(Track) - 1
    Current_Position = Track(i, 1:2);
    Next_Position = Track(i + 1, 1:2);
    V1 = (Current_Position - Last_Position);
    V1 = V1 / hypot(V1(1), V1(2));
    V2 = (Next_Position - Current_Position);
    V2 = V2 / hypot(V2(1), V2(2));
    Dot = V1 * V2';
    Cross = V1(2) * V2(1) - V1(1) * V2(2);
    SP = sign(Cross) * acosd(Dot) / 30;
    
    tic; % Set t = 0
    n = 1;
    while toc < dt % toc returns the time since last tic in seconds
        Axes_values = read(Wheel);
        PV = Axes_values(1); % Steering wheel position from -1 to 1
        Err = (SP - PV);
        esum = Err * toc / n + esum; % The error accumulation rate is the area under the error curve, which is sum of Err * dt. dt = toc / n
        n = n + 1;
        u = kp * Err + ki * esum; % Control signal
        % Apply force as u value
        force(Wheel, 1, -u); % Since 1 makes it move left (-1) position, the sign of u is reversed.
    end
    V2perp = [V2(2), -V2(1)];
    Last_Position = Last_Position + Speed * dt * (V2 * cosd(esum * 30) - V2perp * sind(esum * 30));
    addpoints(p1, Last_Position(1), Last_Position(2));
    addpoints(p3, Last_Position(1), Last_Position(2));
    xlim(p2, [Current_Position(1) - zoom, Current_Position(1) + zoom]); % Set x-axis limits
    ylim(p2, [Current_Position(2) - zoom, Current_Position(2) + zoom]); % Set y-axis limits
    drawnow;
    fprintf('SP: %.2f, PV: %.2f, esum: %.2f\n', SP, PV, esum);
end
