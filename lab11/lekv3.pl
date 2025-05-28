% =====================================================================
% SYSTEM EKSPERTOWY: BAZA LEKÓW I INTERAKCJE MIEDZYLEKOWE
% =====================================================================
% Tematyka: Analiza bezpieczenstwa leczenia
% Cel: Weryfikacja zgodnosci leków z chorobami przewleklymi i alergiami
% Zastosowanie: Wspomaganie decyzji terapeutycznych w praktyce klinicznej
% Problem: Zapobieganie niebezpiecznym interakcjom i reakcjom niepozadanym

% === Fakty: leki ===
lek(aspiryna).
lek(ibuprofen).
lek(paracetamol).
lek(naproksen).
lek(metoprolol).
lek(amlodypina).
lek(ketoprofen).
lek(clopidogrel).
lek(diklofenak).

% === Fakty: choroby ===
choroba(wrzody).
choroba(nadcisnienie).
choroba(astma).
choroba(cukrzyca).
choroba(niewydolnosc_nerek).
choroba(alergia_na_nlpz).
choroba(choroba_serca).

% === Opisy leków ===
opis(aspiryna, 'lek przeciwzapalny, przeciwbólowy i przeciwgoraczkowy').
opis(ibuprofen, 'niesteroidowy lek przeciwzapalny (NLPZ)').
opis(paracetamol, 'lek przeciwbólowy i przeciwgoraczkowy').
opis(naproksen, 'NLPZ stosowany w leczeniu bólu i zapalenia').
opis(metoprolol, 'beta-bloker stosowany w leczeniu nadcisnienia i chorób serca').
opis(amlodypina, 'bloker kanalu wapniowego, stosowany w leczeniu nadcisnienia').
opis(ketoprofen, 'silny NLPZ o dzialaniu przeciwbólowym').
opis(clopidogrel, 'lek przeciwplytkowy zapobiegajacy zakrzepom').
opis(diklofenak, 'NLPZ stosowany w leczeniu stanów zapalnych i bólu').

% === Opisy chorób ===
opis(wrzody, 'uszkodzenie blony sluzowej zoladka lub dwunastnicy').
opis(nadcisnienie, 'podwyzszone cisnienie tetnicze krwi').
opis(astma, 'przewlekla choroba zapalna dróg oddechowych').
opis(cukrzyca, 'przewlekla choroba metaboliczna').
opis(niewydolnosc_nerek, 'uposledzenie funkcji nerek').
opis(alergia_na_nlpz, 'nadwrazliwosc na niesteroidowe leki przeciwzapalne').
opis(choroba_serca, 'ogólne okreslenie chorób ukladu krazenia').

% === Interakcje miedzy lekami ===
interakcja(aspiryna, ibuprofen).
interakcja(aspiryna, clopidogrel).
interakcja(ibuprofen, metoprolol).
interakcja(naproksen, diklofenak).
interakcja(ketoprofen, diklofenak).
interakcja(paracetamol, metoprolol).
interakcja(aspiryna, diklofenak).
interakcja(ketoprofen, clopidogrel).

% === Przeciwwskazania leków przy chorobach ===
przeciwwskazany(aspiryna, wrzody).
przeciwwskazany(aspiryna, alergia_na_nlpz).
przeciwwskazany(ibuprofen, nadcisnienie).
przeciwwskazany(ibuprofen, niewydolnosc_nerek).
przeciwwskazany(naproksen, astma).
przeciwwskazany(naproksen, wrzody).
przeciwwskazany(metoprolol, astma).
przeciwwskazany(amlodypina, niewydolnosc_nerek).
przeciwwskazany(diklofenak, alergia_na_nlpz).
przeciwwskazany(ketoprofen, alergia_na_nlpz).

% === Regula pomocnicza: sprawdzanie interakcji w obie strony ===
interakcja_dwukierunkowa(L1, L2) :-
    interakcja(L1, L2);
    interakcja(L2, L1).

