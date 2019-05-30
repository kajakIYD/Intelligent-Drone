%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Baza wiedzy wraz z predykatami (funkcja inference)
%funkcja odpowiedzialna za pobranie aktualnych predykatów oraz
%parametrów drona (przypisuje do zmiennych ruch do zrobienia i aktualny
%po³o¿enie drona)-odpowiada to funkcji ASK pytamy sie czy jesteœmy pod
%dzia³aniem radaru b¹dŸ broni
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%gi

function [move_to_make, drone_state] = inference(predicates, drone)
    baza_wiedzy = struct; %baza wiedzy bedzie struktura
    baza_wiedzy.reguly = struct; %reguly w bazach wiedzy takze beda struktura
    baza_wiedzy.fakty_dopytywalne = struct; %rozdzielenie faktow w bazie wiedzy na dopytywalne i niedopytywalne
    baza_wiedzy.fakty_niedopytywalne = struct;

    %predykat.jest_ustawiony = true -> fakt niedopytywalny
    
    A = struct; %predykat
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
    
    
    
    MF = struct;
    MF.nazwa = 'MF'; %'ruch_w_przod';
    MF.wartosc = false;
    MF.jest_ustawiony = false;

    MR = struct;
    MR.nazwa = 'MR'; %'ruch_w_prawo';
    MR.wartosc = false;
    MR.jest_ustawiony = false; 
    
    ML = struct;
    ML.nazwa = 'ML'; %'ruch_w_lewo';
    ML.wartosc = false;
    ML.jest_ustawiony = false; 
    
    MD = struct;
    MD.nazwa = 'MD'; %'ruch_w_dol';
    MD.wartosc = false;
    MD.jest_ustawiony = false; 
    
    MU = struct;
    MU.nazwa = 'MU'; %'ruch_w_gore';
    MU.wartosc = false;
    MU.jest_ustawiony = false; 
    
    
    MB = struct;
    MB.nazwa = 'MB'; %'ruch_do_tylu';
    MB.wartosc = false;
    MB.jest_ustawiony = false;
    
    DL = struct;
    DL.nazwa = 'DL'; %'DLoad';
    DL.wartosc = false;
    DL.jest_ustawiony = false; 

    nDL = struct;
    nDL.nazwa = 'nDL'; %'nDLoad';
    nDL.wartosc = false;
    nDL.jest_ustawiony = false; 
    
    baza_wiedzy.reguly(1).przeslanki = [predicates.POP]; %wektor predykatow nF (not F)- zaprzeczenie
    baza_wiedzy.reguly(1).konkluzja = DL;  % DropLoad - zrzuc ladunek
    baza_wiedzy.reguly(2).przeslanki = [predicates.nPOP]; %wektor predykatow nF (not F)- zaprzeczenie
    baza_wiedzy.reguly(2).konkluzja = nDL;  % DropLoad - zrzuc ladunek
    baza_wiedzy.reguly(3).przeslanki = [predicates.nRS, predicates.MF_p, nDL];
    baza_wiedzy.reguly(3).konkluzja = MF;
    baza_wiedzy.reguly(4).przeslanki = [predicates.nRS, predicates.MB_p, DL];
    baza_wiedzy.reguly(4).konkluzja = MB;
    baza_wiedzy.reguly(5).przeslanki = [predicates.nRR, predicates.MR_p]; 
    baza_wiedzy.reguly(5).konkluzja = MR;
    baza_wiedzy.reguly(6).przeslanki = [predicates.nRL, predicates.ML_p]; 
    baza_wiedzy.reguly(6).konkluzja = ML;
    baza_wiedzy.reguly(7).przeslanki = [predicates.nRU, predicates.MU_p]; 
    baza_wiedzy.reguly(7).konkluzja = MU;
    baza_wiedzy.reguly(8).przeslanki = [predicates.nRD, predicates.MD_p];
    baza_wiedzy.reguly(8).konkluzja = MD;
    
    
    
    %%Orientacja sprawdzania czujnikow zmienia sie po osiagnieciu pilota
    %%Natomiast orientacja ruchowa siê nie zmienia
    
    konkluzje_z_bazy_wiedzy = []; %bufor na konkluzje z bazy wiedzy
    for regula = baza_wiedzy.reguly %dla wszystkich regul w bazie wiedzy
        konkluzja_juz_w_wektorze = false; %poczatkowe ustawienie flagi konkluzja_juz_w_wektorze na false
        for konkluzja = konkluzje_z_bazy_wiedzy % dla kazdej konkluzji w bazie wiedzy
            if (strcmp(konkluzja.nazwa, regula.konkluzja.nazwa)) % porownanie nazwy konkluzji z bazy wiedzy z regula
                konkluzja_juz_w_wektorze = true; %w przypadku gdy ju¿ jest taka sama konkluzja w wektorze
                break;%wyjdŸ z pêtli
            end
        end
        if (konkluzja_juz_w_wektorze == false)
            konkluzje_z_bazy_wiedzy = [konkluzje_z_bazy_wiedzy regula.konkluzja]; %gdy jest nowa to dopisz do wektora
        end
    end

    poboczna_lista_predykatow = []; %na tej liscie znajduja sie wszystkie
    %predykaty, ktore sa konkluzjami
    lista_predykatow_pelna = false; %pocz¹tkowe za³o¿enie ¿e lista predykatów nie jest pe³na
    while (lista_predykatow_pelna == false)
        licznik_regul = 1; %ustawienie licznika regu³ na wartoœæ 1, która bêdzie inkrementowana po przejœciu regu³y

        for regula = baza_wiedzy.reguly
            przeslanki = baza_wiedzy.reguly(licznik_regul).przeslanki; %przypisanie zmiennej przeslanki pojedycznej przeslanki z reguly
            mozna_wykonac_regule = true; %zmienna pozwalaj¹c¹ wykonaæ regu³ê
            for predykat = przeslanki
                if ~predykat.jest_ustawiony %jeœli predykat nie jest ustawiony
                    mozna_wykonac_regule = false; %nie mozna wykonac reguly
                    break;
                end
            end

            if mozna_wykonac_regule == true %jeœli mo¿na wykonaæ regu³ê
                result = true; %wynik wnioskowania jest prawdziwy (wstepnie)
                for predykat = przeslanki
                    result = result && predykat.wartosc; %rezultat to bêdzie koniunkcja rezultatu i wartoœci predykatu
                end
                %%Przeszukiwanie calej bazy wiedzy, zeby odnalezc wszystkie
                %%predykaty o tej samej nazwie co aktualnie rozpatrywana
                %%konkluzja i nadac im ponizsze wlasnosci:
                podlicznik_regul = 1; %licznik aby przez ka¿d¹ z regu³ osobno
                for podregula = baza_wiedzy.reguly
                    licznik_podprzeslanek = 1;
                    for podprzeslanka = podregula.przeslanki
                        if(strcmp(podprzeslanka.nazwa, regula.konkluzja.nazwa))
                            baza_wiedzy.reguly(podlicznik_regul).przeslanki(licznik_podprzeslanek).wartosc = result;
                            baza_wiedzy.reguly(podlicznik_regul).przeslanki(licznik_podprzeslanek).jest_ustawiony = true;
