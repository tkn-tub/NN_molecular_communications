# Synchronization
Digital synchronizer in molecular communication channels

## Description
Following the example in [^1], we implemented the RL-based synchronizer in MATLAB and Simulink.
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
It employs a PPO agent with an LSTM layers.
A pretrained agent for the MM testbed is available.
It was trained with time series collected from the particle simulator for 245000 5-bit-frames in 35000 episodes.
For comparison, a matching implementation of the filter-based maximum likelihood estimator [^3] is included.

## Installation

## Usage

## Features

## Contributing
Interested contributers can be in contact with the project owner, see the Contact Information below. We identify further developments to ....


## License
![Licence](https://img.shields.io/github/license/larymak/Python-project-Scripts)

## Acknowledgements

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