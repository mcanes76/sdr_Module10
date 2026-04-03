# Step 1: Codeword Table

## Purpose
- Generate the 16 valid Hamming(7,4) codewords needed for soft decoding.

## Inputs
- Hamming(7,4) generator matrix
- all 16 possible 4-bit input words

## Outputs
- a table of 16 valid 7-bit codewords in binary form
- a corresponding table in BPSK-like form with `0 -> -1` and `1 -> +1`

## Algorithm Idea
- Enumerate all 16 possible 4-bit inputs.
- Encode each input into a 7-bit Hamming codeword.
- Store the binary codeword and its `-1/+1` mapped version.

## Acceptance Criteria
- exactly 16 unique valid codewords are generated
- each binary codeword has a matching `-1/+1` representation
- the bit order is documented and consistent with the Hamming encoder used in the simulation
