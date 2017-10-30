addpaths;
ccc
%% GET TRAJECTORIES FROM SPECIFIC EXPERIEMTN
ccc

% CONFIGURATION (EXPMODE / #TRAJ / LEN / VERBOSE)
% 'highway' / 'objectworld' / 'gridworld'
opt = struct('expmode', 'gridworld' ... 
    , 'ntraj', 100, 'trajlen', 32, 'VERBOSE', 2);

% SAMPLE TRAJECTORIES (STATE / ACTION)
trajs = sample_trajs_from_mdp(opt);

%%
