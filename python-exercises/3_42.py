import pandas as pd
import numpy as np
import os

file_path = "PS_datasets/Olive Oils/Fluorescence_olive_oil_dataset.csv"

df = pd.read_csv(file_path)

print("Kolumny przed czyszczeniem:")
print(df.columns)

print("\nPierwsze 5 wierszy przed czyszczeniem:")
print(df.head())

columns_to_drop = [col for col in ["Var1", "Unnamed: 0"] if col in df.columns]

if columns_to_drop:
    df = df.drop(columns=columns_to_drop)

print("\nKolumny po usunięciu zbędnych kolumn:")
print(df.columns)

print("\nPierwsze 5 wierszy po czyszczeniu:")
print(df.head())

print("\nInformacje o DataFrame:")
df.info()

print("\nTypy danych:")
print(df.dtypes)

print("\nPrzykładowa wartość z kolumny Data:")
print(df.loc[0, "Data"])
print(type(df.loc[0, "Data"]))


def parse_spectrum(s):
    s = str(s).strip()
    s = s.strip("[]")
    s = s.replace(",", " ")
    s = s.replace(";", " ")
    values = np.fromstring(s, sep=" ")
    return values


spectra_series = df["Data"].apply(parse_spectrum)
spectra = np.vstack(spectra_series.values)

df["Spectra"] = list(spectra)

print("\nPierwsze widmo:")
print(df.loc[0, "Spectra"])

print("\nTyp pierwszego widma:")
print(type(df.loc[0, "Spectra"]))

print("\nDługość pierwszego widma:")
print(len(df.loc[0, "Spectra"]))

print("\nRozmiar macierzy spectra:")
print(spectra.shape)

print("\nLiczba unikalnych próbek:")
print(df["Sample"].nunique())

print("\nUnikalne klasy jakości:")
print(df["Quality"].unique())

nan_rows = df.isna().any(axis=1).sum()
print("\nLiczba wierszy z brakującymi wartościami NaN:")
print(nan_rows)


import pandas as pd
import numpy as np

if "Peroxide Index" in df.columns:
    peroxide_col = "Peroxide Index"
elif "PeroxideIndex" in df.columns:
    peroxide_col = "PeroxideIndex"
else:
    raise KeyError("Nie znaleziono kolumny 'Peroxide Index' ani 'PeroxideIndex'.")

print("Używana kolumna dla wskaźnika nadtlenkowego:", peroxide_col)


mean_acidity = df["Acidity"].mean(skipna=True)
median_acidity = df["Acidity"].median(skipna=True)
var_acidity = df["Acidity"].var(skipna=True)
std_acidity = df["Acidity"].std(skipna=True)

print("\nStatystyki dla Acidity:")
print("Średnia:", mean_acidity)
print("Mediana:", median_acidity)
print("Wariancja:", var_acidity)
print("Odchylenie standardowe:", std_acidity)


mean_peroxide = df[peroxide_col].mean(skipna=True)
median_peroxide = df[peroxide_col].median(skipna=True)
var_peroxide = df[peroxide_col].var(skipna=True)
std_peroxide = df[peroxide_col].std(skipna=True)

print("\nStatystyki dla Peroxide Index:")
print("Średnia:", mean_peroxide)
print("Mediana:", median_peroxide)
print("Wariancja:", var_peroxide)
print("Odchylenie standardowe:", std_peroxide)


print("\nPodsumowanie describe() dla Acidity i Peroxide Index:")
print(df[["Acidity", peroxide_col]].describe())


stats_acidity_by_class = df.groupby("Quality")["Acidity"].agg(
    ["mean", "median", "std", "var", "min", "max"]
)

print("\nStatystyki Acidity według klasy Quality:")
print(stats_acidity_by_class)


stats_peroxide_by_class = df.groupby("Quality")[peroxide_col].agg(
    ["mean", "median", "std", "var", "min", "max"]
)

print("\nStatystyki Peroxide Index według klasy Quality:")
print(stats_peroxide_by_class)


df_clean = df.dropna(subset=["Acidity", peroxide_col])

print("\nPorównanie wyników po dropna():")

print("\nAcidity:")
print("Średnia z skipna=True:", df["Acidity"].mean(skipna=True))
print("Średnia po dropna():", df_clean["Acidity"].mean())

