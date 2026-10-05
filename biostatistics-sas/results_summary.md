# Biostatistics (SAS): aggregated results

Aggregated output of `zadanie7_MTHFR665_Hcy.sas` (n = 1 056). Only summary statistics, test results and model estimates are listed. No individual-level records are included.

## Sample

**Genotype MTHFR 665 C>T**

| MTHFR665 | Frequency | Percent | Cumulative Frequency | Cumulative Percent |
|---|---|---|---|---|
| CC | 446 | 42.23 | 446 | 42.23 |
| CT | 508 | 48.11 | 954 | 90.34 |
| TT | 102 | 9.66 | 1056 | 100.00 |

**Case/Control status**

| CaseControl | Frequency | Percent | Cumulative Frequency | Cumulative Percent |
|---|---|---|---|---|
| Case | 264 | 25.00 | 264 | 25.00 |
| Control | 792 | 75.00 | 1056 | 100.00 |

## Part A: homocysteine (Hcy) by genotype

**Descriptive statistics of Hcy [µmol/l] (PROC MEANS)**

| MTHFR665 | N Obs | N | N Miss | Mean | Median | Std Dev | Minimum | Maximum |
|---|---|---|---|---|---|---|---|---|
| CC | 446 | 440 | 6 | 15.97 | 14.60 | 6.43 | 4.07 | 43.50 |
| CT | 508 | 506 | 2 | 15.81 | 14.90 | 5.43 | 1.96 | 38.70 |
| TT | 102 | 102 | 0 | 17.03 | 16.00 | 7.34 | 7.70 | 48.10 |

**Tests for normality, MTHFR665 = CC**

| Test | Statistic | Value | p | p value |
|---|---|---|---|---|
| Shapiro-Wilk | W | 0.901204 | Pr < W | <0.0001 |
| Kolmogorov-Smirnov | D | 0.110768 | Pr > D | <0.0100 |
| Cramer-von Mises | W-Sq | 1.616123 | Pr > W-Sq | <0.0050 |
| Anderson-Darling | A-Sq | 9.668258 | Pr > A-Sq | <0.0050 |

**Tests for normality, MTHFR665 = CT**

| Test | Statistic | Value | p | p value |
|---|---|---|---|---|
| Shapiro-Wilk | W | 0.940393 | Pr < W | <0.0001 |
| Kolmogorov-Smirnov | D | 0.085578 | Pr > D | <0.0100 |
| Cramer-von Mises | W-Sq | 1.149662 | Pr > W-Sq | <0.0050 |
| Anderson-Darling | A-Sq | 7.069988 | Pr > A-Sq | <0.0050 |

**Tests for normality, MTHFR665 = TT**

| Test | Statistic | Value | p | p value |
|---|---|---|---|---|
| Shapiro-Wilk | W | 0.783264 | Pr < W | <0.0001 |
| Kolmogorov-Smirnov | D | 0.173344 | Pr > D | <0.0100 |
| Cramer-von Mises | W-Sq | 0.835758 | Pr > W-Sq | <0.0050 |
| Anderson-Darling | A-Sq | 5.381082 | Pr > A-Sq | <0.0050 |

**Wilcoxon scores (rank sums)**

| MTHFR665 | N | Sum of Scores | Expected Under H0 | Std Dev Under H0 | Mean Score |
|---|---|---|---|---|---|
| CC | 440 | 226872.0 | 230780.0 | 4835.70435 | 515.618182 |
| CT | 506 | 265679.0 | 265397.0 | 4896.17029 | 525.057312 |
| TT | 102 | 57125.0 | 53499.0 | 2904.20499 | 560.049020 |

**Kruskal–Wallis test**

| Chi-Square | DF | Pr > ChiSq |
|---|---|---|
| 1.7877 | 2 | 0.4091 |

**Post-hoc: Dwass–Steel–Critchlow–Fligner pairwise comparisons**

| MTHFR665 | Wilcoxon Z | DSCF Value | Pr > DSCF |
|---|---|---|---|
| CC vs. CT | -0.4819 | 0.6815 | 0.8799 |
| CC vs. TT | -1.3249 | 1.8737 | 0.3813 |
| CT vs. TT | -1.0739 | 1.5188 | 0.5303 |

**Mann–Whitney (Wilcoxon two-sample) pairwise tests**

| Pair | Statistic | Z | One-sided p | Two-sided p | Two-sided p (t approx.) |
|---|---|---|---|---|---|
| CC vs CT | 206320.0 | -0.4818 | 0.3150 | 0.6299 | 0.6301 |
| CC vs TT | 29581.00 | 1.3246 | 0.0927 | 0.1853 | 0.1859 |
| CT vs TT | 32797.00 | 1.0736 | 0.1415 | 0.2830 | 0.2834 |

## Part B: genotype and lung-cancer status

**Testing global null hypothesis: BETA = 0**

| Test | Chi-Square | DF | Pr > ChiSq |
|---|---|---|---|
| Likelihood Ratio | 7.2064 | 2 | 0.0272 |
| Score | 7.2444 | 2 | 0.0267 |
| Wald | 7.2049 | 2 | 0.0273 |

**Type 3 analysis of effects**

| Effect | DF | Wald Chi-Square | Pr > ChiSq |
|---|---|---|---|
| MTHFR665 | 2 | 7.2049 | 0.0273 |

**Maximum likelihood estimates**

| Parameter |  | DF | Estimate | Standard Error | Wald Chi-Square | Pr > ChiSq |
|---|---|---|---|---|---|---|
| Intercept |  | 1 | -0.8882 | 0.1042 | 72.6617 | <.0001 |
| MTHFR665 | CT | 1 | -0.3978 | 0.1499 | 7.0444 | 0.0080 |
| MTHFR665 | TT | 1 | -0.2905 | 0.2556 | 1.2912 | 0.2558 |

**Odds ratios (reference: CC) with 95% Wald CI**

| Effect | Unit | Estimate | 95% CL lower | 95% CL upper |
|---|---|---|---|---|
| MTHFR665 CT vs CC | 1.0000 | 0.672 | 0.501 | 0.901 |
| MTHFR665 TT vs CC | 1.0000 | 0.748 | 0.453 | 1.234 |

**Association of predicted probabilities and observed responses**

| Percent Concordant | 34.2 | Somers' D | 0.098 |
|---|---|---|---|
| Percent Discordant | 24.4 | Gamma | 0.168 |
| Percent Tied | 41.5 | Tau-a | 0.037 |
| Pairs | 209088 | c | 0.549 |

**Contingency table: genotype × status (counts; % of genotype row)**

| Genotype | Case | Control | Total |
|---|---|---|---|
| CC | 130 (29.15%) | 316 (70.85%) | 446 |
| CT | 110 (21.65%) | 398 (78.35%) | 508 |
| TT | 24 (23.53%) | 78 (76.47%) | 102 |
| Total | 264 | 792 | 1 056 |

**Chi-square statistics for genotype × status**

| Statistic | DF | Value | Prob |
|---|---|---|---|
| Chi-Square | 2 | 7.2444 | 0.0267 |
| Likelihood Ratio Chi-Square | 2 | 7.2064 | 0.0272 |
| Mantel-Haenszel Chi-Square | 1 | 4.8890 | 0.0270 |
| Phi Coefficient |  | 0.0828 |  |
| Contingency Coefficient |  | 0.0825 |  |
| Cramer's V |  | 0.0828 |  |

## Figures

In [`figures/`](figures/): Hcy histograms per genotype, Hcy box plot by genotype, Wilcoxon score box plots and the odds-ratio plot. The box plot marks outlying Hcy values as points without identifiers or other variables.
