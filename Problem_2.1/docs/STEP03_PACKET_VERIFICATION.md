# Step 3: Packet Verification

## Purpose
- Verify a received Homework 10 Problem 2.1 packet using the G.9959 checksum rule.

## Inputs
- `packetBytes`
  - exactly `25` bytes
  - payload plus appended checksum

## Outputs
- `isDetectedError`
  - true when the recomputed packet checksum is nonzero
- `checkValue`
  - checksum computed across the full received packet
- `debug`
  - intermediate checksum debug information from the checksum function

## Design Choice
- Reuse the same checksum function for both packet generation and packet verification.

## Why This Choice
- The assignment rule is simple:
  - a valid payload-plus-checksum packet must check to `0x00`
  - a nonzero result indicates a detected packet error
- Reusing the same checksum function keeps generation and verification consistent.

## MATLAB Implementation Notes
- Implemented in [`check_g9959_packet.m`](c:\REPO\sdr_Module10\Problem_2.1\check_g9959_packet.m).
- The function:
  - validates byte type and range
  - enforces the homework packet length of `25` bytes
  - converts the packet to a column vector of `uint8`
  - calls [`g9959_checksum.m`](c:\REPO\sdr_Module10\Problem_2.1\g9959_checksum.m) across the full packet
  - flags a detected error when `checkValue ~= uint8(0)`

## Expected Result
- A valid packet returns `checkValue = 0x00`.
- A corrupted packet should return a nonzero `checkValue`.

## Next Step
- Use the packet verification rule inside the PER simulation to count detected packet errors.
