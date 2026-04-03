# Step 03 Comparison Report

## Purpose

This step executes the fair-energy Hamming(7,4) simulation and compares:

- theoretical uncoded BPSK BER
- original Hamming(7,4) corrected BER
- fair-energy Hamming(7,4) corrected BER

## Simulation Outputs

The simulation generated these files:

- [`problem_2_2_fair_hamming_ber.png`](c:\REPO\sdr_Module10\Problem_2.2\docs\figures\problem_2_2_fair_hamming_ber.png)
- [`problem_2_2_fair_hamming_results.csv`](c:\REPO\sdr_Module10\Problem_2.2\docs\figures\problem_2_2_fair_hamming_results.csv)
- [`problem_2_2_fair_hamming_results.mat`](c:\REPO\sdr_Module10\Problem_2.2\docs\figures\problem_2_2_fair_hamming_results.mat)

## BER Comparison Figure

![Problem 2.2 Fair Hamming BER Comparison](docs/figures/problem_2_2_fair_hamming_ber.png)

## Numerical Results

| Eb/N0 (dB) | Original Hamming(7,4) | Fair-Energy Hamming(7,4) | BPSK Theory |
| --- | ---: | ---: | ---: |
| 0 | 0.04399 | 0.12037 | 0.07865 |
| 1 | 0.02416 | 0.08492 | 0.05628 |
| 2 | 0.01131 | 0.05454 | 0.03751 |
| 3 | 0.00437 | 0.03255 | 0.02288 |
| 4 | 0.00121 | 0.01586 | 0.01250 |
| 5 | 0.00034 | 0.00701 | 0.00595 |
| 6 | 0.00006 | 0.00238 | 0.00239 |

## What Changed

The fair-energy Hamming(7,4) curve shifted upward relative to the original Hamming(7,4) curve across the full simulated `Eb/N0` range.

The BER advantage also decreased compared with the original Live Lab result. For example:

- at `3 dB`, the original corrected BER is `0.00437`, while the fair-energy corrected BER is `0.03255`
- at `6 dB`, the original corrected BER is `0.00006`, while the fair-energy corrected BER is `0.00238`

## Why It Changed

The original Hamming(7,4) baseline transmitted `7` coded bits for every `4` information bits while keeping coded-bit energy unchanged.

That gave the original coded case `7/4` times more total energy per information block.

The fair-energy simulation reduced coded symbol energy by `4/7` by scaling the transmitted coded amplitude by `sqrt(4/7)`.

This removed the extra energy advantage and made the comparison fairer.

The remaining improvement is therefore a more honest measure of coding gain.

## Comparison Against Theoretical BPSK

The fair-energy Hamming(7,4) result is worse than uncoded BPSK theory at low and moderate `Eb/N0` values in this simulation. At the high end of the simulated range, the fair-energy curve approaches the theoretical BPSK curve closely. For example, at `6 dB`, the fair-energy BER is `0.00238` and the BPSK theory value is `0.00239`.

This means coding still provides a structured correction mechanism, but the dramatic advantage seen in the original baseline becomes much smaller once the extra transmit energy is removed from the comparison.

## Main Takeaway

The original result mixed coding gain with extra transmit energy.

The fair-energy result isolates coding gain more honestly, and it shows that much of the earlier BER improvement came from spending more total energy on the coded transmission.
