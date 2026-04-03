function decodedBits = decode_hamming74_soft_correlation(rxSymbols, codewordsBpsk, codewordsBits)
%DECODE_HAMMING74_SOFT_CORRELATION Decode Hamming(7,4) codewords by correlation.
%   Uses the real part of synchronized 7-symbol BPSK segments and selects
%   the valid codeword with the maximum correlation.

    if nargin ~= 3
        error('decode_hamming74_soft_correlation:InvalidInputCount', ...
            'Expected exactly three input arguments.');
    end

    if ~isnumeric(rxSymbols)
        error('decode_hamming74_soft_correlation:InvalidRxSymbolsType', ...
            'rxSymbols must be a numeric matrix.');
    end

    if ~isnumeric(codewordsBpsk) || ~isnumeric(codewordsBits)
        error('decode_hamming74_soft_correlation:InvalidCodewordType', ...
            'codewordsBpsk and codewordsBits must be numeric matrices.');
    end

    if size(rxSymbols, 2) ~= 7
        error('decode_hamming74_soft_correlation:InvalidRxSymbolsSize', ...
            'rxSymbols must have 7 columns.');
    end

    if ~isequal(size(codewordsBpsk), [16, 7])
        error('decode_hamming74_soft_correlation:InvalidCodewordsBpskSize', ...
            'codewordsBpsk must be a 16x7 matrix.');
    end

    if ~isequal(size(codewordsBits), [16, 7])
        error('decode_hamming74_soft_correlation:InvalidCodewordsBitsSize', ...
            'codewordsBits must be a 16x7 matrix.');
    end

    if ~isequal(codewordsBpsk, 2 * codewordsBits - 1)
        error('decode_hamming74_soft_correlation:InconsistentCodewordTables', ...
            'codewordsBpsk must match codewordsBits under the 0 -> -1, 1 -> +1 mapping.');
    end

    rxReal = real(rxSymbols);
    metrics = rxReal * codewordsBpsk.';
    [~, idx] = max(metrics, [], 2);
    decodedBits = codewordsBits(idx, :);
end
