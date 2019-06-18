%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%G��wne okno programu wraz z g��wn� p�tl� do while w kt�rej uruchamiane
%b�d� poszczeg�lne funkcje programu
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all

drone = struct %deklaracja struktury (dron b�dzie stuktur� przechowuj�c� informacj� 
% o jego po�o�eniu, wysoko�ci, pr�dko�ci, energii, zasi�gu czujnika)

[drone, N, H] = get_simulation_parameters(drone, 20, 10, 20, 10, 100, 20);

drone.pilot_position_achieved=false; %pozycja pilota osi�gni�ta (pocz�tkowo ustawione na wartos� false)

drone.if_return_to_start = false; %parametr czy powr�ci� do startu (pozycji startowej)

environment = zeros(N, N, H); %inicjalizacja �rodowiska o wymiarach NxNxH

environment = initialize_guns_and_radars(environment);

predicates = struct %predykaty b�d� strukturami z przyj�tymi parametrami zdanie oraz warto�� logiczna
%predicates.q = "Radar detected"/"Gun detected" // zdanie
%predicates.value = true/false; //warto�� logiczna
% zdanie i wartosc tworza predykat
% regu�y w bazie wiedzy beda tworzone w oparciu o rozpoznanie w ktorym
% miejscu jestesmy (sprawdzane co tur� (krok symulacji))

moves_and_states = struct; %ruchy i stan b�dzie to struktura przechowuj�ca ruch, jaki zrobi� dron oraz jego aktualny stan
simulation_time = 1; %czas symulacji -- parametr inkrementowany po ka�dym ruchu, aby m�c obrazowa� p�niej przej�cie krok po kroku drona)

freezeTime = 3;
able_to_move = true;

predicates = struct;

message = '';


