
[h_parity_matrix,g_generator_matrix] = hammgen(3);   
the_syndrome_table = syndtable(h_parity_matrix);

num_frames = 100000;
num_data_bits = num_frames*4;
num_coded_bits = num_frames*7;

awgn_vector = 0:6;  %in dB

ber_before_correction = zeros(1,length(awgn_vector));
ber_after_correction = zeros(1,length(awgn_vector));
probability_bit_error=zeros(1,length(awgn_vector));

for idx=1:length(awgn_vector)
    after_fec = zeros(num_frames,1);   
    before_fec = zeros(num_frames,1);  
    for k = 1:num_frames
        data_bits = randi([0 1],1,4); % Generate binary data                
        encoded_bits = ...
            mod(data_bits*g_generator_matrix,2); % Append Parity bits 
        modulated_data = pskmod(encoded_bits,2); % BPSK modulate
        noise_vector = randn(1,7)+1.0i*randn(1,7);
        noise_vector = noise_vector*sqrt(1/2);
        noise_vector = ... 
            noise_vector*sqrt(10^(-awgn_vector(idx)/10));          
        rxSig = modulated_data + noise_vector;  % AWGN channel, SNR dB     
        demodulated_data = pskdemod(rxSig,2);  % BPSK demodulate
        syndrome = mod(h_parity_matrix*demodulated_data.',2);
        syndrome_de = bi2de(syndrome.','left-msb');
        correction_vector = the_syndrome_table(1+syndrome_de,:); 
        if ~isequal(demodulated_data,encoded_bits)
            before_fec(k)=sum(abs(demodulated_data-encoded_bits));
        end           
        demodulated_data = rem(correction_vector+demodulated_data,2);
        if ~isequal(demodulated_data,encoded_bits)
            after_fec(k)=sum(abs(demodulated_data-encoded_bits));
        end       
    end
    ber_before_correction(idx) = sum(before_fec)/num_coded_bits;
    ber_after_correction(idx) = sum(after_fec)/num_coded_bits; 
    probability_bit_error(idx)=qfunc(sqrt(2*10^(awgn_vector(idx)/10)));
end

figure
semilogy(awgn_vector,ber_after_correction,'-o')
hold on
semilogy(awgn_vector,ber_before_correction,'-x')
semilogy(awgn_vector,probability_bit_error,'-^')
hold off
title('BER Hamming(7,4) Correcting')
xlabel('Eb/N0')
ylabel('BER')
legend('Simulation-Corrected','Simulation-Uncorrected',... 
    'Theory','location','best')
