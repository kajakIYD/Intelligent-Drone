function [predicates, drone] = check_pilot_presence(drone, pilot_position, predicates)
    
    POP = struct %%Position Over Pilot
    POP.nazwa = 'POP'; 
    POP.wartosc = false;
    POP.jest_ustawiony = true;
    
    
    if (drone.position.x == pilot_position.x && drone.position.y == pilot_position.y && drone.position.z <= pilot_position.z)
       drone.pilot_position_achieved = true;
       POP.wartosc = true;
    end
    
    nPOP = struct %%Position Over Pilot
    nPOP.nazwa = 'nPOP'; 
    nPOP.wartosc = ~POP.wartosc;
    nPOP.jest_ustawiony = true;
    
    predicates.POP = POP;
    predicates.nPOP = nPOP;
end