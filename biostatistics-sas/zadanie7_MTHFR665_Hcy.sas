/*============================================================
  ZADANIE 7
  Analiza poziomu homocysteiny (Hcy) w kontekscie genotypu
  MTHFR 665 C>T oraz wplyw tego genotypu na ryzyko raka pluca.

  Dane: C1metabolismlungcancerv2.xlsx  (arkusz: onetothree)
  Zmienne uzyte w analizie:
     Hcy         - poziom homocysteiny (zmienna ciagla)
     MTHFR665    - genotyp: CC, CT, TT (zmienna kategoryczna)
     CaseControl - status: Case (chory) / Control (zdrowy)

  Logika analizy:
    CZESC A (pytanie 1): czy poziom Hcy rozni sie miedzy genotypami?
       -> statystyki opisowe -> test normalnosci ->
          Kruskal-Wallis (dane nienormalne) lub ANOVA (dane normalne)
          -> testy post-hoc (ktore pary genotypow sie roznia)
    CZESC B (pytanie 2): czy genotyp wplywa na ryzyko raka pluca?
       -> regresja logistyczna (Odds Ratio) + tabela kontyngencji
==============================================================*/


/*------------------------------------------------------------
  KROK 0: Ustawienie sciezki do pliku
  >>> ZMIEN ponizsza sciezke na wlasciwa na swoim komputerze <<<
------------------------------------------------------------*/
%LET plik = C1metabolismlungcancerv2.xlsx;


/*------------------------------------------------------------
  KROK 1: Wczytanie danych z pliku Excel
  - GETNAMES=YES  -> pierwszy wiersz to nazwy kolumn
  - DATAROW=2     -> dane zaczynaja sie od wiersza 2
------------------------------------------------------------*/
PROC IMPORT
    DATAFILE="&plik."
    OUT=dane
    DBMS=XLSX
    REPLACE;
    GETNAMES=YES;
    DATAROW=2;
RUN;

/* Kontrola wczytania danych: struktura zbioru (zmienne, typy, liczba
   obserwacji) zamiast PROC PRINT. Dane dotycza uczestnikow badania,
   wiec output nie powinien wypisywac pojedynczych rekordow; liczebnosci
   sprawdza ponizszy PROC FREQ. */
PROC CONTENTS DATA=dane;
    TITLE "Struktura zbioru danych";
RUN;

/* Liczebnosci genotypow oraz status Case/Control */
PROC FREQ DATA=dane;
    TABLES MTHFR665 CaseControl;
    TITLE "Liczebnosci: genotyp MTHFR 665 C>T oraz status Case/Control";
RUN;


/*============================================================
  CZESC A: POZIOM Hcy W KONTEKSCIE GENOTYPU MTHFR 665 C>T
============================================================*/

/*------------------------------------------------------------
  KROK 2: Statystyki opisowe Hcy wedlug genotypu
------------------------------------------------------------*/
PROC MEANS DATA=dane N NMISS MEAN MEDIAN STD MIN MAX MAXDEC=2;
    CLASS MTHFR665;
    VAR Hcy;
    TITLE "Statystyki opisowe homocysteiny wedlug genotypu MTHFR 665 C>T";
RUN;

/*------------------------------------------------------------
  KROK 3: Wykres pudelkowy (boxplot) - rozklad Hcy w grupach
------------------------------------------------------------*/
PROC SGPLOT DATA=dane;
    VBOX Hcy / CATEGORY=MTHFR665;
    XAXIS LABEL="Genotyp MTHFR 665 C>T";
    YAXIS LABEL="Poziom homocysteiny (umol/l)";
    TITLE "Rozklad homocysteiny wedlug genotypu MTHFR 665 C>T";
RUN;

/*------------------------------------------------------------
  KROK 4: Test normalnosci Shapiro-Wilka (osobno dla genotypu)
  - H0: dane maja rozklad normalny
  - p < 0.05  -> odrzucamy H0 -> brak normalnosci -> Kruskal-Wallis
  - p >= 0.05 -> brak podstaw do odrzucenia H0 -> ANOVA
  (Dla danych biologicznych zwykle wychodzi brak normalnosci.)
------------------------------------------------------------*/
PROC SORT DATA=dane; BY MTHFR665; RUN;

/* ODS EXCLUDE: tabela Extreme Observations wypisuje pojedyncze wartosci
   Hcy wraz z numerami obserwacji, czyli dane na poziomie uczestnika. */
ODS EXCLUDE ExtremeObs;
PROC UNIVARIATE DATA=dane NORMAL;
    BY MTHFR665;
    VAR Hcy;
    HISTOGRAM Hcy / NORMAL;
    TITLE "Test normalnosci Shapiro-Wilka dla Hcy wedlug genotypu";
RUN;

