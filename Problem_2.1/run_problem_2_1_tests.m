%RUN_PROBLEM_2_1_TESTS Homework 10 Problem 2.1 functional tests.
%   Test 1 verifies that a valid payload-plus-checksum packet checks to zero.
%   Test 2 verifies that a single flipped bit produces a nonzero check value.

clear;
clc;

rng(1);

fprintf('=== Homework 10 Problem 2.1 Tests ===\n\n');

%% Test 1: Reversible packet check
payload1 = uint8(randi([0, 255], 24, 1));
[packet1, checksum1] = append_g9959_checksum(payload1);
[isDetectedError1, checkValue1] = check_g9959_packet(packet1);

fprintf('Test 1: Reversible packet check\n');
fprintf('Payload  : %s\n', bytes_to_hex_string(payload1));
fprintf('Checksum : 0x%02X\n', checksum1);
fprintf('CheckVal : 0x%02X\n', checkValue1);

if ~isDetectedError1 && checkValue1 == uint8(0)
    fprintf('PASS: Valid 25-byte packet checks to 0x00.\n\n');
else
    fprintf('FAIL: Valid 25-byte packet did not check to 0x00.\n\n');
end

%% Test 2: Single-bit error detection
payload2 = uint8(randi([0, 255], 24, 1));
[packet2, checksum2] = append_g9959_checksum(payload2);

bitIndex = randi([1, 200]);
byteIndex = ceil(bitIndex / 8);
bitOffsetWithinByte = mod(bitIndex - 1, 8);   % 0..7 in MSB-first ordering
bitPosition = 8 - bitOffsetWithinByte;        % MATLAB bit position: 8..1

corruptedPacket = packet2;
corruptedPacket(byteIndex) = bitxor(corruptedPacket(byteIndex), bitshift(uint8(1), bitPosition - 1));

[isDetectedError2, checkValue2] = check_g9959_packet(corruptedPacket);

fprintf('Test 2: Single-bit error detection\n');
fprintf('Payload  : %s\n', bytes_to_hex_string(payload2));
fprintf('Checksum : 0x%02X\n', checksum2);
fprintf('Flip bit : packet bit %d (byte %d, bit position %d)\n', ...
    bitIndex, byteIndex, bitPosition - 1);
fprintf('CheckVal : 0x%02X\n', checkValue2);

if isDetectedError2 && checkValue2 ~= uint8(0)
    fprintf('PASS: Single-bit corruption produced a nonzero check value.\n\n');
else
    fprintf('FAIL: Single-bit corruption was not detected.\n\n');
end

function hexString = bytes_to_hex_string(byteVector)
%BYTES_TO_HEX_STRING Format a byte vector as space-separated hex bytes.

    byteVector = uint8(byteVector(:));
    hexCells = arrayfun(@(x) sprintf('%02X', x), byteVector, 'UniformOutput', false);
    hexString = strjoin(hexCells, ' ');
end
