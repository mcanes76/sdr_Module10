# Step 2: Soft Decoder Method

## Purpose
- Define the correlation-based soft decoder for synchronized Hamming(7,4) BPSK codewords.

## Inputs
- synchronized received BPSK waveform
- 16 valid Hamming(7,4) codewords in `-1/+1` form

## Outputs
- selected 7-bit codeword for each received 7-symbol segment

## Algorithm Idea
- Break the received waveform into length-7 symbol vectors.
- Use only the real part of each segment.
- Correlate each 7-symbol segment against all 16 valid codewords.
- Select the codeword with the maximum correlation.
- Do not use absolute value.

## Expected Intermediate Checks
- each segment has length 7
- the correlation vector has 16 entries
- the selected codeword index matches the largest correlation value

## Acceptance Criteria
- the decoder chooses the correct codeword on clean or high-SNR trials
- the implementation uses maximum correlation directly
- absolute value is not used in the decision rule
