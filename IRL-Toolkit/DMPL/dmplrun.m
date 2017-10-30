function [ irl_result ] = dmplrun( algorithm_params,mdp_data,mdp_model,...
    feature_data,example_samples,true_features,verbosity )

etc.mdp_data = mdp_data;
etc.true_feature_map = true_features;
etc.feature_data = feature_data;

algorithm_params = dmpldefaultparams(algorithm_params);

sample_opt = algorithm_params;
sample_opt.expmode = mdp_model;
[ntraj, trajlen] = size(example_samples);
sample_opt.ntraj = ntraj;
sample_opt.trajlen = trajlen;
sample_opt.VERBOSE = 2;
mdp_solve = str2func(strcat(mdp_model,'solve'));

tic;
pde = init_pde_mdp(example_samples, etc, sample_opt);

r_s_opt = log(get_pde(pde, feature_data.splittable)+eps);

% Print timing.
time = toc;
if verbosity ~= 0,
    fprintf(1,'Optimization completed in %f seconds.\n',time);
end;

r = repmat(r_s_opt, [1,mdp_data.actions]);
soln = mdp_solve(mdp_data,r);
v = soln.v;
q = soln.q;
p = soln.p;

% Construct returned structure.
irl_result = struct('r',r,'v',v,'p',p,'q',q,'r_itr',{{r}},'model_itr',{{r_s_opt}},...
    'model_r_itr',{{r}},'p_itr',{{p}},'model_p_itr',{{p}},...
    'time',time);

end

