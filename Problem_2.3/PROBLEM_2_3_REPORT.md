# Problem 2.3 - Soft vs Hard Hamming(7,4) Decoding

## Objective

This experiment compares hard-decision and soft-decision decoding for Hamming(7,4) over an AWGN channel. The goal is to evaluate BER performance and determine the coding gain obtained by soft decoding.

Hamming(7,4) encodes 4 data bits into a 7-bit codeword by adding 3 parity bits. In this problem, the same coded transmission is decoded in two different ways so the effect of the decoder decision rule can be observed directly.

## System Model

The communication system used in the simulation is:

1. Generate random 4-bit data blocks
2. Encode using Hamming(7,4)
3. Map bits to BPSK symbols

   `1 -> +1`  
   `0 -> -1`

4. Transmit through AWGN
5. Decode using two approaches
6. Compute BER versus `Eb/N0`

Simulation parameters:

- `Eb/N0` range: `0` to `8` dB
- Frames per SNR: `10,000`
- Code rate: `4/7`

## Hard Decision Decoding

In the hard-decision path, each received symbol is thresholded to a binary bit before decoding. The resulting 7-bit decision vector is then passed through Hamming syndrome decoding to correct single-bit errors.

This method discards amplitude information from the channel. After thresholding, a weak symbol and a strong symbol are treated the same if they fall on the same side of zero.

## Soft Decision Decoding

In the soft-decision path, the received waveform samples are used directly before hard thresholding. Each synchronized 7-symbol segment is correlated against the 16 valid Hamming(7,4) codewords represented in BPSK form.

The decision rule is:

```text
metric(i) = Σ r_k c_{i,k}
```

The decoder selects the codeword with the maximum correlation metric.

Because the received sample values are used directly, soft decoding preserves confidence information from the channel. Symbols with larger magnitude contribute more strongly to the decoding decision than symbols near zero.

## Simulation Results

![Soft vs Hard Hamming(7,4) BER](Problem_2.3_soft_vs_hard_BER.png)

The BER plot shows that the soft-decision curve is shifted left relative to the hard-decision curve. This indicates that soft decoding achieves the same BER at a lower `Eb/N0`.

From the simulation trend, the improvement is approximately `2 dB` for equivalent BER. This is consistent with the expected gain from using reliability information instead of hard symbol slicing alone.

## Discussion

Soft decoding performs better because it keeps information that hard decoding throws away. A hard slicer reduces each received sample to only a `0` or `1`, while the soft decoder keeps the sign and magnitude of the received symbol when comparing against valid codewords.

The maximum-correlation rule is effectively a maximum-likelihood decision for BPSK over AWGN, so it makes better use of the received signal.

Advantages:

- lower BER
- reduced transmit power for the same target BER
- increased communication range

Tradeoff:

- increased computational complexity

## Conclusion

The simulation shows that soft-decision decoding improves BER relative to hard-decision decoding for Hamming(7,4). Approximately `2 dB` of coding gain was observed in the comparison. The improvement comes from preserving reliability information in the received samples rather than making immediate hard symbol decisions.

This result illustrates an important communication-system principle: decoder performance improves when more channel information is retained. The same idea is used in more advanced coding systems such as convolutional, LDPC, and turbo codes.
