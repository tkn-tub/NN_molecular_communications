%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% evaluate a trained agent in the RL synchronizer %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% workspace %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc;
clear all;
close all;

%% setup workspace %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

folder_name = "Agents/";                                       % folder containing evaluated agent
agent_name = "rcv_pretrained";                                          % evaluated agent

ws_folder_name = "WS_eval/";                                   % folder to save the eval data in
ws_name = "RL_rnd_";                                           % start of saved eval data file name

eval_file_dir = "eval_sim_data/";                              % folder with evaluation time-series
config = "080_090_0010_600_20";                                % evaluated testbed configuration
file_name = "mm_RL_ut50_rnd_"+config+".mat";                   % evaluation file name

num_indices = 10;                                              % number of sampling indices per bit
num_ci_repeats = 10;                                           % number of repetitions per index 
% The current testbed time-series data has 10 possible indices per bit.
% So: num_ci_repeats = 10  and num_indices = 10 means 
%     num_ci_repeats*num_indices = 10*10 = 100 evaluation runs in total.

%% load evaluation data %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

mm = load(eval_file_dir + file_name);
l = length(mm.mm);
sec_axis = (1:l);
time_step_size = 2;
sample_length = length(sec_axis);
mol_seq = zeros(1,sample_length);
mol_seq(1:l) = mm.mm(1:l);
bit_sequ_orig = mm.bb(1:l/10);
bit_seq_split = mm.ll(1:length(mm.ll));
bit_length_time = 20;
bit_seq = zeros(1,sample_length);
repeated_values = bit_length_time / time_step_size;
for i = 0 : length(bit_sequ_orig) - 1
    b = i * repeated_values;
    for j = 1 : repeated_values
        bit_seq(1,b+j) = bit_sequ_orig(i+1);
    end
end

%% general evaluation configuration %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

is_training = false;
max_episodes = 2;
use_training_reward = false;
switch_index = false;
num_seq = length(bit_seq_split);
initial_n = -1;                                                % -1 == ignored during evaluation
max_initial_n = 1; 
diff_training_n = bit_seq_split.*repeated_values;
sync_seq = [1, 1, 0, 0, 1];
sync_seq_length = length(sync_seq);
stop_time = 36;
sample_step_time = 2;                                          % time between probes in [s]
sample_step = sample_step_time / time_step_size;               % probe step length within array
frame_bit_length = 2;
bit_length = bit_length_time / sample_step_time;
frame_step = frame_bit_length * bit_length;
mol_seq = mol_seq(1 : sample_step : length(mol_seq));
snr = 30;                                                      % for the additional noise
initial_th = 100;

%% load evaluated agent %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

mols_min = 0;
mols_step = 10;
mols_max = 360;

mols_action_min = -100;
mols_action_step = 10;
mols_action_max = 100;

obs_min = -200;
obs_step = 5;
obs_max = 200;

load(folder_name+agent_name+".mat");
load(folder_name+agent_name+"_i.mat");

% uncomment the following lines if you want to print 
% an overview of the rewards of the 
% evaluated agent
%
% figure;
% hold on;
% plot(info_params.rewards);
% plot(info_params.avgrewards);
% hold off;

%% do the simulations with trained agent %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

num_intervals = 1;
is_training = false;
use_training_reward = false;
switch_index = false;

transmissions_per_interval = 1000*5;                           % number of steps per evaluation run,
                                                               % 1 step = 1 bit
stop_time = transmissions_per_interval * num_intervals;

