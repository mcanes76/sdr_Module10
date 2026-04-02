function packetBytes = bits_to_bytes(bitStream)
%BITS_TO_BYTES Convert an MSB-first bit stream to packet bytes.
%   packetBytes = BITS_TO_BYTES(bitStream) converts a bit vector into a
%   column vector of uint8 bytes using MSB-first ordering within each byte.

    if nargin ~= 1
        error('bits_to_bytes:InvalidInputCount', ...
            'Expected exactly one input argument.');
    end

    if ~isnumeric(bitStream) && ~islogical(bitStream)
        error('bits_to_bytes:InvalidInputType', ...
            'Input must be numeric or logical and convertible to bits.');
    end

    if isempty(bitStream)
        packetBytes = zeros(0, 1, 'uint8');
        return;
    end

    if any(bitStream(:) ~= 0 & bitStream(:) ~= 1)
        error('bits_to_bytes:InvalidBitValue', ...
            'All input values must be binary values 0 or 1.');
    end

    bitStream = uint8(bitStream(:));

    if mod(numel(bitStream), 8) ~= 0
        error('bits_to_bytes:InvalidBitCount', ...
            'Bit-stream length must be a multiple of 8.');
    end

    bitMatrix = reshape(bitStream, 8, []).';
    packetBytes = zeros(size(bitMatrix, 1), 1, 'uint8');

    for col = 1:8
        packetBytes = bitset(packetBytes, 9 - col, logical(bitMatrix(:, col)));
    end
end
