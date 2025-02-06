# Synchronization
Digital synchronizer in molecular communication channels

## Description
Following the example in [^1], we implemented the Reinforcement Learning (RL)-based synchronizer in MATLAB and Simulink.
For our implementation, we used a particle simulation of the Media Modulation (MM) testbed introduced in [^2] showing that the reported approach can be transferred to liquid-based MC scenarios.

<figure>
    <p align="center">
<img src="https://github.com/tkn-tub/NN_molecular_communications/blob/main/Figures/synch.jpg?raw=true" width="400">
    </p>
</figure>
<p align="center">
Fig. 1: System model of the RL-based synchronizer.
</p>

Our synchronizer follows the structure displayed in the figure above.
It employs a PPO agent with LSTM layers.
A pre-trained agent for the MM testbed is available.
It was trained with time series collected from the particle simulator for 245000 5-bit-frames in 35000 episodes.
For comparison, a matching implementation of the filter-based maximum likelihood estimator [^3] is included.

## Installation

This code is tested in MATLAB 2024a, and the required toolboxes are listed in the table below.

| Matlab Toolbox  | Version |
| ------------- | ------------- |
| Simulink  | 24.1  |
| Optimization Toolbox | 24.1 |
| Deep Learning Toolbox  | 24.1  |
| Reinforcement Learning Toolbox  | 24.1  |
| Statistics and Machine Learning Toolbox| 24.1 |
| Signal Processing Toolbox  | 24.1  |


## Usage

### RL-based_Synchronizer

The directory `RL-based_synchronizer` contains the code for the developed RL-based synchronizer.
The following files are included in the directory:

- ``train_agent_single_run.m``: trains an agent for the RL-based synchronizer
- ``eval_agent.m``: runs the evaluation runs for an input testbed configuration for a trained agent
- ``DO_rnd_shift.slx``: Simulink environment for the RL-based synchronizer

Additionally, the following directories exist:

- ``Agents``: directory that is used to save all trained agents, the pre-trained agents (Agent: rcv_pretrained.mat and Agent-Metadata: rcv_pretrained_i.mat) are included in the directory
- ``eval_sim_data``: must contain all time series data used for training and evaluation runs
- ``WS_eval``: directory that is used to save the evaluation output

### Filter-based_maximum_likelihood_Synchronizer

The directory `Filter-based_maximum_likelihood_synchronizer` contains the code for the filter-based maximum likelihood synchronizer used in the evaluation.
The following files are included in the directory:

- ``ML_sync.m``: runs the evaluation runs for an input testbed configuration with the frame-wise filter-based maximum likelihood synchronizer
- ``ML_sync_bitwise.m``: runs the evaluation runs for an input testbed configuration with the bit-wise filter-based maximum likelihood synchronizer

Additionally, the following directories exist:

- ``eval_sim_data``: must contain all time series data used for the evaluation runs
- ``WS_eval``: directory that is used to save the evaluation output

### Plotting

The directory `plotting` contains the code to plot all evaluation plots and the result data for all evaluated synchronizers.
The following files are included in the directory:

- ``plot_results.m``: plots the results in multiple figures
- ``plot_results_together.m``: plots the condensed results used in the survey in a single figure

Additionally, the following directories exist:

- ``eval_sim_data``: must contain all time series data used for the evaluation runs
- ``ML_bit_rnd_data``: contains all results from the filter-based ML synchronizer
- ``RL_rnd_data``: contains all results from the RL-based synchronizer
- ``plots_rnd``: directory that is used to save the plots

## Features

- **ML-based solution to synchronization in molecular communication:** We tackle the problem of synchronization in a changing environment with the application of Machine Learning and present an RL-based synchronizer for the Media Modulation MC testbed in [^2].
The developed RL-agent continually adapts a decoding threshold to detect transmitted synchronization frames.
- **Comparative evaluation with a filter-based maximum likelihood synchronizer:** We comparatively evaluate the RL-based synchronizer's True Positive Rate, False Positive Rate, and Symbol Time Offset performance versus a filter-based maximum likelihood synchronizer.

## Contributing
Interested contributors can be in contact with the project owner, see the Contact Information below. We identify further developments to more complex scenarios including mobility and multiple transmitters.


## License
![Licence](https://img.shields.io/github/license/larymak/Python-project-Scripts)

## References

[^1] L. Y. Debus, P. Hofmann, J. Torres Gómez, F. H. P. Fitzek, and F.Dressler, “Synchronized Relaying in Molecular Communication: An AI-based Approach using a Mobile Testbed Setup,” in 8th Workshop on Molecular Communications (WMC 2024), Oslo, Norway, Apr. 2024.

[^2] L. Brand, M. Garkisch, S. Lotter, et al., “Media Modulation Based Molecular Communication,” IEEE Transactions on Communications, vol. 70, no. 11, pp. 7207–7223, Nov. 2022.

[^3] V. Jamali, A. Ahmadzadeh, and R. Schober, “Symbol Synchronization for Diffusion-Based Molecular Communications,” IEEE Transactions on NanoBioscience, vol. 16, no. 8, pp. 873–887, Dec. 2017

## Contact Information

- **Name:** Lisa Y. Debus

    [![GitHub](https://img.shields.io/badge/GitHub-181717?logo=github)](https://github.com/lyDebus)

    [![Email](https://img.shields.io/badge/Email-email-D14836?logo=gmail&logoColor=white)](mailto:debus@ccs-labs.org)

    [![LinkedIn](https://img.shields.io/badge/LinkedIn-Lisa-blue?logo=linkedin&style=flat-square)](https://www.linkedin.com/in/lisa-yvonne-debus-844876127/)

    [![Website Badge](https://img.shields.io/badge/Website-Homepage-blue?logo=web)](https://www.tkn.tu-berlin.de/team/debus/)
