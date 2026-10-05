% Załóżmy, że sygnał został już:
%  - wczytany,
%  - znormalizowany,
%  - poddany korekcji baseline
%  (jak w poprzednich zadaniach).


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
signal = tic_norm - baseline;       % sygnał po korekcji

% --- Wygładzanie (dla poprawy detekcji pików) ---
signal_smooth = sgolayfilt(signal, 3, 15);

% --- Wykrywanie pików ---
[pk, loc, width] = findpeaks(signal_smooth, time, ...
                             'MinPeakProminence',0.01);

% --- Inicjalizacja tabeli cech ---
nPeaks = length(pk);
features = table('Size',[nPeaks 5], ...
                 'VariableTypes',{'double','double','double','double','double'}, ...
                 'VariableNames',{'t_max','Height','FWHM','Area','Centroid'});

% --- Ekstrakcja cech ---
for i = 1:nPeaks
    % wycinek sygnału wokół piku (± połowa szerokości w FWHM)
    halfWidth = width(i)/2;
    mask = time >= (loc(i)-halfWidth) & time <= (loc(i)+halfWidth);
    
    t_peak = time(mask);
    y_peak = signal_smooth(mask);
    
    % cechy
    t_max    = loc(i);                           % czas retencji (maksimum)
    Height   = pk(i);                            % wysokość
    FWHM     = width(i);                         % szerokość w połowie wysokości
    Area     = trapz(t_peak, y_peak);            % pole pod krzywą (całkowanie num.)
    Centroid = sum(t_peak.*y_peak)/sum(y_peak);  % centroid (środek masy)
    
    features(i,:) = {t_max, Height, FWHM, Area, Centroid};
end

disp(features);
signal_smooth = sgolayfilt(signal, 3, 15);

[pk, loc, width, prom] = findpeaks(signal_smooth, time, ...
    'MinPeakProminence', 0.01);

nPeaks = length(pk);

features = table('Size', [nPeaks 6], ...
    'VariableTypes', {'double','double','double','double','double','double'}, ...
    'VariableNames', {'t_max','Height','FWHM','Area','Centroid','Prominence'});

for i = 1:nPeaks
    halfWidth = width(i)/2;
    mask = time >= (loc(i)-halfWidth) & time <= (loc(i)+halfWidth);

    t_peak = time(mask);
    y_peak = signal_smooth(mask);

    if isempty(t_peak) || isempty(y_peak)
        continue;
    end

    t_max = loc(i);
    Height = pk(i);
    FWHM = width(i);
    Area = trapz(t_peak, y_peak);
    Centroid = sum(t_peak .* y_peak) / sum(y_peak);
    Prominence = prom(i);

    features(i,:) = {t_max, Height, FWHM, Area, Centroid, Prominence};
end

disp(features)

[~, idxHighest] = max(features.Height);

fprintf('\nNajwyższy pik:\n');
fprintf('Numer piku: %d\n', idxHighest);
fprintf('t_max = %.3f s\n', features.t_max(idxHighest));
fprintf('Height = %.5f\n', features.Height(idxHighest));
fprintf('FWHM = %.5f s\n', features.FWHM(idxHighest));
fprintf('Area = %.5f\n', features.Area(idxHighest));
fprintf('Centroid = %.5f s\n', features.Centroid(idxHighest));
fprintf('Prominence = %.5f\n', features.Prominence(idxHighest));

features.Delta_t = features.Centroid - features.t_max;
disp(features)

figure;
plot(time, signal_smooth, 'b-'); hold on;
plot(loc, pk, 'rv', 'MarkerFaceColor', 'r');
xlabel('Retention time [s]');
ylabel('Signal');
title('Detected peaks');
grid on;



