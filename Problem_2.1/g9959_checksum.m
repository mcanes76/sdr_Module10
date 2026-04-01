function [checksumByte, debug] = g9959_checksum(dataBytes)
%G9959_CHECKSUM Compute the ITU-T G.9959 odd longitudinal checksum.
%   checksumByte = G9959_CHECKSUM(dataBytes) returns the 1-byte checksum
%   for the input payload bytes using the standard byte-wise algorithm:
%       CheckSum = 0xFF XOR byte_1 XOR byte_2 ... XOR byte_N
%
%   [checksumByte, debug] also returns intermediate debug fields that
%   expose the equivalent bit-column odd-parity interpretation.

    if nargin ~= 1
        error('g9959_checksum:InvalidInputCount', ...
            'Expected exactly one input argument.');
    end

    if ~isnumeric(dataBytes) && ~islogical(dataBytes)
        error('g9959_checksum:InvalidInputType', ...
            'Input must be numeric or logical and convertible to uint8.');
    end

    if isempty(dataBytes)
        dataBytes = uint8([]);
    else
        if any(dataBytes(:) < 0) || any(dataBytes(:) > 255) || any(mod(double(dataBytes(:)), 1) ~= 0)
            error('g9959_checksum:InvalidByteValue', ...
                'All input values must be integer byte values in the range [0, 255].');
        end
        dataBytes = uint8(dataBytes(:));
    end

    checksumByte = uint8(255);
    for idx = 1:numel(dataBytes)
        checksumByte = bitxor(checksumByte, dataBytes(idx));
    end

    bitMatrix = false(numel(dataBytes), 8);
    for col = 1:8
        % Column order is [7 6 5 4 3 2 1 0] to match the assignment figure.
        bitMatrix(:, col) = logical(bitget(dataBytes, 9 - col));
    end

    columnXor = mod(sum(bitMatrix, 1), 2);
    checksumBits = ~logical(columnXor);

    checksumFromBits = uint8(0);
    for col = 1:8
        checksumFromBits = bitset(checksumFromBits, 9 - col, checksumBits(col));
    end

    debug = struct();
    debug.inputBytes = dataBytes;
    debug.bitMatrixMsbFirst = bitMatrix;
    debug.columnXorMsbFirst = logical(columnXor);
    debug.checksumBitsMsbFirst = checksumBits;
    debug.checksumHex = sprintf('0x%02X', checksumByte);
    debug.checksumFromBitColumns = checksumFromBits;

    if checksumFromBits ~= checksumByte
        error('g9959_checksum:InternalMismatch', ...
            'Byte-wise checksum did not match the bit-column parity reconstruction.');
    end
end
