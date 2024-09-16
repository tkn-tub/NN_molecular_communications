
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% print results for the MCML survey %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% workspace %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc;
clear all;
close all;

%% figure setup %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

paper_figs = true;

% plot layout in part copied from code provided by Jorge
fontsize=20;%fontsize value
color = {'#0c343d','#134f5c','#45818e','#76a5af','#a2c4c9','#d0e0e3','#dd7e6b','#e6b8af', '#cc4125', '#bf9000'}; %list of colors from https://www.mathworks.com/help/matlab/creating_plots/specify-plot-colors.html
if paper_figs == true
    line_width=linspace(0.5,2.5,length(color));%specify the width for each line in the plot
else
    line_width=linspace(0.5,0.6,length(color));%specify the width for each line in the plot
end
marker={'-','-+','-d','-.','-x','-o','-s','-*','-|','-^'};% marker symbols are given at https://www.mathworks.com/help/matlab/creating_plots/create-line-plot-with-markers.html
marker_size=1:length(color);%specify the width for each marker in the plot
marker_indices=1:length(color);%specify the length between markers

set(groot,'defaultfigureposition',[400, 250, 1200, 400])

legend_pos = [0.9,0,0.1,1.5];
ylim_pc = [0,70];
ylim_s = [-12,5];
yticks_pc = [0:20:70];
yticks_sto = [-10:5:5];

idx_rl = 7;
idx_ml = 3;

%% evaluate default configuration %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% data structures %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

results_rl = zeros(1,100,1,5);
results_ml = zeros(1,10,1,5);
bit_idx = 1;

%%% experiment definitions %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

data_names = {"mm_RL_ut50_rnd_080_090_0010_600_20.mat"};
data_legend = {"TPR", "FPR"};
results_legend = {'\parbox{7em}{\strut RL-based \\synchronizer \strut}','\parbox{7em}{\strut FBML \\synchronizer \strut}'};

%%% load results data %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% RL results
P = './RL_rnd_data';
S = dir(fullfile(P,'*.mat'));
for k = 1:numel(S)
    F = dir(fullfile(P,S(k).name));
    load(convertCharsToStrings(F.folder)+"/"+convertCharsToStrings(F.name));
    data_idx = find(strcmp([data_names{:}], file_name));
    
    if ~isnan(data_idx)
        data_input_idx = (bit_sample_index - 1)*10 + ci_repeat;
        results_rl(1, data_input_idx, data_idx, 1) = ratio;
        results_rl(1, data_input_idx, data_idx, 2) = 1 - ratio_correct_detection;
        results_rl(1, data_input_idx, data_idx, 3) = ratio_correct_sync_detection;
        results_rl(1, data_input_idx, data_idx, 5) = avg_misalign_t;
        out_sim_falso_pos = out_sim.false_positive.Data;
        out_sim_c_state = out_sim.c_state.Data;
        pos_c_sync_frames = out_sim_c_state == 10;
        pos_c_empty_frames = out_sim_c_state == 20;
        pos_false_positive = out_sim_falso_pos > 0;
        pos_actually_right = pos_false_positive .* pos_c_sync_frames;
        num_empty_frames = sum(pos_c_empty_frames);
        num_false_positive_all = sum(pos_false_positive) - sum(pos_actually_right);
        results_rl(1, data_input_idx, data_idx, 4) = num_false_positive_all/num_empty_frames;
    end
end

% ML results
P = './ML_bit_rnd_data';
S = dir(fullfile(P,'*.mat'));
for k = 1:numel(S)
    F = dir(fullfile(P,S(k).name));
    load(convertCharsToStrings(F.folder)+"/"+convertCharsToStrings(F.name));
    data_idx = find(strcmp([data_names{:}], file_name));
    
    if ~isnan(data_idx)
        results_ml(1, ci_repeat, data_idx, 1) = ber_all_rcv;
        results_ml(1, ci_repeat, data_idx, 2) = fer_all_rcv;
        results_ml(1, ci_repeat, data_idx, 3) = tpr_sync_rcv;
        results_ml(1, ci_repeat, data_idx, 4) = fpr_sync_rcv;
        results_ml(1, ci_repeat, data_idx, 5) = mis_rcv;
    end
