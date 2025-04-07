%% Reproduction of Figure 6
% Asymptotic instability of a line of nine cars under the influence
% of velocity control, C=0.8 and Δ=2 seconds.

% Reference:
% [1] Herman, R., Montroll, E. W., Potts, R. B., & Rothery, R. W. (1959). 
% Traffic dynamics: analysis of stability in car following. Operations research, 7(1), 86-106.

close all; clear; clc;


%% Simulation Parameters
Delta = 2.0;                            % Response delay (s)
C = 0.8;                                % C = λ Δ / M
u = 40;                                 % Initial velocity (ft/s)
initial_D = 40;                         % Initial separation distance (ft)
simu_T = 30;                            % Total simulation time (s)
dt = 0.01;                              % Time step (s/step)
N = 9;                                  % Number of cars


%% Leading car's (Car 1) acceleration control
t_dec_start = 2.0;                      % Start time of deceleration, in sec
t_dec_end = 4.0;                        % End time of deceleration
t_acc_start = 4.0;                      % ... acceleration ...
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



%% Plotting Figure 6
rel_pos = x - ones(N,1) * (u * time_sec);   % Relative position to equilirium state

figure('Position', [100, 100, 700, 900]);
hold on;
for car_id = 1:N
    plot(rel_pos(car_id, :), time_sec, '-', 'LineWidth', 1.5);
    text_str = num2str(car_id);
    text(0-(car_id-0.7)*initial_D, 2, text_str);
end
grid on;
ylabel('TIME (sec)');
ylim([0 simu_T]);
xlim([0-N*initial_D 0]);
xlabel('CAR POSITION (ft)');
box on;
title(['Figure 6: Asymptotic instability of a line of nine cars under' ...
    '\newline the influence of velocity control, C=0.8 and \Delta=2 s.']);