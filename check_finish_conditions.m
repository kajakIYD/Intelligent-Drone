function [predicates, drone] = check_finish_conditions(drone, predicates)

    
    if (drone.position.x == drone.initial_position.x && drone.position.y == drone.initial_position.y && drone.position.z == drone.initial_position.z && drone.pilot_position_achieved == true)
        drone.if_return_to_start = true;
    end

end