# Baloo - Artifacts

October 2019 - v1.1  
Romain Jacob - jacobr@ethz.ch

This repository contains data (raw and processed), source code, and scripts for Baloo-related publications: 

- *Synchronous Transmissions Made Easy: Design Your Network Stack with Baloo*,  
Romain Jacob, Jonas Bächli, Reto Da Forno, Lothar Thiele,  
Proceedings of the 2019 International Conference on Embedded Wireless Systems and Networks (EWSN), February 2019.  
[[Paper](https://www.research-collection.ethz.ch/handle/20.500.11850/324254)]     [[Presentation](https://www.research-collection.ethz.ch/handle/20.500.11850/328814)]  
Source code:
  - [Available on GitHub](https://github.com/ETHZ-TEC/Baloo/tree/v1.0.1)
  - [Archived on Zenodo](https://doi.org/10.5281/zenodo.3510172)  
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.3510172.svg)](https://doi.org/10.5281/zenodo.3510172)
- *Facilitating the Design and Evaluation of Reliable Low-power Wireless Networks*,  
Chapter 3, Romain Jacob,  
Doctoral Thesis, (Expected) December 2019.  
[[Thesis](https://doi.org/10.5281/zenodo.3510185)]  
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.3510185.svg)](https://doi.org/10.5281/zenodo.3510185)


This file serves as top-level documentation for the paper artefacts (including experimental raw data, processing scripts, and final figures). Additional documentation is available in the individual directories whenever relevant.

A list of files is included at the end of this README, with a short description for each.

**Note** The test results in this directory only contain the serial dump files (which are sufficient for the data processing realized for the upper-mentioned paper). The complete Flocklab test results (including GPIO traces) are available [upon request](mailto:jacobr@ethz.ch).

## Data Processing Tool Chain

The processing should in principal work on any computer capable on running Matlab and Python.

**Tested configurations**
- Ubuntu 16.04 LTS, Matlab R2018b, Python 2.7.12

The Matlab files should be compatible with Windows setups as well (no guarantees, un-tested).


### Duty-cycle and Packet Reception Ratio
The `serial_logs_processing.m` Matlab script contains fetches experiment raw data and computes and outputs the DC and PRR metrics for the different protocols. 
- Select the desired `result_to_parse`.
- Adjust the `tests` and `experiments`.
- Run the script. The output is displayed in the Matlab Command Window.

### Lines of Code

Run the `lineofcode.py` script. Instructions are provided therein.

### Binary size

Requires the GCC-msp430 toolchain. On a linux system, it can be installed  with the command
```
sudo apt install gcc-msp430
```

Run the msp430-size utility on the binary files `.sky` and `.dpp-cc430` respectively (provided in the respective protocol directories).

## List of files

| File name | Short Description |
| --- | --- |
|Crystal/                 	|  Directory containing experiments description and results for Crystal|
|LWB/                     	|  Directory containing experiments description and results for LWB|
|SleepingBeauty/          	|  Directory containing experiments description and results for Sleeping Beauty|
|linecount.py 				| Python script used to estimate the number of lines of code|
|README.md 					| This file|
|serial\_logs\_processing.m | Matlab script used to process the serial logs and extract the PRR and DC metrics|

