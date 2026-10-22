%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% setup                                          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% global fixed time step
TIME_STEP = 0.1;

% sim global vars
time = 0;

% create player tank
player = Tank([-20, 30]);

% create enemy tank
enemy = Tank([0, 0]);

% all tanks in the sim
tanks = [player, enemy];
num_tanks = numel(tanks);

% create renderer for all tanks
%renderer = Renderer(tanks);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% sim loop                                       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
sim_running = true;
while sim_running
    frame_start = tic;

    % update tank kinematics
    for i = 1:num_tanks
        tanks(i).update(TIME_STEP, 0);
    end

    % report tank states
    playerpos = player.get_pos();
    playervel = player.get_vel();
    fprintf("Player Props: x=%f | y=%f    |    v=%f\n", playerpos(1), playerpos(2), sqrt(playervel(2)^2 + playervel(2)));

    % increment time step
    time = time + TIME_STEP;

    % draw the new state
    %renderer.render();

    % if window closed, end sim
    %sim_running = renderer.is_open();

    % delay
    elapsed = toc(frame_start);
    if elapsed < (1/60)
        pause((1/60) - elapsed);
    end
end
