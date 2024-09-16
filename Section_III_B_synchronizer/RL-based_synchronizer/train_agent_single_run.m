
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% train an agent for the RL synchronizer %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% workspace %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc;
clear all;
close all;

%% define the trained agent %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

agent_name = "rcv_test";
params.hl_size = 256;
params.lstm_size = 128;
params.n_epochs = 3;
params.mini_batch = 64;
params.exp_horizon = 128;
params.discount_fact = 0.99;
params.entr_loss_w = 0.01;
params.critic_lr = 0.0002;
params.actor_lr = 0.0002;
file_name = "eval_sim_data/mm_RL_maxmaxdiff_rnd_080_090_0010_600_20.mat";
num_epis = 350;

%% do training %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% load input data %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

mm = load(file_name);
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

%%% general training configuration %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

is_training = true;
use_training_reward = true;
max_episodes = num_epis;
switch_index = true;
num_seq = length(bit_seq_split);
initial_n = -1;                                                % set to -1 to trigger random 
                                                               % startpoint between 0 and 
                                                               % end of first bit
max_initial_n = 1; 
diff_training_n = bit_seq_split.*repeated_values;
sync_seq = [11001];
sync_seq_length = length(sync_seq);
stop_time = 36;                                                % length of one episode
sample_step_time = 2;                                          % time between probes in [s]
sample_step = sample_step_time / time_step_size;               % probe step length within array
frame_bit_length = 5;
bit_sample_index = 5;
bit_length = bit_length_time / sample_step_time;
frame_step = frame_bit_length * bit_length;
mol_seq = mol_seq(1 : sample_step : length(mol_seq));
snr = 30;                                                      % for the additional noise
initial_th = 100;                                              % intial threshold, start of episode

%%% define agent %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

mols_min = 0;
mols_step = 10;
mols_max = 360;

mols_action_min = -100;
mols_action_step = 10;
mols_action_max = 100;

obs_min = -200;
obs_step = 5;
obs_max = 200;

discrete = true;

[m,n] = ndgrid([obs_min:obs_step:obs_max], ...
    [obs_min:obs_step:obs_max]);
vect = [m(:), n(:)];
vect_cell = num2cell(vect,2);
obs_info = rlFiniteSetSpec(vect_cell);
act_info = rlFiniteSetSpec( ...
    mols_action_min:mols_action_step:mols_action_max);
slEnv = rlSimulinkEnv("DO_rnd_shift", ...
    "DO_rnd_shift/fau_testbed_testagent",obs_info,act_info);
slEnv.ResetFcn = @randomizeseed;

actnet = [
    sequenceInputLayer(prod(obs_info.Dimension), ...
        'Normalization','none','Name','input layer')
    fullyConnectedLayer(params.hl_size, ...
        'Name','fully connected layer 1')
    tanhLayer('Name','tanh layer')
    lstmLayer(params.lstm_size,'OutputMode','sequence', ...
        'Name','lstm layer')
    fullyConnectedLayer(length(act_info.Elements), ...
        'Name','fully connected layer 2')
    softmaxLayer('Name','softmax output layer')];

valnet = [
    sequenceInputLayer(prod(obs_info.Dimension), ...
        'Normalization','none','Name','input layer')
    fullyConnectedLayer(params.hl_size, ...
        'Name', 'fully connected layer 1')
    tanhLayer('Name','tanh layer')
    lstmLayer(params.lstm_size,'OutputMode','sequence', ...
        'Name','lstm layer')
    fullyConnectedLayer(1, ...
        'Name','fully connected output layer')];

critic = rlValueFunction(valnet,obs_info, ...
    'Observation','input layer');
actor = rlDiscreteCategoricalActor(actnet, ...
    obs_info,act_info,'Observation','input layer');
agent = rlPPOAgent(actor,critic);
agent.AgentOptions.NumEpoch = params.n_epochs;
agent.AgentOptions.MiniBatchSize = params.mini_batch;
agent.AgentOptions.ExperienceHorizon = params.exp_horizon;
agent.AgentOptions.DiscountFactor = params.discount_fact;
agent.AgentOptions.AdvantageEstimateMethod = 'gae';
agent.AgentOptions.NormalizedAdvantageMethod = 'current';
agent.AgentOptions.AdvantageNormalizingWindow = 500;
agent.AgentOptions.EntropyLossWeight = params.entr_loss_w;
agent.AgentOptions.CriticOptimizerOptions.LearnRate = ...
    params.critic_lr;
