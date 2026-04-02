
[h_parity_matrix,g_generator_matrix] = hammgen(3);   
the_syndrome_table = syndtable(h_parity_matrix);

data_bits = [1 1 1 1];
hamming_coded_bits = mod(data_bits*g_generator_matrix,2)
syndrome_result = mod(hamming_coded_bits*h_parity_matrix.',2);

coded_bit_error_vector = [0 0 0 0 0 0 0];
hamming_coded_bits_in_error = ...
    mod(hamming_coded_bits+coded_bit_error_vector,2);
syndrome_result = mod(hamming_coded_bits_in_error*h_parity_matrix.',2);
syndrome_decimal = bi2de(syndrome_result,'left-msb');
correction_vector = the_syndrome_table(1+syndrome_decimal,:);
corrected_hamming_coded_bits_no_error = ...
    mod(correction_vector+hamming_coded_bits_in_error,2)


coded_bit_error_vector = [0 1 0 0 0 0 0];
hamming_coded_bits_in_error = ...
    mod(hamming_coded_bits+coded_bit_error_vector,2);
syndrome_result = mod(hamming_coded_bits_in_error*h_parity_matrix.',2);
syndrome_decimal = bi2de(syndrome_result,'left-msb');
correction_vector = the_syndrome_table(1+syndrome_decimal,:); 
corrected_hamming_coded_bits_one_error =...
    mod(correction_vector+hamming_coded_bits_in_error,2)


coded_bit_error_vector = [0 1 0 1 0 0 0];
hamming_coded_bits_in_error = ...
    mod(hamming_coded_bits+coded_bit_error_vector,2);
syndrome_result = mod(hamming_coded_bits_in_error*h_parity_matrix.',2);
syndrome_decimal = bi2de(syndrome_result,'left-msb');
correction_vector = the_syndrome_table(1+syndrome_decimal,:); 
corrected_hamming_coded_bits_two_errors = ...
    rem(correction_vector+hamming_coded_bits_in_error,2)


coded_bit_error_vector = [0 1 0 1 0 1 0];
hamming_coded_bits_in_error = ...
    mod(hamming_coded_bits+coded_bit_error_vector,2);
syndrome_result = mod(hamming_coded_bits_in_error*h_parity_matrix.',2);
syndrome_decimal = bi2de(syndrome_result,'left-msb');
correction_vector = the_syndrome_table(1+syndrome_decimal,:); 
corrected_hamming_coded_bits_three_errors_v1 = ... 
    rem(correction_vector+hamming_coded_bits_in_error,2)


coded_bit_error_vector = [1 1 0 1 0 0 0];
hamming_coded_bits_in_error = ...
    mod(hamming_coded_bits+coded_bit_error_vector,2);
syndrome_result = mod(hamming_coded_bits_in_error*h_parity_matrix.',2);
syndrome_decimal = bi2de(syndrome_result,'left-msb');
correction_vector = the_syndrome_table(1+syndrome_decimal,:); 
corrected_hamming_coded_bits_three_errors_v2 = ...
    rem(correction_vector+hamming_coded_bits_in_error,2)