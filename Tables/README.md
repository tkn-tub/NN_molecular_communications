# Tables and Figures
Code for plotting and extracting metadata from papers that investigate NN architectures for IoBNT networks.

## Description
This folder encompasses code for extracting metadata from published papers that research the application of neural networks (NNs) for the Internet of Bio-Nano-Things (IoBNT) networks.
The output of this code is the reproduction of figures 1 and 2, as shown below.
The references are those listed in [1], and the metadata refers to the following per publication:
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

<figure>
    <p align="center">
        <img src="https://github.com/tkn-tub/NN_molecular_communications/blob/main/Figures/NN_arch_app_env.png?raw=true" alt="nn" width="500">
    </p>
</figure>
<p align="center">
Fig. 2: Bubble plot of reported {NN} architectures..
</p>
We have the following code per folder:

## 📂 Folder Structure

- 📁 [Fig_1_trends](./Fig_1_trends)
    - The code in this folder develops Fig. 1 in reference [1].
    This figure, illustrated in Fig. 1, summarizes the number of contributions per communication layer and per year.
- 📁 [Fig_10_NN_Architectures](./Fig_10_NN_Architectures)
    - The code in this folder evaluates the values for the plot in Fig. 10 in reference [1].
    The figure, illustrated in Fig. 2, shows the total number of publications for each NN architecture, molecular communication (MC) scenario, and IoBNT layer.

- 📁 [Tables](./Tables)
    - This folder includes the Excel file `Tables_1_5.xlsx`, which contains tables 1 to 5 in reference [1].
    These tables were compiled manually, following the various sections in [1].
    The tables in the Excel file were later converted to LaTeX code using the plugin [Excel2LaTeX](https://github.com/ivankokan/Excel2LaTeX).

## Installation
The corresponding MATLAB code is tested in MATLAB 2025a, and the corresponding Python code is tested in Visual Studio Code, version 1.107.1.

## Usage

The code runs directly from the files listed on each folder as follows

- 📁 [Fig_1_trends](./Fig_1_trends)
    - The code in this folder is divided into two parts:
        1) The Python code in the file `NN_per_layer.py` loads the references listed in the Excel file `1_References.xlsx`.
        These references follow those listed in [1].
        This code evaluates the number of contributions per year and per communication layer and outputs the Excel file `2_count_per_layer_and_year.xlsx`.
        The produced Excel file comprises a table with three columns: communication layer, publication year, and number of contributions.
        2) The Matlab code in `NN_per_app.mlx` prints Fig. 1, taking the data in the file `2_count_per_layer_and_year.xlsx`.

- 📁 [Fig_10_NN_Architectures](./Fig_10_NN_Architectures)
    - The Excel file `References_vs_NN_MC_scenario.xlsx` includes three sheets
        - References: Listing the references in [1] per NN Architecture, MC scenario, and IoBNT layer.
        This list was manually compiled based on the description in Section III of [1].
        - Results: This sheet evaluates the number of publications per NN architecture, MC scenario, and IoBNT layer.
        The results are presented in tables, one per NN architecture.
        The numbers are evaluated with Excel formulas.
        - Categories: In the second sheet, it lists the different categories in a table format.
    - PowerPoint source file `NN_arch_app_envv_2.pptx` which reproduces Fig. 2.
    The area of each circle is proportional to the number of publications, and the diameter is evaluated as indicated in the Excel file `References_vs_NN_MC_scenario.xlsx` within the sheet "Results".

## License
![Licence](https://img.shields.io/github/license/larymak/Python-project-Scripts)

## References
<a name="fn1">[1]</a>: Jorge Torres Gómez, Pit Hofmann, Lisa Y. Debus, Osman Tugay Basaran, Sebastian Lotter, Roya Khanzadeh, Stefan Angerbauer, Bige Deniz Unluturk, Sergi Abadal, Werner Haselmayr, Frank H. P. Fitzek, Robert Schober and Falko Dressler, "Communicating Smartly in Molecular Communication Environments: Neural Networks in the Internet of Bio-Nano Things," arXiv, eess.SP, 2506.20589, June 2025.

## Contact Information

- **Name:** Jorge Torres Gómez

    [![GitHub](https://img.shields.io/badge/GitHub-181717?logo=github)](https://github.com/jorge-torresgomez)

    [![Email](https://img.shields.io/badge/Email-jorge.torresgomez@ieee.org-D14836?logo=gmail&logoColor=white)](mailto:jorge.torresgomez@ieee.org)

    [![LinkedIn](https://img.shields.io/badge/LinkedIn-torresgomez-blue?logo=linkedin&style=flat-square)](https://www.linkedin.com/in/torresgomez/)

    [![Website Badge](https://img.shields.io/badge/Website-Homepage-blue?logo=web)](https://www.tkn.tu-berlin.de/team/torres-gomez/)

