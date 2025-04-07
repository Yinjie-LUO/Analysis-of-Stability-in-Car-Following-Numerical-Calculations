%% Reproduction of Figure 4
% Deviation from constant spacing of two cars for different values of C; 
% the acceleration of the lead car is the same as that shown in Fig. 3.

% Reference:
% [1] Herman, R., Montroll, E. W., Potts, R. B., & Rothery, R. W. (1959). 
% Traffic dynamics: analysis of stability in car following. Operations research, 7(1), 86-106.

close all; clear; clc;


%% Simulation Parameters
Delta = 1.5;                            % Response delay (s)
C = [0.50, 0.80, 1.57, 1.60];           % C = λ Δ / M (could be more or less than 4)
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

% Quantities for Plotting
dist_rel_to_initial_D = zeros(length(C), num_steps + 1);



%% Run simulations under different C
for i = 1:length(C)
    [a, v, x] = RunSimulation(a1, N, num_steps, u, lambda_M(i), res_delay, dt, initial_D);
    
    dist_rel_to_initial_D(i, :) = x(1, :) - x(2, :) - initial_D;   % only plots the first two cars
end



%% Plotting Figure 4
figure('Position', [100, 100, 700, 900]);
for i = 1:length(C)
    subplot(length(C), 1, i);
    plot(time_sec, dist_rel_to_initial_D(i, :), 'k-', 'LineWidth', 1.0);
    grid on;
    ylabel('RELATIVE DISTANCE (ft)');
    ylim([-30 30]);
    xlim([0 simu_T]);
    text_str = ['$C = ', num2str(C(i)), '$'];
    text(0.05, 0.8, text_str, 'Units', 'normalized', 'Interpreter', 'latex');
    xlabel('TIME (sec)');
    if i == 1
        title(['Figure 4: Deviation from constant spacing of ' ...
            'two cars for different\newline values of C (\Delta=1.5 s).']);
    end
end
