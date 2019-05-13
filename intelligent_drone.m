
drone = struct %deklaracja struktury (dron bêdzie stuktur¹ przechowuj¹c¹ informacjê 
% o jego po³o¿eniu, wysokoœci, prêdkoœci, energii, zasiêgu czujnika)

%1. Parametryzacja parametrów H,N (wysokoœæ, szerokoœæ , g³êbokoœæ)

H %wysokoœæ

N %szerokoœæ, g³êbokoœæ

%Pozycja pocz¹tkowa jako struktura (x,y,z)

initial_position = struct
initial_position.x = 3;
initial_position.y = 3;
initial_position.z = 3;

drone.position = initial_position %inicjalizacja wartoœci¹ pocz¹tkow¹ pozycji drona

initial_speed = 2; % inicjalizacja wartoœci¹ pocz¹tkow¹ prêdkoœci

initial_energy=5; % inicjalizacja wartoœci¹ pocz¹tkow¹ energii

drone.speed = initial_speed; %przypisanie do prêdkoœci drona wartoœci zainicjalizowanej

drone.energy = initial_energy; %przypisanie do energii drona wartoœci zainicjalizowanej

drone.sensor_range %zasiêg czujnika (na ile komórek dron widzi w przód)

%pozycja pilota bêd¹ca struktur¹ (przechowuj¹c¹ wspó³rzêdne)

pilot_position= struct

pilot_position.x =1;

pilot_position.y =2;

pilot_position.z = H/10; %obni¿enie siê do wysokoœci 0.1 H w celu zrzucenia zaopatrzenia
drone.pilot_position = pilot_position; %przypisanie do pola pilot_position w strukturze dron po³o¿enia pilota

drone.pilot_position_achieved=false; %pozycja pilota osi¹gniêta (pocz¹tkowo ustawione na wartosæ false)

drone.if_return_to_start = false; %parametr czy powróci³ do startu (pozycji startowej)

environment = zeros(N, N, H); %inicjalizacja œrodowiska o wymiarach NxNxH
environment(3:5, 4:6, 5:7) = 'r'; %(od 3 do 5, od 4 do 6, od 5 do 7) %wstawienie do pól konkretnych zakresów literki 'r',która bêdzie oznaczaæ, ¿e w tych miejscach znajdowaæ siê bêdzie radar
predicates = struct %predykaty bêd¹ strukturami z przyjêtymi parametrami zdanie oraz wartoœæ logiczna
%predicates.q = "Radar detected"/"Gun detected" // zdanie
%predicates.value = true/false; //wartoœæ logiczna
% zdanie i wartosc tworza predykat
% regu³y w bazie wiedzy beda tworzone w oparciu o rozpoznanie w ktorym
% miejscu jestesmy (sprawdzane co turê (krok symulacji))

moves_and_states = struct; %ruchy i stan bêdzie to struktura przechowuj¹ca ruch, jaki zrobi³ dron oraz jego aktualny stan
simulation_time = 0; %czas symulacji -- parametr inkrementowany po ka¿dym ruchu, aby móc obrazowaæ póŸniej przejœcie krok po kroku drona)

while ( drone.energy > 0  && drone.if_return_to_start != true ) %dopóki energia drona jest >0 i nie powróci³ do pozycji pocz¹tkowej
        cube_to_pass = environment( drone.position.x - drone.sensors_range:drone.position.x + drone.sensors_range
                                    drone.position.y - drone.sensors_range:drone.position.x + drone.sensors_range
                                    drone.position.z - drone.sensors_range:drone.position.x + drone.sensors_range ) %zapisanie wycinka œrodowiska, który bêdzie nas interesowa³, przy analizie kolejnego jego ruchu
    predicates = detect_danger(drone.position, cube_to_pass) %wykryj zagro¿enie aktualizujemy wartosci predykatow za pomoc¹ parametru pozycji drona oraz drogi do przejœcia
    %pocz¹tek tworzenia bazy wiedzy (odpowiada to funkcji TELL - baza
    %wiedzy bêdzie siê zmieniaæ w ka¿dym kroku symulacji
    
    move_to_make, drone_state = inference(predicates, drone); 
    % funkcja odpowiedzialna za pobranie aktualnych predykatów oraz
    % parametrów drona (przypisuje do zmiennych ruch do zrobienia i
    % aktualny po³o¿enie drona)
    %odpowiada to funkcji ASK pytamy sie czy jestemy pod dzia³aniem radaru,
    %czy gun
    
    
    % inference caly algorytm poruszania sie
    %musimy miec informacje gdzie jestesmy i dokad zmierzamy
    
    drone = move_drone(drone, move_to_make); %funkcja odpowiedzialna za poruszanie dronem
    %przyjmuje informacje o dronie oraz ruchu do przejœcia (aktualizacja
    %parametrów drona)
    drone = take_drone_energy(drone, move_to_make); %funkcja odpowiedzialna za pobranie energii drona
    %ile jej uby³o po wykonaniu ruchu
    
    moves_and_states.moves(simulation_time) = move_to_make;
    %zbieranie wyników dla czasu symulacji w wektorze (ruchy) aby póŸniej
    %móc je wyœwietliæ
    
    moves_and_states.states(simulation_time) = drone_state;
     %zbieranie wyników dla czasu symulacji w wektorze (stany) aby póŸniej
    %móc je wyœwietliæ
    
    simulation_time = simulation_time + 1; %inkrementacja czasu symulacji po ka¿dym przejœciu pêtli
end
plot_simulation(environment, drone, moves_and_states); % prezentacja wyników po zebraniu symulacji

analyze_results(drone, simulation_time); %analiza rezultatów (dron w czasie)


%bazuje na tym ¿e mamy bazê wiedzy, mamy regu³y, po kolei przez te regu³y przeskakujemy i patrzymy co sie dzieje

%najkrótsza œcie¿ka do pilota i sprawdza czy na tej najkrótszej œcie¿ce widzianej przez drona œcie¿ce
%czy w tym horyzoncie na tej nakrótszej œcie¿ce coœ przeszkadza

%mamy uaktualnian¹ bazê wiedzy (czy jesteœmy w polu ra¿enia, czy jesteœmy wykrywani przez radar)
%na podstawie tego tworzymy sobie regu³y (regu³y s¹ odpowiednio sformu³owane)

%jeœli jestesmy pod dzia³aniem radaru to porusz sie w prawo chyba ¿e jesteœ na granicy gun to nie poruszaj siê w prawo


%speed to liczba komórek przez które mo¿na przejœæ.

%Za³o¿enie pocz¹tkowe przód ty³ prawo lewo

    
    