print("\nPeroxide Index:")
print("Średnia z skipna=True:", df[peroxide_col].mean(skipna=True))
print("Średnia po dropna():", df_clean[peroxide_col].mean())

print("\nLiczba wierszy przed dropna():", len(df))
print("Liczba wierszy po dropna():", len(df_clean))






import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from scipy.signal import correlate

if "Peroxide Index" in df.columns:
    peroxide_col = "Peroxide Index"
elif "PeroxideIndex" in df.columns:
    peroxide_col = "PeroxideIndex"
else:
    raise KeyError("Nie znaleziono kolumny 'Peroxide Index' ani 'PeroxideIndex'.")

print("Używana kolumna dla wskaźnika nadtlenkowego:", peroxide_col)


df_xy = df[["Acidity", peroxide_col]].dropna()

x = df_xy["Acidity"].to_numpy()
y = df_xy[peroxide_col].to_numpy()

EXY = np.mean(x * y)
print("\nE(XY):", EXY)

cov_manual = np.mean((x - np.mean(x)) * (y - np.mean(y)))
print("\nKowariancja ręcznie, ddof=0:", cov_manual)

cov_numpy_population = np.cov(x, y, ddof=0)[0, 1]
print("Kowariancja NumPy, ddof=0:", cov_numpy_population)

cov_numpy_sample = np.cov(x, y, ddof=1)[0, 1]
print("Kowariancja NumPy, ddof=1:", cov_numpy_sample)

cov_pandas = df_xy["Acidity"].cov(df_xy[peroxide_col])
print("Kowariancja pandas, ddof=1:", cov_pandas)

corr_manual = cov_manual / (np.std(x, ddof=0) * np.std(y, ddof=0))
print("\nKorelacja Pearsona ręcznie:", corr_manual)

corr_numpy = np.corrcoef(x, y)[0, 1]
print("Korelacja Pearsona NumPy:", corr_numpy)

corr_pandas = df_xy["Acidity"].corr(df_xy[peroxide_col])
print("Korelacja Pearsona pandas:", corr_pandas)


print("\nKorelacja pandas bez jawnego dropna():")
print(df["Acidity"].corr(df[peroxide_col]))

print("\nKorelacja NumPy bez dropna() — zwykle da NaN, jeśli są braki:")
print(np.corrcoef(df["Acidity"], df[peroxide_col])[0, 1])


spectrum = np.asarray(df.loc[0, "Spectra"], dtype=float)

acorr = correlate(spectrum, spectrum, mode="full") / len(spectrum)
lags = np.arange(-len(spectrum) + 1, len(spectrum))

plt.figure(figsize=(10, 5))
plt.plot(lags, acorr)
plt.title("Autokorelacja widma próbki 0")
plt.xlabel("Lag")
plt.ylabel("Wartość autokorelacji")
plt.grid(True)
plt.show()


spectrum0 = np.asarray(df.loc[0, "Spectra"], dtype=float)
spectrum1 = np.asarray(df.loc[1, "Spectra"], dtype=float)

xcorr = correlate(spectrum0, spectrum1, mode="full") / len(spectrum0)
lags_xcorr = np.arange(-len(spectrum0) + 1, len(spectrum0))

plt.figure(figsize=(10, 5))
plt.plot(lags_xcorr, xcorr)
plt.title("Korelacja krzyżowa widm próbek 0 i 1")
plt.xlabel("Lag")
plt.ylabel("Wartość korelacji krzyżowej")
plt.grid(True)
plt.show()


columns_of_interest = ["Acidity", "K232", "K270", peroxide_col]

cov_matrix = df[columns_of_interest].cov()
corr_matrix = df[columns_of_interest].corr(method="pearson")

print("\nMacierz kowariancji:")
print(cov_matrix)

print("\nMacierz korelacji Pearsona:")
print(corr_matrix)


corr_abs = corr_matrix.abs()
np.fill_diagonal(corr_abs.values, np.nan)

max_pair = corr_abs.stack().idxmax()
max_value = corr_matrix.loc[max_pair[0], max_pair[1]]

min_pair = corr_abs.stack().idxmin()
min_value = corr_matrix.loc[min_pair[0], min_pair[1]]

print("\nNajsilniej skorelowana para:")
print(max_pair, "r =", max_value)

print("\nNajsłabiej skorelowana para:")
print(min_pair, "r =", min_value)