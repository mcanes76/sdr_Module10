# Problem 2.3 Simulation Plan

## Goal
- Build a Monte Carlo BER simulation for Homework 10 Problem 2.3 that compares hard-decision and soft-decision decoding for Hamming(7,4).

## Baseline Reference
- The starting point is the Live Lab Hamming(7,4) correction simulation.
- That baseline already provides:
  - random 4-bit input generation
  - Hamming(7,4) encoding
  - BPSK modulation
  - AWGN channel
  - hard-decision demodulation
  - Hamming decoding
  - BER measurement

## Monte Carlo Flow
1. Choose the `Eb/N0` sweep for the simulation.
2. For each `Eb/N0` value, generate many random 4-bit data blocks.
3. Encode each block into a 7-bit Hamming(7,4) codeword.
4. BPSK modulate the 7 coded bits.
5. Pass the symbols through AWGN.
6. Process the received symbols through the hard-decision path:
   - hard-demodulate the received symbols
   - decode using the existing Hamming baseline method
   - compare decoded bits to known truth bits
7. Process the same received symbols through the soft-decision path:
   - break the synchronized received waveform into 7-symbol vectors
   - use only the real part of each 7-symbol vector
   - correlate the vector against all 16 valid Hamming(7,4) codewords in `-1/+1` form
   - select the codeword with maximum correlation
   - compare the selected codeword bits to known truth bits
8. Record BER for both decoding methods.
9. Generate the comparison figure and summary tables.

## Codeword Table
- The soft decoder requires a table of the 16 valid Hamming(7,4) codewords.
- Each codeword should be stored in:
  - binary bit form
  - BPSK-like form with `0 -> -1` and `1 -> +1`
- This table is fixed once the Hamming generator matrix is chosen.

## Soft-Decision Rule
- Each received 7-symbol segment is correlated against all 16 valid codewords.
- Only the real part of the synchronized BPSK segment is used.
- The selected codeword is the one with the maximum correlation.
- Absolute value is not used.

## What Will Be Swept
- `Eb/N0` or SNR values, following the Live Lab comparison style unless refined later.
- Monte Carlo trials per point, chosen large enough to stabilize BER curves.

## Metrics To Collect
- hard-decision Hamming(7,4) BER
- soft-decision Hamming(7,4) BER
- theoretical uncoded BPSK BER if included for reference

## Comparison Set
- hard-decision Hamming(7,4) BER
- soft-decision Hamming(7,4) BER
- theoretical uncoded BPSK BER if useful for reference

## Plots To Generate
- Primary BER plot:
  - hard-decision Hamming(7,4)
  - soft-decision Hamming(7,4)
  - theoretical uncoded BPSK BER if included

## Expected Outcome
- Soft decoding should outperform hard decoding because it preserves confidence information from the received waveform samples.
- Hard decoding throws away that information by making an immediate binary decision for each symbol.
- The advantage of soft decoding should appear as a lower BER curve versus `Eb/N0`.

## Validation Checks
- Verify that the hard-decision BER reproduces the expected baseline trend.
- Verify that the codeword table contains exactly 16 valid codewords.
- Check that the soft decoder selects the correct codeword on noise-free or high-SNR trials.
- Confirm that the soft-decision BER is lower than the hard-decision BER over the sweep.

## Implementation Notes for MATLAB/Codex
- Suggested future scripts or functions:
  - `build_hamming74_codeword_table.m`
  - `decode_hamming74_soft_correlation.m`
  - `simulate_problem_2_3_soft_decoding.m`
- A single self-contained script is acceptable if it stays readable.
- Keep the hard-decision path close to the Live Lab architecture.
- The soft path should reuse the same transmitted and received symbols so the comparison is controlled.
