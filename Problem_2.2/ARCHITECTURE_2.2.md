# Problem 2.2: Fair Hamming(7,4) Comparison Architecture

## Purpose
- Define the design for Homework 10 Problem 2.2, which revisits the Live Lab Hamming(7,4) BER simulation under a fairer energy comparison.
- Preserve the same basic communication architecture used in the Live Lab while correcting the energy-accounting issue identified in the assignment.
- Prepare an implementation-ready MATLAB plan without writing code yet.

## Engineering Motivation
- In the Live Lab, Hamming(7,4) showed a strong BER improvement after correction.
- That result was useful, but it was not energy-fair in a practical engineering sense because the coded transmission sent `7` BPSK symbols to protect only `4` information bits.
- If each coded symbol keeps the same energy as the uncoded case, then the coded packet uses `7/4` times the total transmit energy for the same information payload.
- Homework 10 Problem 2.2 asks for a fairer comparison by reducing the coded bit energy so the total energy spent per information bit is comparable to the uncoded baseline.

## Core Interpretation of the Problem
- Hamming(7,4) is a rate-`4/7` linear block code:
  - `4` data bits in
  - `7` coded bits out
- The original Live Lab correction simulation compared:
  - corrected Hamming BER
  - uncorrected coded BER
  - theoretical uncoded BPSK BER
- Problem 2.2 keeps that comparison structure but adds an energy-fair coded case.
- The new fair comparison reduces coded bit energy by a factor of `4/7` relative to the original coded simulation.

## Comparison Categories

### Uncoded BPSK Theoretical BER
- This is the standard BPSK benchmark from the Live Lab.
- It represents the theoretical BER for uncoded BPSK over AWGN as a function of `Eb/N0`.

### Original Hamming(7,4) Live Lab Simulation
- This is the existing correction simulation from the lab reference.
- It uses:
  - BPSK modulation
  - AWGN
  - hard-decision demodulation
  - syndrome decoding
- In that original comparison, the coded case effectively benefits from extra total packet energy.

### Fair-Energy Hamming(7,4) Simulation
- This is the new Homework 10 Problem 2.2 target.
- It uses the same coding and decoding architecture as the original lab simulation.
- The difference is that the coded symbol energy is reduced so the comparison is fair in total energy per information bit.

## Architectural Reference
- The implementation should start from the Live Lab Hamming(7,4) correction simulation in [`hamming_correction_awgn_simulation.m`](c:\REPO\sdr_Module10\Lab10_scripts\hamming_correction_awgn_simulation.m).
- That reference establishes the baseline processing chain:
  1. generate 4 random data bits
  2. encode with Hamming(7,4)
  3. BPSK modulate the 7 coded bits
  4. apply AWGN
  5. demodulate
  6. compute syndrome
  7. correct with the syndrome table
  8. measure BER before and after correction

## Problem 2.2 Workflow
- The fair-comparison workflow should remain close to the lab architecture:
  1. data bits
  2. Hamming(7,4) encoding
  3. BPSK modulation
  4. fair-energy scaling of coded symbols
  5. AWGN
  6. demodulation
  7. syndrome decoding and correction
  8. BER measurement
  9. comparison against theory and original Hamming results

## Inputs
- SNR or `Eb/N0` sweep, expected to follow the Live Lab range unless the assignment or reference script suggests otherwise.
- Random 4-bit input blocks.
- Hamming(7,4) generator and parity-check matrices from MATLAB coding helpers.

## Outputs
- BER before correction for the coded transmission.
- BER after correction for the coded transmission.
- Theoretical uncoded BPSK BER.
- A fair-energy corrected BER curve for direct comparison against:
  - theoretical BPSK BER
  - original Live Lab Hamming(7,4) results

## Plots and Comparisons
- A primary BER figure should compare:
  - theoretical uncoded BPSK BER
  - original Hamming(7,4) corrected BER from the Live Lab style simulation
  - fair-energy Hamming(7,4) corrected BER
- A secondary comparison may also include the uncoded or uncorrected coded BER if that helps interpretation.
- The focus of the report should be on how the fair-energy adjustment changes the apparent coding advantage.

## Fair-Energy Adjustment Concept
- The problem statement says to adjust energy per bit by `4/7`.
- In practical MATLAB terms, one valid way to do this is to reduce the coded BPSK symbol amplitude so that coded bit energy is `4/7` of the original coded case.
- Conceptually:
  - original coded case uses the same per-symbol amplitude as uncoded BPSK
  - fair coded case reduces symbol energy so the total transmit energy for `7` coded bits is comparable to the uncoded energy for `4` information bits
- The exact implementation detail can be chosen later, but the documentation should treat amplitude scaling or equivalent noise-normalized scaling as the intended mechanism.

## Expected Change in Results
- The original Hamming(7,4) corrected BER curve appeared especially strong because the coded transmission used more total energy for the same information payload.
- After fair-energy scaling, some of that apparent BER advantage should shrink.
- The fair-energy coded result may still provide useful coding gain, but the comparison should be more physically meaningful.

## Assumptions
- The Live Lab correction simulation is the baseline architecture and should not be reinvented unnecessarily.
- BPSK, AWGN, hard-decision demodulation, and syndrome-based correction remain unchanged in structure.
- Theoretical BPSK BER remains the uncoded reference curve.
- The fair-energy case changes energy scaling, not the Hamming encoder or decoder logic.

## Risks
- It is easy to confuse total packet energy, coded-bit energy, and information-bit energy.
- If the scaling is applied in the wrong place, the resulting comparison will not be fair.
- If BER is reported against coded-bit counts in one case and information-bit counts in another, the comparison can become misleading.
- The professor will likely care more about whether the energy accounting is conceptually correct than about small numerical differences.

## Validation Strategy
- Confirm that the fair-energy simulation reduces coded symbol energy by the intended `4/7` factor relative to the original coded case.
- Confirm that the original Hamming(7,4) simulation can still be reproduced as a baseline reference.
- Confirm that the theoretical BPSK curve is plotted on the same axis for comparison.
- Check that the fair-energy corrected BER curve shifts relative to the original Hamming curve in the expected direction.
- Verify that the implementation notes clearly explain why the change occurs.

## Proposed File Layout
- `ARCHITECTURE_2.2.md`
  - this design document
- `SIMULATION_PLAN_2.2.md`
  - detailed Monte Carlo plan
- `steps/STEP01_BASELINE_REVIEW.md`
  - baseline lab simulation review
- `steps/STEP02_FAIR_ENERGY_SCALING.md`
  - fair-energy adjustment design
- `steps/STEP03_RESULT_COMPARISON.md`
  - comparison and interpretation plan

## Review Focus
- Confirm that the fair comparison should be framed in terms of equal information-bit energy rather than equal transmitted coded-bit energy.
- Confirm whether the final implementation should reproduce the original Live Lab curve inside the same script or load/reference prior results.
- Confirm whether the report should emphasize corrected BER only, or also include uncorrected coded BER for context.
