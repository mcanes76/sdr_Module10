%BASELINE_REVIEW_HAMMING74 Reproduce the Live Lab Hamming(7,4) baseline.
%   This script mirrors the correction simulation architecture from the
%   Live Lab reference and exports a baseline figure and result file for the
%   Problem 2.2 Step 01 review.

clearvars;
clc;
close all;

rng(1);

[h_parity_matrix, g_generator_matrix] = hammgen(3);
the_syndrome_table = syndtable(h_parity_matrix);

num_frames = 100000;
num_data_bits = num_frames * 4;
num_coded_bits = num_frames * 7;

awgn_vector = 0:6;

ber_before_correction = zeros(1, length(awgn_vector));
ber_after_correction = zeros(1, length(awgn_vector));
probability_bit_error = zeros(1, length(awgn_vector));

for idx = 1:length(awgn_vector)
    after_fec = zeros(num_frames, 1);
    before_fec = zeros(num_frames, 1);

    for k = 1:num_frames
        data_bits = randi([0 1], 1, 4);
        encoded_bits = mod(data_bits * g_generator_matrix, 2);
        modulated_data = pskmod(encoded_bits, 2);

        noise_vector = randn(1, 7) + 1.0i * randn(1, 7);
        noise_vector = noise_vector * sqrt(1 / 2);
        noise_vector = noise_vector * sqrt(10^(-awgn_vector(idx) / 10));

        rxSig = modulated_data + noise_vector;
        demodulated_data = pskdemod(rxSig, 2);
        syndrome = mod(h_parity_matrix * demodulated_data.', 2);
        syndrome_de = bi2de(syndrome.', 'left-msb');
        correction_vector = the_syndrome_table(1 + syndrome_de, :);

        if ~isequal(demodulated_data, encoded_bits)
            before_fec(k) = sum(abs(demodulated_data - encoded_bits));
        end

        corrected_data = rem(correction_vector + demodulated_data, 2);
        if ~isequal(corrected_data, encoded_bits)
            after_fec(k) = sum(abs(corrected_data - encoded_bits));
        end
    end

    ber_before_correction(idx) = sum(before_fec) / num_coded_bits;
    ber_after_correction(idx) = sum(after_fec) / num_coded_bits;
    probability_bit_error(idx) = qfunc(sqrt(2 * 10^(awgn_vector(idx) / 10)));
end

results = table(awgn_vector(:), ber_after_correction(:), ...
    ber_before_correction(:), probability_bit_error(:), ...
    'VariableNames', {'EbN0_dB', 'BER_Corrected', 'BER_Uncorrected', 'BER_Theory'});

output_dir = fullfile(fileparts(mfilename('fullpath')), 'docs', 'figures');
if ~exist(output_dir, 'dir')
    mkdir(output_dir);
end

figure('Color', 'w');
semilogy(awgn_vector, ber_after_correction, '-o', 'LineWidth', 1.2);
hold on;
semilogy(awgn_vector, ber_before_correction, '-x', 'LineWidth', 1.2);
semilogy(awgn_vector, probability_bit_error, '-^', 'LineWidth', 1.2);
hold off;
grid on;
title('Baseline BER Hamming(7,4) Correcting');
xlabel('Eb/N0 (dB)');
ylabel('BER');
legend('Simulation-Corrected', 'Simulation-Uncorrected', 'Theory', ...
    'Location', 'best');

exportgraphics(gcf, fullfile(output_dir, 'step01_baseline_hamming74_ber.png'), ...
    'Resolution', 150);
writetable(results, fullfile(output_dir, 'step01_baseline_hamming74_results.csv'));
save(fullfile(output_dir, 'step01_baseline_hamming74_results.mat'), ...
    'awgn_vector', 'ber_after_correction', 'ber_before_correction', ...
    'probability_bit_error', 'num_frames', 'num_data_bits', 'num_coded_bits');

disp(results);
