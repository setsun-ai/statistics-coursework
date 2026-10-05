import os
import json
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

from sklearn.preprocessing import MinMaxScaler, StandardScaler
from scipy.stats import zscore

# =========================
# 1. Wczytanie danych
# =========================

file_path = r"PS_datasets/Olive Oils/Fluorescence_olive_oil_dataset.csv"

df = pd.read_csv(file_path)

# Usunięcie zbędnej kolumny, jeśli istnieje
for col in ["Var1", "Unnamed: 0"]:
    if col in df.columns:
        df = df.drop(columns=[col])

# Konwersja kolumny Data do macierzy Spectra
# Najpierw próbujemy JSON, a jeśli nie zadziała, używamy np.fromstring
def parse_spectrum(s):
    try:
        return np.array(json.loads(s))
    except:
        return np.fromstring(str(s).strip("[]"), sep=",")

spectra = df["Data"].apply(parse_spectrum)
spectra = np.vstack(spectra.values)
df["Spectra"] = list(spectra)

print("Rozmiar macierzy widm:", spectra.shape)
print(df.head())

x = df["Acidity"].dropna().values.reshape(-1, 1)

scaler = MinMaxScaler(feature_range=(0, 1))
x_norm = scaler.fit_transform(x)

print("Acidity przed normalizacją:")
print("min =", x.min())
print("max =", x.max())

print("\nAcidity po normalizacji:")
print("min =", x_norm.min())
print("max =", x_norm.max())

plt.hist(x, bins=20, alpha=0.5, label="Oryginał")
plt.hist(x_norm, bins=20, alpha=0.5, label="Znormalizowane")
plt.xlabel("Acidity")
plt.ylabel("Liczność")
plt.title("Normalizacja Acidity do [0, 1]")
plt.legend()
plt.show()