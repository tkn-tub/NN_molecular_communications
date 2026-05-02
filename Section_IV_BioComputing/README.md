# NN architectures with Microfluidic Circuits
This project develops microfluidic circuits in COMSOL to model their computational capabilities.

## Description
This project is a work in progress to explore the computational capabilites with microfluidic circuits.
We aim to implement the linear and non-linear components of a 1D convolutional neural newtork (CNN) with the transport of diluted species guided through the connection of various microfluidic pipes, as illustrated in Fig. 1.
The conception is to interpret the digital signal processing (DSP) operations with the properties of the flow of diluted species.
Specifically, the multiplication of coefficients with the inputs is interpreted with the reduction of the concentration of species as they travel through the pipe.
The propagation delay introduced by the pipe is directly corresponded with the delay on each branch of the CNN.
In this way, the linear component of the CNN is synthetized with the properties of the transport of diluted species, while the non-linear component with a chemical reaction.


<!-- which is syntethized with the transport component of the microfluidic circuit.
The nonlinear operation of the network $\sigma(y)$ is realized with a chemical reaction. -->

<figure>
    <p align="center">
        <table><tr><td bgcolor="white" align="center">
            <img src="https://github.com/tkn-tub/NN_molecular_communications/blob/main/Figures/microfluidic.SVG?raw=true" alt="nn" width="500">
        </td></tr></table>
    </p>
</figure>
<p align="center">
Fig. 1: Illustration of the microfluidic circuit to realize a neuron.
</p>

The linear component of the CNN, is analytically described with the following convolution operation between the sequence of coefficients $\omega_n$ and the sequence to process $x_n$ as

 ![sum](https://latex.codecogs.com/png.latex?\bg_white%20y_n=w_n\ast%20x_n=\sum_{i=1}^{N}%20\omega_i%20x_{n-i}.%20\qquad%20(1))

The coefficients $\omega_i$'s, when interpreted as attenuators, are evaluated with the dispersion of molecules due to the diffusion of particles within a pipe.
The delay is produced with the traveling time of particles along the pipe, which depends on the volumetric flow $Q$.
Following this description the synthesis problem is formulated as evaluating the size of the pipes, i.e., lenght, width and depth, that produces the desired attenuation $\omega_i$ and the delay of $n$ units of time in one-to-one correspondence between the coefficients and the pipe.
The output of this project is a fabrication and simulation in COMSOL of 3-coefficients CNN, as illustrated in Fig. 2.

<figure>
    <p align="center">
        <img src="https://github.com/tkn-tub/NN_molecular_communications/blob/main/Figures/CNN_Sensor_Concentration_Phase_1.gif?raw=true" alt="nn" width="300">
    </p>
</figure>
<p align="center">
Fig. 2: Animation of the transport of particles in 3-pipes microfluidic design.
</p>

## Installation
This simulation is developed in Matlab R2025b and in COMSOL Multiphysics 6.3, which needs to be installed on the local PC.
The Matlab toolboxes used for this calculations is Symbolic Math Toolbox.
In COMSOL, the physics included within this simulation are the following:

- Chemical Species of Transport using the modules
    
        Reaction Engineering,
        Chemical Reaction, and
        Transport of Diluted Species.
- Fluid Flow: Single-Phase Flow.

## Usage

This project synthesize the microfluidic pipes alternating between the calculation of the microfluidic geometry in Matlab and the numeric simulation in COMSOL.
The synthesis is conceived along three phases to gradually: i) Adjust the timing (phase 1); ii) Adjust the amplitude (phase 2) with the timing already fixed in phase 1; and iii) Includes the hydraulic resistance to the design as in phase 3.
On each phase, the geometry is computed in the matlab code files `Synthesis_Three_Pipes_Phase_1.mlx`, `Synthesis_Three_Pipes_Phase_2.mlx`, and `Synthesis_Three_Pipes_Phase_3.mlx`, and the simulations are all included in the COMSOL file `COMSOL_Three_Pipes_Phases_1_to_4.mph`.
All Matlab codes as well as the COMSOL simulation are placed within the code file,  

- Phase 1

<table>
  <tr>
    <td align="center">
      <img src="https://github.com/tkn-tub/NN_molecular_communications/blob/main/Figures/CNN_Sensor_Concentration_Phase_1.gif?raw=true" alt="Phase 1 simulation" width="350">
      <br><em>(a) COMSOL simulation</em>
    </td>
    <td align="center">
      <img src="https://github.com/tkn-tub/NN_molecular_communications/blob/main/Figures/result_Phase_1.SVG?raw=true" alt="Phase 1 results" width="350">
      <br><em>(b) Results</em>
    </td>
  </tr>
</table>
<p align="center">Fig. 3: Phase 1 results.</p>

