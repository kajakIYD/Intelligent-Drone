function [drone, N, H] = get_simulation_parameters(drone, N_max, N_min, H_max, H_min, initial_energy_max, initial_energy_min)

    %1. Parametryzacja parametrów H,N (wysokoœæ, szerokoœæ , g³êbokoœæ)

    H = round((H_max  - H_min) * rand(1)) + H_min; %wysokoœæ

    N = round((N_max - N_min) * rand(1)) + N_min;  %szerokoœæ, g³êbokoœæ

    %Pozycja pocz¹tkowa jako struktura (x,y,z)

    initial_position = struct;
    initial_position.x = round((N - 1) * rand(1)) + 1; % 1;
    initial_position.y = round((N - 1) * rand(1)) + 1; % 3;
    initial_position.z = round((H - 1) * rand(1)) + 1; % 7;

    drone.position = initial_position; %inicjalizacja wartoœci¹ pocz¹tkow¹ pozycji drona
    drone.initial_position = initial_position;

    initial_speed = 1; % inicjalizacja wartoœci¹ pocz¹tkow¹ prêdkoœci

    initial_energy = (initial_energy_max - initial_energy_min) * rand(1) + initial_energy_min; % inicjalizacja wartoœci¹ pocz¹tkow¹ energii

    drone.speed = initial_speed; %przypisanie do prêdkoœci drona wartoœci zainicjalizowanej

    drone.energy = initial_energy; %przypisanie do energii drona wartoœci zainicjalizowanej
    drone.initial_energy = initial_energy; 

    drone.sensors_range = 1; %zasiêg czujnika (na ile komórek dron widzi w przód)

    %pozycja pilota bêd¹ca struktur¹ (przechowuj¹c¹ wspó³rzêdne)

    pilot_position= struct

    pilot_position.x = 3;

    pilot_position.y = 5;

% For debugging only
%     N = 11;
%     H = 15;
%     
%     drone.position.x = 9;
%     drone.position.y = 7;
%     drone.position.z = 5;
    
    pilot_position.z = round(H/10); %obni¿enie siê do wysokoœci 0.1 H w celu zrzucenia zaopatrzenia
    drone.pilot_position = pilot_position; %przypisanie do pola pilot_position w strukturze dron po³o¿enia pilota

    
    
end