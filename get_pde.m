function y = get_pde(pde, Xtest)
% GET PROXIMAL DENSITY

alphathat = pde.alphathat;
hypopt = pde.hypopt;
Xu = pde.Xu;
Lu = pde.Lu;
nzr_X = pde.nzr_inputs;

% 1. NORMALIZE
nzpnts  = get_nzval(nzr_X, Xtest);

% 2. COMPUTE PROXIMAL DENSITY
Ktestu  = kernel_se(nzpnts, Xu, ones(size(nzpnts, 1), 1), Lu, hypopt);
y       = Ktestu*alphathat;

