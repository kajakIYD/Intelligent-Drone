%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Funkcja odpowiedzialna za %wykrycie zagro¿enia. aktualizujemy wartosci predykatow za pomoc¹ parametru pozycji drona oraz drogi do przejœcia
%opdpowiada to funkcji TELL - bazy wiedzy bêdzie siê zmieniaæ w ka¿dym kroku symulacji
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [predicates] = detect_danger(drone, environment, optimal_path, predicates) 
    %cube_to_pass - wycinek srodowiska do sprawdzenia (tam sa 'r' 'g')
    
    %%%%%TODO%%%%%
    %trzeba sprawdzac czy jestesmy na granicy srodowiska, zeby nie probowac
    %wykryc radaru albo guna tam gdzie juz nie ma srodowiska
    
    %%predicates : radar wykryty, gun wykryty
    
    if (drone.pilot_position_achieved == true)
        %Orientacja -> backwards, czyli radar na prowo -> szukamy po
        %wiêkszych wspolrzednych "x" niz pozycja drona, radar na lewo ->
        %szukamy po mniejszych wspolrzednych "x" niz pozycja drona, radar
        %na wprost -> z racji tego ze orientacja jest "backwards" to
        %szukamy po wspolrzednych "y" mniejszych niz pozycja drona
        predicates = detect_danger_backward_orientation(drone, environment, optimal_path, predicates);
    else
        predicates = detect_danger_forward_orientation(drone, environment, optimal_path, predicates);
    end
end