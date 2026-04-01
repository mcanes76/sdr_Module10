# Problem 2.1: ITU-T G.9959 Checksum PER Architecture

## Purpose
- Define the MATLAB architecture for Problem 2.1 of the Module 10 design challenge.
- Implement the ITU-T G.9959 odd longitudinal checksum used as a 1-byte parity check.
- Verify the checksum behavior with reversible and single-bit-error tests.
- Build a packet-error-rate simulation that compares detected PER against true PER.

## Requirement Summary
- A message contains `24 bytes = 192 bits` of payload.
- The checksum appends `8 parity bits = 1 byte` to the payload.
- The full packet is therefore `25 bytes = 200 bits`.
- The checksum is an odd longitudinal checksum:
  - one parity bit per bit position
  - parity is computed across all payload bytes in that bit column
  - parity is chosen so the full column across payload plus parity has odd parity
- The provided standard code shows the checksum can be computed byte-wise as:
  - initialize checksum to `0xFF`
  - XOR each payload byte into that accumulator
  - return the final checksum byte
- A packet error means any bit error anywhere in the transmitted 200-bit packet.
- Detection rule:
  - recompute the checksum over the received 25-byte packet
  - a correct packet should produce `0x00`
  - any nonzero result means the parity check detected an error

## Reference Interpretation
- Figure 1 shows the checksum as column-wise odd parity across bytes.
- Figure 2 shows the equivalent byte-wise implementation from the standard:

```c
BYTE CheckSum = 0xFF;
for (; Length > 0; Length--) {
    CheckSum ^= *Data++;
}
return CheckSum;
```

- Figure 3 states transmission is MSB first.
- Figure 4 labels byte bit positions as `7 6 5 4 3 2 1 0`.
- Important implementation note:
  - transmission order is MSB first
  - checksum formation is still equivalent to byte-wise XOR with `0xFF`
  - for MATLAB bit inspection, bit position `7` is the MSB and bit position `0` is the LSB within each byte

## Scope
- In scope:
  - checksum generation for a 24-byte payload
  - checksum verification on the 25-byte packet
  - reversibility and single-bit-error detection tests
  - PER simulation from `0 dB` to `6 dB` in `1 dB` steps
  - comparison of detected PER versus true PER
  - plot of absolute PER difference versus SNR
- Out of scope:
  - coding beyond this parity scheme
  - forward error correction
  - optimization beyond assignment-scale runtime

## Inputs

### Checksum Block
- Payload bytes as a `uint8` vector of length `24`.

### Verification Block
- Full packet bytes as a `uint8` vector of length `25`.

### Simulation Block
- SNR vector: `0:1:6` dB
- Number of packets per SNR: `10000`
- Random payload length: `24` bytes
- Packet length after parity append: `25` bytes

## Outputs

### Functional Outputs
- `checksumByte`: checksum for a 24-byte payload
- `packetBytes`: 25-byte payload-plus-checksum packet
- `checkValue`: checksum recomputed across the received 25-byte packet
- `isDetectedError`: true when `checkValue ~= 0`

### Simulation Outputs
- `perDetected`: detected packet error rate versus SNR
- `perTruth`: true packet error rate versus SNR
- `perDifference`: absolute difference between truth and detected PER

### Plot Outputs
- PER versus SNR plot showing:
  - detected PER
  - true PER
- difference plot showing:
  - `abs(perTruth - perDetected)` versus SNR

## Design Choice
- Use the byte-wise checksum formulation from the standard as the production implementation.
- Keep an optional bit-matrix debug view so the logic still maps cleanly to the odd-parity figure.
- Separate the project into:
  - checksum construction
  - packet verification
  - communication simulation
  - plotting/reporting

## Why This Choice
- The byte-wise XOR implementation is the direct standard representation.
- It is simpler and less error-prone than manually assembling per-column parity bits in the main path.
- A separate truth counter is necessary because this checksum does not detect all multi-bit error patterns.
- Modular separation makes it easy to verify Problem 2.1 before moving to later problems.

## Proposed File Layout
- `g9959_checksum.m`
  - compute checksum byte for payload bytes
- `append_g9959_checksum.m`
  - create a 25-byte packet from a 24-byte payload
- `check_g9959_packet.m`
  - recompute checksum over a received packet and return pass/fail
- `simulate_problem_2_1_per.m`
  - run the SNR sweep and collect truth/detected PER
- `run_problem_2_1_tests.m`
  - execute the assignment's two functional tests
- `ARCHITECTURE_2.1.md`
  - this design note

## Functional Decomposition

### 1. Checksum Generation
- Input: 24 payload bytes.
- Algorithm:
  1. Set accumulator to `uint8(255)`.
  2. XOR each payload byte into the accumulator.
  3. Return the accumulator as the checksum byte.
- Equivalent bit interpretation:
  - each checksum bit is the odd-parity completion bit for one column.

### 2. Packet Formation
- Input: payload bytes.
- Steps:
  1. Compute checksum byte from the payload.
  2. Append checksum byte to the end of the payload.
- Output: 25-byte packet.

