# Evaluation of LWB

## Content of the directory

| File/Directory | Short Description |
| --- | --- |
|Code/         		| Source code of the LWB files for the Baloo implementation |
|GMW-CC430/     	| Directory containing test results ran on the cc430 SoC |
|GMW-Sky/       	| Directory containing test results ran on the TelosB motes with our re-implementation |
|Native/        	| Directory containing test results ran on the TelosB motes with the authors' code |
|TestConfigFiles/	| Directory containing the configuration files of all tests for re-running |
|README.md       	| This file |
|summary.ods     	| Summary of the output metrics from the evaluation |

The rest of this file is a description of the experiment that were run.

## Experiments performed
- All runs are 60 minutes long.
- The host/sink node is always node 1.
- Complete list of observer used: 001 002 003 004 006 007 008 010 011 013 014 015 016 017 018 019 020 022 023 024 025 026 027 028 032 033 (See in `TestConfigFiles/` for the FlockLab XML templates).

## Variable input parameters
### 1. Inter-packet interval (IPI) of the data streams registered by the source nodes.
  - Value: 4s and 30s
  - Controlled by the `SOURCE_IPI` parameter in `project-conf.h`
### 2. Platform used
  - Tmote Sky (cc2420)
  - DPP1 (cc430)

## Output metrics 
### 1. PRR
  - Computed based on the serial logs using the matlab script `../serial_logs_processing.m`
  - A packet is counted as lost if it is detected by the host (the preamble was detected at least once by the radio), but not correctly received by the end of the flood. All floods are counted.
  - **Important** This means that we count a failed contention slot (that nodes use to register their data stream) as a 'lost packet'.  
This is arguable. However this is fine in our case, as all implementation of LWB do the same, and we are interested in the respective differences.
### 2. Average duty cycle on all nodes across the whole test
  - Values obtained using the DCSTAT utility.
### 3. Binary size
  - Value obtained using the `msp430-size` utility.
  - All binary files can be found in `./{GMW-CC430,GMW-Sky,Native}/Binaries/`.
  - The size of the protocol implementation is estimated by substracting the size of the OS from the total binary size.
  - The size of the OS is estimated to be the size of a minimal `hello-world` application.
### 4. Lines of code
  - Obtained using the following Python script: `..\linecount.py`
  - `summary.ods` details the code files that were included in the count.
  - For the native implementation, count is based on [the public repository](https://github.com/ETHZ-TEC/LWB/tree/dpp/core/net).
  - For the Baloo re-implementation, count includes all files in `./Code/`.


## Test numbers
### Native
- IPI4	57805	2018-09-19 23:00:00 +02:00	2018-09-20 00:00:00 +02:00	Wednesday night
- IPI30	57806	2018-09-20 00:08:00 +02:00	2018-09-20 01:08:00 +02:00	Wednesday night
### Sky
- IPI4	57773	2018-09-19 01:09:00 +02:00	2018-09-19 02:09:00 +02:00	Tuesday night
- IPI30	57807	2018-09-20 01:16:00 +02:00	2018-09-20 02:16:00 +02:00	Wednesday night
### CC430
- IPI4	57772	2018-09-19 00:00:00 +02:00	2018-09-19 01:00:00 +02:00	Tuesday night
- IPI30	57810	2018-09-20 02:00:00 +02:00	2018-09-20 03:00:00 +02:00	Wednesday night
