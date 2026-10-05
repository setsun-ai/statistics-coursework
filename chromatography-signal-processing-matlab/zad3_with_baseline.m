% --- Wczytanie chromatogramu TIC z pliku CDF ---
filename = 'C01.CDF';   % <- podaj swój plik
time = ncread(filename, 'scan_acquisition_time');
tic  = ncread(filename, 'total_intensity');

% --- Normalizacja ---
tic_norm = tic / max(tic);

% --- Usunięcie baseline (dopasowanie 3. rzędu) ---
p = polyfit(time, tic_norm, 3);
baseline = polyval(p, time);
tic_corr = tic_norm - baseline;

% --- Parametry sygnału ---
dt = mean(diff(time));          
Fs = 1/dt;                      
N = length(tic_norm);           

% --- FFT przed ---
Y_raw = fftshift(fft(tic_norm));
f = (-N/2:N/2-1)*(Fs/N);

% --- FFT po ---
Y_corr = fftshift(fft(tic_corr));

% --- PSD (Welch) ---
[pxx_raw,fwelch]   = pwelch(tic_norm,[],[],[],Fs);
[pxx_corr,fwelch2] = pwelch(tic_corr,[],[],[],Fs);

% --- Rysowanie ---
figure;

subplot(2,1,1);
plot(f, abs(Y_raw)/N, 'r-', 'DisplayName','Raw (with baseline)'); hold on;
plot(f, abs(Y_corr)/N, 'b-', 'DisplayName','Corrected (baseline removed)');
xlim([0 1]);
xlabel('Frequency [Hz]');
ylabel('|FFT|');
title('FFT of chromatogram (raw vs. baseline corrected)');
legend; grid on;

subplot(2,1,2);
plot(fwelch,10*log10(pxx_raw),'r-', 'DisplayName','Raw (with baseline)'); hold on;
plot(fwelch2,10*log10(pxx_corr),'b-', 'DisplayName','Corrected (baseline removed)');
xlim([0 1]);
xlabel('Frequency [Hz]');
ylabel('PSD [dB/Hz]');
title('Power Spectral Density (Welch) - comparison');
legend; grid on;
