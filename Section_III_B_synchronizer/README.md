# Synchronization

Following the example in [1], we implemented the RL-based synchronizer in MATLAB and Simulink.
For our implementation, we used a particle simulation of the Media Modulation (MM) testbed introduced in [2] showing that the reported approach can be transferred to liquid-based MC scenarios.

<img src="https://github.com/tkn-tub/NN_molecular_communications/blob/main/Figures/synch.jpg?raw=true" width="400">

Our synchronizer follows the structure displayed in the figure above.
It employs a PPO agent with an LSTM layers.
A pretrained agent for the MM testbed is available.
It was trained with time series collected from the particle simulator for 245000 5-bit-frames in 35000 episodes.
For comparison, a matching implementation of the filter-based maximum likelihood estimator [3] is included.

[1] L. Y. Debus, P. Hofmann, J. Torres Gómez, F. H. P. Fitzek, and F.Dressler, “Synchronized Relaying in Molecular Communication: An AI-based Approach using a Mobile Testbed Setup,” in 8th Workshop on Molecular Communications (WMC 2024), Oslo, Norway, Apr. 2024.

[2] L. Brand, M. Garkisch, S. Lotter, et al., “Media Modulation Based Molecular Communication,” IEEE Transactions on Communications, vol. 70, no. 11, pp. 7207–7223, Nov. 2022.

[3] V. Jamali, A. Ahmadzadeh, and R. Schober, “Symbol Synchronization for Diffusion-Based Molecular Communications,” IEEE Transactions on NanoBioscience, vol. 16, no. 8, pp. 873–887, Dec. 2017