% === Glówna regula analizy bezpieczenstwa terapii ===
% analiza(+Leki:list, +Choroby:list, -Ostrzezenia:list)
% sprawdza, czy leki maja interakcje miedzy soba lub sa przeciwwskazane przy danych chorobach.
% Moze sluzyc do oceny planowanego leczenia lub do sprawdzania bezpieczenstwa juz stosowanych leków.
analiza(Leki, Choroby, Ostrzezenia) :-
    znajdz_interakcje(Leki, Interakcje),                     % generuje liste ostrzezen o interakcjach miedzy lekami
    znajdz_przeciwwskazania(Leki, Choroby, Przeciwwskazania), % generuje liste ostrzezen o przeciwwskazaniach
    append(Interakcje, Przeciwwskazania, Ostrzezenia).       % laczy ostrzezenia w jedna liste wynikowa

% === Znajdowanie interakcji miedzy lekami ===
% znajdz_interakcje(+Leki:list, -Ostrzezenia:list)
% szuka wszystkich par leków, które wchodza w potencjalnie niebezpieczna interakcje
znajdz_interakcje(Leki, Ostrzezenia) :-
    findall(
        O,  % zmienna O to pojedynczy komunikat ostrzezenia (atom)
        (
            select(L1, Leki, Pozostale),   % wybiera L1 z listy Leki, a Pozostale to lista bez L1
            member(L2, Pozostale),         % iteruje po pozostalych lekach jako L2
            interakcja_dwukierunkowa(L1, L2),  % sprawdza, czy L1 i L2 maja interakcje (niezaleznie od kolejnosci)
            L1 @< L2,                      % warunek ze kazda para jest wzieta tylko raz (sprawdzane oba, wyswietl jedno)
            format(atom(O),
                   'potencjalnie niebezpieczna interakcja miedzy ~w a ~w',
                   [L1, L2])               % tworzy komunikat w formie atomu
        ),
        Ostrzezenia                       % findall tworzy liste wszystkich dopasowan
    ).

% === Znajdowanie przeciwwskazan dla chorób ===
% znajdz_przeciwwskazania(+Leki:list, +Choroby:list, -Ostrzezenia:list)
% sprawdza, czy którys z leków jest przeciwwskazany
% przy którejkolwiek z podanych chorob
znajdz_przeciwwskazania(Leki, Choroby, Ostrzezenia) :-
    findall(
        O,  % O to pojedynczy komunikat ostrzezenia
        (
            member(Lek, Leki),            % iteruje po lekach
            member(Choroba, Choroby),     % iteruje po chorobach
            przeciwwskazany(Lek, Choroba),% sprawdza, czy dany lek jest przeciwwskazany przy danej chorobie
            format(atom(O),
                   'lek ~w jest przeciwwskazany przy chorobie ~w',
                   [Lek, Choroba])        % tworzy komunikat ostrzezenia w formie atomu
        ),
        Ostrzezenia                       % zbiera wszystkie dopasowania w liste
    ).


% === Sprawdzenie czy lek jest bezpieczny dla pacjenta ===
% przydatne do sprawdzenia czy lek mozna dodac do leczenia
bezpieczny_lek_dla_pacjenta(Lek, ChorobyPacjenta, PrzyjmowaneLeki) :-
    % lek nie moze byc przeciwwskazany przy zadnej chorobie pacjenta
    \+ (member(Choroba, ChorobyPacjenta), przeciwwskazany(Lek, Choroba)),

    % lek nie moze wchodzic w interakcje z zadnym z aktualnie przyjmowanych leków
    \+ (member(InnyLek, PrzyjmowaneLeki), interakcja_dwukierunkowa(Lek, InnyLek)).


% === Przykladowe zapytania ===
% analiza([aspiryna, ibuprofen, paracetamol], [wrzody, nadcisnienie], Wynik).

% znajdz_interakcje([aspiryna, ibuprofen, paracetamol], Wynik).

% bezpieczny_lek_dla_pacjenta(paracetamol, [nadcisnienie, astma],[aspiryna]).
% true.

% bezpieczny_lek_dla_pacjenta(aspiryna, [wrzody], [ibuprofen]).
% false.

% bezpieczny_lek_dla_pacjenta(amlodypina, [niewydolnosc_nerek], []).
% false.

% analiza([aspiryna, metoprolol, paracetamol], [cukrzyca, nadcisnienie], Wynik).

