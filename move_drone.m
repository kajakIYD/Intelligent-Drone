%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%funkcja odpowiedzialna za poruszanie dronem
%przyjmuje informacje o dronie oraz ruchu do przejœcia (aktualizacja
%parametrów drona)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [drone] = move_drone(drone, move_to_make)

    drone.position.x = drone.position.x + move_to_make.x * drone.speed;
    drone.position.y = drone.position.y + move_to_make.y * drone.speed;
    drone.position.z = drone.position.z + move_to_make.z * drone.speed;

end