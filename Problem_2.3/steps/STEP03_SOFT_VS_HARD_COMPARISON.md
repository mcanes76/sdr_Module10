# Step 3: Soft vs Hard Comparison

## Purpose
- Compare BER for hard-decision and soft-decision Hamming(7,4) decoding.

## Inputs
- hard-decoded 7-bit outputs from the baseline method
- soft-decoded 7-bit outputs from the correlation method
- known truth 7-bit codeword bits

## Outputs
- BER versus `Eb/N0` for:
  - hard decoding
  - soft decoding

## Algorithm Idea
- Compare each hard-decoded codeword to the known truth bits and count bit errors.
- Compare each soft-decoded codeword to the known truth bits and count bit errors.
- Accumulate BER across the Monte Carlo sweep.
- Plot both BER curves on the same axis.

## Acceptance Criteria
- BER is computed against the known truth codeword bits consistently for both methods
- the plot clearly shows hard versus soft decoding
- soft decoding yields lower BER than hard decoding versus `Eb/N0`
