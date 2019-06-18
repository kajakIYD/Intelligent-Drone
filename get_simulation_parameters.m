function [drone, N, H] = get_simulation_parameters(drone, N_max, N_min, H_max, H_min, initial_energy_max, initial_energy_min)

    %1. Parametryzacja parametr�w H,N (wysoko��, szeroko�� , g��boko��)

    H = round((H_max  - H_min) * rand(1)) + H_min; %wysoko��

    N = round((N_max - N_min) * rand(1)) + N_min;  %szeroko��, g��boko��

    %Pozycja pocz�tkowa jako struktura (x,y,z)

    initial_position = struct;
    initial_position.x = round((N - 1) * rand(1)) + 1; % 1;
    initial_position.y = round((N - 1) * rand(1)) + 1; % 3;
    initial_position.z = round((H - 1) * rand(1)) + 1; % 7;

    drone.position = initial_position; %inicjalizacja warto�ci� pocz�tkow� pozycji drona
    drone.initial_position = initial_position;

    initial_speed = 1; % inicjalizacja warto�ci� pocz�tkow� pr�dko�ci

    initial_energy = (initial_energy_max - initial_energy_min) * rand(1) + initial_energy_min; % inicjalizacja warto�ci� pocz�tkow� energii

    drone.speed = initial_speed; %przypisanie do pr�dko�ci drona warto�ci zainicjalizowanej

    drone.energy = initial_energy; %przypisanie do energii drona warto�ci zainicjalizowanej
    drone.initial_energy = initial_energy; 

    drone.sensors_range = 1; %zasi�g czujnika (na ile kom�rek dron widzi w prz�d)

    %pozycja pilota b�d�ca struktur� (przechowuj�c� wsp�rz�dne)

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
    
    pilot_position.z = round(H/10); %obni�enie si� do wysoko�ci 0.1 H w celu zrzucenia zaopatrzenia
    drone.pilot_position = pilot_position; %przypisanie do pola pilot_position w strukturze dron po�o�enia pilota

    
    
end