function [a, v, x] = RunSimulation(a1, N, num_steps, u, lambda_M, res_delay, dt, initial_D)
%% Simulate the motion of a line of N cars, with a given acceleration input for the leading car.
% Return the acceleration, velocity, and position vectors of cars.
% Input parameters are the same as those defined in Main_<Fig>.m


% Initialize Car States
x = zeros(N, num_steps + 1);    % Position (ft)
v = zeros(N, num_steps + 1);    % Velocity (ft/s)
a = zeros(N, num_steps + 1);    % Acceleration (ft/s^2)


% Initial conditions of cars (at t=0)
x(1, 1) = 0;                    % Position of car 1
v(1, 1) = u;                    % Velocity
a(1, :) = a1;                   % Apply acceleration
for car_id = 2:N                % Car 2-N
    x(car_id, 1) = x(car_id-1, 1) - initial_D;
    v(car_id, 1) = u;
    a(car_id, 1) = 0;
end


% Simulation starts
for i = 1:num_steps
    curr_t_step = i;
    next_t_step = i + 1;

    % Update from downstream to upstream
    for car_id = 1:N
        
        % Leading car (Car 1)
        if car_id == 1
            v(car_id, next_t_step) = v(1, i) + a(1, i) * dt;    % speed update
            x(car_id, next_t_step) = x(1, i) + v(1, i) * dt;    % position update
            continue;
        end

        % Car 2 - N

        % Delayed response (get the previous velocities)
        if curr_t_step > res_delay
            % t > Δ, update according to the front car
            delay_t_step = curr_t_step - res_delay + 1;     % time step with reference to vehicles' states
            v1_delayed = v(car_id-1, delay_t_step);         % leading car
            v2_delayed = v(car_id, delay_t_step);           % following car
        else
            % t <= Δ, maintain the initial velocity
            v1_delayed = u;
            v2_delayed = u;
        end

        % Motion state updates
        a(car_id, curr_t_step) = lambda_M * (v1_delayed - v2_delayed);
        v(car_id, next_t_step) = v(car_id, curr_t_step) + a(car_id, curr_t_step) * dt;
        x(car_id, next_t_step) = x(car_id, curr_t_step) + v(car_id, curr_t_step) * dt;
    end

end


end