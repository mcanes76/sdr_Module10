function [isDetectedError, checkValue, debug] = check_g9959_packet(packetBytes)
%CHECK_G9959_PACKET Check a 25-byte Homework 10 Problem 2.1 packet.
%   [isDetectedError, checkValue, debug] = CHECK_G9959_PACKET(packetBytes)
%   validates a 25-byte packet, recomputes the ITU-T G.9959 checksum over
%   the full packet, and flags any nonzero result as a detected packet error.

    if nargin ~= 1
        error('check_g9959_packet:InvalidInputCount', ...
            'Expected exactly one input argument.');
    end

    if ~isnumeric(packetBytes) && ~islogical(packetBytes)
        error('check_g9959_packet:InvalidInputType', ...
            'Input must be numeric or logical and convertible to uint8.');
    end

    if isempty(packetBytes)
        error('check_g9959_packet:InvalidPacketLength', ...
            'Packet must contain exactly 25 bytes for Homework 10 Problem 2.1.');
    end

    if any(packetBytes(:) < 0) || any(packetBytes(:) > 255) || ...
            any(mod(double(packetBytes(:)), 1) ~= 0)
        error('check_g9959_packet:InvalidByteValue', ...
            'All packet values must be integer byte values in the range [0, 255].');
    end

    packetBytes = uint8(packetBytes(:));

    if numel(packetBytes) ~= 25
        error('check_g9959_packet:InvalidPacketLength', ...
            'Packet must contain exactly 25 bytes for Homework 10 Problem 2.1.');
    end

    [checkValue, debug] = g9959_checksum(packetBytes);
    isDetectedError = (checkValue ~= uint8(0));
end
