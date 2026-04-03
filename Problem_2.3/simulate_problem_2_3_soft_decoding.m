%SIMULATE_PROBLEM_2_3_SOFT_DECODING Homework 10 Problem 2.3 simulation.
%   Compares hard-decision and soft-decision Hamming(7,4) decoding.

clearvars;
clc;
close all;

rng(1);

[h_parity_matrix, g_generator_matrix] = hammgen(3);
the_syndrome_table = syndtable(h_parity_matrix);
[codewordsBits, codewordsBpsk] = build_hamming74_codeword_table();

EbN0dB = 0:1:8;
numFrames = 10000;
numCodedBits = numFrames * 7;

berHard = zeros(size(EbN0dB));
berSoft = zeros(size(EbN0dB));

for idx = 1:numel(EbN0dB)
    hardBitErrors = 0;
    softBitErrors = 0;
    noiseSigma = sqrt(1 / (2 * 10^(EbN0dB(idx) / 10)));

    for k = 1:numFrames
        dataBits = randi([0 1], 1, 4);
        encodedBits = mod(dataBits * g_generator_matrix, 2);
        txSymbols = 2 * encodedBits - 1;

        noise = noiseSigma * randn(1, 7);
        rxSymbols = txSymbols + noise;

        hardBits = rxSymbols > 0;
        syndrome = mod(h_parity_matrix * hardBits.', 2);
        syndromeIndex = bi2de(syndrome.', 'left-msb');
        correctionVector = the_syndrome_table(1 + syndromeIndex, :);
        hardDecodedBits = rem(correctionVector + hardBits, 2);

        softDecodedBits = decode_hamming74_soft_correlation( ...
            rxSymbols, codewordsBpsk, codewordsBits);

        hardBitErrors = hardBitErrors + sum(abs(hardDecodedBits - encodedBits));
        softBitErrors = softBitErrors + sum(abs(softDecodedBits - encodedBits));
    end

    berHard(idx) = hardBitErrors / numCodedBits;
    berSoft(idx) = softBitErrors / numCodedBits;
end

results = struct();
results.EbN0dB = EbN0dB;
results.berHard = berHard;
results.berSoft = berSoft;

figure('Color', 'w');
semilogy(EbN0dB, berHard, '-o', 'LineWidth', 1.2);
hold on;
semilogy(EbN0dB, berSoft, '-s', 'LineWidth', 1.2);
hold off;
grid on;
xlabel('Eb/N0 (dB)');
ylabel('BER');
title('Problem 2.3 Soft vs Hard Hamming(7,4) Decoding');
legend('Hard-decision Hamming(7,4)', 'Soft-decision Hamming(7,4)', ...
    'Location', 'best');

outputPath = fullfile(fileparts(mfilename('fullpath')), ...
    'Problem_2.3_soft_vs_hard_BER.png');
exportgraphics(gcf, outputPath, 'Resolution', 150);

disp(table(EbN0dB(:), berHard(:), berSoft(:), ...
    'VariableNames', {'EbN0_dB', 'BER_Hard', 'BER_Soft'}));
