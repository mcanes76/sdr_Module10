# Simulation Plan

## Goal
- Simulate packet error rate for Homework 10 Problem 2.1 using the G.9959 checksum as the packet-error detector.

## Target Workflow
- The simulation should follow the lab architecture exactly:
  1. payload
  2. append checksum
  3. packet bits
  4. BPSK
  5. AWGN
  6. demod
  7. packet reconstruction
  8. checksum verification

## Simulation Requirements
- SNR range: `0:1:6` dB
- Packets per SNR: `10000`
- Payload size: `24` bytes
- Packet size: `25` bytes after checksum append

## Per-Packet Flow
1. Generate a random 24-byte payload.
2. Form the 25-byte packet with [`append_g9959_checksum.m`](c:\REPO\sdr_Module10\Problem_2.1\append_g9959_checksum.m).
3. Convert packet bytes to a 200-bit vector using MSB-first ordering.
4. Apply BPSK modulation using the lab reference flow from `Lab10_scripts`.
5. Add AWGN at the selected SNR.
6. Demodulate the noisy symbols back to received bits.
7. Count a truth packet error if any received bit differs from the transmitted bit.
8. Convert the received bits back to 25 bytes.
9. Verify the received packet with [`check_g9959_packet.m`](c:\REPO\sdr_Module10\Problem_2.1\check_g9959_packet.m).
10. Count a detected packet error if the check value is nonzero.

## Metrics
- `perTruth`
  - actual fraction of corrupted packets
- `perDetected`
  - fraction of packets flagged by the checksum
- `perDifference`
  - `abs(perTruth - perDetected)`

## Expected Behavior
- `perDetected` should never exceed `perTruth`.
- Both PER curves should generally decrease as SNR increases.
- The difference curve represents undetected packet errors.

## Planned Outputs
- Plot 1:
  - detected PER and true PER versus SNR
- Plot 2:
  - absolute PER difference versus SNR

## Implementation Notes
- Keep the first simulation version simple and readable.
- Separate helper steps if needed for:
  - byte-to-bit conversion
  - bit-to-byte conversion
  - BPSK modulation
  - hard-decision demodulation
  - truth error counting
  - plotting
- Use the `Lab10_scripts` folder as the source of truth for the modulation and demodulation structure.

## Ready-For-Code Checklist
- checksum generation is implemented
- packet formation is implemented
- packet verification is implemented
- functional tests pass
- lab-reference BPSK modulation/demodulation scripts still need to be imported from `Lab10_scripts`
