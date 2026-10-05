% --- Wczytanie chromatogramu TIC z pliku CDF ---
filename = 'C01.CDF';   % należy podać nazwę pliku
time = ncread(filename, 'scan_acquisition_time');
tic  = ncread(filename, 'total_intensity');

% --- Normalizacja ---
tic_norm = tic / max(tic);

% --- Usunięcie linii podstawowej (dopasowanie wielomianu 3. rzędu) ---
p = polyfit(time, tic_norm, 3);
baseline = polyval(p, time);
tic_corr = tic_norm - baseline;

% --- Parametry sygnału ---
dt = mean(diff(time));     % krok czasowy [s]
Fs = 1/dt;                 % częstotliwość próbkowania [Hz]
N = length(tic_norm);      % liczba próbek

% --- FFT: przed i po korekcji baseline ---
f = (-N/2:N/2-1)*(Fs/N);   % wektor częstotliwości
Y_corr = fftshift(fft(tic_corr));

% --- PSD (Welch) ---
[pxx_corr,fwelch2] = pwelch(tic_corr,[],[],[],Fs);

% --- Rysowanie ---
figure;

subplot(2,1,1);
plot(f, abs(Y_corr)/N, 'b-', 'DisplayName','Corrected (baseline removed)');
xlim([0 1]); grid on;
xlabel('Frequency [Hz]');
ylabel('|FFT|');
title('FFT');
legend;

subplot(2,1,2);
plot(fwelch2,10*log10(pxx_corr),'b-', 'DisplayName','Corrected (baseline removed)');
xlim([0 1]); grid on;
xlabel('Frequency [Hz]');
ylabel('PSD [dB/Hz]');
title('Power Spectral Density (Welch)');
legend;