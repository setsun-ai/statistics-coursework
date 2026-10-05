% --- Wczytanie chromatogramu TIC z pliku CDF ---
filename = 'S40.CDF';   % należy podać nazwę pliku CDF

% Wektor czasu retencji [s]
time = ncread(filename, 'scan_acquisition_time');

% Całkowita intensywność sygnału (Total Ion Chromatogram, TIC)
tic = ncread(filename, 'total_intensity');

% --- Rysowanie chromatogramu w skali liniowej ---
figure;                  % utworzenie nowego okna wykresu
subplot(2,1,1);          % górny panel wykresu
plot(time, tic, 'b-');   % niebieska linia
xlabel('Retention time [s]');
ylabel('Total Ion Intensity');
title('Total Ion Chromatogram (linear scale)');
grid on;                 % siatka pomocnicza

% --- Rysowanie chromatogramu w skali logarytmicznej ---
subplot(2,1,2);          % dolny panel wykresu
loglog(time, tic, 'r-'); % skala logarytmiczna osi Y
xlabel('Retention time [s]');
ylabel('Total Ion Intensity (log)');
title('Total Ion Chromatogram (log scale)');
grid on;