while ( drone.energy > 0  && drone.if_return_to_start ~= true ) %dop�ki energia drona jest >0 i nie powr�ci� do pozycji pocz�tkowej
    %%TODO ruch w gore: 
    %%-reguly w bazie wiedzy, pierwszenstwo w funkcji
    %%calculate_optimal_path
    %%-"if y " w detect_danger_backward_orientation -> czyli fakty
    %%niedopytywalne odnosnie wykrywania gun-a i radar�w
    %[x_start, x_end, y_start, y_end, z_start, z_end] = check_coordinates(drone, N, H); 
    
    %[cube_to_pass, drone_relative_position] = environment( x_start:x_end, y_start:y_end, z_start:z_end); %zapisanie wycinka �rodowiska, kt�ry b�dzie nas interesowa�, przy analizie kolejnego jego ruchu
    [predicates, drone] = check_pilot_presence(drone, pilot_position, predicates);
    [optimal_path, predicates] = calculate_optimal_path(drone, predicates);
    
    if ( drone.pilot_position_achieved == true)
        disp('a');
    end
    
    drone = check_sensors_range(drone);
    predicates = detect_danger(drone, environment, optimal_path, predicates); %wykryj zagro�enie aktualizujemy wartosci predykatow za pomoc� parametru pozycji drona oraz drogi do przej�cia

    %pocz�tek tworzenia bazy wiedzy (odpowiada to funkcji TELL - baza
    %wiedzy b�dzie si� zmienia� w ka�dym kroku symulacji
    
    [move_to_make] = inference(predicates, drone); 
    % funkcja odpowiedzialna za pobranie aktualnych predykat�w oraz
    % parametr�w drona (przypisuje do zmiennych ruch do zrobienia i
    % aktualny po�o�enie drona)
    %odpowiada to funkcji ASK pytamy sie czy jestemy pod dzia�aniem radaru,
    %czy gun
    
    
    % inference caly algorytm poruszania sie
    %musimy miec informacje gdzie jestesmy i dokad zmierzamy
    
    [drone_state] = check_drone_state(drone,environment);
    
    if (drone_state.gun_contact == true)
        drone.speed = round(drone.speed / 2);
        if drone.speed == 0
            drone.speed = 1;
        end
    end
    
    if (freezeTime == 0)
        able_to_move = true;
        freezeTime = 3;
    else
        if (drone_state.radar_contact == true)
            if (freezeTime == 0) %to znaczy ze w poprzedniej iteracji sie ruszylismy
                freezeTime = 3;
            end
            freezeTime = freezeTime - 1;
            able_to_move = false;
        else
            freezeTime = 3;
            able_to_move = true;
        end
    end
    
    if (able_to_move == true)
        drone = move_drone(drone, move_to_make); %funkcja odpowiedzialna za poruszanie dronem
    else
        move_to_make.x = 0;
        move_to_make.y = 0;
        move_to_make.z = 0;
        drone = move_drone(drone, move_to_make); 
    end
    %przyjmuje informacje o dronie oraz ruchu do przej�cia (aktualizacja
    %parametr�w drona)    
    
    drone = take_drone_energy(drone); %funkcja odpowiedzialna za pobranie energii drona
    %ile jej uby�o po wykonaniu ruchu
    
    moves_and_states.moves(simulation_time) = move_to_make;
    [message] = append_move_to_message(message, moves_and_states.moves(simulation_time));
    
    moves_and_states.speed(simulation_time) = drone.speed;
    %zbieranie wynik�w dla czasu symulacji w wektorze (ruchy) aby p�niej
    %m�c je wy�wietli�
    
    moves_and_states.states(simulation_time) = drone_state;
     %zbieranie wynik�w dla czasu symulacji w wektorze (stany) aby p�niej
    %m�c je wy�wietli�
    
    [predicates, drone] = check_finish_conditions(drone, predicates);
    simulation_time = simulation_time + 1; %inkrementacja czasu symulacji po ka�dym przej�ciu p�tli
end
plot_simulation(environment, drone, moves_and_states); % prezentacja wynik�w po zebraniu symulacji

[message] = analyze_results(drone, moves_and_states, simulation_time, message); %analiza rezultat�w (dron w czasie)

disp(message)

%bazuje na tym �e mamy baz� wiedzy, mamy regu�y, po kolei przez te regu�y przeskakujemy i patrzymy co sie dzieje

%najkr�tsza �cie�ka do pilota i sprawdza czy na tej najkr�tszej �cie�ce widzianej przez drona �cie�ce
%czy w tym horyzoncie na tej nakr�tszej �cie�ce co� przeszkadza

%mamy uaktualnian� baz� wiedzy (czy jeste�my w polu ra�enia, czy jeste�my wykrywani przez radar)
%na podstawie tego tworzymy sobie regu�y (regu�y s� odpowiednio sformu�owane)

%je�li jestesmy pod dzia�aniem radaru to porusz sie w prawo chyba �e jeste� na granicy gun to nie poruszaj si� w prawo


%speed to liczba kom�rek przez kt�re mo�na przej��.

%Za�o�enie pocz�tkowe prz�d ty� prawo lewo

    
   %% baza wiedzy
   
   %1.w bazie wiedzy musimy miec warunek ze jak znajdujemy sie nad pilotem
   %jezeli jestem na pilotem i jestesm wyzej niz minimalna wysokosc to
   %wtedy w dol
   %2. Zrzucono ladunek -> powrot do miejsca startu
   %3. Caly czas porusza sie przed siebie chyba ze jest jakies zagrozenie
   %Jesli nie jestes pod dzialaniem zagrozenia i jestes nad dronem to wtedy
   %ruch w przod
   %4. Jezeli po zrobieniu kroku w przodu znalezlismy sie pod dzialaniem radaru to albo w lewo albo w prawo
   %5. Jezeli po zrobieniu kroku w przodu znalezlismy sie pod dzialaniem
   %wystrzalu to albo w lewo albo w prawo albo w gore
   %5. Czy pole dzialania radaru nie konczy sie szybciej w prawo czy w lewo
   %6. Probujemy zawsze isc w prawo a jak sie nie uda to w lewo
   %7. Zestaw ograniczen na to ze dron jest w srodowisku
   %(sytuacje w ktorych dojechal do konca osrodka)
   %Czy jest na prawej, gornej granicy, dolnej, lewej (sprawdzanie
   %wspolrzednych)
   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%System wnioskowania


   
  
   
   
   
   

