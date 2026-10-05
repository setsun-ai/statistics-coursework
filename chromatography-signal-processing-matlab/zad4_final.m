% --- Wczytanie chromatogramu TIC ---
filename = 'C01.CDF';   % <- podaj plik
time = ncread(filename, 'scan_acquisition_time');
tic  = ncread(filename, 'total_intensity');

% --- Normalizacja i baseline correction ---
tic_norm = tic / max(tic);
p = polyfit(time, tic_norm, 3);
baseline = polyval(p, time);
signal = tic_norm - baseline;

% --- Wygładzanie różnymi metodami ---
N = 15;  % długość okna (należy dopasować do danych)

sig_movmean = smoothdata(signal,'movmean',N);
sig_sgolay  = sgolayfilt(signal,3,N);   % rząd 3, okno N
d = designfilt('lowpassiir','FilterOrder',8, ...
               'HalfPowerFrequency',0.05,'DesignMethod','butter');
sig_butter  = filtfilt(d,signal);

% --- Porównanie przebiegów ---
figure;
plot(time, signal, 'k-', 'DisplayName','Original'); hold on;
plot(time, sig_movmean, 'r-', 'DisplayName','MovMean');
plot(time, sig_sgolay, 'b-', 'DisplayName','Savitzky-Golay');
plot(time, sig_butter, 'g-', 'DisplayName','Butterworth');
xlabel('Retention time [s]');
ylabel('Corrected intensity');
title('Chromatogram smoothing methods');
legend; grid on;

% --- Detekcja pików + obliczenie FWHM ---
[pk,loc,width,prom] = findpeaks(sig_sgolay, time,'MinPeakProminence',0.01);

% Wyświetlenie wyników dla pierwszego wykrytego piku
fprintf('Wysokość piku: %.3f\n', pk(1));
fprintf('Czas retencji: %.2f s\n', loc(1));
fprintf('FWHM: %.2f s\n', width(1));
