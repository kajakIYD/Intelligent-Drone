function plot_simulation(environment, drone, moves_and_states)
% prezentacja wyników po zebraniu symulacji

%%kazdy element srodowiska wyplotowac w siatce 3d, zalezznie od wartosci
%%ktora siedzi w environment odpowiednio np. pokolorowac znaczniki
% for i = 1 : 3 * length(environment(:, 1,1))
%     x(i) = mod(i, length(environment(:, 1,1)); 
x = 1 : length(environment(:, 1,1));
y = 1 : length(environment(1, :,1));
z = environment(1, 1,:);
z = 1 : length(z(:));

h = zeros(5,1);
%%%Scenariusz 2
%h = zeros(3,1);

for i = 1:length(x)
for k = 1:length(z)
   if (environment(i, 1, k) == 'r')
       h(2) =  plot3(i, 1, k, 'rx');
   elseif (environment(i, 1, k) == 'g')
       h(3) = plot3(i, 1, k, 'gx');  
   else
       h(1) = plot3(i, 1, k, 'b.');   
   end
   hold on
   
   if (environment(i, length(y), k) == 'r')
      h(2) = plot3(i, length(y), k, 'rx');
   elseif (environment(i, length(y), k) == 'g')
      h(3) = plot3(i, length(y), k, 'gx');   
   else
      h(1) = plot3(i, length(y), k, 'b.');   
   end
   hold on
end
end

for j = 1:length(y)
for k = 1:length(z)
   if (environment(1, j, k) == 'r')
       h(2) = plot3(1, j, k, 'rx');
   elseif (environment(1, j, k) == 'g')
       h(3) = plot3(1, j, k, 'gx');   
   else
       h(1) = plot3(1, j, k, 'b.');
   end   
   hold on
   
   if (environment(length(x), j, k) == 'r')
        h(2) = plot3(length(x), j, k, 'rx');
   elseif (environment(length(x), j, k) == 'g')
        h(3) = plot3(length(x), j, k, 'gx');   
   else
        h(1) = plot3(length(x), j, k, 'b.');
   end
   hold on
end
end

for j = 1:length(y)
for i = 1:length(x)
   if (environment(i, j, 1) == 'r')
        h(2) = plot3(i, j, 1, 'rx');
   elseif (environment(i, j, 1) == 'g')
        h(3) = plot3(i, j, 1, 'gx');   
   else
        h(1) = plot3(i, j, 1, 'b.');
   end
   hold on
   
   if (environment(i, j, length(z)) == 'r')
        h(2) = plot3(i, j, length(z), 'rx');
   elseif (environment(i, j, length(z)) == 'g')
        h(3) = plot3(i, j, length(z), 'gx');   
   else
        h(1) = plot3(i, j, length(z), 'b.');
   end
   
   hold on
end
end

drone_position_i = drone.initial_position;
for i = 1:length(moves_and_states.moves)
    drone_position_i_1.x = moves_and_states.moves(i).x;
    drone_position_i_1.y = moves_and_states.moves(i).y;
    drone_position_i_1.z = moves_and_states.moves(i).z;
    
    x_path = [drone_position_i.x, drone_position_i.x + drone_position_i_1.x * drone.speed];
    y_path = [drone_position_i.y, drone_position_i.y + drone_position_i_1.y * drone.speed];
    z_path = [drone_position_i.z, drone_position_i.z + drone_position_i_1.z * drone.speed];
    
    plot3(x_path, y_path, z_path, 'k'); 
    hold on;
    
    drone_position_i.x = x_path(2);
    drone_position_i.y = y_path(2);
    drone_position_i.z = z_path(2);
end
%%Scenariusz 2
%h(2) = plot3(drone.initial_position.x, drone.initial_position.y, drone.initial_position.z, 'm*');
h(4) = plot3(drone.initial_position.x, drone.initial_position.y, drone.initial_position.z, 'm*');
hold on
%h(3) = plot3(drone.pilot_position.x, drone.pilot_position.y, drone.pilot_position.z, 'c*');
h(5) = plot3(drone.pilot_position.x, drone.pilot_position.y, drone.pilot_position.z, 'c*');

%%Legenda dla kazdego rodzaju oznaczenia
% h(1) - puste pole
% h(2) - czerwone, radar
% h(3) - zielone, gun
% h(4) - magenta, dron i pilot

legend(h, 'Puste pole', 'Radar', 'Gun', 'Drone - start', 'Pilot');

%%%% Scenariusz 2
%legend(h, 'Puste pole', 'Drone - start', 'Pilot');


end