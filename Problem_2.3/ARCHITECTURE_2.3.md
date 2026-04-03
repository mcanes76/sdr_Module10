# Problem 2.3: Soft Decoding Architecture

## Purpose
- Define the design for Homework 10 Problem 2.3, which compares hard decoding and soft decoding for Hamming(7,4) over a BPSK AWGN channel.
- Preserve the Live Lab Hamming(7,4) simulation as the hard-decision baseline.
- Add a soft-decision decoding path that uses received waveform samples before symbol thresholding.

## Engineering Motivation
- The hard decoder used in the Live Lab makes symbol-by-symbol hard decisions before decoding.
- That approach keeps only binary decisions and throws away confidence information contained in the received waveform.
- The soft decoder for this problem keeps the received sample values long enough to compare each 7-symbol segment against all valid Hamming(7,4) codewords.
- In practical communication systems, this often improves error-rate performance because weak and strong decisions are not treated as equally reliable.

## Core Interpretation of the Problem
- Hamming(7,4) maps `4` input bits into `7` coded bits.
- Because there are `2^4 = 16` possible 4-bit inputs, there are only `16` valid 7-bit codewords.
- Problem 2.3 uses those 16 valid codewords in two representations:
  - bit form, using `0` and `1`
  - BPSK-like form, using `-1` and `+1`, where `0 -> -1` and `1 -> +1`
- The soft decoder will compare each received 7-symbol segment against all 16 valid codewords and select the one with the maximum correlation.

## Hard-Decision Baseline
- The hard-decision path should remain consistent with the Live Lab Hamming(7,4) correction simulation:
  1. generate 4 random data bits
  2. encode to a 7-bit codeword
  3. BPSK modulate
  4. add AWGN
  5. hard-demodulate each symbol
  6. decode using the existing Hamming decision path
  7. compute BER against known truth bits

## Soft-Decision Path
- The soft decoder uses the received waveform samples directly before hard thresholding.
- The received BPSK stream is segmented into synchronized 7-symbol groups.
- Only the real part of each received 7-symbol segment is used.
- Each segment is correlated against the 16 valid Hamming(7,4) codewords represented in `-1/+1` form.
- The decoder selects the codeword with the maximum correlation.
- Absolute value is not used in the correlation decision.

## Problem 2.3 Workflow
1. generate random 4-bit data blocks
2. encode with Hamming(7,4)
3. BPSK modulate the 7 coded bits
4. apply AWGN
5. process the received waveform through:
   - hard-decision decoding path
   - soft-decision correlation path
6. compare both decoded outputs to the known truth codeword bits
7. measure BER versus `Eb/N0`
8. compare hard and soft decoding performance

## Inputs
- `Eb/N0` or SNR sweep consistent with the Live Lab Hamming simulation
- random 4-bit input words
- Hamming(7,4) generator and parity-check matrices
- synchronized received BPSK waveform segments of length `7`

## Outputs
- hard-decision Hamming(7,4) BER
- soft-decision Hamming(7,4) BER
- optionally theoretical uncoded BPSK BER as a reference curve
- a comparison plot showing BER versus `Eb/N0`

## Codeword Table Concept
- The implementation will need a table of the 16 valid Hamming(7,4) codewords.
- Each table row should store:
  - the 7-bit codeword in binary form
  - the corresponding BPSK-like form with `0 -> -1` and `1 -> +1`
- This table is the reference set used by the soft decoder.

## Expected Plots and Comparisons
- A primary BER comparison figure should include:
  - hard-decision Hamming(7,4) BER
  - soft-decision Hamming(7,4) BER
  - theoretical uncoded BPSK BER if used as a baseline reference
- The main comparison should show whether soft decoding lowers BER relative to hard decoding across the simulated `Eb/N0` range.

## Assumptions
- The BPSK signal is synchronized, so the received symbols can be grouped directly into 7-symbol segments.
- Only the real component of the synchronized BPSK signal is needed for soft decoding.
- The Hamming(7,4) encoder definition remains the same as in the Live Lab.
- The hard-decision baseline remains the existing lab-style architecture and is not redesigned.

## Risks
- If the codeword table is generated in an inconsistent bit order, the soft decoder will choose the wrong codewords.
- If the received waveform is segmented incorrectly, the correlation decisions will be invalid.
- If absolute value is mistakenly used, the decoder may select the wrong codeword because sign information is essential.
- If the BER comparison mixes codeword-level and bit-level metrics, the final interpretation may be misleading.

## Validation Strategy
- Verify that exactly 16 valid Hamming(7,4) codewords are generated.
- Check that the `-1/+1` codeword table matches the binary codeword table exactly under the mapping `0 -> -1`, `1 -> +1`.
- Confirm that the soft decoder chooses the correct codeword on clean or very high-SNR examples.
- Confirm that the hard-decision path reproduces the baseline Hamming behavior.
- Check that soft-decoding BER is lower than hard-decoding BER over the simulated range.

## Proposed File Layout
- `ARCHITECTURE_2.3.md`
  - this design document
- `SIMULATION_PLAN_2.3.md`
  - Monte Carlo simulation plan
- `steps/STEP01_CODEWORD_TABLE.md`
  - codeword-table generation plan
- `steps/STEP02_SOFT_DECODER_METHOD.md`
  - correlation decoder plan
- `steps/STEP03_SOFT_VS_HARD_COMPARISON.md`
  - BER comparison plan

## Review Focus
- Confirm the exact hard-decision baseline to reuse from the Live Lab structure.
- Confirm whether the final comparison should include uncoded BPSK theory on the same plot or keep the plot focused on hard versus soft decoding.
- Confirm that the BER metric should be reported against the 7-bit codeword truth sequence rather than only the 4-bit information words.
