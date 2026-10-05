'PS_datasets/Olive Oils/Fluorescence_olive_oil_dataset.csv'

import pandas as pd
import os
dataset_directory = r"PS_datasets/Olive Oils"
file_path = os.path.join(dataset_directory,
"Fluorescence_olive_oil_dataset.csv")
df = pd.read_csv(file_path)










import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from scipy import stats

if "Peroxide Index" in df.columns:
    peroxide_col = "Peroxide Index"
elif "PeroxideIndex" in df.columns:
    peroxide_col = "PeroxideIndex"
else:
    raise KeyError("Nie znaleziono kolumny 'Peroxide Index' ani 'PeroxideIndex'.")

print("Używana kolumna dla wskaźnika nadtlenkowego:", peroxide_col)


for bins in [10, 20, 40]:
    plt.figure(figsize=(8, 5))
    plt.hist(df["Acidity"].dropna(), bins=bins, edgecolor="black")
    plt.xlabel("Acidity")
    plt.ylabel("Liczność")
    plt.title(f"Histogram kwasowości — bins={bins}")
    plt.grid(True)
    plt.show()












































plt.figure(figsize=(6, 5))
plt.boxplot(df[peroxide_col].dropna())
plt.ylabel("Peroxide Index")
plt.title("Wykres pudełkowy dla Peroxide Index")
plt.grid(True)
plt.show()


plt.figure(figsize=(6, 6))
stats.probplot(df["K232"].dropna(), dist="norm", plot=plt)
plt.title("QQ-plot dla K232 — rozkład normalny")
plt.grid(True)
plt.show()


plt.figure(figsize=(6, 6))
stats.probplot(df["K232"].dropna(), dist="expon", plot=plt)
plt.title("QQ-plot dla K232 — rozkład wykładniczy")
plt.grid(True)
plt.show()


x_axis = range(len(df.loc[0, "Spectra"]))
y_spectrum = df.loc[0, "Spectra"]

plt.figure(figsize=(10, 5))
plt.plot(x_axis, y_spectrum)
plt.xlabel("Kanał detektora")
plt.ylabel("Intensywność")
plt.title("Widmo fluorescencyjne — próbka 0")
plt.grid(True)
plt.show()


sample_id = 10

x_axis_2 = range(len(df.loc[sample_id, "Spectra"]))
y_spectrum_2 = df.loc[sample_id, "Spectra"]

plt.figure(figsize=(10, 5))
plt.plot(x_axis_2, y_spectrum_2)
plt.xlabel("Kanał detektora")
plt.ylabel("Intensywność")
plt.title(f"Widmo fluorescencyjne — próbka {sample_id}")
plt.grid(True)
plt.show()


plt.figure(figsize=(10, 5))
plt.plot(x_axis, y_spectrum, label="Próbka 0")
plt.plot(x_axis_2, y_spectrum_2, label=f"Próbka {sample_id}")
plt.xlabel("Kanał detektora")
plt.ylabel("Intensywność")
plt.title("Porównanie widm fluorescencyjnych")
plt.legend()
plt.grid(True)
plt.show()


plt.figure(figsize=(10, 5))
plt.semilogy(x_axis, y_spectrum)
plt.xlabel("Kanał detektora")
plt.ylabel("Intensywność (log)")
plt.title("Widmo fluorescencyjne — skala logarytmiczna")
plt.grid(True)
plt.show()

counts = df["Quality"].value_counts()

plt.figure(figsize=(8, 5))
counts.plot(kind="bar")
plt.title("Liczba próbek w klasach jakości")
plt.xlabel("Quality")
plt.ylabel("Liczność")
plt.xticks(rotation=0)
plt.grid(axis="y")
plt.show()


plt.figure(figsize=(7, 7))
counts.plot(kind="pie", autopct="%1.1f%%")
plt.ylabel("")
plt.title("Procentowy udział klas jakości")
plt.show()


mean_acidity = df.groupby("Quality")["Acidity"].mean()

plt.figure(figsize=(8, 5))
mean_acidity.plot(kind="bar")
plt.title("Średnia kwasowość w klasach jakości")
plt.xlabel("Quality")
plt.ylabel("Średnia Acidity")
plt.xticks(rotation=0)
plt.grid(axis="y")
plt.show()


var_peroxide = df.groupby("Quality")[peroxide_col].var()

plt.figure(figsize=(8, 5))
var_peroxide.plot(kind="bar")
plt.title("Wariancja Peroxide Index w klasach jakości")
plt.xlabel("Quality")
plt.ylabel("Wariancja Peroxide Index")
plt.xticks(rotation=0)
plt.grid(axis="y")
plt.show()