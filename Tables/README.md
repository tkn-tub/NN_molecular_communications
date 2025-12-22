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
        <img src="https://github.com/tkn-tub/NN_molecular_communications/blob/main/Figures/trends.png?raw=true" alt="nn" width="500">
    </p>
</figure>
<p align="center">
Fig. 1: Trends in contributions related to {NN} research for the {IoBNT}.
</p>

We have the following code per folder:

## 📂 Folder Structure

- 📁 [Fig_1_trends](./Fig_1_trends)
    - The code in this folder develops the Fig. 1 in reference [1].
    This figure, illustrated in Fig. 1, summarizes the number of contribution per communication layer and per year.
- 📁 [Fig_10_NN_Architectures](./Fig_10_NN_Architectures)
    - The code in this folder evaluates the values for the plot in Fig. 10 in reference [1]. The figure, here illustrated in Fig. 2, evaluates the total of publications per NN architecture, MC scenario, and IoBNT layer.

## Installation
The corresponding Matlab code is tested in Matlab 2025a and the corresponding Phyton code is tested in Visual Studio Code, version 1.107.1.

## Usage

The code runs directly from the files listed on each folder as follows

- 📁 [Fig_1_trends](./Fig_1_trends)
    - The code in this folder is divided into two parts:
        1) The Phyton code in the file `NN_per_layer.py` file load the references listed in the excel file `1_References.xlsx`.
        These references follows those listed in [1].
        This code evaluates the number of contributions per year and per communication layer and outputs the excel file `2_count_per_layer_and_year.xlsx`.
        The produced excel file comprises a table of three colums listing the communciaton layer, publication year, and number of contributions.
        2) The Matlab code in `NN_per_app.mlx` prints Fig. 1 taking the data in the file `2_count_per_layer_and_year.xlsx`.

- 📁 [Fig_10_NN_Architectures](./Fig_10_NN_Architectures)
    - The Matlab code in `NN_architectures_per_MC_scenario_IoBNT_layer.mlx` reads the data from from the excel file `References_vs_NN_MC_scenario.xlsx`.
    The code writes in the excel file a new sheet per NN architecture, calculating the number of entries per MC scenario and IoBNT layer.
    - The excel file `References_vs_NN_MC_scenario.xlsx` includes in the first sheet the references listed in [1] per NN Architecture, MC scenario, and IoBNT layer.
    In the second sheet it lists the different categories.
    These two sheets were manually evaluated following the description of each reference, as given in [1].


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