The Matlab code evaluates the length and width per pipe for a given constant inlet volumetric flow $Q$ and height of pipes.
The volumetric flow is defined as $Q=2\mu\mathrm{L}/\min$, a value that follows the pressure pump used in the experimental part of this work, see a [link to the preasure pump technology](https://elveflow.com/microfluidic-products/microfluidics-flow-control-systems/ob1-pressure-controller/).
The height is predefined by the sensor technology, which limits a height to a minimum of $50\, \mu\mathrm{m}$.

The geometry computed by the Matlab code is introduced in COMSOL, which construct and simulate the transport of diluted species along the pipes, as illustrated in Fig. 2.
This figure illustrates the connection of the three pipes, which emulates a 1D-CNN of three coefficients, and a sensor chamber (circular geometry) where the operations are measured.
The sensor component is simulated with the evaluation of the pH levels in COMSOL.



### Implementing the linear component

<!--<figure>
    <p align="center">
        <img src="https://github.com/tkn-tub/NN_molecular_communications/blob/main/Figures/microfluidic_animation.gif?raw=true" alt="nn" width="300">
    </p>
</figure>
<p align="center">
Fig. 2: Animation of the variability of the concentration.
</p>-->

The flow within the pipe is defined with water H2O as the material, the water fluid is forced to keep a velocity $v_0$ at the inlet.
The pipe comprises two inlets, one within the first compartment and a second one on the top wall of the last compartment.
In the Inlet 1, the chemical input component is Acetic Acid (CH3COOH), in the Inlet 2 is Sodium Hydroxide (NaOH), both reactants produce Sodium Acetic (CH3COONa) and water.
This particular reaction was selected due to its affordability in chemical labs and due to the variability of the product pH with the concentration of CH2COONa.
This particular reaction is an acid-base one, where the pH level develops an S-function with the concentration of the product.
As such it develops the needed non-linear component of the neuron scheme.

This simulation also includes a time variable concentration at the Inlet 1.
The Acetic Acid is feeded in a form of pulse with the concentration level.
This allows to model pulse-based transmissions within the microfluidic channel.



## Usage

This project directly runs from the file `2D_turn_chemıical_reaction.mph`, which is located in the folder `COMSOL_2D_turn_chemical_reaction`.
Besides, we also provide Matlab code in the file `Master_File.mlx` to plot the exported results from COMSOL.
This project can be customized with their parameters, which are defined within the box `Global Definition/Paremeters 1`.
Parameters are related to the geometry of the pipe, the chemical reaction, and the fluid of the chemical components.
The main parameters related to this simulation are described as follows 

### Chemical reaction parameters

| Chemical-related parameters  | Description |
| ------------- | ------------- |
| A | Forward frequency factor accounting for the Arrhenius expression.|
| c_CH3COOH_ini  | Initial concentration of Acetic acid. |
| c_NaOH_ini  | Initial concentration of Sodium hydroxide. |
| c_CH3COONa_ini  | Initial concentration of Acetic Sodium. |
| c_H2O_ini  | Initial concentration of water. |

### Geometry parameters
The most relevant parameters related to the geometry are the size of the three straigth paths, the turning angle, and the radius of the pipe.
These parameters are listed as follows

| Geometry-related parameters  | Description |
| ------------- | ------------- |
| width_cylinder_in_1  | Length of the cilinder at the Inlet 1. |
| radius_cylinder_1  | Radius of the pipe.  |
|width_cylinder_out_1 | Length of the cilinder placed after the turn. |
|width_cylinder_chem_chamber_1| Length of the cylinder where the chemical reaction takes place.|
|angle_turn_1_rad| Angle in radians of the turnning geometry.|
|r_in_1| Radius of the circle that defines the inner arc of the turning geometry.|

### Transport related parameters

The fluid within the pipe follows the initial speed of the Inlet 1, and we also define a second speed to release the components whithin the Inlet 2.
We also introduce the diffusion coefficients for each component in water.
These parameters are

| Fluid-related parameters  | Description |
| ------------- | ------------- |
|v_0| Speed of the fluid at the Inlet 1.|
|v0_chem_inlet| Speed of the fluid at the Inlet 2.|
|D_CH3COOH | Diffusion coefficient of Acetic Acid in water.|
|D_CH3COONa | Diffusion coefficient of Acetic Sodium in water.|
|D_NaOH | Diffusion coefficient of Sodium Hydroxide in water.|
|D_H2O | Diffusion coefficient of water in water.|

Within the Inlet 1, we introduce a time variable concentration level of the Acetic Acid which is controled with the paremeters

| Pulse-related Parameters  | Description |
| ------------- | ------------- |
|pulse_duration| Pulse duration of the concentration at the Inlet 1.|
|pulse_transition|Pulse transition of the concentration at the Inlet 1.|

### Geometry

The main geometry is defined in Component 1, which is an space-dependent simulation.
The geometry consist of four components: 1) `pipe_in_1`, where the left inlet is located for the CH3COO chemical reactant; 2) Circular_Arc which defines the turning; 3) the pipe_out as rectangle that continues the turning, and 4) the `Chemical_Chamber` where a second inlet is located for the reactant NaOH.

### Definitions in Component 1
For the easiest of the physics configuration, various selections are defined in regard to the domain, the walls, the two inlets and the outlet.
These geometry selections are defined in `Model Builder/Component 1/Definitions/Selections`.
Besides, a rectangular function is defined to model the inlet for the CH3COO chemical component.
This rectangular function is defined `Analytic 1 (pulse)` of parameter `t`, which uses the `Rectangle 1 (rect 1)` function.
The `rect 1` function defines a rectangular pulse of pulse duration and transition given by the parameters `pulse_duration` and `pulse_transition`.

