function drone_state = check_drone_state(drone, environment)

    drone_state.radar_contact = false;
    drone_state.gun_contact = false;
    
    if (environment(drone.position.x, drone.position.y, drone.position.z) == 'r')
        drone_state.radar_contact= true;
    end
    
    if (environment(drone.position.x, drone.position.y, drone.position.z) == 'g')
        drone_state.gun_contact= true;
    end
end