%% Reproduction of Figure 3
% Detailed motion of two cars showing the effect of a fluctuation 
% in the acceleration of the lead car.

% Reference:
% [1] Herman, R., Montroll, E. W., Potts, R. B., & Rothery, R. W. (1959). 
% Traffic dynamics: analysis of stability in car following. Operations research, 7(1), 86-106.

close all; clear; clc;


%% Simulation Parameters
Delta = 1.5;                            % Response delay (s)
C = 1 / exp(1);                         % C = λ Δ / M, (1/exp(1) ≈ 0.368)
u = 70;                                 % Initial velocity (ft/s)
initial_D = 70;                         % Initial separation distance (ft)
simu_T = 20;                            % Total simulation time (s)
dt = 0.01;                              % Time step (s/step)
N = 2;                                  % Number of cars


%% Leading car's (Car 1) acceleration control
t_dec_start = 2.0;                      % Start time of deceleration, in sec
t_dec_end = 4.0;                        % End time of deceleration
t_acc_start = 4.0;                      % ... acceleration
t_acc_end = 6.0;
dec_mag = -6.0;                         % Deceleration magnitude (ft/s^2)
acc_mag = 6.0;                          % Accelertion magnitude (ft/s^2)



%% Initialization 
num_steps = round(simu_T / dt);         % Total simulation steps
time_sec = (0:num_steps) * dt;          % Time series (s)
lambda_M = C / Delta;                   % Sensitivity and mass parameters (= lambda/M)
res_delay = round(Delta / dt);          % Response delay (time steps)

% Acceleration of car 1
a1 = zeros(1, num_steps + 1); 
for i = 1:num_steps+1
    t_sec = time_sec(i);
    if t_sec > t_dec_start && t_sec <= t_dec_end
        % Decelerate
        a1(i) = dec_mag;
    elseif t_sec > t_acc_start && t_sec <= t_acc_end
        % Accelerate
        a1(i) = acc_mag;
    else
        % Do nothing
        a1(i) = 0;
    end
end



%% Run simulation
[a, v, x] = RunSimulation(a1, N, num_steps, u, lambda_M, res_delay, dt, initial_D);



%% Plotting Figure 3 (only plots the first two cars)

% Quantities for Plotting
rel_v1 = v(1, :) - u;               % Velocity relative to initial u
rel_v2 = v(2, :) - u;               % Velocity relative to initial u
rel_v = v(1, :) - v(2, :);          % Relative velocity (v1 - v2)
rel_dist = x(1, :) - x(2, :);       % Relative distance (x1 - x2)

figure('Position', [100, 100, 700, 900]);

% 1. Acceleration Plot
subplot(4, 1, 1);
plot(time_sec, a(1,:), 'b-', 'LineWidth', 1.5, 'DisplayName', 'Car 1 ($\ddot{x}_1$)');
hold on;
plot(time_sec, a(2,:), 'r--', 'LineWidth', 1.5, 'DisplayName', 'Car 2 ($\ddot{x}_2$)');
hold off;
grid on;
ylabel('ACCELERATION (ft/sec^2)');
ylim([-8 8]);
xlim([0 simu_T]);
legend('Interpreter', 'latex', 'Location', 'NorthEast');
title('Figure 3: Detailed motion of two cars (\Delta=1.5 s, C=e^{-1}=0.368).');

% 2. Velocity Plot (relative to u)
subplot(4, 1, 2);
plot(time_sec, rel_v1, 'b-', 'LineWidth', 1.5, 'DisplayName', 'Car 1 ($\dot{x}_1 - u$)');
hold on;
plot(time_sec, rel_v2, 'r--', 'LineWidth', 1.5, 'DisplayName', 'Car 2 ($\dot{x}_2 - u$)');
hold off;
grid on;
ylabel('VELOCITY (ft/sec)');
ylim([-15 5]);
xlim([0 simu_T]);
legend('Interpreter', 'latex', 'Location', 'SouthEast');

% 3. Relative Velocity Plot
subplot(4, 1, 3);
plot(time_sec, rel_v, 'g-', 'LineWidth', 1.5);
grid on;
ylabel('RELATIVE VELOCITY (ft/sec)');
ylim([-18 8]);
xlim([0 simu_T]);
text(0.5, 0.9, '($\dot{x}_1 - \dot{x}_2$)', 'Units', 'normalized', 'Interpreter', 'latex');

% 4. Relative Distance Plot
subplot(4, 1, 4);
plot(time_sec, rel_dist, 'g-', 'LineWidth', 1.5);
grid on;
ylabel('RELATIVE DISTANCE (ft)');
ylim([40 80]);
xlim([0 simu_T]);
text(0.5, 0.9, '($x_1 - x_2$)', 'Units', 'normalized', 'Interpreter', 'latex');
xlabel('TIME (sec)');