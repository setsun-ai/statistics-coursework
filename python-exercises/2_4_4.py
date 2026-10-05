import matplotlib.pyplot as plt
import numpy as np
x = np.linspace(0, 2*np.pi, 100)
y = np.sin(x)
plt.plot(x, y)
plt.show() # otwiera okno z wykresem i zatrzymuje program, dopóki okno nie zostanie zamknięte
plt.plot(x, y)
plt.xlabel("x")
plt.ylabel("sin(x)")
plt.title("Wykres funkcji sinus")
plt.grid(True)
plt.show()
plt.figure(1)
plt.plot(x, np.sin(x))
plt.figure(2)
plt.plot(x, np.cos(x))
plt.show() # wyświetla oba okna jednocześnie
plt.plot(x, np.sin(x), 'r--', label="sin(x)") # czerwona linia przerywana
plt.plot(x, np.cos(x), 'b:', label="cos(x)") # niebieska linia kropkowana
plt.legend()
plt.title("sin(x) i cos(x)")
plt.show()

plt.subplot(2, 1, 1) # 2 wiersze, 1 kolumna, pierwszy wykres
plt.plot(x, np.sin(x))
plt.title("sin(x)")
plt.subplot(2, 1, 2) # drugi wykres
plt.plot(x, np.cos(x))
plt.title("cos(x)")
plt.tight_layout() # automatyczne dopasowanie
plt.show()

plt.plot(x, y, 'k--*') # czarna przerywana linia z gwiazdkami
plt.show()

# wykres punktowy
plt.scatter([1, 2, 3], [4, 5, 6])
# wykres słupkowy
plt.bar(["A", "B", "C"], [5, 7, 3])
# histogram
plt.hist(np.random.randn(1000), bins=20)
# wykres kołowy
plt.pie([30, 50, 20], labels=["A", "B", "C"])
# wykres „szpilkowy”
plt.stem([1, 2, 3], [2, 4, 6])
# wykres powierzchniowy
plt.fill_between(x, np.sin(x), color="skyblue", alpha=0.4)
plt.show()