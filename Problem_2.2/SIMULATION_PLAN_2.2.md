# Problem 2.2 Simulation Plan

## Goal
- Build a Monte Carlo BER simulation for Homework 10 Problem 2.2 using the Live Lab Hamming(7,4) correction simulation as the baseline.
- Add a fair-energy coded case so the comparison against uncoded BPSK is physically more meaningful.

## Baseline Reference
- The reference architecture is [`hamming_correction_awgn_simulation.m`](c:\REPO\sdr_Module10\Lab10_scripts\hamming_correction_awgn_simulation.m).
- That script already includes:
  - Hamming(7,4) encoding
  - BPSK modulation
  - AWGN
  - hard-decision demodulation
  - syndrome decoding
  - BER before correction
  - BER after correction
  - theoretical BPSK BER

## Monte Carlo Flow
1. Choose the `Eb/N0` sweep used for the comparison.
2. For each SNR point, generate many random 4-bit data words.
3. Encode each 4-bit word into a 7-bit Hamming codeword.
4. Produce the original Live Lab coded-symbol case.
5. Produce the fair-energy coded-symbol case by reducing coded symbol energy by `4/7` relative to the original coded case.
6. Transmit the coded symbols through AWGN.
7. Hard-demodulate the received symbols back to bits.
8. Compute the syndrome and apply single-error correction.
9. Record BER before correction and BER after correction as needed.
10. Compute the theoretical uncoded BPSK BER over the same `Eb/N0` values.
11. Generate comparison plots and interpret the differences.

## Fair-Energy Adjustment
- The key change in Problem 2.2 is energy normalization.
- The original coded simulation effectively spent more total energy on the 7 coded bits than the uncoded system spent on 4 information bits.
- The fair comparison should keep information-bit energy comparable by reducing coded symbol energy by `4/7` relative to the original coded case.
- One practical implementation path is to scale the coded BPSK symbol amplitude.
- Another mathematically equivalent path may be to adjust the noise normalization consistently.
- The exact MATLAB implementation can be chosen later, but the scaling must clearly represent the `4/7` energy factor.

## What Will Be Swept
- `Eb/N0` or SNR values, following the Live Lab comparison range unless later refined.
- Monte Carlo trials per point, chosen large enough to stabilize BER estimates.

## Metrics To Collect
- uncoded BPSK theoretical BER
- original Hamming(7,4) BER before correction
- original Hamming(7,4) BER after correction
- fair-energy Hamming(7,4) BER after correction
- optionally fair-energy BER before correction if it helps explain the shift

## Comparison Set
- theoretical BPSK BER
- original Hamming(7,4) BER from the Live Lab style simulation
- fair-energy Hamming(7,4) BER

## Plots To Generate
- Primary BER plot:
  - theoretical BPSK BER
  - original Hamming(7,4) corrected BER
  - fair-energy Hamming(7,4) corrected BER
- Optional context plot:
  - original coded BER before correction
  - fair-energy coded BER before correction

## Expected Outcome
- The fair-energy Hamming(7,4) curve should perform worse than the original Hamming(7,4) Live Lab curve because the original coded case benefited from extra total transmit energy.
- The fair-energy result should still show the effect of coding and correction, but the advantage should be reduced.
- This change is expected because the assignment removes an energy advantage that was previously embedded in the coded transmission.

## Validation Checks
- Reproduce the original Live Lab Hamming(7,4) behavior first.
- Verify that the fair-energy case differs only in energy normalization, not in the encoder, channel model, or decoder logic.
- Check that the theoretical BPSK curve still matches the standard expression from the lab.
- Confirm that the fair-energy curve moves in the expected direction relative to the original coded result.

## Implementation Notes for MATLAB/Codex
- Start from the existing lab script rather than rewriting the simulation from scratch.
- Likely implementation structure:
  - one script for the full comparison
  - optional helper sections for:
    - original coded case
    - fair-energy coded case
    - theory curve generation
    - plotting
- Suggested future filenames:
  - `simulate_problem_2_2_fair_hamming.m`
  - `plot_problem_2_2_comparison.m`
  - or a single self-contained script if simplicity is preferred
- Keep the first implementation readable and close to the lab reference so the energy-scaling change is easy to audit.

## Interpretation Notes
- The report should explain that the earlier Hamming result was optimistic because it used more total packet energy.
- The fair-energy comparison answers a more meaningful engineering question:
  - what BER improvement remains when the coded system is not allowed extra total transmit energy for the same information payload?
