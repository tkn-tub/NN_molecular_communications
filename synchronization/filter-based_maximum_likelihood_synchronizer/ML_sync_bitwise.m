
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% run filter-based maximum Likelihood synchronizer %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% bit-wise %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% workspace %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc;
clear all
close all;

%% define experiment %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

folder_name = "WS_eval/";                                      % folder to save the eval data in
ws_name = "ML_bit_FER_rnd_";                                   % start of saved eval data file name

eval_file_dir = "eval_sim_data/";                              % folder with evaluation time-series
config = "080_090_0010_600_20";                                % evaluated testbed configuration
file_name = "mm_RL_ut50_rnd_"+config+".mat";                   % evaluation file name
num_ci_repeats = 10;                                          
ml_file_dir = "eval_sim_data/";                                % folder with comparison time-series
ml_file_name = "mm_sync_frame_avg_080_090_0010_600.mat";       % comparison file name for FBML

threshold = 241;                                               % threshold for estimation process

max_bits = 45;
orig_bits = 50;
max_mols = max_bits * 10;
orig_mols = orig_bits * 10;

%% run and evaluate synchronizer %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for ci_repeat = 1:num_ci_repeats
    fprintf("########################### "+ci_repeat);
    
    %%% setup experiment %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    synch_frame = [1 1 0 0 1];
    T_b = 20;                                                  % bit duration in [s]
    sampling_freq = 0.5;                                       % [Hz]
    sampling_time = 1/sampling_freq;                           % grid time in [s]
    bit_samples = T_b/sampling_time;                           % number of samples per bit
    frame_samples = bit_samples*length(synch_frame);           % number of samples per frame
    snr = 30;                                                  % for additional noise
    sequence_total_slots = 10000;                              % number of frame slots in sequence
    
    %%% perform pattern emission %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    mm = load(eval_file_dir + file_name);
    for i = 1:length(mm.ll)
        start_idx = (i-1)*max_bits + 1;
        end_idx = start_idx + max_bits-1;
        start_bb_idx = (i-1)*orig_bits + 2;
        end_bb_idx = start_bb_idx + max_bits-1;
        single_bit_sequence(start_idx:end_idx) = ...
            mm.bb(start_bb_idx:end_bb_idx,1);
    end
    single_bit_sequence = single_bit_sequence';
    single_bit_sequence = repmat(single_bit_sequence,1000,1);
    single_bit_sequence = ...
        single_bit_sequence(1:sequence_total_slots*5);
    if ~any(single_bit_sequence ~= 0, "all")
        fprintf("Error: single_bit_sequence is empty!");
    end
    for i = 1:length(mm.ll)
        start_idx = (i-1)*max_mols + 11;
        end_idx = start_idx + max_mols-1;
        start_mm_idx = (i-1)*orig_mols + 12;
        end_mm_idx = start_mm_idx + max_mols-1;
        mol_no_noise(start_idx:end_idx) = ...
            mm.mm(start_mm_idx:end_mm_idx,1);
    end
    mol_no_noise = mol_no_noise';
    mol_no_noise = mol_no_noise(11:end);
    mol_no_noise = repmat(mol_no_noise,1000,1);
    mol_no_noise = mol_no_noise(1:sequence_total_slots*5*10);
    mol_sequence = awgn(mol_no_noise, snr, 'measured');

    frame_sequence = zeros(sequence_total_slots,1);
    
    i = 1;
    j = 1;
    while i+4 <= length(single_bit_sequence) && ...
            j <= sequence_total_slots
        if isequal(single_bit_sequence(i:i+4), synch_frame')
            frame_sequence(j) = 1;
        end
        i = i + 5;
        j = j + 1;
    end
    
    %%% process tesbed measurements %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    mm_avg = load(ml_file_dir + ml_file_name);
    M_rx_bit = mm_avg.mm_frame(11:20);                         % bit '1'
    [L_FIR,L_FIR_lag]=filter(M_rx_bit,1,mol_sequence);         % filtered likelihood
    [a,b] = size(L_FIR);
    if b > a
        L_FIR = L_FIR';
    end
    size(L_FIR_lag);
    L_FIR=horzcat(L_FIR(floor(length(M_rx_bit)/2):end)', ...   % delete the transient time
        L_FIR_lag')/sum(M_rx_bit);
    
    %%% Plotting received sequence & the ML filter %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % uncomment the following lines to plot the received sequence & the filter
    % 
    % fontsize = 15;
    % figure;
    % hold on;
    % grid minor;
    % plot((0:length(L_FIR)-1)*sampling_time,L_FIR, ...
    %     'LineWidth',2); hold on; grid on
    % plot((0:length(L_FIR)-1)*sampling_time, ...
    %     threshold*ones(1,length(L_FIR)),'--', ...
    %     'LineWidth',2);
    % xlabel('Time [s]','Interpreter','latex','FontSize', ...
    %     fontsize);
    % ylabel('ML filter at the Relay','Interpreter','latex', ...
    %     'FontSize',fontsize);
    % set(gca,'FontSize',fontsize);
    % 
    % plot((0:50:length(L_FIR)-51)*sampling_time, ...
    %     frame_sequence*200,'LineWidth',2); hold on; grid on
    % plot((0:10:length(L_FIR)-10)*sampling_time, ...
    %     single_bit_sequence*250,'LineWidth',2); hold on; grid on
    % hold off;

    %%% decode the sequence %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    bit_peaks=zeros(1,length(single_bit_sequence));
    bit_peaks_pos=zeros(1,length(single_bit_sequence));
    bit_detected=zeros(1,length(single_bit_sequence));       

    % decode the lines inbetween to plot the filter per bit 

    % figure;
    % hold on;
    for i=1:length(single_bit_sequence)
        x1=(i-1)*bit_samples+1;
        x2=x1+bit_samples-1;
        [bit_peaks(i),bit_peaks_pos(i)]=max(L_FIR(x1:x2));
        % if (single_bit_sequence(i) == 1)
        %     plot(L_FIR(x1:x2),'LineWidth',2, Color='#dd7e6b');
        % else
        %     plot(L_FIR(x1:x2),'LineWidth',2, Color='#45818e');
        % end
        
        if(bit_peaks(i)>=threshold)
            bit_detected(i)=1;
        end
    
    end
    % hold off;

    %%% receiver evaluation %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    detected_frames = zeros(sequence_total_slots,1);
   
    i = 1;
    j = 1;
    while i+4 <= length(bit_detected) && ...
            j <= sequence_total_slots
        if isequal(bit_detected(i:i+4), synch_frame)
            detected_frames(j) = 1;
            mis_collection(i) = ...                            % collect the symbol offset time
                bit_peaks_pos(i) * sampling_time;
        end
        i = i + 5;
        j = j + 1;
    end

    ber_all_rcv = biterr(bit_detected,single_bit_sequence')/ ...
        length(single_bit_sequence);
    fer_all_rcv = biterr(detected_frames,frame_sequence)/ ...
        length(frame_sequence);
    
    type_frames = frame_sequence';
    sync_frames = type_frames;
    sync_indices = find(sync_frames<=0);
    sync_frames(sync_indices) = [];
    empty_frames = type_frames;
    empty_indices = find(empty_frames>0);
    empty_frames(empty_indices) = [];
    
    detected_sync = detected_frames';
    detected_sync(sync_indices) = [];
    detected_empty = detected_frames';
    detected_empty(empty_indices) = [];
    detected_fpr_sync = detected_frames';
    detected_fpr_sync(empty_indices) = [];
    if ~isempty(detected_sync)
        tpr_sync_rcv = sum(detected_sync)/length(sync_frames);
    else
        fprintf("empty!");
        fer_sync_rcv = 0;
    end
    fpr_sync_rcv = sum(detected_fpr_sync)/length(empty_frames);
    fer_empty_rcv = biterr(detected_empty,empty_frames)/ ...
        length(empty_frames);
    misalignments_rcv_all = bit_peaks_pos(find(bit_detected)) ...
        * sampling_time;
    mis_rcv = sum(mis_collection)/length(mis_collection) - ...
        (bit_samples/2) * sampling_time;
   
    fprintf('BER %f\n', ber_all_rcv);
    fprintf('FER %f\n', fer_all_rcv);
    fprintf('true positive rate %f\n', tpr_sync_rcv);
    fprintf('false positive rate %f\n', fpr_sync_rcv);
    fprintf('avg STO %f\n', mis_rcv);

    % evalaution results are saved in a file named according to:
    % - ws_name
    % - configuration identifier
    % - repitition number
    save(folder_name+ws_name+"_"+config+"__rep"+ci_repeat+".mat", ...
        "ci_repeat", "threshold", "file_name", "ber_all_rcv", ...
        "fer_all_rcv", "tpr_sync_rcv",  "fpr_sync_rcv", ...
        "fer_empty_rcv", "mis_rcv", "misalignments_rcv_all")

    clear single_bit_sequence;
    clear mol_sequence;
    clear mol_no_noise;
    clear frame_sequence;
    clear mis_collection;
    clear detected_sync;
    clear detected_empty;
    clear detected_fpr_sync;
    clear L_FIR;
end