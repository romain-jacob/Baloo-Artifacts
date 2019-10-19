# Evaluation of Crystal

## Content of the directory

| File/Directory | Short Description |
| --- | --- |
|Code/         		| Source code of the Crystal files for the Baloo implementation |
|GMW-CC430/     	| Directory containing test results ran on the cc430 SoC |
|GMW-Sky/       	| Directory containing test results ran on the TelosB motes with our re-implementation |
|Native/        	| Directory containing test results ran on the TelosB motes with the authors' code |
|TestConfigFiles/	| Directory containing the configuration files of all tests for re-running |
|README.md       	| This file |
|summary.ods     	| Summary of the output metrics from the evaluation |

The rest of this file is a description of the experiment that were run.

## Experiments performed
- All runs are 60 minutes long, with a round period of 2s, thus approx 1800 epochs per run.
- Source nodes start generating packets from the 11th epoch onwards (controlled by the `CRYSTAL_START_EPOCH` parameter)
- The host/sink node is always node 1.
- Complete list of observer used: 001 002 003 004 006 007 008 010 011 013 014 015 016 017 018 019 020 022 023 024 025 026 027 028 032 033 (See in `TestConfigFiles/` for the FlockLab XML templates).
- **All tests use channel hopping**, following a predifined sequence based on the epoch and TA pair counters. See sequence definition in the `get_channel_epoch()` and `get_channel_epoch_ta()` functions.
- **All tests use the noise detection feature** 
  - Controlled by the `GMW_CONF_USE_NOISE_DETECTION` parameter.
  - Settings:
    * -105 dBm threshold, 80 threshold crossing to return *high noise*
> We intended the set the threshold to -60 dBm but forgot about the offset of 45 dBm set by default by the TelosB radio module. This is the source of the DC differences we have observed between the original Crystal results and our own experiments. On the DPP, the threshold was correctly set to -60 dBm
    * -60 dBm threshold, 80 threshold crossing to return *high noise*
> New series of tests performed with the proper power settings. As expected, the results are now comparable on all platforms.

## Variable input parameters
### 1. Number of source nodes sending a packet in each epoch 
  - Value: 0, 1 and 20
  - Controlled by the `CRYSTAL_NB_CONCURRENT_SENDER` parameter
  - The node sending in one epoch is defined by the `sndtbl` array, staticly defined are used for all Crystal test (see `sndtbl.c`).
### 2. Platform used
  - TelosB (cc2420)
  - DPP1 (cc430)

## Output metrics
### 1. PRR
  - Computed based on the serial logs using the matlab script `../serial_logs_processing.m`
  - A packet is counted as lost if it was send (at least once) by a source node, but not received at the host/sink by the end of the same epoch.
  - **Important** This means a packet that should have been sent by a node (according to the `sndtbl`) but wasn't (e.g. because the node was out of sync) is not counted as a 'lost packet'. This is arguable. However this is fine in our case, as all implementation of Crystal do the same, and we are interested in the respective differences.
### 2. Average duty cycle on all nodes across the whole test
  - Values obtained using energest on TelosB, and DCSTATS (custom duty cycle tracing) on cc430.
  - DC is reset at the first execution of the application process (after first bootstrapping).
### 3. Binary size
  - Value obtained using the `msp430-size` utility.
  - All binary files can be found in `./{GMW-CC430,GMW-Sky,Native}/Binaries/`.
  - The size of the protocol implementation is estimated by substracting the size of the OS from the total binary size.
  - The size of the OS is estimated to be the size of a minimal `hello-world` application.
### 4. Lines of code
  - Obtained using the following Python script: `..\linecount.py`.
  - `summary.ods` details the code files that were included in the count.
  - For the native implementation, count is based on [the public repository](https://github.com/d3s-trento/crystal/tree/master/apps/crystal).
  - For the Baloo re-implementation, count includes all files in `./Code/`.

## Test numbers
### Native
- U0	57708	2018-09-17 06:50:00 +02:00	2018-09-17 07:52:04 +02:00	Monday
- U1	57709	2018-09-17 09:00:00 +02:00	2018-09-17 10:02:04 +02:00	Monday
- U20	57710	2018-09-17 10:10:00 +02:00	2018-09-17 11:12:03 +02:00	Monday
### Sky
- U0	57731	2018-09-17 08:03:00 +02:00	2018-09-17 08:51:27 +02:00	Monday
- U1	57712	2018-09-17 11:17:00 +02:00	2018-09-17 12:18:27 +02:00	Monday
- U20	57713	2018-09-19 10:30:00 +02:00	2018-09-19 11:30:00 +02:00	Wednesday
### CC430
- U0	57714	2018-09-17 20:17:00 +02:00	2018-09-17 21:17:00 +02:00	Monday
- U1	57707	2018-09-16 13:15:27 +02:00	2018-09-16 14:18:07 +02:00	Sunday
- U20	57704	2018-09-16 11:32:06 +02:00	2018-09-16 12:34:45 +02:00	Sunday

