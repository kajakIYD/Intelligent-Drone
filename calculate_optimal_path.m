function [optimal_path, predicates] = calculate_optimal_path(drone, predicates)
    
    drone_position = drone.position;
    pilot_position = drone.pilot_position;
    pilot_position_achieved = drone.pilot_position_achieved;
    
    if (pilot_position_achieved == false)
        %1.os y 2.os x 3.os z

        y_movement = pilot_position.y - drone_position.y; %ruch przod/tyl

        x_movement = pilot_position.x - drone_position.x;%ruch prawo/lewo

        z_movement = pilot_position.z - drone_position.z;%ruch gora/dol

        optimal_path.y = y_movement;
        optimal_path.x = x_movement;
        optimal_path.z = z_movement;

        MF_p = struct;
        MF_p.nazwa = 'MF_p'; %'ruch_w_przod priorytet';
        MF_p.wartosc = false;
        MF_p.jest_ustawiony = true;

        MB_p = struct;
        MB_p.nazwa = 'MB_p'; %'ruch_w_przod priorytet';
        MB_p.wartosc = false;
        MB_p.jest_ustawiony = true;

        MR_p = struct;
        MR_p.nazwa = 'MR_p'; %'ruch_w_dol priorytet';
        MR_p.wartosc = false;
        MR_p.jest_ustawiony = true;

        ML_p = struct;
        ML_p.nazwa = 'ML_p'; %'ruch_w_lewo priorytet';
        ML_p.wartosc = false;
        ML_p.jest_ustawiony = true; 

        MD_p = struct;
        MD_p.nazwa = 'MD_p'; %'ruch_w_dol priorytet';
        MD_p.wartosc = false;
        MD_p.jest_ustawiony = true;

        MU_p = struct;
        MU_p.nazwa = 'MU_p'; %'ruch_w_gore priorytet';
        MU_p.wartosc = false;
        MU_p.jest_ustawiony = true;
        
        predicates.MF_p = MF_p;
        predicates.MB_p = MB_p;
        predicates.MR_p = MR_p;
        predicates.ML_p = ML_p;
        predicates.MD_p = MD_p;
        predicates.MU_p = MU_p;

        if (y_movement > 0)
            predicates.MF_p.wartosc = true;
            return
        end
        if (y_movement == 0 && x_movement > 0)
            predicates.MR_p.wartosc = true;
            return;
        end
        if (y_movement == 0 && x_movement < 0)
            predicates.ML_p.wartosc = true;
            return;
        end
        if (y_movement == 0 && x_movement == 0 && z_movement < 0)
            predicates.MD_p.wartosc = true;
            return;
        end
        if (y_movement == 0 && x_movement == 0 && z_movement > 0)
            predicates.MU_p.wartosc = true;
            return;
        end
        if (y_movement < 0)
            predicates.MB_p.wartosc = true;
        end
    else
        %1.os y 2.os x 3.os z

        y_movement = drone.initial_position.y - drone_position.y; %ruch przod/tyl

        x_movement = drone.initial_position.x - drone_position.x;%ruch prawo/lewo

        z_movement = drone.initial_position.z - drone_position.z;%ruch gora/dol

        optimal_path.y = y_movement;
        optimal_path.x = x_movement;
        optimal_path.z = z_movement;

        MF_p = struct;
        MF_p.nazwa = 'MF_p'; %'ruch_w_przod priorytet';
        MF_p.wartosc = false;
        MF_p.jest_ustawiony = true;

        MB_p = struct;
        MB_p.nazwa = 'MB_p'; %'ruch_w_przod priorytet';
        MB_p.wartosc = false;
        MB_p.jest_ustawiony = true;
        
        MR_p = struct;
        MR_p.nazwa = 'MR_p'; %'ruch_w_dol priorytet';
        MR_p.wartosc = false;
        MR_p.jest_ustawiony = true;

        ML_p = struct;
        ML_p.nazwa = 'ML_p'; %'ruch_w_lewo priorytet';
        ML_p.wartosc = false;
        ML_p.jest_ustawiony = true; 

        MD_p = struct;
        MD_p.nazwa = 'MD_p'; %'ruch_w_dol priorytet';
        MD_p.wartosc = false;
        MD_p.jest_ustawiony = true;
        
        MU_p = struct;
        MU_p.nazwa = 'MU_p'; %'ruch_w_dol priorytet';
        MU_p.wartosc = false;
        MU_p.jest_ustawiony = true;

        predicates.MF_p = MF_p;
        predicates.MB_p = MB_p;
        predicates.MR_p = MR_p;
        predicates.ML_p = ML_p;
        predicates.MD_p = MD_p;
        predicates.MU_p = MU_p;

        if (y_movement < 0)
            predicates.MB_p.wartosc = true;
            return
        end
        if (y_movement == 0 && x_movement > 0)
            predicates.MR_p.wartosc = true;
            return;
        end
        if (y_movement == 0 && x_movement < 0)
            predicates.ML_p.wartosc = true;
            return;
        end
        if (y_movement == 0 && x_movement == 0 && z_movement < 0)
            predicates.MD_p.wartosc = true;
            return;
        end
        if (y_movement == 0 && x_movement == 0 && z_movement > 0)
            predicates.MU_p.wartosc = true;
            return;
        end
        if (y_movement > 0)
            predicates.MF_p.wartosc = true;
            return;
        end
    end
end