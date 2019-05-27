%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Funkcja odpowiedzialna za %wykrycie zagro�enia. aktualizujemy wartosci predykatow za pomoc� parametru pozycji drona oraz drogi do przej�cia
%opdpowiada to funkcji TELL - bazy wiedzy b�dzie si� zmienia� w ka�dym kroku symulacji
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [predicates] = detect_danger(drone, environment, optimal_path, predicates) 
    %cube_to_pass - wycinek srodowiska do sprawdzenia (tam sa 'r' 'g')
    
    %%%%%TODO%%%%%
    %trzeba sprawdzac czy jestesmy na granicy srodowiska, zeby nie probowac
    %wykryc radaru albo guna tam gdzie juz nie ma srodowiska
    
    %%predicates : radar wykryty, gun wykryty
    
    if (drone.pilot_position_achieved == true)
        predicates = detect_danger_backward_orientation(drone, environment, optimal_path, predicates);
    else
        predicates = detect_danger_forward_orientation(drone, environment, optimal_path, predicates);
    end
end