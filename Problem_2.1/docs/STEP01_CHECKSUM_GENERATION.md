# Step 1: Checksum Generation

## Purpose
- Implement the ITU-T G.9959 odd longitudinal checksum for a payload of bytes.
- Keep the production MATLAB path aligned to the standard code.
- Expose debug information that also matches the bit-column parity explanation from the homework figures.

## Inputs
- `dataBytes`
  - numeric, logical, row, or column input convertible to `uint8`
  - expected assignment payload size is `24` bytes, but the checksum function accepts any byte-vector length for reuse and testing

## Outputs
- `checksumByte`
  - the checksum byte computed as `0xFF XOR` all payload bytes
- `debug`
  - `bitMatrixMsbFirst`
  - `columnXorMsbFirst`
  - `checksumBitsMsbFirst`
  - `checksumHex`
  - `checksumFromBitColumns`

## Design Choice
- Use byte-wise XOR reduction as the main implementation.
- Reconstruct the same checksum from bit columns in debug logic only.

## Why This Choice
- The byte-wise form is exactly what the standard code implements.
- It is compact, fast, and less error-prone than building parity bit-by-bit in the main path.
- The debug reconstruction gives us confidence that the MATLAB implementation still matches the assignment figure.

## MATLAB Implementation Notes
- Implemented in [`g9959_checksum.m`](c:\REPO\sdr_Module10\Problem_2.1\g9959_checksum.m).
- Uses:
  - `bitxor` for the production checksum accumulator
  - `bitget` and `bitset` for the debug bit-column reconstruction
- Bit-column debug output is ordered as `[7 6 5 4 3 2 1 0]` to match the figure.

## Testbench
- Implemented in [`tb_g9959_checksum.m`](c:\REPO\sdr_Module10\Problem_2.1\testbenches\tb_g9959_checksum.m).
- The testbench covers:
  - the homework figure example with expected checksum `0xAA`
  - a deterministic regression vector
  - a random 24-byte cross-check

## Expected Result
- The checksum from the homework figure should evaluate to `0xAA`.
- The byte-wise XOR reduction and the bit-column reconstruction should always match.

## Next Step
- After checksum generation is validated, Step 2 is packet formation:
  - append the checksum byte to the 24-byte payload to create a 25-byte packet
