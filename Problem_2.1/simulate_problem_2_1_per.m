%SIMULATE_PROBLEM_2_1_PER Homework 10 Problem 2.1 PER simulation.
%   This script follows the live-lab architecture:
%       payload -> append checksum -> packet bits -> BPSK -> AWGN -> demod
%       -> packet reconstruction -> checksum verification
%
%   Optional workspace overrides for quick runs:
%       snrVecOverride
%       numFramesOverride
%       rngSeedOverride
%       makePlotsOverride

clearvars -except snrVecOverride numFramesOverride rngSeedOverride makePlotsOverride;
clc;

if exist('rngSeedOverride', 'var')
    rng(rngSeedOverride);
else
    rng(1);
end

if exist('snrVecOverride', 'var')
    snrVec = snrVecOverride;
else
    snrVec = 0:6;
end

if exist('numFramesOverride', 'var')
    numFrames = numFramesOverride;
else
    numFrames = 10000;
end

if exist('makePlotsOverride', 'var')
    makePlots = logical(makePlotsOverride);
else
    makePlots = true;
end

payloadLengthBytes = 24;
packetLengthBytes = 25;
packetLengthBits = 200;

PER_detected = zeros(1, numel(snrVec));
PER_truth = zeros(1, numel(snrVec));

fprintf('=== Homework 10 Problem 2.1 PER Simulation ===\n');
fprintf('SNR range : %s dB\n', mat2str(snrVec));
fprintf('Frames/SNR: %d\n\n', numFrames);

for idx = 1:numel(snrVec)
    detected_error = zeros(numFrames, 1);
    truth_error = zeros(numFrames, 1);
    snrDb = snrVec(idx);

    fprintf('Running SNR = %g dB ...\n', snrDb);

    for k = 1:numFrames
        payloadBytes = uint8(randi([0, 255], payloadLengthBytes, 1));
        packetBytes = append_g9959_checksum(payloadBytes);
        txBits = bytes_to_bits(packetBytes);

        if numel(txBits) ~= packetLengthBits
            error('simulate_problem_2_1_per:InvalidPacketBitCount', ...
                'Expected %d packet bits, but got %d.', packetLengthBits, numel(txBits));
        end

        modulated_data = pskmod(double(txBits), 2);
        signal_length = length(modulated_data);

        noise_vector = randn(signal_length, 1) + 1.0i * randn(signal_length, 1);
        noise_vector = noise_vector * sqrt(1 / 2);
        noise_vector = noise_vector * sqrt(10^(-snrDb / 10));

        rxSig = modulated_data + noise_vector;
        demodulated_data = pskdemod(rxSig, 2);
        rxBits = uint8(demodulated_data(:));

        if ~isequal(rxBits, txBits)
            truth_error(k) = 1;
        end

        rxPacketBytes = bits_to_bytes(rxBits);

        if numel(rxPacketBytes) ~= packetLengthBytes
            error('simulate_problem_2_1_per:InvalidPacketByteCount', ...
                'Expected %d packet bytes, but got %d.', packetLengthBytes, numel(rxPacketBytes));
        end

        isDetectedError = check_g9959_packet(rxPacketBytes);
        detected_error(k) = double(isDetectedError);
    end

    PER_detected(idx) = sum(detected_error) / numFrames;
    PER_truth(idx) = sum(truth_error) / numFrames;

    fprintf('  Detected PER = %.6f, Truth PER = %.6f, Difference = %.6f\n\n', ...
        PER_detected(idx), PER_truth(idx), PER_truth(idx) - PER_detected(idx));
end

PER_difference = abs(PER_truth - PER_detected);

results = struct();
results.snrVec = snrVec;
results.numFrames = numFrames;
results.payloadLengthBytes = payloadLengthBytes;
results.packetLengthBytes = packetLengthBytes;
results.packetLengthBits = packetLengthBits;
results.perDetected = PER_detected;
results.perTruth = PER_truth;
results.perDifference = PER_difference;

disp('Simulation complete.');
disp(results);

if makePlots
    figure;
    semilogy(snrVec, PER_detected, '-o');
    hold on;
    semilogy(snrVec, PER_truth, '-x');
    hold off;
    grid on;
    title('PER for the G.9959 Parity Check');
    xlabel('SNR (dB)');
    ylabel('PER');
    legend('Detected', 'Truth', 'Location', 'best');

    figure;
    plot(snrVec, PER_difference, '-o');
    grid on;
    xlabel('SNR (dB)');
    ylabel('Difference in PER (Actual-Measured)');
    title('Difference in PER');
end
