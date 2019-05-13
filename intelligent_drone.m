
drone = struct %deklaracja struktury (dron b�dzie stuktur� przechowuj�c� informacj� 
% o jego po�o�eniu, wysoko�ci, pr�dko�ci, energii, zasi�gu czujnika)

%1. Parametryzacja parametr�w H,N (wysoko��, szeroko�� , g��boko��)

H %wysoko��

N %szeroko��, g��boko��

%Pozycja pocz�tkowa jako struktura (x,y,z)

initial_position = struct
initial_position.x = 3;
initial_position.y = 3;
initial_position.z = 3;

drone.position = initial_position %inicjalizacja warto�ci� pocz�tkow� pozycji drona

initial_speed = 2; % inicjalizacja warto�ci� pocz�tkow� pr�dko�ci

initial_energy=5; % inicjalizacja warto�ci� pocz�tkow� energii

drone.speed = initial_speed; %przypisanie do pr�dko�ci drona warto�ci zainicjalizowanej

drone.energy = initial_energy; %przypisanie do energii drona warto�ci zainicjalizowanej

drone.sensor_range %zasi�g czujnika (na ile kom�rek dron widzi w prz�d)

%pozycja pilota b�d�ca struktur� (przechowuj�c� wsp�rz�dne)

pilot_position= struct

pilot_position.x =1;

pilot_position.y =2;

pilot_position.z = H/10; %obni�enie si� do wysoko�ci 0.1 H w celu zrzucenia zaopatrzenia
drone.pilot_position = pilot_position; %przypisanie do pola pilot_position w strukturze dron po�o�enia pilota

drone.pilot_position_achieved=false; %pozycja pilota osi�gni�ta (pocz�tkowo ustawione na wartos� false)

drone.if_return_to_start = false; %parametr czy powr�ci� do startu (pozycji startowej)

environment = zeros(N, N, H); %inicjalizacja �rodowiska o wymiarach NxNxH
environment(3:5, 4:6, 5:7) = 'r'; %(od 3 do 5, od 4 do 6, od 5 do 7) %wstawienie do p�l konkretnych zakres�w literki 'r',kt�ra b�dzie oznacza�, �e w tych miejscach znajdowa� si� b�dzie radar
predicates = struct %predykaty b�d� strukturami z przyj�tymi parametrami zdanie oraz warto�� logiczna
%predicates.q = "Radar detected"/"Gun detected" // zdanie
%predicates.value = true/false; //warto�� logiczna
% zdanie i wartosc tworza predykat
% regu�y w bazie wiedzy beda tworzone w oparciu o rozpoznanie w ktorym
% miejscu jestesmy (sprawdzane co tur� (krok symulacji))

moves_and_states = struct; %ruchy i stan b�dzie to struktura przechowuj�ca ruch, jaki zrobi� dron oraz jego aktualny stan
simulation_time = 0; %czas symulacji -- parametr inkrementowany po ka�dym ruchu, aby m�c obrazowa� p�niej przej�cie krok po kroku drona)

while ( drone.energy > 0  && drone.if_return_to_start != true ) %dop�ki energia drona jest >0 i nie powr�ci� do pozycji pocz�tkowej
        cube_to_pass = environment( drone.position.x - drone.sensors_range:drone.position.x + drone.sensors_range
                                    drone.position.y - drone.sensors_range:drone.position.x + drone.sensors_range
                                    drone.position.z - drone.sensors_range:drone.position.x + drone.sensors_range ) %zapisanie wycinka �rodowiska, kt�ry b�dzie nas interesowa�, przy analizie kolejnego jego ruchu
    predicates = detect_danger(drone.position, cube_to_pass) %wykryj zagro�enie aktualizujemy wartosci predykatow za pomoc� parametru pozycji drona oraz drogi do przej�cia
    %pocz�tek tworzenia bazy wiedzy (odpowiada to funkcji TELL - baza
    %wiedzy b�dzie si� zmienia� w ka�dym kroku symulacji
    
    move_to_make, drone_state = inference(predicates, drone); 
    % funkcja odpowiedzialna za pobranie aktualnych predykat�w oraz
    % parametr�w drona (przypisuje do zmiennych ruch do zrobienia i
    % aktualny po�o�enie drona)
    %odpowiada to funkcji ASK pytamy sie czy jestemy pod dzia�aniem radaru,
    %czy gun
    
    
    % inference caly algorytm poruszania sie
    %musimy miec informacje gdzie jestesmy i dokad zmierzamy
    
    drone = move_drone(drone, move_to_make); %funkcja odpowiedzialna za poruszanie dronem
    %przyjmuje informacje o dronie oraz ruchu do przej�cia (aktualizacja
    %parametr�w drona)
    drone = take_drone_energy(drone, move_to_make); %funkcja odpowiedzialna za pobranie energii drona
    %ile jej uby�o po wykonaniu ruchu
    
    moves_and_states.moves(simulation_time) = move_to_make;
    %zbieranie wynik�w dla czasu symulacji w wektorze (ruchy) aby p�niej
    %m�c je wy�wietli�
    
    moves_and_states.states(simulation_time) = drone_state;
     %zbieranie wynik�w dla czasu symulacji w wektorze (stany) aby p�niej
    %m�c je wy�wietli�
    
    simulation_time = simulation_time + 1; %inkrementacja czasu symulacji po ka�dym przej�ciu p�tli
end
plot_simulation(environment, drone, moves_and_states); % prezentacja wynik�w po zebraniu symulacji

analyze_results(drone, simulation_time); %analiza rezultat�w (dron w czasie)


%bazuje na tym �e mamy baz� wiedzy, mamy regu�y, po kolei przez te regu�y przeskakujemy i patrzymy co sie dzieje

%najkr�tsza �cie�ka do pilota i sprawdza czy na tej najkr�tszej �cie�ce widzianej przez drona �cie�ce
%czy w tym horyzoncie na tej nakr�tszej �cie�ce co� przeszkadza

%mamy uaktualnian� baz� wiedzy (czy jeste�my w polu ra�enia, czy jeste�my wykrywani przez radar)
%na podstawie tego tworzymy sobie regu�y (regu�y s� odpowiednio sformu�owane)

%je�li jestesmy pod dzia�aniem radaru to porusz sie w prawo chyba �e jeste� na granicy gun to nie poruszaj si� w prawo


%speed to liczba kom�rek przez kt�re mo�na przej��.

%Za�o�enie pocz�tkowe prz�d ty� prawo lewo

    
    

