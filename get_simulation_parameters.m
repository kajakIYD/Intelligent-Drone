%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Funkcja s�u�aca do pobrania wartosci do symulacji drona (H,N, polozenie
%poczatkowe drona i pilota, zasieg czujnikow poczatkowy, predkosc
%poczatkowa)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [drone, N, H, pilot_position] = get_simulation_parameters(drone, N_max, N_min, H_max, H_min, initial_energy_max, initial_energy_min, randomMode)


if (randomMode == true)
    %1. Parametryzacja parametr�w H,N (wysoko��, szeroko�� , g��boko��)

    H = round((H_max  - H_min) * rand(1)) + H_min; %wysoko��

    N = round((N_max - N_min) * rand(1)) + N_min;  %szeroko��, g��boko��
else
    %%Parametry ustawiane na sztywno
    N = N_max;
    H = H_max;
end
    
    %Pozycja pocz�tkowa jako struktura (x,y,z)

    initial_position = struct;
    initial_position.x = 9;%round((N - 1) * rand(1)) + 1; %9; 8; 10; 1;
    initial_position.y = 9;%round((N - 1) * rand(1)) + 1; %9; 5; 4; 3;
    initial_position.z = 8;%round((H - 1) * rand(1)) + 1; %4; 5; 6; 7;

    drone.position = initial_position; %inicjalizacja warto�ci� pocz�tkow� pozycji drona
    drone.initial_position = initial_position;

    initial_speed = 1; % inicjalizacja warto�ci� pocz�tkow� pr�dko�ci

    initial_energy = (initial_energy_max - initial_energy_min) * rand(1) + initial_energy_min; % inicjalizacja warto�ci� pocz�tkow� energii

    drone.speed = initial_speed; %przypisanie do pr�dko�ci drona warto�ci zainicjalizowanej

    drone.energy = initial_energy; %przypisanie do energii drona warto�ci zainicjalizowanej
    drone.initial_energy = initial_energy; 

    drone.sensors_range = 1; %zasi�g czujnika (na ile kom�rek dron widzi w prz�d)

    %pozycja pilota b�d�ca struktur� (przechowuj�c� wsp�rz�dne)

    pilot_position= struct;
    
 %%%%%%Scenariusz testowy 1,2 

    pilot_position.x = 3;

    pilot_position.y = 3;

% For debugging only
%     N = 11;
%     H = 15;
%     
%     drone.position.x = 9;
%     drone.position.y = 7;
%     drone.position.z = 5;
    
    pilot_position.z = 3;%round(H/10); %obni�enie si� do wysoko�ci 0.1 H w celu zrzucenia zaopatrzenia
    if (pilot_position.z == 0)
        pilot_position.z = 1;
    end
    
    drone.pilot_position = pilot_position; %przypisanie do pola pilot_position w strukturze dron po�o�enia pilota

end