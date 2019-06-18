function [message] = append_move_to_message(message, move)

    message = [message 'Ruch: x=' num2str(move.x) ' y=' num2str(move.y) ' z=' num2str(move.z) newline];
        
end