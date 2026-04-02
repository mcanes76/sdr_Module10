# Step 2: Fair Energy Scaling

## Purpose
- Define how to modify the original Hamming(7,4) simulation so the coded case no longer benefits from extra total transmit energy.

## Inputs
- Original coded BPSK symbol stream.
- Required fair-energy factor: `4/7`.

## Outputs
- A documented scaling approach for the fair-energy coded case.

## Algorithm Idea
- Reduce coded symbol energy by `4/7` relative to the original coded simulation.
- A practical path is to reduce coded symbol amplitude accordingly, while leaving the rest of the simulation architecture unchanged.

## Acceptance Criteria
- The documentation clearly distinguishes:
  - original coded case
  - fair-energy coded case
- The planned scaling approach can be implemented later without ambiguity.