/*------------------------------------------------------------
  KROK 5A: Test Kruskala-Wallisa  (sciezka NIEPARAMETRYCZNA)
  - Stosujemy, gdy Shapiro-Wilk wykazal brak normalnosci.
  - H0: rozklady (mediany) Hcy sa jednakowe we wszystkich grupach
  - p < 0.05 -> przynajmniej jedna grupa rozni sie od pozostalych
  - WILCOXON dla >2 grup = test Kruskala-Wallisa
  - DSCF = post-hoc Dwass-Steel-Critchlow-Fligner (porownania parami)
------------------------------------------------------------*/
PROC NPAR1WAY DATA=dane WILCOXON DSCF;
    CLASS MTHFR665;
    VAR Hcy;
    TITLE "Kruskal-Wallis + post-hoc DSCF: Hcy wedlug genotypu MTHFR 665 C>T";
RUN;

/*------------------------------------------------------------
  KROK 5B: ANOVA  (sciezka PARAMETRYCZNA - alternatywa)
  - Stosujemy TYLKO, gdy Shapiro-Wilk NIE wykazal odchylen.
  - MODEL Hcy = MTHFR665 : Hcy wyjasniane przez genotyp
  - HOVTEST = test jednorodnosci wariancji (zalozenie ANOVA)
  - TUKEY   = test post-hoc (ktore pary grup sie roznia)
  >>> Odkomentuj ponizszy blok, jesli dane sa normalne <<<
------------------------------------------------------------*/
/*
PROC GLM DATA=dane;
    CLASS MTHFR665;
    MODEL Hcy = MTHFR665;
    MEANS MTHFR665 / TUKEY HOVTEST;
    TITLE "ANOVA + Tukey: Hcy wedlug genotypu MTHFR 665 C>T";
RUN;
QUIT;
*/

/*------------------------------------------------------------
  KROK 6 (opcjonalnie): Reczne porownania parami testem
  Manna-Whitneya z korekta Bonferroniego.
  Alternatywa dla post-hoc DSCF z KROKU 5A.
  Przy 3 porownaniach prog istotnosci = 0.05 / 3 = 0.0167
  -> pare uznajemy za istotna, gdy p < 0.0167.
  >>> Odkomentuj, jesli chcesz wykonac te porownania <<<
------------------------------------------------------------*/

DATA para_CC_CT; SET dane; WHERE MTHFR665 IN ('CC','CT'); RUN;
DATA para_CC_TT; SET dane; WHERE MTHFR665 IN ('CC','TT'); RUN;
DATA para_CT_TT; SET dane; WHERE MTHFR665 IN ('CT','TT'); RUN;

PROC NPAR1WAY DATA=para_CC_CT WILCOXON; CLASS MTHFR665; VAR Hcy;
    TITLE "Post-hoc (Mann-Whitney): CC vs CT"; RUN;
PROC NPAR1WAY DATA=para_CC_TT WILCOXON; CLASS MTHFR665; VAR Hcy;
    TITLE "Post-hoc (Mann-Whitney): CC vs TT"; RUN;
PROC NPAR1WAY DATA=para_CT_TT WILCOXON; CLASS MTHFR665; VAR Hcy;
    TITLE "Post-hoc (Mann-Whitney): CT vs TT"; RUN;



/*============================================================
  CZESC B: WPLYW GENOTYPU MTHFR 665 C>T NA RYZYKO RAKA PLUCA
============================================================*/

/*------------------------------------------------------------
  KROK 7: Regresja logistyczna - genotyp a ryzyko raka pluca
  - Zmienna zalezna (Y): outcome (1 = Case/chory, 0 = Control/zdrowy)
  - Zmienna niezalezna (X): MTHFR665 (CC, CT, TT)
  - REF='CC' -> genotyp CC jest grupa referencyjna
  - Wynik: Odds Ratio (OR) z 95% przedzialem ufnosci (CLODDS)
       OR > 1 -> genotyp zwieksza szanse raka pluca
       OR < 1 -> genotyp zmniejsza szanse raka pluca
       OR = 1 -> brak wplywu
------------------------------------------------------------*/

/* Tworzymy zmienna binarna 0/1 z tekstu Case/Control */
DATA dane2;
    SET dane;
    IF CaseControl = 'Case'    THEN outcome = 1;
    ELSE IF CaseControl = 'Control' THEN outcome = 0;
RUN;

PROC LOGISTIC DATA=dane2;
    CLASS MTHFR665 (REF='CC') / PARAM=REF;
    MODEL outcome(EVENT='1') = MTHFR665 / CLODDS=WALD;
    TITLE "Regresja logistyczna: wplyw genotypu MTHFR 665 C>T na ryzyko raka pluca";
RUN;

/*------------------------------------------------------------
  KROK 8: Tabela kontyngencji genotyp x Case/Control
  - CHISQ   = test chi-kwadrat (czy rozklad genotypow rozni sie
              miedzy chorymi a zdrowymi)
  - RELRISK = iloraz szans (OR) liczony bezposrednio z tabeli
  - MEASURES = dodatkowe miary zaleznosci
------------------------------------------------------------*/
PROC FREQ DATA=dane;
    TABLES MTHFR665 * CaseControl / CHISQ RELRISK;
    TITLE "Tabela kontyngencji: genotyp MTHFR 665 C>T vs rak pluca";
RUN;

TITLE;
