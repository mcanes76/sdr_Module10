# Step 1: Baseline Review

## Purpose
- Review the Live Lab Hamming(7,4) correction simulation and identify exactly what should remain unchanged in Problem 2.2.

## Inputs
- Live Lab reference script:
  - [`hamming_correction_awgn_simulation.m`](c:\REPO\sdr_Module10\Lab10_scripts\hamming_correction_awgn_simulation.m)

## Outputs
- A clear baseline definition for:
  - encoder
  - BPSK modulation
  - AWGN model
  - hard-decision demodulation
  - syndrome decoding
  - BER measurements

## Algorithm Idea
- Preserve the original simulation chain first.
- Identify the fair-comparison change as an energy-scaling modification, not a coding-logic modification.

## Acceptance Criteria
- The baseline simulation architecture is documented clearly enough to reproduce before adding fair-energy scaling.
