function plot_simulation(environment, drone, moves_and_states)
% prezentacja wyników po zebraniu symulacji

%%kazdy element srodowiska wyplotowac w siatce 3d, zalezznie od wartosci
%%ktora siedzi w environment odpowiednio np. pokolorowac znaczniki
for i = 1 : 3 * length(environment(:, 1,1))
    x(i) = mod(i, length(environment(:, 1,1)): 
y = 1 : length(environment(1, :,1));
z = environment(1, 1,:);
z = 1 : length(z(:));

plot3(x, y, z, 'o');

end