function [codewordsBits, codewordsBpsk] = build_hamming74_codeword_table()
%BUILD_HAMMING74_CODEWORD_TABLE Build the 16 valid Hamming(7,4) codewords.
%   Returns the codewords in binary form and BPSK-like form with
%   0 -> -1 and 1 -> +1.

    [~, g_generator_matrix] = hammgen(3);

    dataWords = de2bi(0:15, 4, 'left-msb');
    codewordsBits = mod(dataWords * g_generator_matrix, 2);
    codewordsBpsk = 2 * codewordsBits - 1;

    if ~isequal(size(codewordsBits), [16, 7])
        error('build_hamming74_codeword_table:InvalidBitsSize', ...
            'codewordsBits must be a 16x7 matrix.');
    end

    if ~isequal(size(codewordsBpsk), [16, 7])
        error('build_hamming74_codeword_table:InvalidBpskSize', ...
            'codewordsBpsk must be a 16x7 matrix.');
    end

    if size(unique(codewordsBits, 'rows'), 1) ~= 16
        error('build_hamming74_codeword_table:NonUniqueCodewords', ...
            'The generated Hamming(7,4) codewords must be unique.');
    end

    if ~isequal(codewordsBpsk, 2 * codewordsBits - 1)
        error('build_hamming74_codeword_table:InvalidBpskMapping', ...
            'codewordsBpsk does not match the 0 -> -1, 1 -> +1 mapping.');
    end
end
