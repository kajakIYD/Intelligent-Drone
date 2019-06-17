function [environment] = initialize_guns_and_radars(environment)
%%Docelowo liczba radarow i dzial oraz ich objetosc ladowane z pliku zawierajacego sceariusze testowe    

%     environment(3:5, 4:6, 5:7) = 'r'; %(od 3 do 5, od 4 do 6, od 5 do 7) %wstawienie do pól konkretnych zakresów literki 'r',która bêdzie oznaczaæ, ¿e w tych miejscach znajdowaæ siê bêdzie radar
%     environment(1:2, 1:2, 1:2) = 'r';
%     
    environment(9:10, 9:10, 9:10) = 'g';
    environment(8:9, 8:9, 8:9) = 'g';
    
    environment(1, 4, 7) = 'r'; %obok poz startowej drona
    environment(3, 4, 1) = 'r'; %obok pilota
    environment(4, 5, 1) = 'r'; %obok pilota
    environment(1, 3, 1) = 'r'; %obok pilota
end