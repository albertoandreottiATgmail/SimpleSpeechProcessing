f0 = 8192/24000;   % norm. frequency
b = fir1(14, f0); % FIR filter coefficients
freqz(b);         % Plot Frequency Response