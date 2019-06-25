%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Sprawdzenie zasiegu czujnikow drona, ktore sa zalezne od wysokosci, na
% ktorej obecnie dron sie znajduje
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function drone = check_sensors_range(drone)

    if (drone.position.z > 1 && drone.position.z <= 3)
        drone.sensors_range = 1;
    elseif (drone.position.z > 3 && drone.position.z <= 7)
        drone.sensors_range = 2;
    elseif(drone.position.z > 7)
        drone.sensors_range = 3;
    end

end