function [message] = analyze_results(drone, moves_and_states, simulation_time, message, randomMode, N, H)
%analiza rezultat�w (dron w czasie),
       
    if (randomMode == true)
        message = [message 'Random Mode ON' newline ' N=' num2str(N) ' H=' num2str(H) newline];
    else
        message = [message 'Random Mode OFF' newline];
    end

    if (drone.if_return_to_start == true)
        message  = [message 'Misja zako�czona powodzeniem' newline];
    else
        message  = [message 'Misja zako�czona niepowodzeniem' newline];
    end
    
    message  = [message 'Symulacja trwa�a: ' num2str(simulation_time) ' iteracji ' newline];
    
    suma = 0;
    for move = moves_and_states.moves
        suma = suma + abs(move.x) + abs(move.y) + abs(move.z);
    end
    
    avg_speed = suma / simulation_time;
    message = [message '�rednia pr�dko��: ' num2str(avg_speed) newline];
    
    message  = [message 'Energia pocz�tkowa: ' num2str(drone.initial_energy) ' Pozosta�o energii: ' num2str(drone.energy)];
end