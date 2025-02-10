# Autoencoders for Molecular Communications
This project develops an Autoencoder (AEC) for end-to-end learning of molecular communication with data data-driven channel identification.

## Description
An AEC consists of two NNs, known as the encoder and decoder, which are trained together in an unsupervised fashion. The encoder and decoder replace respectively the transmitter and the receiver parts of the communication, and the entire communication pathway is optimized simultaneously in an end-to-end manner. Fig. 1 illustrates the AEC architecture for end-to-end learning of a molecular communication channel.

<figure>
    <p align="center">
<img src="https://github.com/tkn-tub/NN_molecular_communications/blob/main/Figures/autoencoder.jpg?raw=true" width="400">
    </p>
</figure>
<p align="center">
Fig. 1: AEC architecture for end-to-end learning of a molecular communication channel.
</p>

Training an AEC for end-to-end communication requires a known differentiable channel model. We tackle this challenge by representing the real-world molecular channel with a data-driven differentiable model.
The AEC is trained using a data-driven molecular channel representation, following the approach proposed in [^1]. The proposed training procedure is achieved in three steps: i) modeling the MC channel through a RNN, ii) training the emitter and receiver components of the AEC, and iii) fine-tuning training of the complete model. Fig. 2 illustrates the training procedure steps. A data-driven ML method is used in the first step to obtain a differentiable molecular channel representation. A specific type of linear regression, a so-called Auto-Regressive Exogenous (ARX) method is utilized as a promising alternative to the channel representation using NNs. This method models the channel function as an Infinite Impulse Response (IIR) filter implemented by a trainable RNN which is differentiable. In the second step, both the encoder and decoder parts of the AEC are jointly trained using backpropagation, while the RNN which represents the channel is fixed. Lastly, the AEC undergoes fine-tuning to address mismatches between the approximation of the channel model and the real model. The decoder parameters are adjusted using transmissions over the real channel model, while the encoder parameters remain unchanged.

<figure>
    <p align="center">
<!-- <img src="https://github.com/tkn-tub/NN_molecular_communications/blob/main/Figures/AEC_data_driven_channel.png" width="200"> -->
        <img src="Figures/AEC_data_driven_channel.png" width="200">
    </p>
</figure>
<p align="center">
Fig. 2: Proposed end-to-end learning communication system: (a) Channel identification (step 1), (b) offline training of the Tx and Rx on the identified channel model (step 2), (c) online fine-tuning of the Rx (step 3).
</p>

Real measurements from salinity-based communication in a microfluidic channel testbed proposed in [^2] are used to estimate molecular channel parameters. The resulting model generates real-world channel realizations for the channel identification step and is employed to train a Recurrent Neural Network (RNN) during the training.


## Installation
This code is tested in Python 3.11.11, and Pytorch is used as an open-source deep-learning framework.

## Usage

This project runs directly from the file AEC_IIRChannelIdentification.ipynb. In the 'Configuration' section, all the necessary libraries are imported. In the 'Transmission parameters' section, parameters such as symbol duration, oversampling ratio, transmission power, and length are adjusted. Note that the current design supports only binary transmission. In the following sections, an ARX channel model is first trained based on the real channel model and then employed for training the AEC. The performance of the trained model is ultimately evaluated according to the calculated Bit Error Rate (BER) in the 'Calculate BER' section. It is worth mentioning that the AEC can be trained at a specific SNR value (for example, 40 dB) and then tested over the entire range of desired SNR values.

## Features


## Contributing
Interested contributors can contact the project owner. Please refer to the Contact Information below. 

## License
![Licence](https://img.shields.io/github/license/larymak/Python-project-Scripts)

## Acknowledgements
This work has been in part supported by the ”University SAL Labs” initiative of Silicon Austria Labs (SAL) and its Austrian partner universities for applied fundamental research for electronic-based system.

## References
[^1]: Khanzadeh, Roya, et al. "End-to-End Learning of Communication Systems with Novel Data-Efficient IIR Channel Identification." 2023 57th Asilomar Conference on Signals, Systems, and Computers. IEEE, 2023.
[^2]: Angerbauer, Stefan, et al. "Salinity-based molecular communication in microfluidic channels." IEEE Transactions on Molecular, Biological, and Multi-Scale Communications 9.2 (2023): 191-206.

## Contact Information

- **Name:** Roya Khanzadeh

    [![GitHub](https://img.shields.io/badge/GitHub-181717?logo=github)](https://github.com/ROYA_USER)

    [![Email](https://img.shields.io/badge/Email-roya.khanzadeh@jku.at-D14836?logo=gmail&logoColor=white)](mailto:roya.khanzadeh@jku.at)

    [![LinkedIn](https://img.shields.io/badge/LinkedIn-Roya-blue?logo=linkedin&style=flat-square)](https://www.linkedin.com/in/roya-khanzadeh-6180b654/?originalSubdomain=at)

    [![Website Badge](https://img.shields.io/badge/Website-Homepage-blue?logo=web)](https://www.jku.at/institut-fuer-nachrichtentechnik-und-hochfrequenzsysteme/team/prof-andreas-springer/roya-khanzadeh/)