end

%%% plot %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure;
ax = axes();
hold(ax);
set(gca,'FontSize',fontsize);
data_type_idx = 3; % TPR
boxchart(1*ones(size(results_rl(bit_idx,:,1,data_type_idx))), results_rl(bit_idx,:,1,data_type_idx).*100, 'BoxFaceColor', color{idx_rl}, 'MarkerStyle','none');
boxchart(2*ones(size(results_ml(bit_idx,:,1,data_type_idx))), results_ml(bit_idx,:,1,data_type_idx).*100, 'BoxFaceColor', color{idx_ml}, 'MarkerStyle','none', 'MarkerStyle','none');
data_type_idx = 4; % FPT
boxchart(3*ones(size(results_rl(bit_idx,:,1,data_type_idx))), results_rl(bit_idx,:,1,data_type_idx).*100, 'BoxFaceColor', color{idx_rl}, 'MarkerStyle','none');
boxchart(4*ones(size(results_ml(bit_idx,:,1,data_type_idx))), results_ml(bit_idx,:,1,data_type_idx).*100, 'BoxFaceColor', color{idx_ml}, 'MarkerStyle','none', 'MarkerStyle','none');
axis tight
%ylim([0 1]);
xaxisproperties= get(gca, 'XAxis');
xaxisproperties.TickLabelInterpreter = 'latex'; % latex for x-axis
yaxisproperties= get(gca, 'YAxis');
yaxisproperties.TickLabelInterpreter = 'latex'; % latex for y-axis
set(gca, 'YGrid', 'on', 'XGrid', 'off')
ylabel('Rate [\%]','interpreter','latex');
ylim(ylim_pc);
yticks(yticks_pc);
xticks([1.5, 3.5]);
xticklabels(data_legend);
%xlabel('$p_{switch,{T}_{x}}$ [\%]','interpreter','latex');
legend({results_legend{1}, results_legend{2}},...
    'Location','northeast','Interpreter',"latex",'FontSize',fontsize)
hold off;
saveas(gcf,'plots_rnd/tpr_fpr','epsc')

figure;
data_type_idx = 5;
ax = axes();
hold(ax);
set(gca,'FontSize',fontsize);
boxchart(1*ones(size(results_rl(bit_idx,:,1,data_type_idx))), results_rl(bit_idx,:,1,data_type_idx), 'BoxFaceColor', color{idx_rl}, 'MarkerStyle','none');
boxchart(2*ones(size(results_ml(bit_idx,:,1,data_type_idx))), results_ml(bit_idx,:,1,data_type_idx), 'BoxFaceColor', color{idx_ml}, 'MarkerStyle','none', 'MarkerStyle','none');
axis tight
%ylim([0 1]);
xaxisproperties= get(gca, 'XAxis');
xaxisproperties.TickLabelInterpreter = 'latex'; % latex for x-axis
yaxisproperties= get(gca, 'YAxis');
yaxisproperties.TickLabelInterpreter = 'latex'; % latex for y-axis
set(gca, 'YGrid', 'on', 'XGrid', 'off')
ylabel('STO [s]','interpreter','latex');
ylim(ylim_s);
yticks(yticks_sto);
xticks([2, 5, 8, 11]);
xticklabels(data_legend);
%xlabel('$p_{switch,{T}_{x}}$ [\%]','interpreter','latex');
legend(results_legend,...
    'Location','northeast','Interpreter',"latex",'FontSize',fontsize)
hold off;
saveas(gcf,'plots_rnd/sto','epsc')


function ci_data = calc_ci(data, num)
    N = num;
    N_sqrt = sqrt(N);
    CI95 = tinv([0.025 0.975], N-1);
    
    ci_data.mean = mean(data);
    ci_data.sem = std(data)/N_sqrt;
    ci_data.ci95 = bsxfun(@times, ci_data.sem, CI95(:));
end


