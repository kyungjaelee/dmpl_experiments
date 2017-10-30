function [ algorithm_params ] = dmpldefaultparams(algorithm_params)

% Create default parameters.
default_params = struct(...
    'lambda',1E-1,...
    'beta',0);

% Set parameters.
algorithm_params = filldefaultparams(algorithm_params,default_params);
end

