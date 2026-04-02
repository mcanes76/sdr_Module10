[h_parity_matrix,g_generator_matrix] = hammgen(3);   
the_syndrome_table = syndtable(h_parity_matrix);

num_frames = 100000;
num_data_bits = num_frames*4;
num_coded_bits = num_frames*7;

awgn_vector = 0:6;  %in dB

numFrames = 100000;
awgnvec=0:6;
PER_detected=zeros(1,length(awgnvec));
PER_truth=zeros(1,length(awgnvec));

for idx=1:length(awgnvec)
    detected_error = zeros(numFrames,1);
    truth_error = zeros(numFrames,1);   
    for k = 1:numFrames
        data_bits = randi([0 1],4,1); % Generate binary data
        encoded_data = ...
            mod(data_bits.'*g_generator_matrix,2); % Append Parity bits
        modulated_data = pskmod(encoded_data,2); % BPSK modulate
        noise_vector = randn(1,7)+1.0i*randn(1,7);
        noise_vector = noise_vector*sqrt(1/2);
        noise_vector = ... 
            noise_vector*sqrt(10^(-awgn_vector(idx)/10));          
        rxSig = modulated_data + noise_vector;  % AWGN channel, SNR dB 
        demodulated_data = pskdemod(rxSig,2); % BPSK demodulate
        syndrome = mod(h_parity_matrix*demodulated_data.',2);
        if sum(syndrome)>0
            detected_error(k)=1;
        end
        if ~isequal(demodulated_data,encoded_data)
            truth_error(k)=1;
        end              
    end
    PER_detected(idx) = sum(detected_error)/numFrames; 
    PER_truth(idx) = sum(truth_error)/numFrames; 
end

figure
semilogy(awgnvec,PER_detected,'-o')
hold on
semilogy(awgnvec,PER_truth,'-x')
hold off
title('PER Hamming(7,4) Detecting')
xlabel('Eb/N0')
ylabel('PER')
legend('Detected','Truth',... 
    'location','best')
figure
plot(awgnvec,PER_truth-PER_detected)
xlabel('Eb/N0')
ylabel('Difference in PER (Actual-Measured)')
