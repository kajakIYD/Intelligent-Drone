%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Funkcja odpowiedzialna za sprawdzenie wspó³rzêdnych (sprawdza równie¿ czy
%dron (agent nie jest na granicy oœrodka - jeœli tak to ustawia mu
%maksymalne wspó³rzêdne (N lub H w zale¿noœci od osi)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [x_start, x_end, y_start, y_end, z_start, z_end] = check_coordinates(drone, N, H)

    x_start = drone.position.x - drone.sensor_range;
    if (x_start < 1)
       x_start = 1; 
    end
    x_end = drone.position.x + drone.sensor_range;
    if (x_end < 1)
       x_end = 1; 
    end
    if (x_end > N)
        x_end = N; 
    end
    y_start = drone.position.y - drone.sensor_range;
    if (y_start < 1)
       y_start = 1; 
    end
    y_end = drone.position.x + drone.sensor_range;
    if (y_end > N)
       y_end = N; 
    end
    z_start = drone.position.z - drone.sensor_range;
    if (z_start < 1)
       z_start = 1; 
    end
    z_end = drone.position.x + drone.sensor_range;
    if (z_end > N)
       z_end = H; 
    end

end