agent.AgentOptions.CriticOptimizerOptions.GradientThreshold = 1;
agent.AgentOptions.ActorOptimizerOptions.LearnRate = ...
    params.actor_lr;
agent.AgentOptions.ActorOptimizerOptions.GradientThreshold = 1;

%%% train the agent %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

opts = rlTrainingOptions( ...
    MaxEpisodes=max_episodes, ......
    MaxStepsPerEpisode=stop_time, ...
    ScoreAveragingWindowLength=200, ...
    Verbose=true, ...
    Plots="none",...
    StopTrainingCriteria="AverageReward", ...
    StopTrainingValue=stop_time * 0);  
% runs the training in the command line, 
% can be changed to run in UI by commenting
% "Verbose=true, Plots="none"" out
info = train(agent,slEnv,opts);
save("Agents/"+agent_name+".mat", "agent");
info_params.rewards = info.EpisodeReward;
info_params.avgrewards = info.AverageReward;
info_params.episodes = max_episodes;
info_params.steps = stop_time;

%% run first evaluation after training %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% do the simulation with trained agent %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

num_intervals = 8;
is_training = false;
use_training_reward = false;
transmissions_per_interval = 2000;
stop_time = transmissions_per_interval * num_intervals;
out_sim=sim('DO_rnd_shift.slx');

%%% collect and calculate all results %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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

[~,ratio] = biterr(out_sim_curr_val, out_sim_curr_bit);
pos_c_sync_frames = out_sim_c_state == 10;
pos_e_sync_frames = out_sim_e_state == 10;
detected_sync_frames = pos_e_sync_frames .* pos_c_sync_frames;
pos_c_empty_frames = out_sim_c_state == 20;
pos_e_empty_frames = out_sim_e_state == 20;
detected_empty_frames = pos_e_empty_frames .* ...
    pos_c_empty_frames;
pos_false_positive = out_sim_falso_pos > 0;
pos_actually_right = pos_false_positive .* pos_c_sync_frames;
pos_tp_empty_pos = pos_false_positive .* pos_c_empty_frames;

num_correct_frames = sum(detected_sync_frames) + ...
    sum(detected_empty_frames);
num_all_frames = sum(pos_c_sync_frames) + ...
    sum(pos_c_empty_frames);
num_correct_sync_frames = sum(detected_sync_frames);
num_sync_frames = sum(pos_c_sync_frames);
num_false_positive = sum(pos_tp_empty_pos);
num_false_positive_all = sum(pos_false_positive);
num_actually_right = sum(pos_actually_right);

ratio_correct_sync_detection = num_correct_sync_frames / ...
    num_sync_frames;
ratio_correct_detection = num_correct_frames/num_all_frames;
ratio_false_positive = num_false_positive / ...
    (num_sync_frames - num_correct_sync_frames);
ratio_false_positive_all = num_false_positive_all / ...
    (num_sync_frames - num_correct_sync_frames);
empty_detect_rate = sum(detected_empty_frames) / ...
    sum(pos_c_empty_frames);
sync_misalign = detected_sync_frames .* out_sim_misalign_1;
avg_misalign = sum(sync_misalign) / sum(sync_misalign ~= 0);
avg_misalign_t = avg_misalign * time_step_size;

%%% print results and save agent info %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fprintf('BER %f\n', ratio);
fprintf('detect rate %f\n', ratio_correct_sync_detection);
fprintf('detect rate all %f\n', ratio_correct_detection);
fprintf('# false positive %f\n', num_false_positive);
fprintf('# false positive all %f\n', num_false_positive_all);
fprintf('# actually right %f\n', num_actually_right);
fprintf('prob false positive %f\n', ratio_false_positive);
fprintf('avg misalignment %f\n', avg_misalign_t);
info_params.BER = ratio;
info_params.DR = ratio_correct_sync_detection;
info_params.params = params;
info_params.file = file_name;
save("Agents/"+agent_name+"_i.mat", "info_params");

%% randomize the random number seed in the Simulink model %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function simin = randomizeseed(simin)
    simin = setVariable(simin,"seed",randi(1e8), ...
        "Workspace","fau_testbed_testagent");
end
