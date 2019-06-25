function [message] = analyze_results(drone, moves_and_states, simulation_time, message)
%analiza rezultatów (dron w czasie)
    
    if (drone.if_return_to_start == true)
        message  = [message 'Misja zakoñczona powodzeniem' newline];
    else
        message  = [message 'Misja zakoñczona niepowodzeniem' newline];
    end
    
    message  = [message 'Symulacja trwa³a: ' num2str(simulation_time) ' iteracji ' newline];
    
    suma = 0;
    for move = moves_and_states.moves
        suma = suma + abs(move.x) + abs(move.y) + abs(move.z);
    end
    
    avg_speed = suma / simulation_time;
    message = [message 'Œrednia prêdkoœæ: ' num2str(avg_speed) newline];
    
    message  = [message 'Energia pocz¹tkowa: ' num2str(drone.initial_energy) ' Pozosta³o energii: ' num2str(drone.energy)];
end