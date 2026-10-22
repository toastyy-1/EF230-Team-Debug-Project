%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% setup                                          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% global fixed time step
TIME_STEP = 1/60;

% sim global vars
time = 0;

% create player tank
player = Tank([0 0]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% sim loop                                       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
sim_running = true;
while sim_running

    % update player kinematics
    player.update(TIME_STEP);

    % increment time step
    time = time + TIME_STEP;

end