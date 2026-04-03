# Step 01 Baseline Review Report

## Purpose

This report documents the baseline Hamming(7,4) correction simulation used as the architectural reference for Homework 10 Problem 2.2. The goal of Step 01 is to reproduce the Live Lab behavior before introducing any fair-energy scaling.

## Baseline Reference

The baseline architecture is taken from [`hamming_correction_awgn_simulation.m`](c:\REPO\sdr_Module10\Lab10_scripts\hamming_correction_awgn_simulation.m). That simulation uses:

1. random 4-bit data generation
2. Hamming(7,4) encoding
3. BPSK modulation
4. AWGN channel
5. hard-decision demodulation
6. syndrome computation
7. single-error correction using the syndrome table
8. BER measurement before and after correction

## What Was Reproduced

A local review script was created to mirror the Live Lab baseline while exporting reusable results for documentation:

- [`baseline_review_hamming74.m`](c:\REPO\sdr_Module10\Problem_2.2\baseline_review_hamming74.m)

The script preserves the same main simulation structure and generates:

- a BER figure
- a CSV table of BER values
- a MATLAB `.mat` result file

## Baseline Figure

Figure 1 shows the reproduced baseline BER comparison.

![Baseline Hamming(7,4) BER](docs/figures/step01_baseline_hamming74_ber.png)

## Baseline Results

The exported numerical results are stored here:

- [`step01_baseline_hamming74_results.csv`](c:\REPO\sdr_Module10\Problem_2.2\docs\figures\step01_baseline_hamming74_results.csv)
- [`step01_baseline_hamming74_results.mat`](c:\REPO\sdr_Module10\Problem_2.2\docs\figures\step01_baseline_hamming74_results.mat)

The baseline comparison includes:

- corrected Hamming(7,4) BER
- uncorrected coded BER
- theoretical uncoded BPSK BER

Selected reproduced values are:

| Eb/N0 (dB) | Corrected BER | Uncorrected BER | BPSK Theory |
| --- | ---: | ---: | ---: |
| 0 | 0.04399 | 0.07892 | 0.07865 |
| 3 | 0.00437 | 0.02303 | 0.02288 |
| 6 | 0.00006 | 0.00234 | 0.00239 |

## Interpretation

The reproduced baseline shows the same qualitative behavior expected from the Live Lab:

- the corrected Hamming(7,4) result is better than the uncorrected coded result
- the uncorrected coded BER closely tracks the theoretical uncoded BPSK BER
- the corrected Hamming(7,4) curve shows a strong apparent improvement over both

However, this baseline is not yet the fair comparison required by Homework 10 Problem 2.2. In the baseline configuration, the coded system transmits 7 coded bits to represent 4 information bits while keeping the transmitted coded-bit energy unchanged. That means the coded transmission uses more total energy per information payload than the uncoded reference.

This point matters because part of the apparent BER advantage comes from the added redundancy and part comes from spending more total energy.

## Why Step 01 Matters

Step 01 establishes the exact baseline that Problem 2.2 will modify. By reproducing the original Hamming(7,4) correction simulation first, we create a clean reference for the next step:

- keep the encoder, channel, demodulator, and syndrome correction logic the same
- change only the coded energy scaling to create a fairer comparison

## Main Takeaway

The baseline review confirms that the original Live Lab Hamming(7,4) simulation provides the correct starting point for Problem 2.2. The next task is not to redesign the coding chain, but to normalize the coded energy so the final BER comparison is fair on an information-bit energy basis.
