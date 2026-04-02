crcgenerator = comm.CRCGenerator(...
    'Polynomial','X^16 + X^12 + X^5 + 1',...
    'InitialConditions',1,...
    'DirectMethod',true,...
    'FinalXOR',1);
crcdetector = comm.CRCDetector(...
    'Polynomial','X^16 + X^12 + X^5 + 1',...
    'InitialConditions',1,...
    'DirectMethod',true,...
    'FinalXOR',1);
 
numFrames = 100000;
awgnvec = 0:6;
message_length = 32;
PER_detected=zeros(1,length(awgnvec));
PER_truth=zeros(1,length(awgnvec));

for idx=1:length(awgnvec)
    detected_error = zeros(numFrames,1);
    truth_error = zeros(numFrames,1);    
    for k = 1:numFrames
        data = randi([0 1],message_length,1); % Generate binary data
        encoded_data = crcgenerator(data); % Append CRC bits
        modulated_data = pskmod(encoded_data,2); % BPSK modulate
        signal_length = length(modulated_data);
        noise_vector = randn(signal_length,1)+1.0i*randn(signal_length,1);
        noise_vector = noise_vector*sqrt(1/2);
        noise_vector = ... 
            noise_vector*sqrt(10^(-awgn_vector(idx)/10));          
        rxSig = modulated_data + noise_vector;  % AWGN channel, SNR dB 
        demodulated_data = pskdemod(rxSig,2); % BPSK demodulate
        [~,detected_error(k)] = ...
            crcdetector(demodulated_data); % Detect CRC errors
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
title('PER CRC Detecting')
xlabel('Eb/N0')
ylabel('PER')
legend('Detected','Truth',... 
    'location','best')
 
figure
plot(awgnvec,PER_truth-PER_detected)
xlabel('Eb/N0')
ylabel('Difference in PER (Actual-Measured)')

