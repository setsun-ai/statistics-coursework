% --- Wczytanie chromatogramu TIC z pliku CDF ---
filename = 'S40.CDF';   % należy podać nazwę pliku
time = ncread(filename, 'scan_acquisition_time');
tic  = ncread(filename, 'total_intensity');

% --- Normalizacja do maksimum ---
tic_norm = tic / max(tic);

% --- Korekcja linii podstawowej (dopasowanie wielomianu) ---
polyOrder = 3;                             % rząd wielomianu
p = polyfit(time, tic_norm, polyOrder);    % dopasowanie wielomianu
baseline = polyval(p, time);               % wyznaczenie linii podstawowej
tic_corrected = tic_norm - baseline;       % sygnał po korekcji

% --- Rysowanie ---
figure;

subplot(3,1,1);
plot(time, tic_norm, 'b-'); hold on;
plot(time, baseline, 'r--','LineWidth',1.2);
xlabel('Retention time [s]');
ylabel('Intensity (norm.)');
title('Normalized chromatogram + fitted baseline');
legend('Normalized TIC','Baseline');

subplot(3,1,2);
plot(time, tic_corrected, 'k-');
xlabel('Retention time [s]');
ylabel('Corrected intensity');
title('Chromatogram after baseline subtraction');

subplot(3,1,3);
semilogy(time, tic_corrected, 'm-');
xlabel('Retention time [s]');
ylabel('Corrected intensity (log)');
title('Chromatogram after baseline subtraction (log scale)');