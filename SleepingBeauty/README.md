# Evaluation of Sleeping Beauty

## Content of the directory

| File/Directory | Short Description |
| --- | --- |
|Code/         		| Source code of the Sleeping Beauty files for the Baloo implementation |
|GMW-CC430/     	| Directory containing test results ran on the cc430 SoC |
|GMW-Sky/       	| Directory containing test results ran on the TelosB motes with our re-implementation |
|Native/        	| Directory containing test results ran on the TelosB motes with the authors' code |
|TestConfigFiles/	| Directory containing the configuration files of all tests for re-running |
|README.md       	| This file |
|summary.ods     	| Summary of the output metrics from the evaluation |

The rest of this file is a description of the experiment that were run.

## Experiments performed
- All runs are 60 minutes long, with a round period of 10s, thus approx 360 rounds per run.
- The host/sink node is always node 1.
- Complete list of observer used: 001 002 003 004 006 007 008 010 011 013 014 015 016 017 018 019 020 022 023 024 025 026 027 028 032 033 (See in `TestConfigFiles/` for the FlockLab XML templates).
- All source nodes send a request to get a slot assigned to send their data.
- After 3 rounds without any new request, the host signals the end of the bootstrapping phase (of Sleeping Beauty).  
The host then select a set of nodes that should remain active and send their data at every round. All other nodes go to sleep until the end of the scheduling period, which is 10-round long (ie 100s).
- All others configuration parameters of Sleeping Beauty have been set according to [the original paper](https://ieeexplore.ieee.org/abstract/document/7815012/) description.  
All values are in `project-conf.h` (`#define SB_xxx`).

## Variable input parameters
### 1. We vary the number of active source nodes set as active by the host. They are statically 
chose for reprocucibility purposes, using the following defines in `sleeping-beauty.h`
```
#define SOURCES_LIST                    { 2,3,15,18,23,28,4,8,20,22,25,26 }
#define NUM_SOURCES_CASE                  6
```
The `NUM_SOURCES_CASE` defines how many source nodes are used. We used:
  - 3, 6, and, 12
  - corresponding to 12.5%, 25%, 50% of total number of source nodes.
### 2. Platform used
  - TelosB (cc2420)
  - DPP1 (cc430)

## Output metrics
### 1. PRR
  - Computed based on the serial logs using the matlab script `../serial_logs_processing.m`
  - The host expects one packet to arrive on all scheduled data slots. If one packet does not arrive in one slot, it is counted as lost.
### 2. Average duty cycle on all nodes across the whole test
  - Values obtained using energest (on TelosB) and DCSTATS (cc430).
  - DC is reset when Sleeping Beauty bootstrapping is finished.
### 3. Binary size
  - Value obtained using the `msp430-size` utility.
  - All binary files can be found in `./{GMW-CC430,GMW-Sky,Native}/Binaries/`.
  - The size of the protocol implementation is estimated by substracting the size of the OS from the total binary size.
  - The size of the OS is estimated to be the size of a minimal `hello-world` application.
### 4. Lines of code
  - Obtained using the following Python script: `..\linecount.py`
  - `summary.ods` details the code files that were included in the count.
  - For the native implementation, count is based on [the public repository](https://github.com/csarkar/sleeping-beauty/tree/master/sleeping-beauty-test).
  - For the Baloo re-implementation, count includes all files in `./Code/`.

## Tests information
Below are the FlockLab test numbers and the time and date at which they ran. The test configuration files can be found in `TestConfigFiles/` for re-running.

### Sky
- U3	57854	2018-09-21 01:41:57 +02:00	2018-09-21 02:43:24 +02:00	Thursday night
- U6	57852	2018-09-20 23:29:55 +02:00	2018-09-21 00:31:58 +02:00	Thursday night
- U12	57850	2018-09-20 19:45:13 +02:00	2018-09-20 20:46:43 +02:00	Thursday night
### CC430
- U3	57855	2018-09-21 02:47:58 +02:00	2018-09-21 03:50:35 +02:00	Thursday night
- U6	57853	2018-09-21 00:35:56 +02:00	2018-09-21 01:38:34 +02:00	Thursday night
- U12	57851	2018-09-20 20:51:14 +02:00	2018-09-20 21:53:53 +02:00	Thursday night
