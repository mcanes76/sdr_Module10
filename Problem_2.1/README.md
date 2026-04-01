# Problem 2.1

## Overview

This folder contains the implementation and documentation for Problem 2.1 of Module 10:

- ITU-T G.9959 checksum generation
- packet verification logic
- PER simulation using the checksum as the error detector

## Current Files

- [`ARCHITECTURE_2.1.md`](c:\REPO\sdr_Module10\Problem_2.1\ARCHITECTURE_2.1.md)
  - overall architecture and execution plan
- [`g9959_checksum.m`](c:\REPO\sdr_Module10\Problem_2.1\g9959_checksum.m)
  - Step 1 checksum-generation function
- [`docs/STEP01_CHECKSUM_GENERATION.md`](c:\REPO\sdr_Module10\Problem_2.1\docs\STEP01_CHECKSUM_GENERATION.md)
  - checksum-generation design note
- [`testbenches/tb_g9959_checksum.m`](c:\REPO\sdr_Module10\Problem_2.1\testbenches\tb_g9959_checksum.m)
  - checksum-generation testbench

## Current Status

Step 1 of the functional decomposition is implemented:

- checksum generation
- debug reconstruction of the odd-parity bit columns
- testbench coverage for the figure example and regression vectors

## Next Planned Files

- `append_g9959_checksum.m`
- `check_g9959_packet.m`
- `simulate_problem_2_1_per.m`