%                             break;
                        end
                        licznik_podprzeslanek = licznik_podprzeslanek + 1;
                    end
                    if (strcmp(regula.konkluzja.nazwa, podregula.konkluzja.nazwa))
                        baza_wiedzy.reguly(podlicznik_regul).konkluzja.wartosc = result;
                        baza_wiedzy.reguly(podlicznik_regul).konkluzja.jest_ustawiony = true;
                    end
                    podlicznik_regul = podlicznik_regul + 1;
                end

                predykat_na_liscie_pobocznej = false; %%na tej liscie znajduja sie wszystkie
    %predykaty, ktore sa konkluzjami
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

    %%Sprawdz wartosc logiczna predykatow "odpowiedzialnych za ruch"
    move_predicates = [baza_wiedzy.reguly(3).konkluzja, baza_wiedzy.reguly(4).konkluzja, baza_wiedzy.reguly(5).konkluzja, baza_wiedzy.reguly(6).konkluzja, baza_wiedzy.reguly(7).konkluzja, baza_wiedzy.reguly(8).konkluzja];
    
    move_to_make = struct;
    move_to_make.x = 0;
    move_to_make.y = 0;
    move_to_make.z = 0;
    for predicate = move_predicates
        if (strcmp(predicate.nazwa, 'MF') == true && predicate.wartosc == true)
            %%Ruch w przod
            move_to_make.y = 1; %binarna informacja ( w ktora strone sie ruszyc) 
        end
        if (strcmp(predicate.nazwa, 'MB') == true && predicate.wartosc == true)
            %%Ruch do tylu
            move_to_make.y = -1; %binarna informacja ( w ktora strone sie ruszyc) 
        end
        if (strcmp(predicate.nazwa, 'MR') == true && predicate.wartosc == true)
            %%Ruch w prawo
            move_to_make.x = 1;
        end
        if (strcmp(predicate.nazwa, 'ML') == true && predicate.wartosc == true)
            %%Ruch w lewo
            move_to_make.x = -1;
        end
        if (strcmp(predicate.nazwa, 'MD') == true && predicate.wartosc == true)
            %%Ruch w dol
            move_to_make.z = -1;
        end
        if (strcmp(predicate.nazwa, 'MU') == true && predicate.wartosc == true)
            %%Ruch w dol
            move_to_make.z = 1;
        end
    end
    
    
    drone_state_predicates = [baza_wiedzy.reguly(4).przeslanki]; 
    drone_state = struct;
    drone_state.radar_detected = false;
    drone_state.gun_detected = false;
    for predicate = drone_state_predicates
        if (strcmp(predicate.nazwa, 'RD') == true && predicate.wartosc == true)
            %%Radar wykryty
            drone_state.radar_detected = true; %informacja o tym ze radar wykryty
        end
        if (strcmp(predicate.nazwa, 'GD') == true && predicate.wartosc == true)
            %%Gun wykryty
            drone_state.gun_detected = true;
        end
    end
    
end
