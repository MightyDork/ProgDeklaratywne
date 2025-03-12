/* definiujemy relacje nad(X,Y), spelniona, gdy klocek x lezy nad klockiem Y
(niekoniecznie bezposrendio) */

na(d,c).
na(c,a).
na(c,b).
na(a,e).
na(b,g).
nad(X,Y):-na(X,Y).
nad(X,Y):-na(X,Z),nad(Z,Y).

/* Czy kloeck d lezy nad b?
?-nad(d,b).
true,
false.*/
