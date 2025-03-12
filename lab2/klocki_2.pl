% PROGRAM: klocki_2
% Baza wiedzy o ukladzie klocków
% Definiowane predykaty:
% na/2
%    pod/2
%   miedzy/3
%====================================


% na(X,Y)
% opis: spelniony, gdy klocek X lezy
% bezposrednio na klocku Y
%  pod(X,Y)
% opis: spelniony, gdy klocek X lezy
% bezposrednio pod klockiem Y
% miedzy(X,Y,Z)
% opis: spelniony, gdy klocek X lezy miedzy
% klockami Y i Z
% ---------------------------------------na/2
  na(c,a).
  na(c,b).
  na(d,c).
        pod(X,Y):-na(Y,X).
    miedzy(X,Y,Z):-na(Z,X),na(X,Y).
    miedzy(X,Y,Z):-na(Y,X),na(X,Z).
% ---------------------------------------na/2

/*
Informacje o budoiwe programu:
Program sklada sie z 6 klauzul.
Program zwiera 3 definicje relacji.
Sa to relacje na/2, pod/2 i miedzy/3.
Definicja relacji na/2 sklada sie z
3 klazul,które sa faktami.
Definicja relacji pod/2 sklada sie z 1
klauzli, która jest regula.
Definicja relacji miedzy/2 sklada sie
z 2 klauzul, które sa regulami.
*/
