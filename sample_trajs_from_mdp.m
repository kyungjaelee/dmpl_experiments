function [trajs, etc] = sample_trajs_from_mdp(opt)

% PARSE
expmode = opt.expmode;
ntraj   = opt.ntraj;
trajlen = opt.trajlen;
VERBOSE = opt.VERBOSE;

% CONSTRUCT MDP & SOLVE MDP
mdp_params  = struct('continuous', 1);  % USE DEFAULT PARAMETERS 
test_params = struct('training_sample_lengths', trajlen ...
    , 'training_samples', ntraj, 'verbosity', VERBOSE);
test_params = setdefaulttestparams(test_params);
[mdp_data, r , feature_data, true_feature_map] ...
    = feval(strcat(expmode,'build'), mdp_params);
if ~isempty(test_params.true_features),
    true_feature_map = test_params.true_features;
end
mdpmodel = 'standardmdp'; % OPTIMAL POLICY COMES FROM SOLVING THIS
mdp_solution = feval(strcat(mdpmodel,'solve'), mdp_data, r);

% SAMPLE TRAJECTORIES (STATE / ACTION)
trajs = sampleexamples(mdpmodel, mdp_data, mdp_solution, test_params);

% OTHER USEFUL DATA
etc.mdp_data     = mdp_data;
etc.mdp_solution = mdp_solution;
etc.r            = r;
etc.true_feature_map = true_feature_map;
etc.feature_data = feature_data;
etc.mdp_params   = mdp_params;
