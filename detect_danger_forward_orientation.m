    %%%%%%%%%%%%%%%%%%%%%%%%RADAR%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%gor, dol, prawo, lewo
function [predicates] = detect_danger_forward_orientation(drone, environment, optimal_path, predicates)
    [N, ~, H] = size(environment); %tylda - tu nic nie wpisuj

    RS = struct;
    RS.nazwa = 'RS'; %'radar_wykryty_na_wprost';
    RS.wartosc = false;
    if (optimal_path.y > 0)
        for i = 1:drone.sensors_range
            if (drone.position.y + i <= N) %zabezpieczenie aby nie wyjsc poza granice srodowiska
                if (environment(drone.position.x , drone.position.y + i, drone.position.z) == 'r')
                   RS.wartosc = true;
                   break;
                end
            end
        end
    end    
    RS.jest_ustawiony = true;
    
    
    nRS = struct;
    nRS.nazwa = 'nRS'; %'radar_nie_wykryty_na_wprost';
    nRS.wartosc = ~RS.wartosc;
    nRS.jest_ustawiony = true;
    
    RR = struct;
    RR.nazwa = 'RR'; %'radar_wykryty_na_prawo';
    RR.wartosc = false;
    if (optimal_path.x > 0)
        for i = 1:drone.sensors_range
            if (drone.position.x + i <= N) %zabezpieczenie aby nie wyjsc poza granice srodowiska
                if (environment(drone.position.x + i, drone.position.y, drone.position.z) == 'r')
                   RR.wartosc = true;
                   break;
                end
            end
        end
    end
    RR.jest_ustawiony = true;
    
    
    nRR = struct;
    nRR.nazwa = 'nRR'; %'radar_nie_wykryty_na_prawo';
    nRR.wartosc = ~RR.wartosc;
    nRR.jest_ustawiony = true;
    
    RL = struct;
    RL.nazwa = 'RL'; %'radar_wykryty_na_lewo';
    RL.wartosc = false;
    if (optimal_path.x < 0)
        for i = 1:drone.sensors_range
            if (drone.position.x - i >= 1) %zabezpieczenie aby nie wyjsc poza granice srodowiska
                if (environment(drone.position.x - i, drone.position.y, drone.position.z) == 'r')
                   RL.wartosc = true;
                   break;
                end
            end
        end
    end
    RL.jest_ustawiony = true;
    
    
    nRL = struct;
    nRL.nazwa = 'nRL'; %'radar_nie_wykryty_na_lewo';
    nRL.wartosc = ~RL.wartosc;
    nRL.jest_ustawiony = true;
    
    RU = struct;
    RU.nazwa = 'RU'; %'radar_wykryty_na_gorze';
    RU.wartosc = false;
    % ruch w gore nie ma sensu (mamy ustalona wartosc Hmin i jesli jestesmy
    % ponizej niej to mozemy wykonac zrzut)
    for i = 1:drone.sensors_range
        if (drone.position.z + i <= H) %zabezpieczenie aby nie wyjsc poza granice srodowiska
            if (environment(drone.position.x , drone.position.y, drone.position.z + i) == 'r')
               RU.wartosc = true;
               break;
            end
        end
    end
    RU.jest_ustawiony = true;
    
    
    nRU = struct;
    nRU.nazwa = 'nRU'; %'radar_nie_wykryty_na_gorze';
    nRU.wartosc = ~RU.wartosc;
    nRU.jest_ustawiony = true;
    
    RD = struct;
    RD.nazwa = 'RD'; %'radar_wykryty_na_dole';
    RD.wartosc = false;
    if (optimal_path.z < 0)
        for i = 1:drone.sensors_range
            if (drone.position.z - i >= 1) %zabezpieczenie aby nie wyjsc poza granice srodowiska
                if (environment(drone.position.x , drone.position.y, drone.position.z - i) == 'r')
                   RD.wartosc = true;
                   break;
                end
            end
        end
    end    
    RD.jest_ustawiony = true;
    
    
    nRD = struct;
    nRD.nazwa = 'nRD'; %'radar_nie_wykryty_na_dole';
    nRD.wartosc = ~RD.wartosc;
    nRD.jest_ustawiony = true;
    
    %%%%%%%%%%%%%%%%%%%%%%%%GUN%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%gor, dol, prawo, lewo
    
    GS = struct;
    GS.nazwa = 'GS'; %'gun_wykryty_na_wprost';
    GS.wartosc = false;
    if (optimal_path.y > 0)
        for i = 1:drone.sensors_range
            if (drone.position.y + i <= N) %zabezpieczenie aby nie wyjsc poza granice srodowiska
                if (environment(drone.position.x , drone.position.y + i, drone.position.z) == 'g')
                   GS.wartosc = true;
                   break;
                end
            end
        end
    end
    GS.jest_ustawiony = true;
    
    
    nGS = struct;
    nGS.nazwa = 'nGS'; %'gun_nie_wykryty_na_wprost';
    nGS.wartosc = ~GS.wartosc;
    nGS.jest_ustawiony = true;
    
    GR = struct;
    GR.nazwa = 'GR'; %'gun_wykryty_na_prawo';
    GR.wartosc = false;
    if (optimal_path.x > 0)
        for i = 1:drone.sensors_range
            if (drone.position.x + i <= N) %zabezpieczenie aby nie wyjsc poza granice srodowiska
                if (environment(drone.position.x + i, drone.position.y, drone.position.z) == 'g')
                   GR.wartosc = true;
                   break;
                end
            end
        end
    end
    GR.jest_ustawiony = true;
    
    
    nGR = struct;
    nGR.nazwa = 'nGR'; %'gun_nie_wykryty_na_prawo';
    nGR.wartosc = ~GR.wartosc;
    nGR.jest_ustawiony = true;
    
    GL = struct;
    GL.nazwa = 'RL'; %'gun_wykryty_na_lewo';
    GL.wartosc = false;
    if (optimal_path.x < 0)
        for i = 1:drone.sensors_range
            if (drone.position.x - i >= 1) %zabezpieczenie aby nie wyjsc poza granice srodowiska
                if (environment(drone.position.x - i, drone.position.y, drone.position.z) == 'r')
                   GL.wartosc = true;
                   break;
                end
            end
        end
    end
    GL.jest_ustawiony = true;
    
    
    nGL = struct;
    nGL.nazwa = 'nGL'; %'gun_nie_wykryty_na_lewo';
    nGL.wartosc = ~GL.wartosc;
    nGL.jest_ustawiony = true;
    
    GU = struct;
    GU.nazwa = 'GU'; %'gun_wykryty_na_gorze';
    GU.wartosc = false;
    for i = 1:drone.sensors_range
        if (drone.position.z + i <= H) %zabezpieczenie aby nie wyjsc poza granice srodowiska
            if (environment(drone.position.x , drone.position.y, drone.position.z + i) == 'g')
               GU.wartosc = true;
               break;
            end
        end
    end
    GU.jest_ustawiony = true;
    
    
    nGU = struct;
    nGU.nazwa = 'nRU'; %'gun_nie_wykryty_na_gorze';
    nGU.wartosc = ~GU.wartosc;
    nGU.jest_ustawiony = true;
    
    GD = struct;
    GD.nazwa = 'GD'; %'gun_wykryty_na_dole';
    GD.wartosc = false;
    if (optimal_path.z < 0)
        for i = 1:drone.sensors_range
            if (drone.position.z - i >= 1) %zabezpieczenie aby nie wyjsc poza granice srodowiska
                if (environment(drone.position.x , drone.position.y, drone.position.z - i) == 'g')
                   GD.wartosc = true;
                   break;
                end
            end
        end
    end
    GD.jest_ustawiony = true;
    
    
    nGD = struct;
    nGD.nazwa = 'nGD'; %'gun_nie_wykryty_na_dole';
    nGD.wartosc = ~GD.wartosc;
    nGD.jest_ustawiony = true;
    
    predicates.RS = RS;
    predicates.nRS = nRS;
    predicates.RR = RR;
    predicates.nRR = nRR;
    predicates.RL = RL;
    predicates.nRL = nRL;
    predicates.RU = RU;
    predicates.nRU = nRU;
    predicates.RD = RD;
    predicates.nRD = nRD;
    predicates.GS = GS;
    predicates.nGS = nGS;
    predicates.GR = GR;
    predicates.nGR = nGR;
    predicates.GL = GL;
    predicates.nGL = nGL;
    predicates.GU = GU;
    predicates.nGU = nGU;
    predicates.GD = GD;
    predicates.nGD = nGD;
    
    
    %%
    %%, RR, nRR, RL, nRL, RU, nRU, RD, nRD, GS, nGS, GR, nGR, GL, nGL, GU, nGU, GD, nGD];
end