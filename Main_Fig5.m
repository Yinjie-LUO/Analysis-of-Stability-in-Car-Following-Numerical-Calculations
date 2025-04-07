%% Reproduction of Figure 5
% Separation distances of a line of cars under the influence of
% velocit;y control for different values of C.

% Reference:
% [1] Herman, R., Montroll, E. W., Potts, R. B., & Rothery, R. W. (1959). 
% Traffic dynamics: analysis of stability in car following. Operations research, 7(1), 86-106.

close all; clear; clc;


%% Simulation Parameters
Delta = 1.5;                            % Response delay (s)
C = [1/exp(1), 0.5, 0.75];              % C = λ Δ / M (could be more or less than 3)
u = 70;                                 % Initial velocity (ft/s)
initial_D = 70;                         % Initial separation distance (ft)
simu_T = 60;                            % Total simulation time (s)
dt = 0.01;                              % Time step (s/step)
N = 8;                                  % Number of cars


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

% Quantities for Plotting
sep_dist = cell(length(C), 1);      % Separation distances of a line of cars under different C



%% Run simulations under different C
for i = 1:length(C)
    [a, v, x] = RunSimulation(a1, N, num_steps, u, lambda_M(i), res_delay, dt, initial_D);
    
   % Separation distances of a line of cars under a specific C
    sep_dist{i, 1} = zeros(N - 1, num_steps + 1);
    for car_id = 2:N
        sep_dist{i, 1}(car_id, :) = x(car_id - 1, :) - x(car_id, :);
    end
end



%% Plotting Figure 5
figure('Position', [100, 100, 700, 900]);
for i = 1:length(C)
    subplot(length(C), 1, i);
    hold on;
    for car_id = 2:2:N
        plot(time_sec, sep_dist{i, 1}(car_id, :), '-', 'LineWidth', 1.2, ...
            'DisplayName', [num2str(car_id-1), ' - ', num2str(car_id)]);
    end
    grid on;
    ylabel('SEPARATION DISTANCES (ft)');
    ylim([20 120]);
    xlim([0 simu_T]);
    text_str = ['$C = ', num2str(C(i)), '$'];
    text(0.8, 0.1, text_str, 'Units', 'normalized', 'Interpreter', 'latex');
    xlabel('TIME (sec)');
    box on;
    if i == 1
        title(['Figure 5: Separation distances of a line of cars under ' ...
            'different\newline values of C (\Delta=1.5 s).']);
        legend('Location', 'NorthEast');
    end
end
