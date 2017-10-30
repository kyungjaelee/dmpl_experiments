addpaths;
ccc
%% SAMPLE / TRAIN / EXAMPLE TEST
ccc
% SAMPLE TRAJECTORIES (STATE / ACTION)
sample_opt = struct('expmode', 'objectworld' ...
    , 'ntraj', 100, 'trajlen', 32, 'VERBOSE', 2);
[trajs, etc] = sample_trajs_from_mdp(sample_opt);

% TRAIN PROXIMAL DENSITY ESTIMATOR (PDE)
pde = init_pde_mdp(trajs, etc, sample_opt);

% EXAMPLE USAGE
ntest = 100;
Xtest = rand(ntest, pde.dim);
y = get_pde(pde, Xtest);

% PLOT 
plot(y);

%%
