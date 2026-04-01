%TB_G9959_CHECKSUM Testbench for Step 1 checksum generation.
%   Exercises the ITU-T G.9959 checksum function using:
%   1. the homework figure example
%   2. a deterministic multi-byte regression vector
%   3. a random vector cross-check against direct XOR reduction

clear;
clc;

fprintf('=== tb_g9959_checksum ===\n');

repoRoot = fileparts(fileparts(mfilename('fullpath')));
addpath(repoRoot);

%% Test 1: Homework figure example
% Rows from Figure 1, interpreted MSB-first as bytes:
%   01100010 = 0x62
%   11101100 = 0xEC
%   10100101 = 0xA5
%   01111110 = 0x7E
% Expected checksum bits from the figure: 10101010 = 0xAA
figureExample = uint8([hex2dec('62'), hex2dec('EC'), hex2dec('A5'), hex2dec('7E')]);
[checksumExample, debugExample] = g9959_checksum(figureExample);
expectedExample = uint8(hex2dec('AA'));

assert(checksumExample == expectedExample, ...
    'Figure example checksum mismatch: expected 0xAA, got 0x%02X.', checksumExample);

fprintf('PASS Test 1: figure example checksum = 0x%02X\n', checksumExample);
disp('Figure-example checksum bits [7:0]:');
disp(double(debugExample.checksumBitsMsbFirst));

%% Test 2: Deterministic regression vector
regressionBytes = uint8([0, 1, 2, 3, 16, 32, 64, 128, 255]);
[checksumRegression, debugRegression] = g9959_checksum(regressionBytes);

expectedRegression = uint8(255);
for idx = 1:numel(regressionBytes)
    expectedRegression = bitxor(expectedRegression, regressionBytes(idx));
end

assert(checksumRegression == expectedRegression, ...
    'Regression checksum mismatch: expected 0x%02X, got 0x%02X.', ...
    expectedRegression, checksumRegression);
assert(debugRegression.checksumFromBitColumns == checksumRegression, ...
    'Bit-column reconstruction mismatch on regression vector.');

fprintf('PASS Test 2: regression checksum = 0x%02X\n', checksumRegression);

%% Test 3: Random-vector cross-check
rng(210, 'twister');
randomBytes = uint8(randi([0, 255], 24, 1));
[checksumRandom, debugRandom] = g9959_checksum(randomBytes);

expectedRandom = uint8(255);
for idx = 1:numel(randomBytes)
    expectedRandom = bitxor(expectedRandom, randomBytes(idx));
end

assert(checksumRandom == expectedRandom, ...
    'Random checksum mismatch: expected 0x%02X, got 0x%02X.', ...
    expectedRandom, checksumRandom);
assert(debugRandom.checksumFromBitColumns == checksumRandom, ...
    'Bit-column reconstruction mismatch on random vector.');

fprintf('PASS Test 3: random checksum = 0x%02X\n', checksumRandom);
fprintf('All checksum-generation tests passed.\n');
