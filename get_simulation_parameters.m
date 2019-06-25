%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Funkcja s³u¿aca do pobrania wartosci do symulacji drona (H,N, polozenie
%poczatkowe drona i pilota, zasieg czujnikow poczatkowy, predkosc
%poczatkowa)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [drone, N, H, pilot_position] = get_simulation_parameters(drone, N_max, N_min, H_max, H_min, initial_energy_max, initial_energy_min, randomMode)


if (randomMode == true)
    %1. Parametryzacja parametrów H,N (wysokoœæ, szerokoœæ , g³êbokoœæ)

    H = round((H_max  - H_min) * rand(1)) + H_min; %wysokoœæ

    N = round((N_max - N_min) * rand(1)) + N_min;  %szerokoœæ, g³êbokoœæ
else
    %%Parametry ustawiane na sztywno
    N = N_max;
    H = H_max;
end
    
    %Pozycja pocz¹tkowa jako struktura (x,y,z)

    initial_position = struct;
    initial_position.x = 9;%round((N - 1) * rand(1)) + 1; %9; 8; 10; 1;
    initial_position.y = 9;%round((N - 1) * rand(1)) + 1; %9; 5; 4; 3;
    initial_position.z = 8;%round((H - 1) * rand(1)) + 1; %4; 5; 6; 7;

    drone.position = initial_position; %inicjalizacja wartoœci¹ pocz¹tkow¹ pozycji drona
    drone.initial_position = initial_position;

    initial_speed = 1; % inicjalizacja wartoœci¹ pocz¹tkow¹ prêdkoœci

    initial_energy = (initial_energy_max - initial_energy_min) * rand(1) + initial_energy_min; % inicjalizacja wartoœci¹ pocz¹tkow¹ energii

    drone.speed = initial_speed; %przypisanie do prêdkoœci drona wartoœci zainicjalizowanej

    drone.energy = initial_energy; %przypisanie do energii drona wartoœci zainicjalizowanej
    drone.initial_energy = initial_energy; 

    drone.sensors_range = 1; %zasiêg czujnika (na ile komórek dron widzi w przód)

    %pozycja pilota bêd¹ca struktur¹ (przechowuj¹c¹ wspó³rzêdne)

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
    
    pilot_position.z = 3;%round(H/10); %obni¿enie siê do wysokoœci 0.1 H w celu zrzucenia zaopatrzenia
    if (pilot_position.z == 0)
        pilot_position.z = 1;
    end
    
    drone.pilot_position = pilot_position; %przypisanie do pola pilot_position w strukturze dron po³o¿enia pilota

end