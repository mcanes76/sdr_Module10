# Problem 2.1 Report

## Overview

Problem 2.1 implements the ITU-T G.9959 odd longitudinal checksum and uses it as a packet-error detector in a BPSK/AWGN simulation.

The completed workflow is:

1. generate a random 24-byte payload
2. compute and append the 1-byte checksum
3. convert the 25-byte packet to a 200-bit stream
4. modulate the packet using BPSK
5. pass the signal through an AWGN channel
6. demodulate the received signal
7. reconstruct the received packet bytes
8. verify the packet using the checksum

## Checksum Method

The checksum follows the ITU-T G.9959 odd longitudinal checksum rule.

- The payload contains `24 bytes = 192 bits`.
- One checksum byte is appended to form a `25-byte = 200-bit` packet.
- The checksum is computed as:

```text
CheckSum = 0xFF XOR byte_1 XOR byte_2 XOR ... XOR byte_24
```

- A valid received packet should produce a recomputed check value of `0x00` when the checksum is applied across all 25 bytes.

## Implemented Files

- [`g9959_checksum.m`](c:\REPO\sdr_Module10\Problem_2.1\g9959_checksum.m)
  - computes the checksum byte
- [`append_g9959_checksum.m`](c:\REPO\sdr_Module10\Problem_2.1\append_g9959_checksum.m)
  - appends the checksum to the 24-byte payload
- [`check_g9959_packet.m`](c:\REPO\sdr_Module10\Problem_2.1\check_g9959_packet.m)
  - verifies the received 25-byte packet
- [`bytes_to_bits.m`](c:\REPO\sdr_Module10\Problem_2.1\bytes_to_bits.m)
  - converts bytes to an MSB-first bit stream
- [`bits_to_bytes.m`](c:\REPO\sdr_Module10\Problem_2.1\bits_to_bytes.m)
  - reconstructs bytes from the received bit stream
- [`run_problem_2_1_tests.m`](c:\REPO\sdr_Module10\Problem_2.1\run_problem_2_1_tests.m)
  - performs the required functional tests
- [`simulate_problem_2_1_per.m`](c:\REPO\sdr_Module10\Problem_2.1\simulate_problem_2_1_per.m)
  - runs the PER simulation

## Functional Verification

Two required checks were implemented and verified:

1. Reversible packet check
- A random 24-byte payload is generated.
- The checksum is appended.
- Recomputing the checksum over the full 25-byte packet returns `0x00`.

2. Single-bit error detection
- A random 24-byte payload is generated.
- The checksum is appended.
- One random bit in the 200-bit packet is flipped.
- Recomputing the checksum over the corrupted packet returns a nonzero value.

These tests confirm correct packet formation and basic checksum detection behavior.

## Simulation Structure

The PER simulation follows the same general structure as the live-lab CRC example, but replaces the CRC block with the G.9959 checksum functions.

For each SNR value:

1. generate `10000` random payloads
2. append the checksum
3. convert the packet to bits
4. apply BPSK modulation
5. add AWGN
6. demodulate the received signal
7. compare transmitted and received bits for truth data
8. reconstruct the packet bytes
9. verify the packet with the checksum

The simulation records:

- `PER_truth`
- `PER_detected`
- `PER_difference = abs(PER_truth - PER_detected)`

## Interpretation

`PER_truth` represents the true packet error probability caused by the AWGN channel.

`PER_detected` represents the fraction of packets flagged as erroneous by the checksum.

The difference between these curves corresponds to undetected packet errors.

These errors occur when channel noise alters packet bits but the resulting packet still satisfies the checksum condition.

The simulation shows that simple additive checksums provide limited error detection capability.

## Discussion

The checksum reliably detects all single-bit errors, but it does not detect every possible multi-bit error pattern. Because of that limitation, the detected PER is expected to be lower than the true PER. As SNR increases, both PER curves should generally decrease, but a nonzero gap may remain because some corrupted packets still pass the checksum test.

This behavior is consistent with the purpose of the assignment: to compare actual packet corruption against what a lightweight detection rule can observe.

## Conclusion

Problem 2.1 was implemented successfully using the required checksum architecture. The payload, packet formation, verification path, and PER simulation are all in place. The final result demonstrates how the G.9959 checksum can detect many transmission errors while still allowing some corrupted packets to go undetected.
