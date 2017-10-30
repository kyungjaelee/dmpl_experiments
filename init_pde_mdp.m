function pde = init_pde_mdp(trajs, etc, sample_opt)
% TRAIN PROXIMAL DENSITY FOR MARKOX DECISION PROCESSES

% CONCATENATE INPUT AND LEVERAGES FOR TRAINING DMPL
inputs = []; levs = [];
for trajidx = 1:sample_opt.ntraj % FOR ALL TRAJS
    for timeidx = 1:sample_opt.trajlen % FOR EACH TIME INDEX
        % GET STATE AND ACTION
        s = trajs{trajidx, timeidx}(1);
        a = trajs{trajidx, timeidx}(2);
        % CONVERT STATE TO FEATURE
        fvec = etc.feature_data.splittable(s, :);
        avec = zeros(1, etc.mdp_data.actions); avec(a) = 1;
        favec = [fvec];
        % CONCATENATE
        lev = 1;
        inputs = [inputs ; favec];
        levs   = [levs ; lev^(sample_opt.trajlen-timeidx)];
    end % for timeidx = 1:opt.trajlen % FOR EACH TIME INDEX
end % for trajidx = 1:opt.ntraj % FOR ALL TRAJS

% NORMALIZE INPUT
nzr_inputs = init_nz(inputs);

% TRAIN
Xd = get_nzval(nzr_inputs, inputs);
Ld = levs;
lambda = sample_opt.lambda; % 1E-1 ADDED TO THE DIAGONAL// HILBERTNORM
beta   = sample_opt.beta; % 0 // COEFFICIENT
% MEDIAN TRICK
dim = size(Xd, 2);
Nd  = size(Xd, 1);
dismat = cell(1, dim);
deddist = zeros(1, dim);
for i = 1:dim
    dismat{i} = pdist(Xd(randsample(Nd, min(1000, Nd)), i));
    deddist(i) = median(dismat{i});
end
mininvlen = 1;
maxinvlen = 10;

% LARGE INV_LENGTH => SHARPE KERNEL
hypinit = [100*deddist 1]';

% INDUCING SET
minX = min(min(Xd));
maxX = max(max(Xd));
nadd = 0;
Xu   = minX + (maxX-minX)*rand(nadd, dim);
nsel = min(Nd, 1000);
Xu   = [Xu ; Xd(randperm(Nd, nsel), :)];
Lu   = ones(size(Xu, 1), 1);
% RECOMPUTE THE NUMBER OF DATA
Nd   = size(Xd, 1);
Nu   = size(Xu, 1);
% COMPUTE KERNEL MATRIX
hypopt = hypinit;
KU = kernel_se(Xu, Xu, Lu, Lu, hypopt);
KD = kernel_se(Xu, Xd, Lu, Ld, hypopt);

% COMPUTE ALPHA
alphathat = 1/Nd*(lambda*KU + beta*eye(Nu))\KU*KD*ones(Nd, 1);

% PARSE OTHER USEFUL INFORMATION
pde.alphathat  = alphathat;
pde.dim        = dim;
pde.hypopt     = hypopt;
pde.Xu         = Xu;
pde.Lu         = Lu;
pde.nzr_inputs = nzr_inputs;









