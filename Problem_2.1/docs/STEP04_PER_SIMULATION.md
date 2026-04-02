# Step 4: PER Simulation

## Purpose
- Simulate packet error rate for Homework 10 Problem 2.1 using the G.9959 checksum as the packet-error detector.

## Workflow
- The simulation follows the lab architecture exactly:
  1. payload
  2. append checksum
  3. packet bits
  4. BPSK
  5. AWGN
  6. demod
  7. packet reconstruction
  8. checksum verification

## Inputs
- random `24`-byte payloads
- SNR range `0:1:6` dB
- `10000` packets per SNR for the full homework run

## Outputs
- `perTruth`
  - true packet error rate
- `perDetected`
  - packet error rate detected by the checksum
- `perDifference`
  - absolute difference between truth and detected PER

## Design Choice
- Reuse the same BPSK/AWGN/demod structure as the Live Lab reference script.
- Replace only the CRC detector with the G.9959 checksum functions developed for Problem 2.1.

## Why This Choice
- It keeps the simulation aligned with the lab architecture.
- It isolates the comparison to the error-detection method rather than changing the communication chain.

## MATLAB Implementation Notes
- Implemented in [`simulate_problem_2_1_per.m`](c:\REPO\sdr_Module10\Problem_2.1\simulate_problem_2_1_per.m).
- Supporting utilities:
  - [`append_g9959_checksum.m`](c:\REPO\sdr_Module10\Problem_2.1\append_g9959_checksum.m)
  - [`check_g9959_packet.m`](c:\REPO\sdr_Module10\Problem_2.1\check_g9959_packet.m)
  - [`bytes_to_bits.m`](c:\REPO\sdr_Module10\Problem_2.1\bytes_to_bits.m)
  - [`bits_to_bytes.m`](c:\REPO\sdr_Module10\Problem_2.1\bits_to_bytes.m)
- The script also supports optional overrides for quick validation runs:
  - `snrVecOverride`
  - `numFramesOverride`
  - `rngSeedOverride`
  - `makePlotsOverride`

## Expected Result
- `perDetected` should be less than or equal to `perTruth`.
- Both curves should generally decrease as SNR increases.
- The difference curve represents undetected packet errors.

## Report Notes
- This step demonstrates that the checksum can detect many packet errors, but not all multi-bit error patterns.
- The gap between true PER and detected PER quantifies the checksum’s detection limitation.
