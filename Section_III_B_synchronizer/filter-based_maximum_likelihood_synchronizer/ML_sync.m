
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% run filter-based maximum Likelihood synchronizer %%%%%%%%%%%%%%%%%%%%%%
%%% frame-wise %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% workspace %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc;
clear all
close all;

%% define experiment %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

folder_name = "WS_eval/"; % folder to save the eval data in
ws_name = "ML_frame_FER_rnd_"; % start of saved eval data file name

eval_file_dir = "eval_sim_data/"; % folder that contains the evaluation time-series
config = "080_090_0010_600_20"; % testbed configuration that will be evaluated
file_name = "mm_RL_ut50_rnd_"+config+".mat"; % evaluation file name
num_ci_repeats = 10; % number of repetitions
ml_file_name = "mm_sync_frame_avg_080_090_0010_600.mat"; % comparison file name

threshold=209; % threshold for the estimation process

max_bits = 20;
orig_bits = 25;
max_mols = max_bits * 10;
orig_mols = orig_bits * 10;

for ci_repeat = 1:num_ci_repeats
    fprintf("########################### "+ci_repeat);
    % define synchronization frame parameters
    synch_frame = [1 1 0 0 1];
    % define testbed parameters
    T_b = 20; % bit duration,units of seconds
    sampling_freq = 0.5; % in the units of hertz
    sampling_time = 1/sampling_freq; % grid time resolution in seconds
    bit_samples = T_b/sampling_time;
    frame_samples = bit_samples*length(synch_frame);
    snr = 30;
    
    %%% perform pattern emission %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    mm = load(eval_file_dir + file_name);
    sequence_total_slots = 10000; % number of frame slots in sequence
    for i = 1:length(mm.ll)
        start_idx = (i-1)*max_bits + 1;
        end_idx = start_idx + max_bits-1;
        start_bb_idx = (i-1)*orig_bits + 2;
        end_bb_idx = start_bb_idx + max_bits-1;
        single_bit_sequence(start_idx:end_idx) = mm.bb(start_bb_idx:end_bb_idx,1);
    end
    single_bit_sequence = single_bit_sequence';
    single_bit_sequence = repmat(single_bit_sequence,1000,1);
    single_bit_sequence = single_bit_sequence(1:sequence_total_slots*5);
    if isempty(single_bit_sequence ~= 0)
        fprintf("empty!");
    end
    for i = 1:length(mm.ll)
        start_idx = (i-1)*max_mols + 11;
        end_idx = start_idx + max_mols-1;
        start_mm_idx = (i-1)*orig_mols + 12;
        end_mm_idx = start_mm_idx + max_mols-1;
        mol_no_noise(start_idx:end_idx) = mm.mm(start_mm_idx:end_mm_idx,1);
    end
    mol_no_noise = mol_no_noise';
    mol_no_noise = mol_no_noise(11:end);
    mol_no_noise = repmat(mol_no_noise,1000,1);
    mol_no_noise = mol_no_noise(1:sequence_total_slots*5*10);
    mol_sequence = awgn(mol_no_noise, snr, 'measured');

    frame_sequence = zeros(sequence_total_slots,1);
    
    i = 1;
    j = 1;
    while i+4 <= length(single_bit_sequence) && j <= sequence_total_slots
        if isequal(single_bit_sequence(i:i+4), synch_frame')
            frame_sequence(j) = 1;
        end
        i = i + 5;
        j = j + 1;
    end
    
    %%% process tesbed measurements %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % evaluate average for the received frames
    ml_file_dir = "eval_sim_data/";
    mm_avg = load(ml_file_dir + ml_file_name);
    M_rx_frame = mm_avg.mm_frame; 
    % filtered likelihood
    [L_FIR,L_FIR_lag]=filter(M_rx_frame,1,mol_sequence);
    [a,b] = size(L_FIR);
    if b > a
        L_FIR = L_FIR';
    end
    size(L_FIR_lag);
    % delete the transient time
    L_FIR=horzcat(L_FIR(floor(length(M_rx_frame)/2):end)',L_FIR_lag')/sum(M_rx_frame);
    
    %%% Plotting received sequence & the ML filter %%%%%%%%%%%%%%%%%%%%%%%%
    
    % uncomment the following lines to plot the received sequence & the filter

    % figure;
    % subplot 211
    % plot((0:length(M_rx_frame)-1)*sampling_time,M_rx_frame,'LineWidth',2); grid on; hold on;
    % xlabel('Time [s]','Interpreter','latex','FontSize',fontsize);
    % ylabel('Received Molecules at the Relay','Interpreter','latex','FontSize',fontsize);
    % set(gca,'FontSize',fontsize);
    % 
    % subplot 212
    % plot((0:length(L_FIR)-1)*sampling_time,L_FIR,'LineWidth',2); hold on; grid on
    % plot((0:length(L_FIR)-1)*sampling_time,threshold*ones(1,length(L_FIR)),'--','LineWidth',2);
    % xlabel('Time [s]','Interpreter','latex','FontSize',fontsize);
    % ylabel('ML filter at the Relay','Interpreter','latex','FontSize',fontsize);
    % set(gca,'FontSize',fontsize);
    % 
    % figure;
    % hold on;
    % grid minor;
    % plot((0:length(L_FIR)-1)*sampling_time,L_FIR,'LineWidth',2); hold on; grid on
    % plot((0:length(L_FIR)-1)*sampling_time,threshold*ones(1,length(L_FIR)),'--','LineWidth',2);
    % xlabel('Time [s]','Interpreter','latex','FontSize',fontsize);
    % ylabel('ML filter at the Relay','Interpreter','latex','FontSize',fontsize);
    % set(gca,'FontSize',fontsize);
    % 
    % plot((0:50:length(L_FIR)-51)*sampling_time,frame_sequence*100,'LineWidth',2); hold on; grid on
    % plot((0:10:length(L_FIR)-30)*sampling_time,single_bit_sequence*150,'LineWidth',2); hold on; grid on
    % hold off;

    %%% decode the sequence %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    frames_peaks=zeros(1,length(frame_sequence));
    frames_peaks_pos=zeros(1,length(frame_sequence));
    frames_detected=zeros(1,length(frame_sequence));%avoiding the detection for the first sequence
    
    % decode the lines inbetween to plot the filter per frame 
    % figure;
    % hold on;
    for i=1:length(frame_sequence)
        x1=(i-1)*bit_samples*length(synch_frame)+1;
        x2=x1+length(synch_frame)*bit_samples-1;
        %[frames_peaks(i),frames_peaks_pos(i)]=max(L_FIR_relay(x1:x1+2*bit_samples));
        [frames_peaks(i),frames_peaks_pos(i)]=max(L_FIR(x1:x2));
        % if (frame_sequence(i) == 1)
        %     plot(L_FIR(x1:x2),'LineWidth',2, Color='#dd7e6b');
        % else
        %     plot(L_FIR(x1:x2),'LineWidth',2, Color='#45818e');
        % end
        
        first = L_FIR(x1);
        last = L_FIR(x2);

        if(frames_peaks(i)>=threshold)
            frames_detected(i)=1;
        end
    
    end
    % hold off;

    %%% receiver evaluation %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    fer_all_rcv = biterr(frames_detected,frame_sequence')/length(frames_detected) 
    type_frames = frame_sequence';
    sync_frames = type_frames;
    sync_indices = find(sync_frames<=0);
    sync_frames(sync_indices) = [];
    empty_frames = type_frames;
    empty_indices = find(empty_frames>0);
    empty_frames(empty_indices) = [];
    
    detected_sync = frames_detected;
    detected_sync(sync_indices) = [];
    detected_empty = frames_detected;
    detected_empty(empty_indices) = [];
    if ~isempty(detected_sync)
        fer_sync_rcv = biterr(detected_sync,sync_frames)/length(sync_frames)
    else
        fprintf("empty!");
        fer_sync_rcv = 0
    end
    fer_empty_rcv = biterr(detected_empty,empty_frames)/length(empty_frames)
    misalignments_rcv = (frames_peaks_pos(find(frames_detected)) * sampling_time);
    mis_rcv = sum(frames_peaks_pos(find(frames_detected)) * sampling_time - 50)/length(frames_peaks_pos(find(frames_detected)))
   
    % evalaution results are saved in a file named containing to:
    % - ws_name
    % - configuration identifier
    % - repitition number
    save(folder_name+ws_name+"_"+config+"__rep"+ci_repeat+".mat", "ci_repeat", "threshold", "file_name", "fer_all_rcv", "fer_sync_rcv", "fer_empty_rcv", "mis_rcv", "misalignments_rcv")

    clear single_bit_sequence;
    clear mol_sequence;
    clear mol_no_noise;
end