# Tables and Figures
Code for plotting for extracting metadata from papers that investigate NN architectures for IoBNT networks.

## Description
This folder encommpasses code for extracting metadata from published papers that research the application of neural networks (NNs) for the internet of bio-nano-things (IoBNT) networks.
The references are those listed in [1] and the metadata refers to the following per publication:
- Publication Year spanning from 2017 to 2025,
- Reported communication layer: PHY, MAC, Upper layer, Application layer,
- Reported NN architecture: Feedforward, RNN, Autoencoders, CNN, Reinforcement Learning, Transformer,
- Molecular communication scenario: Free-diffusion, Drifted, Vessel-like channels, Open air, bacteria colony.

<figure>
    <p align="center">
        <img src="https://github.com/tkn-tub/NN_molecular_communications/blob/main/Figures/distance_estimator.png?raw=true" alt="nn" width="500">
    </p>
</figure>
<p align="center">
Fig. 1: Components for estimating the distance among cell using a feedforward NN.
</p>

We have the following code per folder:

## 📂 Folder Structure

- 📁 [Fig_1_trends](./Fig_1_trends)
- 📁 [docs](./docs)
- 📁 [tests](./tests)



The NN is a low-complexity feedforward architecture implemented in MATLAB and comprises a single layer and two nodes. The output of the NN is the predicted distance, as illustrated in Fig. 1c, the model devise a quite accurate estimator.

## Installation
This code is tested in MATLAB 2023b, and the required toolboxes are listed in the table below.

| Matlab Toolbox  | Version |
| ------------- | ------------- |
| System Identification Toolbox  | 23.2  |
| Deep Learning Toolbox  | 23.2  |
|Statistics and Machine Learning Toolbox|23.2|

## Usage

This project directly runs from the file `A_Master_File.mlx`, where the NN model is trained and deployed. This file calls to the other two project files `Parameters.mlx` and optionally to `Dataset_compiler.mlx`. By default, the code loads the stored file `Dataset_cell2cell.mat`, accesible on the [IEEE DataPort portal at this link](https://ieee-dataport.org/documents/dataset-cell-cell-communications) after loggin or in the [Ocean Code portal (dataset folder) at this link](https://codeocean.com/capsule/6777864/tree/v1) (withouth any loggin requirements).

## Features
- **Realistic model for vesicles exchange among cells:** This code evaluates a realistic model for the exchange of molecules between immune and cancer cells. The code within the file `Dataset_compiler.mlx`, originally provided by Mohammad Zoofaghari, follows the mathematical developments in [1].
- **Low-complex distance estimator to a cancer cell:** This solution features a 2 nodes NN to accurately estimate the distance to a cancer cell from a neighbord immune cell.

## Contributing
Interested contributors can contact the project owner. Please refer to the Contact Information below. We identify further developments for more complex scenarios like estimating the distance to multiple cancer cells.

## License
![Licence](https://img.shields.io/github/license/larymak/Python-project-Scripts)

## Acknowledgements
We want to acknoledge the support provided by Mohammad Zoofaghari, author of the paper in [1] for giving us the code to generate the dataset.

## References
<a name="fn1">[1]</a>: Jorge Torres Gómez, Pit Hofmann, Lisa Y. Debus, Osman Tugay Basaran, Sebastian Lotter, Roya Khanzadeh, Stefan Angerbauer, Bige Deniz Unluturk, Sergi Abadal, Werner Haselmayr, Frank H. P. Fitzek, Robert Schober and Falko Dressler, "Communicating Smartly in Molecular Communication Environments: Neural Networks in the Internet of Bio-Nano Things," arXiv, eess.SP, 2506.20589, June 2025.

## Contact Information

- **Name:** Jorge Torres Gómez

    [![GitHub](https://img.shields.io/badge/GitHub-181717?logo=github)](https://github.com/jorge-torresgomez)

    [![Email](https://img.shields.io/badge/Email-jorge.torresgomez@ieee.org-D14836?logo=gmail&logoColor=white)](mailto:jorge.torresgomez@ieee.org)

    [![LinkedIn](https://img.shields.io/badge/LinkedIn-torresgomez-blue?logo=linkedin&style=flat-square)](https://www.linkedin.com/in/torresgomez/)

    [![Website Badge](https://img.shields.io/badge/Website-Homepage-blue?logo=web)](https://www.tkn.tu-berlin.de/team/torres-gomez/)