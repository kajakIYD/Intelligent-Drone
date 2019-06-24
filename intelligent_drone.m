%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%G³ówne okno programu wraz z g³ówn¹ pêtl¹ do while w której uruchamiane
%bêd¹ poszczególne funkcje programu
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% clear all
%close all

function [environment, drone, moves_and_states, message] = intelligent_drone(N, H, randomMode)

    drone = struct %deklaracja struktury (dron bêdzie stuktur¹ przechowuj¹c¹ informacjê 
    % o jego po³o¿eniu, wysokoœci, prêdkoœci, energii, zasiêgu czujnika)

    [drone, N, H, pilot_position] = get_simulation_parameters(drone, N, 10, H, 10, 50, 20, randomMode);
    %pilot_position = pilot_position_backup;
    %drone.initial_position = drone_init_pos_backup;

    drone.pilot_position_achieved=false; %pozycja pilota osi¹gniêta (pocz¹tkowo ustawione na wartosæ false)

    drone.if_return_to_start = false; %parametr czy powróci³ do startu (pozycji startowej)

    environment = zeros(N, N, H); %inicjalizacja œrodowiska o wymiarach NxNxH

    environment = initialize_guns_and_radars(environment);
    %environment = env_backup;

    predicates = struct %predykaty bêd¹ strukturami z przyjêtymi parametrami zdanie oraz wartoœæ logiczna
    %predicates.q = "Radar detected"/"Gun detected" // zdanie
    %predicates.value = true/false; //wartoœæ logiczna
    % zdanie i wartosc tworza predykat
    % regu³y w bazie wiedzy beda tworzone w oparciu o rozpoznanie w ktorym
    % miejscu jestesmy (sprawdzane co turê (krok symulacji))

    moves_and_states = struct; %ruchy i stan bêdzie to struktura przechowuj¹ca ruch, jaki zrobi³ dron oraz jego aktualny stan
    simulation_time = 1; %czas symulacji -- parametr inkrementowany po ka¿dym ruchu, aby móc obrazowaæ póŸniej przejœcie krok po kroku drona)

    freezeTime = 3;
    able_to_move = true;

    predicates = struct;

    message = '';

    move_to_make_from_backwards = 0;
    pilot_position_achieved_time = 0;

    while ( drone.energy > 0  && drone.if_return_to_start ~= true ) %dopóki energia drona jest >0 i nie powróci³ do pozycji pocz¹tkowej
        %%TODO ruch w gore: 
        %%-reguly w bazie wiedzy, pierwszenstwo w funkcji
        %%calculate_optimal_path
        %%-"if y " w detect_danger_backward_orientation -> czyli fakty
        %%niedopytywalne odnosnie wykrywania gun-a i radarów
        %[x_start, x_end, y_start, y_end, z_start, z_end] = check_coordinates(drone, N, H); 

        %[cube_to_pass, drone_relative_position] = environment( x_start:x_end, y_start:y_end, z_start:z_end); %zapisanie wycinka œrodowiska, który bêdzie nas interesowa³, przy analizie kolejnego jego ruchu
        [predicates, drone] = check_pilot_presence(drone, pilot_position, predicates);
        [optimal_path, predicates] = calculate_optimal_path(drone, predicates);

        drone = check_sensors_range(drone);
        predicates = detect_danger(drone, environment, optimal_path, predicates); %wykryj zagro¿enie aktualizujemy wartosci predykatow za pomoc¹ parametru pozycji drona oraz drogi do przejœcia

        %pocz¹tek tworzenia bazy wiedzy (odpowiada to funkcji TELL - baza
        %wiedzy bêdzie siê zmieniaæ w ka¿dym kroku symulacji

        if (drone.pilot_position_achieved == false)
            [move_to_make] = inference(predicates, drone); 
            % funkcja odpowiedzialna za pobranie aktualnych predykatów oraz
            % parametrów drona (przypisuje do zmiennych ruch do zrobienia i
            % aktualny po³o¿enie drona)
                %odpowiada to funkcji ASK pytamy sie czy jestemy pod dzia³aniem radaru,
                %czy gun
            pilot_position_achieved_time = simulation_time;
        else
            move_to_make = moves_and_states.moves(pilot_position_achieved_time - move_to_make_from_backwards);
            move_to_make_from_backwards = move_to_make_from_backwards + 1;
            move_to_make.x = -move_to_make.x;
            move_to_make.y = -move_to_make.y;
            move_to_make.z = -move_to_make.z;
        end
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
                if (freezeTime == 0) % to znaczy ze w poprzedniej iteracji sie ruszylismy
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
        %przyjmuje informacje o dronie oraz ruchu do przejœcia (aktualizacja
        %parametrów drona)    

        drone = take_drone_energy(drone); %funkcja odpowiedzialna za pobranie energii drona
        %ile jej uby³o po wykonaniu ruchu

        moves_and_states.moves(simulation_time) = move_to_make;
        [message] = append_move_to_message(message, moves_and_states.moves(simulation_time));

        moves_and_states.speed(simulation_time) = drone.speed;
        %zbieranie wyników dla czasu symulacji w wektorze (ruchy) aby póŸniej
        %móc je wyœwietliæ

        moves_and_states.states(simulation_time) = drone_state;
         %zbieranie wyników dla czasu symulacji w wektorze (stany) aby póŸniej
        %móc je wyœwietliæ

        [predicates, drone] = check_finish_conditions(drone, predicates);
        simulation_time = simulation_time + 1; %inkrementacja czasu symulacji po ka¿dym przejœciu pêtli
    end
    
    [message] = analyze_results(drone, moves_and_states, simulation_time, message); %analiza rezultatów (dron w czasie)  

end

