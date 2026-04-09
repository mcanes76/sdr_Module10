%SIMULATE_PROBLEM_2_2_FAIR_HAMMING Homework 10 Problem 2.2 simulation.
%   Compares:
%   1. theoretical uncoded BPSK BER
%   2. original Hamming(7,4) corrected BER
%   3. fair-energy Hamming(7,4) corrected BER

clearvars;
clc;
close all;

rng(1);

[h_parity_matrix, g_generator_matrix] = hammgen(3);
the_syndrome_table = syndtable(h_parity_matrix);

num_frames = 100000;
num_coded_bits = num_frames * 7;
awgn_vector = 0:10;
fair_scale = sqrt(4 / 7);

ber_original_corrected = zeros(1, length(awgn_vector));
ber_fair_corrected = zeros(1, length(awgn_vector));
ber_theory_bpsk = zeros(1, length(awgn_vector));

for idx = 1:length(awgn_vector)
    original_after_fec = zeros(num_frames, 1);
    fair_after_fec = zeros(num_frames, 1);

    for k = 1:num_frames
        data_bits = randi([0 1], 1, 4);
        encoded_bits = mod(data_bits * g_generator_matrix, 2);

        modulated_original = pskmod(encoded_bits, 2);
        modulated_fair = fair_scale * modulated_original;

        noise_vector = randn(1, 7) + 1.0i * randn(1, 7);
        noise_vector = noise_vector * sqrt(1 / 2);
        noise_vector = noise_vector * sqrt(10^(-awgn_vector(idx) / 10));

        rx_original = modulated_original + noise_vector;
        rx_fair = modulated_fair + noise_vector;

        demod_original = pskdemod(rx_original, 2);
        demod_fair = pskdemod(rx_fair, 2);

        syndrome_original = mod(h_parity_matrix * demod_original.', 2);
        syndrome_original_de = bi2de(syndrome_original.', 'left-msb');
        correction_original = the_syndrome_table(1 + syndrome_original_de, :);
        corrected_original = rem(correction_original + demod_original, 2);

        syndrome_fair = mod(h_parity_matrix * demod_fair.', 2);
        syndrome_fair_de = bi2de(syndrome_fair.', 'left-msb');
        correction_fair = the_syndrome_table(1 + syndrome_fair_de, :);
        corrected_fair = rem(correction_fair + demod_fair, 2);

        if ~isequal(corrected_original, encoded_bits)
            original_after_fec(k) = sum(abs(corrected_original - encoded_bits));
        end

        if ~isequal(corrected_fair, encoded_bits)
            fair_after_fec(k) = sum(abs(corrected_fair - encoded_bits));
        end
    end

    ber_original_corrected(idx) = sum(original_after_fec) / num_coded_bits;
    ber_fair_corrected(idx) = sum(fair_after_fec) / num_coded_bits;
    ber_theory_bpsk(idx) = qfunc(sqrt(2 * 10^(awgn_vector(idx) / 10)));
end

results = table(awgn_vector(:), ber_original_corrected(:), ...
    ber_fair_corrected(:), ber_theory_bpsk(:), ...
    'VariableNames', {'EbN0_dB', 'BER_Hamming_Original', ...
    'BER_Hamming_Fair', 'BER_BPSK_Theory'});

output_dir = fullfile(fileparts(mfilename('fullpath')), 'docs', 'figures');
if ~exist(output_dir, 'dir')
    mkdir(output_dir);
end

figure('Color', 'w');
semilogy(awgn_vector, ber_original_corrected, '-o', 'LineWidth', 1.2);
hold on;
semilogy(awgn_vector, ber_fair_corrected, '-s', 'LineWidth', 1.2);
semilogy(awgn_vector, ber_theory_bpsk, '-^', 'LineWidth', 1.2);
hold off;
grid on;
title('Problem 2.2 Fair Hamming(7,4) Comparison');
xlabel('Eb/N0 (dB)');
ylabel('BER');
legend('Hamming(7,4) Original', 'Hamming(7,4) Fair Energy', ...
    'BPSK Theory', 'Location', 'best');

exportgraphics(gcf, fullfile(output_dir, 'problem_2_2_fair_hamming_ber.png'), ...
    'Resolution', 150);
writetable(results, fullfile(output_dir, 'problem_2_2_fair_hamming_results.csv'));
save(fullfile(output_dir, 'problem_2_2_fair_hamming_results.mat'), ...
    'awgn_vector', 'ber_original_corrected', 'ber_fair_corrected', ...
    'ber_theory_bpsk', 'num_frames', 'fair_scale');

disp(results);
fprintf('\n');
fprintf('Interpretation:\n');
fprintf('- The fair-energy Hamming curve should move worse than the original baseline.\n');
fprintf('- That change occurs because the original coded case used extra total energy per 4 information bits.\n');
fprintf('- The fair comparison isolates coding gain more honestly.\n');
