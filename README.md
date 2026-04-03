# SDR Module 10

## Overview

This repository contains the design and implementation work for Module 10.

The homework work is currently organized under:

- [`Problem_2.1`](c:\REPO\sdr_Module10\Problem_2.1)
- [`Problem_2.2`](c:\REPO\sdr_Module10\Problem_2.2)
- [`Problem_2.3`](c:\REPO\sdr_Module10\Problem_2.3)

## References

- [`Homework_10.pdf`](c:\REPO\sdr_Module10\Homework_10.pdf)
- [`SDR Live Lab 10.pdf`](c:\REPO\sdr_Module10\SDR Live Lab 10.pdf)
- [`Lab10_scripts`](c:\REPO\sdr_Module10\Lab10_scripts)

## Problem 2.1

Problem 2.1 implements the ITU-T G.9959 checksum, packet formation and verification, and a PER simulation over BPSK/AWGN.

- [`Problem_2.1/ARCHITECTURE_2.1.md`](c:\REPO\sdr_Module10\Problem_2.1\ARCHITECTURE_2.1.md)
- [`Problem_2.1/README.md`](c:\REPO\sdr_Module10\Problem_2.1\README.md)
- [`Problem_2.1/REPORT_2.1.md`](c:\REPO\sdr_Module10\Problem_2.1\REPORT_2.1.md)

Run the required functional tests:

```matlab
cd('c:/REPO/sdr_Module10/Problem_2.1')
run('run_problem_2_1_tests.m')
```

Run the full PER simulation:

```matlab
cd('c:/REPO/sdr_Module10/Problem_2.1')
run('simulate_problem_2_1_per.m')
```

Run a short override-based debug simulation:

```matlab
cd('c:/REPO/sdr_Module10/Problem_2.1')
snrVecOverride = 0:1;
numFramesOverride = 20;
makePlotsOverride = false;
run('simulate_problem_2_1_per.m')
```

## Problem 2.2

Problem 2.2 compares the original Live Lab Hamming(7,4) BER result against a fair-energy version that scales coded amplitude by `sqrt(4/7)`.

- [`Problem_2.2/ARCHITECTURE_2.2.md`](c:\REPO\sdr_Module10\Problem_2.2\ARCHITECTURE_2.2.md)
- [`Problem_2.2/SIMULATION_PLAN_2.2.md`](c:\REPO\sdr_Module10\Problem_2.2\SIMULATION_PLAN_2.2.md)
- [`Problem_2.2/STEP01_BASELINE_REPORT.md`](c:\REPO\sdr_Module10\Problem_2.2\STEP01_BASELINE_REPORT.md)
- [`Problem_2.2/STEP02_FAIR_ENERGY_METHOD.md`](c:\REPO\sdr_Module10\Problem_2.2\STEP02_FAIR_ENERGY_METHOD.md)
- [`Problem_2.2/STEP03_COMPARISON_REPORT.md`](c:\REPO\sdr_Module10\Problem_2.2\STEP03_COMPARISON_REPORT.md)

Reproduce the accepted baseline review:

```matlab
cd('c:/REPO/sdr_Module10/Problem_2.2')
run('baseline_review_hamming74.m')
```

Run the fair-energy comparison:

```matlab
cd('c:/REPO/sdr_Module10/Problem_2.2')
run('simulate_problem_2_2_fair_hamming.m')
```

## Problem 2.3

Problem 2.3 compares hard-decision and soft-decision Hamming(7,4) decoding using correlation against the 16 valid codewords.

- [`Problem_2.3/ARCHITECTURE_2.3.md`](c:\REPO\sdr_Module10\Problem_2.3\ARCHITECTURE_2.3.md)
- [`Problem_2.3/SIMULATION_PLAN_2.3.md`](c:\REPO\sdr_Module10\Problem_2.3\SIMULATION_PLAN_2.3.md)
- [`Problem_2.3/build_hamming74_codeword_table.m`](c:\REPO\sdr_Module10\Problem_2.3\build_hamming74_codeword_table.m)
- [`Problem_2.3/decode_hamming74_soft_correlation.m`](c:\REPO\sdr_Module10\Problem_2.3\decode_hamming74_soft_correlation.m)
- [`Problem_2.3/simulate_problem_2_3_soft_decoding.m`](c:\REPO\sdr_Module10\Problem_2.3\simulate_problem_2_3_soft_decoding.m)

Inspect or test the codeword table function:

```matlab
cd('c:/REPO/sdr_Module10/Problem_2.3')
[codewordsBits, codewordsBpsk] = build_hamming74_codeword_table()
```

Run the soft-vs-hard BER simulation:

```matlab
cd('c:/REPO/sdr_Module10/Problem_2.3')
run('simulate_problem_2_3_soft_decoding.m')
```

## Notes

- Open MATLAB in the problem folder before running scripts when possible.
- Problem 2.1 uses override variables in the workspace for quick simulation runs.
- Problems 2.2 and 2.3 save figures and result files from their simulation scripts.
