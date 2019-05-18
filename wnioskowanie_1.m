baza_wiedzy = struct;
baza_wiedzy.reguly = struct;
baza_wiedzy.fakty_dopytywalne = struct;
baza_wiedzy.fakty_niedopytywalne = struct;

A = struct;
A.nazwa = 'A'; %'Znajduje sie nad pilotem';
A.wartosc = true;
A.jest_ustawiony = true;
B = struct;
B.nazwa = 'B'; %'Jest ponizej wysokosci minimalnej';
B.wartosc = false;
B.jest_ustawiony = true;
C = struct;
C.nazwa = 'C'; %'Spusc ladunek';
C.wartosc = false;
C.jest_ustawiony = false;
D = struct;
D.nazwa = 'D'; %'Powrot do miejsca startu';
D.wartosc = false;
D.jest_ustawiony = false;
E = struct;
E.nazwa = 'E'; %'regula';
E.wartosc = false;
E.jest_ustawiony = false;


baza_wiedzy.reguly(1).przeslanki = [A, B]; %wektor predykatow A, B
baza_wiedzy.reguly(1).konkluzja = C;  % C
baza_wiedzy.reguly(2).przeslanki = [A C]; %wektor predykatow A, C
baza_wiedzy.reguly(2).konkluzja = D;  % D
baza_wiedzy.reguly(3).przeslanki = [B C]; %wektor predykatow B, C
baza_wiedzy.reguly(3).konkluzja = E;  % D
% A, B -> C
% A, C -> D
% B, C -> E
konkluzje_z_bazy_wiedzy = [];
for regula = baza_wiedzy.reguly
    konkluzja_juz_w_wektorze = false;
    for konkluzja = konkluzje_z_bazy_wiedzy
        if (strcmp(konkluzja.nazwa, regula.konkluzja.nazwa))
            konkluzja_juz_w_wektorze = true;
            break;
        end
    end
    if (konkluzja_juz_w_wektorze == false)
        konkluzje_z_bazy_wiedzy = [konkluzje_z_bazy_wiedzy regula.konkluzja];
    end
end

poboczna_lista_predykatow = []; %na tej liscie znajduja sie wszystkie
%predykaty, ktore sa konkluzjami
lista_predykatow_pelna = false;
while (lista_predykatow_pelna == false)
    licznik_regul = 1;
    
    for regula = baza_wiedzy.reguly
        przeslanki = baza_wiedzy.reguly(licznik_regul).przeslanki;
        mozna_wykonac_regule = true;
        for predykat = przeslanki
            if ~predykat.jest_ustawiony
                mozna_wykonac_regule = false;
                break;
            end
        end

        if mozna_wykonac_regule == true
            result = true; %wynik wnioskowania jest prawdziwy (wstepnie)
            for predykat = przeslanki
                result = result && predykat.wartosc;
            end
            %%Przeszukiwanie calej bazy wiedzy, zeby odnalezc wszystkie
            %%predykaty o tej samej nazwie co aktualnie rozpatrywana
            %%konkluzja i nadac im ponizsze wlasnosci:
            podlicznik_regul = 1;
            for podregula = baza_wiedzy.reguly
                licznik_podprzeslanek = 1;
                for podprzeslanka = podregula.przeslanki
                    if(strcmp(podprzeslanka.nazwa, regula.konkluzja.nazwa))
                        baza_wiedzy.reguly(podlicznik_regul).przeslanki(licznik_podprzeslanek).wartosc = result;
                        baza_wiedzy.reguly(podlicznik_regul).przeslanki(licznik_podprzeslanek).jest_ustawiony = true;
                        break;
                    end
                    licznik_podprzeslanek = licznik_podprzeslanek + 1;
                end
                if (strcmp(regula.konkluzja.nazwa, podregula.konkluzja.nazwa))
                    baza_wiedzy.reguly(podlicznik_regul).konkluzja.wartosc = result;
                    baza_wiedzy.reguly(podlicznik_regul).konkluzja.jest_ustawiony = true;
                end
                podlicznik_regul = podlicznik_regul + 1;
            end
                
            predykat_na_liscie_pobocznej = false;
            for predykat_poboczny = poboczna_lista_predykatow
                if (strcmp(regula.konkluzja.nazwa, predykat_poboczny.nazwa))
                    predykat_na_liscie_pobocznej = true;
                end
            end
            if (predykat_na_liscie_pobocznej == false)
                poboczna_lista_predykatow = [poboczna_lista_predykatow regula.konkluzja];
            end
        end
        
        licznik_regul = licznik_regul + 1;

    end
    
    lista_predykatow_pelna = true;
    for konkluzja = konkluzje_z_bazy_wiedzy
        konkluzja_jest_na_liscie_pobocznej = false;
        for predykat = poboczna_lista_predykatow
            if (strcmp(konkluzja.nazwa, predykat.nazwa))
                konkluzja_jest_na_liscie_pobocznej = true;
            end
        end
        if (konkluzja_jest_na_liscie_pobocznej == false)
            lista_predykatow_pelna = false;
            break;
        end
    end
        
end


