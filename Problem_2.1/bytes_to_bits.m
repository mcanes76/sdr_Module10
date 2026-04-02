function bitStream = bytes_to_bits(packetBytes)
%BYTES_TO_BITS Convert packet bytes to an MSB-first bit stream.
%   bitStream = BYTES_TO_BITS(packetBytes) converts a byte vector into a
%   column vector of bits ordered MSB-first within each byte.

    if nargin ~= 1
        error('bytes_to_bits:InvalidInputCount', ...
            'Expected exactly one input argument.');
    end

    if ~isnumeric(packetBytes) && ~islogical(packetBytes)
        error('bytes_to_bits:InvalidInputType', ...
            'Input must be numeric or logical and convertible to uint8.');
    end

    if isempty(packetBytes)
        bitStream = zeros(0, 1, 'uint8');
        return;
    end

    if any(packetBytes(:) < 0) || any(packetBytes(:) > 255) || ...
            any(mod(double(packetBytes(:)), 1) ~= 0)
        error('bytes_to_bits:InvalidByteValue', ...
            'All input values must be integer byte values in the range [0, 255].');
    end

    packetBytes = uint8(packetBytes(:));
    numBytes = numel(packetBytes);

    bitMatrix = false(numBytes, 8);
    for col = 1:8
        bitMatrix(:, col) = logical(bitget(packetBytes, 9 - col));
    end

    bitStream = uint8(reshape(bitMatrix.', [], 1));
end
