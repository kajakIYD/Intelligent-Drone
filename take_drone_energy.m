function drone = take_drone_energy(drone) %funkcja odpowiedzialna za pobranie energii drona

    a = 0.1;    
    
    drone.energy = drone.energy - a * drone.position.z;



end