for ci_repeat = 1:num_ci_repeats
    for i=1:num_indices
        bit_sample_index = i

        out_sim=sim('DO_rnd_shift.slx');
        out_sim_curr_action = out_sim.action_taken.Data;
        out_sim_curr_th = out_sim.curr_th.Data;
        out_sim_curr_bit = out_sim.curr_bit.Data;
        out_sim_curr_val = out_sim.c_bit_val.Data;
        out_sim_curr_mols = out_sim.curr_mols.Data;
        out_sim_e_state = out_sim.e_state.Data;
        out_sim_c_state = out_sim.c_state.Data;
        out_sim_frame_end = out_sim.end_frame.Data;
        out_sim_frame_reward = out_sim.reward_frame.Data;
        out_sim_misalign_1 = out_sim.align_idx_1.Data;
        out_sim_falso_pos = out_sim.false_positive.Data;
        out_sim_reward = out_sim.reward.Data;
            
        out_sim_transm_axis = (1:stop_time + 1);
        
        %% print input & evaluation results %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        paper_figs = false;
        
        [~,ratio] = biterr(out_sim_curr_val, out_sim_curr_bit);
        pos_c_sync_frames = out_sim_c_state == 10;
        pos_e_sync_frames = out_sim_e_state == 10;
        detected_sync_frames = pos_e_sync_frames .* ...
            pos_c_sync_frames;
        pos_c_empty_frames = out_sim_c_state == 20;
        pos_e_empty_frames = out_sim_e_state == 20;
        detected_empty_frames = pos_e_empty_frames .* ...
            pos_c_empty_frames;
        pos_false_positive = out_sim_falso_pos > 0;
        pos_actually_right = pos_false_positive .* ...
            pos_c_sync_frames;
        pos_tp_empty_pos = pos_false_positive .* ...
            pos_c_empty_frames;
        
        num_correct_frames = sum(detected_sync_frames) + ...
            sum(detected_empty_frames);
        num_all_frames = sum(pos_c_sync_frames) + ...
            sum(pos_c_empty_frames);
        num_correct_sync_frames = sum(detected_sync_frames);
        num_sync_frames = sum(pos_c_sync_frames);
        num_false_positive = sum(pos_tp_empty_pos);
        num_false_positive_all = sum(pos_false_positive);
        num_actually_right = sum(pos_actually_right);
        
        ratio_correct_sync_detection = ...
            num_correct_sync_frames/num_sync_frames;
        ratio_correct_detection = ...
            num_correct_frames/num_all_frames;
        ratio_false_positive = num_false_positive / ...
            (num_sync_frames - num_correct_sync_frames);
        ratio_false_positive_all = num_false_positive_all / ...
            (num_sync_frames - num_correct_sync_frames);
        empty_detect_rate = sum(detected_empty_frames) / ...
            sum(pos_c_empty_frames);
        sync_misalign = detected_sync_frames .* ...
            out_sim_misalign_1;
        avg_misalign = sum(sync_misalign) / ...
            sum(sync_misalign ~= 0);
        avg_misalign_t = avg_misalign * time_step_size;
        
        fprintf('BER %f\n', ratio);
        fprintf('detect rate %f\n', ratio_correct_sync_detection);
        fprintf('detect rate all %f\n', ratio_correct_detection);
        fprintf('# false positive %f\n', num_false_positive);
        fprintf('# false positive all %f\n', num_false_positive_all);
        fprintf('# actually right %f\n', num_actually_right);
        fprintf('prob false positive %f\n', ratio_false_positive);
        fprintf('avg STO %f\n', avg_misalign_t);
        info_params.BER = ratio;
        info_params.DR = ratio_correct_sync_detection;
    
        % evalaution results are saved in a file named containing to:
        % - ws_name
        % - configuration identifier
        % - sampling index
        % - repitition number
        save(ws_folder_name+ws_name+"_"+config+"__idx"+i+"_rep"+ci_repeat+".mat", ...
            "ci_repeat", "file_name", "bit_sample_index",  "ratio",...
            "ratio_correct_sync_detection" , "ratio_correct_detection", ...
            "num_false_positive", "num_false_positive_all", "num_actually_right", ...
            "ratio_false_positive", "ratio_false_positive_all", "avg_misalign_t", "out_sim");
        
    end
end

%% randomize the random number seed in the Simulink model %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function simin = randomizeseed(simin)
    simin = setVariable(simin,"seed",randi(1e8),"Workspace","fau_testbed_testagent");
end
