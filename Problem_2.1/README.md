# SDR Module 10

## Overview

This folder contains the design and implementation work for Module 10.

The current focus is **Problem 2.1: ITU-T G.9959 Checksum PER Measurement**:

- implement the ITU-T G.9959 odd longitudinal checksum
- verify the checksum with required functional tests
- simulate detected packet error rate versus true packet error rate
- compare results across SNR values from `0` to `6` dB

## Problem 2.1 Summary

- Payload length: `24 bytes = 192 bits`
- Parity length: `1 byte = 8 bits`
- Packet length: `25 bytes = 200 bits`
- Checksum method:
  - initialize checksum to `0xFF`
  - XOR each payload byte into the accumulator
  - append the resulting checksum byte to the payload
- Verification rule:
  - recompute checksum across the full received packet
  - valid packet result should be `0x00`
  - nonzero result means an error was detected

## Current Files

- [`ARCHITECTURE_2.1.md`](c:\REPO\sdr_Module10\ARCHITECTURE_2.1.md)
  - architecture, assumptions, and execution plan for Problem 2.1

## Planned MATLAB Files

- `g9959_checksum.m`
  - compute checksum byte from payload bytes
- `append_g9959_checksum.m`
  - append checksum to a 24-byte payload
- `check_g9959_packet.m`
  - validate a received 25-byte packet
- `run_problem_2_1_tests.m`
  - run reversibility and single-bit-error tests
- `simulate_problem_2_1_per.m`
  - run the SNR sweep and generate PER plots

## Expected Workflow

1. Generate a random 24-byte payload.
2. Compute the checksum and append it to form a 25-byte packet.
3. Verify the packet checks to zero before transmission.
4. Pass packet bits through the live-lab modulation/noise/demodulation chain.
5. Measure:
   - true packet errors
   - detected packet errors
   - PER difference versus SNR

## Notes

- Bit transmission order should follow the assignment figures: MSB first.
- The checksum logic is equivalent to the odd column-parity construction shown in the homework figures.
- This parity scheme detects all single-bit errors, but not all multi-bit error patterns.