### 3. Packet Verification
- Input: received 25-byte packet.
- Steps:
  1. Recompute the checksum across all 25 bytes.
  2. If the result is `0x00`, declare no detected error.
  3. If the result is nonzero, declare packet error detected.
- This directly matches the assignment's reversibility test.

### 4. Functional Test 1: Reversible Check
- Create a random 192-bit message.
- Form the checksum from the first 24 bytes.
- Append the checksum to make a 25-byte packet.
- Recompute checksum over the full 25-byte packet.
- Expected result:
  - returned check value must be `0x00`

### 5. Functional Test 2: Single-Bit Error Detection
- Create a random 192-bit message.
- Form checksum and append it.
- Flip any one bit in the 200-bit packet.
- Recompute checksum over the corrupted 25-byte packet.
- Expected result:
  - returned check value must be nonzero

### 6. PER Simulation
- For each SNR value from `0` to `6` dB:
  1. Generate `10000` random payloads of 24 bytes each.
  2. Compute and append the checksum.
  3. Modulate the 200 packet bits.
  4. Add noise at the selected SNR.
  5. Demodulate back to received bits.
  6. Compare transmitted and received packet bits to determine truth packet error.
  7. Re-pack received bits into 25 bytes.
  8. Recompute checksum over the received packet.
  9. Count detected packet errors using the nonzero check result.

## MATLAB Interface Proposal

```matlab
function checksumByte = g9959_checksum(dataBytes)
```

```matlab
function packetBytes = append_g9959_checksum(payloadBytes)
```

```matlab
function [isDetectedError, checkValue] = check_g9959_packet(packetBytes)
```

```matlab
function results = simulate_problem_2_1_per()
```

## Data Representation

### Byte Domain
- Public APIs should use `uint8` vectors.
- Payload size should be enforced as `24` bytes in assignment-facing functions.
- Packet size should be enforced as `25` bytes where appropriate.

### Bit Domain
- For modulation and truth tracking, convert bytes to a 200-bit vector.
- Transmission order within each byte should be MSB first to match Figure 3 and Figure 4.
- Recommended MATLAB conversions:
  - use `de2bi(..., 8, 'left-msb')` or equivalent logic for byte-to-bit conversion
  - use `bi2de(..., 'left-msb')` or equivalent logic for bit-to-byte conversion

## Channel / Modulation Architecture
- The assignment references the CRC-16 live-lab example for the communication simulation.
- The exact modulation should follow that live-lab template so results stay consistent with course expectations.
- Architecture assumption for this document:
  - use the same modulation, noise, and demodulation flow as the provided CRC-16 example
  - replace only the error-detection block with the G.9959 parity-check block

## Truth Data Definition
- `truthPacketError = true` if any received packet bit differs from the transmitted packet bit.
- This must be counted even if the parity check fails to detect it.
- Therefore:
  - detected PER measures what the checksum catches
  - true PER measures actual packet corruption
  - their difference quantifies undetected packet errors

## Metrics
- For each SNR:
  - `perTruth = truthErrorCount / 10000`
  - `perDetected = detectedErrorCount / 10000`
  - `perDifference = abs(perTruth - perDetected)`

## Assumptions
- The simulation uses the same modem chain as the CRC live-lab example.
- Random messages are independently generated for each packet.
- A 24-byte payload is the fixed packet payload size for Problem 2.1.
- The packet carries exactly one appended checksum byte.
- Received bits are grouped back into bytes using MSB-first ordering before checksum verification.

## Limitations / Risks
- This parity scheme detects all single-bit errors but not all multi-bit error patterns.
- Detected PER will therefore be less than or equal to true PER.
- A mismatch in bit ordering between byte packing and modem serialization will invalidate results.
- If the simulation chain differs from the course CRC example, PER curves may not match the expected figure style.

## Test Strategy

### Unit-Level Checksum Tests
- Verify `g9959_checksum` against hand-worked byte examples.
- Verify that the bit-column interpretation matches the byte-wise XOR result.

### Required Functional Tests
- Reversible packet test:
  - payload plus checksum must check to zero
- One-bit corruption test:
  - corrupted packet must check nonzero

### Simulation Validation
- Confirm for every SNR that:
  - `perDetected <= perTruth`
  - both rates lie in `[0, 1]`
- Sanity-check that higher SNR generally lowers both PER curves.

## Execution Plan
1. Implement `g9959_checksum.m` exactly as `0xFF XOR` reduction across bytes.
2. Implement `append_g9959_checksum.m` to create the 25-byte packet.
3. Implement `check_g9959_packet.m` so a valid packet returns check value `0`.
4. Implement `run_problem_2_1_tests.m` for the two required assignment checks.
5. Reuse the live-lab CRC simulation modem chain in `simulate_problem_2_1_per.m`.
6. Replace the CRC detector with the parity-check detector while preserving truth tracking.
7. Sweep `0:6` dB using `10000` packets per SNR.
8. Plot detected PER and true PER versus SNR.
9. Plot absolute difference versus SNR.

## Review Focus
- Confirm the live-lab modulation/demodulation block we should mirror.
- Confirm whether you want function names exactly as above or adapted to your existing naming style.
- Confirm whether you want the next step to be:
  - implement the checksum/test files first
  - or scaffold the full simulation pipeline as well
