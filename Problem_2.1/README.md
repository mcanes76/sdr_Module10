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
- [`append_g9959_checksum.m`](c:\REPO\sdr_Module10\Problem_2.1\append_g9959_checksum.m)
  - Step 2 packet-formation function
- [`check_g9959_packet.m`](c:\REPO\sdr_Module10\Problem_2.1\check_g9959_packet.m)
  - Step 3 packet-verification function
- [`simulate_problem_2_1_per.m`](c:\REPO\sdr_Module10\Problem_2.1\simulate_problem_2_1_per.m)
  - Step 4 PER simulation script
- [`bytes_to_bits.m`](c:\REPO\sdr_Module10\Problem_2.1\bytes_to_bits.m)
  - byte-to-bit conversion utility for modulation
- [`bits_to_bytes.m`](c:\REPO\sdr_Module10\Problem_2.1\bits_to_bytes.m)
  - bit-to-byte reconstruction utility after demodulation
- [`docs/STEP01_CHECKSUM_GENERATION.md`](c:\REPO\sdr_Module10\Problem_2.1\docs\STEP01_CHECKSUM_GENERATION.md)
  - checksum-generation design note
- [`docs/STEP02_PACKET_FORMATION.md`](c:\REPO\sdr_Module10\Problem_2.1\docs\STEP02_PACKET_FORMATION.md)
  - packet-formation design note
- [`docs/STEP03_PACKET_VERIFICATION.md`](c:\REPO\sdr_Module10\Problem_2.1\docs\STEP03_PACKET_VERIFICATION.md)
  - packet-verification design note
- [`docs/STEP04_PER_SIMULATION.md`](c:\REPO\sdr_Module10\Problem_2.1\docs\STEP04_PER_SIMULATION.md)
  - PER-simulation design note
- [`docs/SIMULATION_PLAN.md`](c:\REPO\sdr_Module10\Problem_2.1\docs\SIMULATION_PLAN.md)
  - pre-implementation simulation plan
- [`run_problem_2_1_tests.m`](c:\REPO\sdr_Module10\Problem_2.1\run_problem_2_1_tests.m)
  - required functional tests for packet formation and verification
- [`testbenches/tb_g9959_checksum.m`](c:\REPO\sdr_Module10\Problem_2.1\testbenches\tb_g9959_checksum.m)
  - checksum-generation testbench

## Current Status

Steps 1 through 4 of the functional decomposition are implemented:

- checksum generation
- packet formation
- packet verification
- PER simulation
- debug reconstruction of the odd-parity bit columns
- checksum testbench coverage for the figure example and regression vectors
- required Homework 10 functional tests
