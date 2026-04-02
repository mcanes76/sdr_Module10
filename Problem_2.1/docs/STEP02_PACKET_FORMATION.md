# Step 2: Packet Formation

## Purpose
- Form the Homework 10 Problem 2.1 packet by appending the G.9959 checksum byte to the 24-byte payload.

## Inputs
- `payloadBytes`
  - exactly `24` bytes
  - numeric or logical input convertible to `uint8`

## Outputs
- `packetBytes`
  - `25x1 uint8` vector
  - payload followed by checksum byte
- `checksumByte`
  - checksum computed from the payload
- `debug`
  - checksum debug information plus `packetBytes`

## Design Choice
- Keep packet formation as a separate function from checksum generation.

## Why This Choice
- It makes the transmitter-side workflow explicit:
  - start with payload
  - compute checksum
  - append checksum
- It also keeps later verification and simulation code cleaner.

## MATLAB Implementation Notes
- Implemented in [`append_g9959_checksum.m`](c:\REPO\sdr_Module10\Problem_2.1\append_g9959_checksum.m).
- The function:
  - validates byte type and range
  - enforces the homework payload length of `24` bytes
  - converts the payload to a column vector of `uint8`
  - calls [`g9959_checksum.m`](c:\REPO\sdr_Module10\Problem_2.1\g9959_checksum.m)
  - appends the checksum byte to produce the 25-byte packet

## Expected Result
- A valid 24-byte payload becomes a 25-byte packet with the checksum in the last byte.

## Next Step
- Verify that the full 25-byte packet checks to zero when the checksum is recomputed over the entire packet.
