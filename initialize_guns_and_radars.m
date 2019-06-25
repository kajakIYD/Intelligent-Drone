function [environment] = initialize_guns_and_radars(environment)
%%Docelowo liczba radarow i dzial oraz ich objetosc ladowane z pliku zawierajacego sceariusze testowe    

 %   environment(5:6, 5:6, 5:6) = 'r'; 
     environment(2, 2, 2) = 'r';
     
 %   environment(9:10, 9:10, 9:10) = 'g';
    environment(4, 4, 4) = 'g';
    
    
%    environment(1, 4, 7) = 'g'; %obok poz startowej drona
    
%    environment(5:6, 5:6, 5:6) = 'g';
%    environment(7:8, 7:8, 7:8) = 'r';
   % environment(1:N, 5, 3) = 'r'; %pasek radarów
   % environment(1:N, 5, 1:H) = 'r'; %œciana radarów
    
%    environment(3, 4, 1) = 'r'; %obok pilota
%    environment(4, 5, 1) = 'r'; %obok pilota
%    environment(1, 3, 1) = 'r'; %obok pilota
end