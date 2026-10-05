# Statistics coursework: biostatistics in SAS and chromatographic signal processing

**MSc coursework.** Two applied-statistics courses in one repository:
- a SAS analysis of a genetic association study (MTHFR genotype, homocysteine, lung cancer),
- signal processing of GC-MS chromatograms in MATLAB, with small Python data-preparation exercises.

<img src="biostatistics-sas/figures/ORPlot.png" width="45%">

## Context & motivation

- **Biostatistics:** genetic association studies ask two typical questions. Does a genotype shift a continuous biomarker? Is it associated with disease status? Answering them correctly means:
  - checking distributional assumptions,
  - choosing parametric or rank-based tests accordingly,
  - correcting for multiple pairwise comparisons,
  - reporting effect sizes (odds ratios with confidence intervals), not only p-values.

  The course (*Biostatistics*) trained this workflow in SAS, the standard tool in clinical and industrial statistics.
- **Statistical Programming:** analytical-chemistry signals need preprocessing before any peak can be quantified: normalisation, baseline removal, smoothing and peak detection. The course trained these steps across MATLAB, Python and R on real instrument data.

## 1. Biostatistics in SAS (`biostatistics-sas/`)

**Data:** a case–control dataset of 1 056 participants: MTHFR 665 C>T genotype, plasma homocysteine (Hcy) and lung-cancer status.

**Method:**
- descriptive statistics and normality tests (Shapiro–Wilk per genotype),
- Kruskal–Wallis with Dwass–Steel–Critchlow–Fligner post-hoc tests,
- logistic regression (reference: CC) with Wald CIs,
- χ² test with Cramér's V.

**Key results** (full tables in [`results_summary.md`](biostatistics-sas/results_summary.md)):
- **Hcy vs genotype:** not normally distributed in any group (Shapiro–Wilk p < 0.0001). No difference between genotypes (Kruskal–Wallis χ² = 1.79, p = 0.41; all DSCF pairs p > 0.38).
- **Genotype vs status:** associated (Type 3 Wald p = 0.027; χ² p = 0.027).
  - CT vs CC: OR = 0.67 (95 % CI 0.50–0.90).
  - TT vs CC: OR = 0.75 (CI 0.45–1.23, not significant).
- **Effect size:** the association is weak (Cramér's V = 0.083; model c-statistic = 0.549). Single-factor and observational, so not a causal claim.

Files:
- `zadanie7_MTHFR665_Hcy.sas`: annotated SAS script,
- `results_summary.md` and `figures/`: aggregated output,
- `presentation.pdf`: presentation of the results (Polish).

## 2. GC-MS chromatogram processing in MATLAB (`chromatography-signal-processing-matlab/`)

Total-ion chromatograms of apple-wine fermentation samples, read from netCDF (`.CDF`) files:
1. raw TIC in linear vs logarithmic scale (trace components),
2. normalisation and polynomial baseline correction,
3. FFT and Welch power spectral density before and after baseline removal,
4. smoothing (moving mean vs Savitzky–Golay) and peak detection with FWHM (`findpeaks`),
5. a combined processing pipeline.

Files: `zad1–5_final.m` and `lab4_report.pdf` (Polish).

## 3. Python exercises (`python-exercises/`)

Basic plotting, plus cleaning and scaling of an olive-oil fluorescence dataset (column clean-up, outlier checks, min–max and z-score scaling) with pandas, NumPy, SciPy and scikit-learn.

## Data availability & privacy

- **Biostatistics dataset** (`C1metabolismlungcancerv2.xlsx`): **not included**. It contains individual genotypes, biomarker levels and disease status, which is health data. It was course material and is available only from the course instructors. **No individual-level participant data are distributed in this repository.** The SAS script no longer prints example rows or extreme observations, and the results contain only group-level summaries.
- **GC-MS data:** public. *GC-MS Analysis for Apple Wine Fermentation*, University of Copenhagen Chemometrics group: <https://ucphchemometrics.com/applewine/> (~1.3 GB, not copied here).
- **Olive-oil fluorescence:** public. Venturini F. et al., *Dataset of Fluorescence Spectra and Chemical Parameters of Olive Oils*, Mendeley Data, CC BY 4.0, <https://data.mendeley.com/datasets/thkcz3h6n6/6>. The scripts expect it in `PS_datasets/Olive Oils/`.

## Scope

- **Set by the course:**
  - the biostatistics task (task 7: the two research questions and the dataset),
  - the MATLAB lab sequence (instructions 1–5 on the apple-wine chromatograms),
  - the Python exercise list.
- **My decisions:**
  - the test selection logic (normality → rank test → post-hoc),
  - reporting effect sizes and model discrimination alongside p-values,
  - the interpretation,
  - removing participant-level output from this repository.

## AI usage

AI-assisted development was used for implementation and documentation. Method choice, validation strategy, data-handling decisions, result verification and interpretation were reviewed and owned by me.

## License

Code: MIT (see [LICENSE](LICENSE)). The datasets belong to their owners (see above) and are not covered by this licence.

---

## 🇵🇱 Opis po polsku

Wybrane zadania z przedmiotów *Biostatystyka* i *Programowanie statystyczne* (kierunek InfoBioChem, studia II stopnia, Politechnika Gdańska, 2026):

- **SAS:** genotyp MTHFR 665 a homocysteina i rak płuca.
  - Brak różnic Hcy między genotypami (Kruskal–Wallis p = 0,41).
  - Słaba, ale istotna asocjacja genotypu ze statusem (p = 0,027; CT vs CC OR = 0,67).
  - Wyniki tylko zagregowane, bez danych pojedynczych uczestników.
- **MATLAB:** obróbka chromatogramów TIC (normalizacja, linia bazowa, FFT/PSD, wygładzanie, detekcja pików i FWHM).
- **Python:** ćwiczenia na zbiorze fluorescencji oliwy.

**Dane:**
- Zbiór kliniczny nie jest publikowany: to dane zdrowotne, dostępne tylko u prowadzących.
- Zbiory GC-MS i oliwy są publiczne (linki wyżej).

**Wsparcie AI:** kod i dokumentacja powstały z pomocą narzędzi AI. Wybór metody, decyzje dotyczące danych, weryfikacja i interpretacja wyników należały do mnie.
