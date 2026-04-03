# Step 02 Fair Energy Method

## 1. Objective

The goal of Homework 10 Problem 2.2 is to create a fair comparison between uncoded BPSK and Hamming(7,4) coding by equalizing the total transmit energy used for the same information block.

In practical terms, the comparison should answer this question:

- if both systems are given comparable total energy per 4 information bits, how much BER improvement still remains from Hamming(7,4)?

## 2. Baseline Energy Imbalance

In the original Live Lab simulation, Hamming(7,4) encodes every 4 information bits into 7 coded bits. The simulation then transmits those 7 coded bits using the same coded-bit energy as the uncoded BPSK reference.

That creates an energy imbalance:

- uncoded case transmits 4 bits for one 4-bit information block
- coded case transmits 7 bits for that same 4-bit information block

If the transmitted bit energy is unchanged, then the coded system uses:

```text
7/4
```

times more total transmit energy than the uncoded case for the same information payload.

## 3. Energy Normalization

To make the comparison fair, the total coded transmit energy for one 4-bit information block should match the uncoded transmit energy for that same block.

The normalization condition is:

```text
7 Ecoded = 4 Eb
```

which gives:

```text
Ecoded = (4/7) Eb
```

This means each transmitted coded bit in the fair-comparison case must use only `4/7` of the original uncoded bit energy.

## 4. Implementation in the Simulation

For BPSK, symbol energy is proportional to amplitude squared. Because of that, reducing coded bit energy by `4/7` can be implemented by scaling the coded BPSK symbol amplitude by:

```text
sqrt(4/7)
```

Original coded symbol:

```text
+1 or -1
```

Fair-energy coded symbol:

```text
+sqrt(4/7) or -sqrt(4/7)
```

This keeps the simulation structure simple while directly enforcing the intended energy normalization.

## 5. What Remains Unchanged

The fair-energy comparison changes only the coded symbol energy. The rest of the simulation remains identical to the baseline:

- encoder
- AWGN channel
- demodulation
- syndrome decoding
- BER measurement

This is important because it isolates the comparison to one design change only: energy normalization.

## 6. Expected Outcome

The fair-energy Hamming BER curve should move upward relative to the original Live Lab result because the earlier simulation benefited from extra total transmit energy.

After the energy adjustment, some of the apparent advantage of the original Hamming curve should disappear. Any remaining improvement represents the true coding gain more honestly, because it is no longer inflated by spending extra energy on the coded transmission.
