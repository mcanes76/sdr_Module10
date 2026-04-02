function [packetBytes, checksumByte, debug] = append_g9959_checksum(payloadBytes)
%APPEND_G9959_CHECKSUM Append the Homework 10 Problem 2.1 checksum byte.
%   [packetBytes, checksumByte, debug] = APPEND_G9959_CHECKSUM(payloadBytes)
%   validates a 24-byte payload, computes the ITU-T G.9959 checksum using
%   G9959_CHECKSUM, and appends the checksum to form a 25-byte packet.

    if nargin ~= 1
        error('append_g9959_checksum:InvalidInputCount', ...
            'Expected exactly one input argument.');
    end

    if ~isnumeric(payloadBytes) && ~islogical(payloadBytes)
        error('append_g9959_checksum:InvalidInputType', ...
            'Input must be numeric or logical and convertible to uint8.');
    end

    if isempty(payloadBytes)
        error('append_g9959_checksum:InvalidPayloadLength', ...
            'Payload must contain exactly 24 bytes for Homework 10 Problem 2.1.');
    end

    if any(payloadBytes(:) < 0) || any(payloadBytes(:) > 255) || ...
            any(mod(double(payloadBytes(:)), 1) ~= 0)
        error('append_g9959_checksum:InvalidByteValue', ...
            'All payload values must be integer byte values in the range [0, 255].');
    end

    payloadBytes = uint8(payloadBytes(:));

    if numel(payloadBytes) ~= 24
        error('append_g9959_checksum:InvalidPayloadLength', ...
            'Payload must contain exactly 24 bytes for Homework 10 Problem 2.1.');
    end

    [checksumByte, checksumDebug] = g9959_checksum(payloadBytes);
    packetBytes = [payloadBytes; checksumByte];

    debug = checksumDebug;
    debug.packetBytes = packetBytes;
end
