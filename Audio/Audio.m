%Recording parameters
bitDepth = 16;
duration = 10;
fs=40000;

%First record
record1 = audiorecorder(fs, bitDepth, 1);
disp('Start record 1');

recordblocking(record1, duration);
disp('End of record 1');

input1 = getaudiodata(record1);
audiowrite('input1.wav', input1, fs);



%Second record
record2 = audiorecorder(fs, bitDepth, 1);
disp('Start record 2');

recordblocking(record2, duration);
disp('End of record 2');

input2 = getaudiodata(record2);
audiowrite('input2.wav', input2, fs);

%Filter input1
filtered1=filter(LowPassFilter_1,input1);
audiowrite('filtered1.wav', filtered1, fs);

%Filter input2
filtered2=filter(LowPassFilter_1,input2);
audiowrite('filtered2.wav', filtered2, fs);

%Plotting parameters
n=length(input1);        %number of samples
f=(-n/2:n/2-1)*fs/n;     %Define x-axis

%Plot input1
fft_input1=fft(input1);
figure;
subplot(2,1,1);
plot(f, abs(fftshift(fft_input1)));
title('Input1');




%Plot input1 after filtering
fft_filtered1=fft(filtered1);
subplot(2,1,2);
plot(f, abs(fftshift(fft_filtered1)) );
title('Input1 after filtering');


%Plot input2
fft_input2=fft(input2);
figure;
subplot(2,1,1);
plot(f, abs(fftshift(fft_input2)) );
title('Input2');




%Plot input2 after filtering
fft_output2=fft(filtered2);
subplot(2,1,2);
plot(f, abs(fftshift(fft_output2)) );
title('Input2 after filtering');



%Define carrier parameters
t = (0: n-1) / fs;  %Define time for carrier

f_carrier1 = 5000;   
f_carrier2 = 15000;  

carrier1 = cos(2*pi*f_carrier1*t);
carrier2 = cos(2*pi*f_carrier2*t);

%Modify carrier signals to properly multiply the matrices
carrier1_t = transpose(carrier1);
carrier2_t = transpose(carrier2);

%Amplitude modulation   
modulated1 = filtered1 .* carrier1_t;
modulated2 = filtered2 .* carrier2_t;

%Frequency Division Multiplexing
FDM = modulated1 + modulated2;


%Plotting the modulated and FDM signals
figure;
subplot(3,1,1);
plot(f, abs( fftshift(fft(modulated1)) ) );
title('Modulated 1');

subplot(3,1,2);
plot(f, abs( fftshift(fft(modulated2)) ) );
title('Modulated 2');

subplot(3,1,3);
plot(f, abs( fftshift(fft(FDM)) ) );
title('FDM');


%Demodulation
demodulated1 = FDM .* carrier1_t;
demodulated2 = FDM .* carrier2_t;

output1=2*filter(LowPassFilter_2,demodulated1);
output2=2*filter(LowPassFilter_2,demodulated2);

audiowrite('output1.wav', output1, fs);
audiowrite('output2.wav', output2, fs);

figure;
subplot(2,1,1);
plot(f, abs(fftshift(fft(output1))) );
title("Received 1 (output1)");
subplot(2,1,2);
plot(f, abs(fftshift(fft(output2))) );
title("Received 2 (output2)");