### Physics and simulation results

The simulation includes the modeling of the chemical reaction, the laminar flow and the transport of diluted species within the pipe.
A variety of studies are included to accounts for these components.
Besides, we plot the simulation results in Matlab with the file `Master_File.mlx`.
The matlab code imports results from COMSOL, which is stored in the file `datasets`.
The ph

#### Reaction physics:
- This study refers to the chemical reaction within the pipe.
The reaction is the non-reversible basic-acid: CH3COOH+NaOH -> CH3COONa+H2O.
This time-dependent study produces a Global 1D plot to evaluate the concentration of reactants and products with time.
This is illustrated within the `Model Builder/Results`  in COMSOL for the entry `Chemical Reaction`.
The results are exported into the file `chemical_reaction.csv` and illustrated in Fig. 2 below.

<figure>
    <p align="center">
        <img src="https://github.com/tkn-tub/NN_molecular_communications/blob/main/Figures/chemical_reaction.png?raw=true" alt="nn" width="300">
    </p>
</figure>
<p align="center">
Fig. 3: Concentration level of the chemical reaction in 0D.
</p>

#### Fluid dynamic physics:

- The fluid dynamic is modeled with water, which is defined in the Model Builder/Component 1/Materials.
The density and viscosity parameters follows the one included by the COMSOL library, which refer to the water as material.
Initial values are zero for the speed and the pressure.
Two inlets are defined for the two reactants of normal inflow velocities defined by the paramters `v0` and `v0_chem_inlet`.
The walls and the oulets are accordingly defined as weel with the fluid flow.
This physics includes an stationary study that evaluates the velocity of the fluid within the pipe.
This study solve for the physics Chemistry and Laminar Flow and the multiphysics Reacting Flow, Diluted Species.
The result from COMSOL is exported to the file `velocity.csv` and later ploted in Matlab, as illustrated in Fig. 4.

<figure>
    <p align="center">
        <img src="https://github.com/tkn-tub/NN_molecular_communications/blob/main/Figures/velocity_vs_geometry.png?raw=true" alt="nn" width="300">
    </p>
</figure>
<p align="center">
Fig. 4: Velocity of the fluid within the pipe
</p>

#### Fluid of Diluted Species physics 

- Fluid:  The Fluid of Diluted Species is defined along the four domains of the pipes.
The diffusion properties in the fluid are defined with the source as the `Chemistry`, and using the diffusion coefficients for the variety of chemicals.
- Initial Values: All the initial values are set to zero.
- Reactions: All the reaction rate coefficients are already set to the ones in the Chemistry component.
- Inflow 1: This inlet is the one located on the left of the pipe. It inflows the chemical CH3COOH as a pulse using the entry `c_CH3COOH_ini*pulse(t)`.
The value for `c_CH3COOH_ini` is defined in the `Global Definitions/Parameters`.
The function of time `pulse(t)` is defined in `Component 1/Definitions/Analytic 1`.
- Inflow 2: Located at the inlet of the chemical chamber domain, it defines the feeding of the chemical component NaOH.
This chemical is constant with time, which is defined with concentration level `c_NaOH_init`.
- Outflow: It is defind at the oulet of the chemical chamber.
- Study Concentration: This study is defined as time-dependent.
It evaluates the concentration level with time of the four chemicals within the pipe (CH3COOH, NaOH, CH3COONa, and H2O).
The study solves for the physics Chemistry, Laminar Flow, and Transport of Diluted Species, as well as for the multiphysics `Reacting Flow, Diluted Species`.
This study also calculates the concentration along a variety of inlets and outlets.
The calculations are defined in `Results/Derived Values`

        a) Surface plot for the concentration value of the four components CH3COOH, NaOH, CH3COONa, and H2O.
    
        b) Average concentration value for CH3COOH at the input of the chemical chamber.

        c) 

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
<a name="fn1">[1]</a>: M. Zoofaghari, F. Pappalardo, M. Damrath, and I. Balasingham, “Modeling Extracellular Vesicles-Mediated Interactions of Cells in the Tumor Microenvironment,” IEEE Transactions on NanoBioscience,
vol. 23, no. 1, pp. 71–80, Jan. 2024. [Link](https://ieeexplore.ieee.org/document/10149035)

## Contact Information

- **Name:** Jorge Torres Gómez

    [![GitHub](https://img.shields.io/badge/GitHub-181717?logo=github)](https://github.com/jorge-torresgomez)

    [![Email](https://img.shields.io/badge/Email-jorge.torresgomez@ieee.org-D14836?logo=gmail&logoColor=white)](mailto:jorge.torresgomez@ieee.org)

    [![LinkedIn](https://img.shields.io/badge/LinkedIn-torresgomez-blue?logo=linkedin&style=flat-square)](https://www.linkedin.com/in/torresgomez/)

    [![Website Badge](https://img.shields.io/badge/Website-Homepage-blue?logo=web)](https://www.tkn.tu-berlin.de/team/torres-gomez/)