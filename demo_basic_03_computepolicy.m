addpaths;
ccc
%% COMPUTE POLICY BASED ON TRAINED PROXIMAL DENSITY ESTIMATOR
ccc

% TRAIN PROXIMAL DENSITY ESTIMATOR (PDE) FROM SAMPLED TRAJS
sample_opt = struct('expmode', 'objectworld' ...
    , 'ntraj', 100, 'trajlen', 16, 'VERBOSE', 2);
[trajs, etc] = sample_trajs_from_mdp(sample_opt);
pde = init_pde_mdp(trajs, etc, sample_opt);
fprintf('PROXIMAL DENSITY ESTIMATOR. \n');

mdp_data = etc.mdp_data;
na   = mdp_data.actions;
ns   = mdp_data.states;
sa_s = mdp_data.sa_s;
sa_p = mdp_data.sa_p;
s2f  = etc.feature_data.splittable;

%%
policy_beam = zeros(na, 1);
for sidx = 1:ns % FOR ALL STATE
    fprintf('[%d/%d] \n', sidx, ns);
    % BEAM SEARCH
    opt = struct('beamsize', 20, 'nbranch', na, 'horizon', 1 ...
        , 'pde', pde);
    beam  = init_beam(opt);
    currs = sidx;
    beam  = beam_search(beam, currs, mdp_data, s2f);
    % FIND THE MOST PROBABLE ACTION
    policy_beam(sidx) = beam.optimal_action;
end

%% COMPUTE POLICY GREEDY
clc
% FIRST CUMMULATE TRAJ
slist = [];
flist = [];
alist = [];
[n, len] = size(trajs);
for i = 1:n
    for j = 1:len
        sa = trajs{i, j};
        s = sa(1); a = sa(2);
        f = s2f(s, :);
        slist = [slist ; s];
        flist = [flist ; f];
        alist = [alist ; a];
    end
end


policy_beam = zeros(na, 1);
dists = zeros(na, 1);
for sidx = 1:ns % FOR ALL STATE
    if 0
        f = s2f(sidx, :);
        [outindex, d] = knnsearch(flist, f, 'k', 1);
        a_knn = alist(outindex);
    else
        [outindex, d] = knnsearch(slist, sidx, 'k', 1);
        a_knn = alist(outindex);
    end
    dists(sidx) = d;
    policy_beam(sidx) = a_knn;
end

clf; plot(dists); drawnow;

%% EVALUATE POLICY
clc
policy_oh    = zeros(ns, na);
for i = 1:ns, policy_oh(i, policy_beam(i)) = 1; end
irl_result   = struct('p', policy_beam, 'r', etc.r, 'sparsity', 0);
test_models  = {'standardmdp'};
score = valuescore(etc.mdp_solution, etc.r, irl_result, '', '', '' ...
    , etc.mdp_data, '', test_models{1});
disp(score(1));


%%







