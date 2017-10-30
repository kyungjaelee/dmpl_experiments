% Convenience script for running a single test.
addpaths;
close all; clear; clc;
global l1
global epsilon
global lambda
l1 = 1;
epsilon = 0.01;
lambda = 1;
% test_result = runtest('dmpl',struct(),'linearmdp',...
%     'objectworld',struct('n',32,'determinism',0.7,'seed', 1, 'continuous', 1),...
%     struct('training_sample_lengths', 32, 'training_samples', 128, 'verbosity',2));
test_result = runtest('dmpl',struct(),'linearmdp',...
    'highway',struct('n',64,'determinism',0.7,'seed', 1, 'continuous', 1),...
    struct('training_sample_lengths', 64, 'training_samples', 128, 'verbosity',2));

% Visualize solution.
printresult(test_result);
visualize(test_result);
