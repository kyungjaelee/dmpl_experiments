%%
close all; clear; clc;
%%
% addpath('Output_Objectworld_Examples_32_05-Sep-2017_02.40.51');
addpath('Output_Objectworld_Examples_32_06-Sep-2017_10.21.13');
results = load('result.mat');

nr_algs = length(results.algorithms);
nr_test = length(results.test_params);
nr_model = length(results.test_model_names);
nr_restarts = results.restarts;

performance_list = zeros(nr_algs,nr_test,nr_restarts);
time_list = zeros(nr_algs,nr_test,nr_restarts);

for alg_idx = 1:nr_algs
%     if strfind(results.names{alg_idx},'DMPL')
%         results.names{alg_idx} = 'DMRL';
%     end
    for test_idx = 1:nr_test
        for model_idx = nr_model
            for rnd_idx = 1:nr_restarts
                performance_list(alg_idx,test_idx,rnd_idx) = abs(results.series_result{test_idx,alg_idx,rnd_idx}.metric_scores{2,4}(1));
                time_list(alg_idx,test_idx,rnd_idx) = results.series_result{test_idx,alg_idx,rnd_idx}.irl_result.time;
            end
        end
    end
end

wrld_size = results.mdp_params{1}.n;
%%
fig = figure(1); clf; hold on;lw = 3; ms = 15;
set(fig,'Position',[500 200 1000 500]);
demo_size_list = str2double(results.mdp_param_names);
colorlist = hsv(nr_algs);

h = [];
leg_list = {};
marker_style = {'o','v','^','d','>','s','p','.'};
for alg_idx = nr_algs:-1:1
    h(alg_idx) = plot(demo_size_list,squeeze(mean(performance_list(alg_idx,:,:),3)),...
        'LineStyle','-','Color','k',...
        'MarkerSize',ms,'Marker',marker_style{alg_idx},'MarkerFaceColor',colorlist(alg_idx,:),...
        'LineWidth',lw);
    leg_list{alg_idx} = results.names{alg_idx};
    errorbar_fill(demo_size_list, squeeze(mean(performance_list(alg_idx,:,:),3))...
        ,0.5*squeeze(std(performance_list(alg_idx,:,:),[],3)),colorlist(alg_idx,:) );
end

ticksize = 18;
set(gca, 'XTick', demo_size_list,...
    'XTickLabel', demo_size_list, 'FontSize', ticksize);
ylim([-0.5 9]);
xlim([min(demo_size_list)-1 max(demo_size_list) + 1]);

fsize = 23;

xlabel('World Size','FontWeight','bold','FontSize',fsize);
ylabel('Expected Value Difference','FontWeight','bold','FontSize',fsize);

legend(h,leg_list,'Location','northeastoutside');
hl = legend('show');
set(hl,'FontWeight','bold','FontSize',23);

title(sprintf('Object World with %d Demonstrations',results.test_params{1}.training_samples),'FontWeight','bold','FontSize',fsize);

%%
fig = figure(2); clf; hold on;lw = 3; ms = 15;
set(fig,'Position',[500 200 1000 500]);
demo_size_list = str2double(results.mdp_param_names);

h = [];
leg_list = {};
maxy = 25;
marker_style = {'o','v','^','d','>','s','p','.'};
for alg_idx = nr_algs:-1:1
        h(alg_idx) = plot(demo_size_list,squeeze(mean(time_list(alg_idx,:,:),3)),...
        'LineStyle','-','Color','k',...
        'MarkerSize',ms,'Marker',marker_style{alg_idx},'MarkerFaceColor',colorlist(alg_idx,:),...
        'LineWidth',lw);
%     if maxy > mean(mean(time_list(alg_idx,:,:),3))
       leg_list{alg_idx} = results.names{alg_idx};
%     else
%        leg_list{alg_idx} = [results.names{alg_idx},' (Off Scale)'];
%     end
    errorbar_fill(demo_size_list, squeeze(mean(time_list(alg_idx,:,:),3))...
        ,0.5*squeeze(std(time_list(alg_idx,:,:),[],3)),colorlist(alg_idx,:) );
end

ticksize = 18;
set(gca, 'XTick', demo_size_list,...
    'XTickLabel', demo_size_list, 'FontSize', ticksize);
ylim([-0.5 maxy]);
xlim([min(demo_size_list)-1 max(demo_size_list) + 1]);

fsize = 23;

xlabel('World Size','FontWeight','bold','FontSize',fsize);
ylabel('Computaion Time [ms]','FontWeight','bold','FontSize',fsize);

legend(h,leg_list,'Location','northeastoutside');
hl = legend('show');
set(hl,'FontWeight','bold','FontSize',23);

title(sprintf('Object World with %d Demonstrations',results.test_params{1}.training_samples),'FontWeight','bold','FontSize',fsize);
