
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% print results for the MCML survey %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% workspace %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc;
clear all;
close all;

%% figure setup %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

paper_figs = true;

fontsize=20;%fontsize value
color = {'#0c343d','#134f5c','#45818e','#76a5af','#a2c4c9',...
    '#d0e0e3','#dd7e6b','#e6b8af', '#cc4125', '#bf9000'}; 
if paper_figs == true
    line_width=linspace(0.5,2.5,length(color));
else
    line_width=linspace(0.5,0.6,length(color));
end
marker={'-','-+','-d','-.','-x','-o','-s','-*','-|','-^'};
marker_size=1:length(color);
marker_indices=1:length(color);

set(groot,'defaultfigureposition',[400, 250, 1200, 400])

legend_pos = [0.9,0,0.1,1.5];
ylim_pc = [-4,70];
ylim_s = [-12,25];
yticks_pc = [-10:10:70];
yticks_sto = [-10:5:30];

idx_rl = 7;
idx_ml = 3;
idx_ax1 = 2;
idx_ax2 = 9;

%% data structures %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

results_rl = zeros(1,100,1,5);
results_ml = zeros(1,10,1,5);
bit_idx = 1;

%% experiment definitions %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

data_names = {"mm_RL_ut50_rnd_080_090_0010_600_20.mat"};
data_legend = {"TPR", "FPR", "STO"};
results_legend = {'\parbox{7em}{\strut RL-based \\synchronizer \strut}',...
    '\parbox{7em}{\strut FBML \\synchronizer \strut}'};

%% load results data %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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

% FBML results
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

%% plot %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure;
set(gca,'FontSize',fontsize);
yaxisproperties= get(gca, 'YAxis');
yaxisproperties.TickLabelInterpreter = 'latex'; % latex for y-axis
set(gca, 'YGrid', 'on', 'XGrid', 'off')
ax = axes();
hold(ax);
yyaxis left
data_type_idx = 3; % TPR
boxchart(1*ones(size(results_rl(bit_idx,:,1,data_type_idx))), ...
    results_rl(bit_idx,:,1,data_type_idx).*100, 'BoxFaceColor', ...
    color{idx_rl}, 'MarkerStyle','none');
boxchart(2*ones(size(results_ml(bit_idx,:,1,data_type_idx))), ...
    results_ml(bit_idx,:,1,data_type_idx).*100, 'BoxFaceColor', ...
    color{idx_ml}, 'MarkerStyle','none');
data_type_idx = 4; % FPT
boxchart(3*ones(size(results_rl(bit_idx,:,1,data_type_idx))), ...
    results_rl(bit_idx,:,1,data_type_idx).*100, 'BoxFaceColor', ...
    color{idx_rl}, 'MarkerStyle','none');
boxchart(4*ones(size(results_ml(bit_idx,:,1,data_type_idx))), ...
    results_ml(bit_idx,:,1,data_type_idx).*100, 'BoxFaceColor', ...
    color{idx_ml}, 'MarkerStyle','none');
set(gca, 'YGrid', 'on', 'XGrid', 'off')
ylabel('Rate [\%]','interpreter','latex');
ylim(ylim_pc);
yticks(yticks_pc);

yyaxis right
data_type_idx = 5; % STO
boxchart(5*ones(size(results_rl(bit_idx,:,1,data_type_idx))), ...
    results_rl(bit_idx,:,1,data_type_idx), 'BoxFaceColor', ...
    color{idx_rl}, 'MarkerStyle','none');
boxchart(6*ones(size(results_ml(bit_idx,:,1,data_type_idx))), ...
    results_ml(bit_idx,:,1,data_type_idx), 'BoxFaceColor', ...
    color{idx_ml}, 'MarkerStyle','none');
axis tight
set(gca, 'YGrid', 'on', 'XGrid', 'off')
ylabel('STO [s]','interpreter','latex');
ylim(ylim_s);
yticks(yticks_sto);

ax.YAxis(1).Color = [0 0 0];
ax.YAxis(2).Color = [0 0 0];
xaxisproperties= get(gca, 'XAxis');
xaxisproperties.TickLabelInterpreter = 'latex';
xticks([1.5, 3.5, 5.5]);
xticklabels(data_legend);
legend({results_legend{1}, results_legend{2}},...
    'Location','northeast','Interpreter',"latex",'FontSize',fontsize)
hold off;
saveas(gcf,'plots_rnd/tpr_fpr_sto','epsc')