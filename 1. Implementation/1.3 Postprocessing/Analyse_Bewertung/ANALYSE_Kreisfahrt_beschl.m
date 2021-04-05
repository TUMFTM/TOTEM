function [delta_v, delta_psi_1s] = ANALYSE_Kreisfahrt_beschl( sv_FZG_psi, sv_time, sv_FZG_x)

%% Suche Giergeschwindigkeitsänderung und Geschwindigkeitsänderung zum und eine Sekunde nach Beschleunigung
ind_0s = find(sv_time == 5);
ind_1s = find(sv_time == 6);
v_0s = sv_FZG_x(ind_0s,2);
v_1s = sv_FZG_x(ind_1s,2);

delta_psi_1s = rad2deg(sv_FZG_psi(ind_1s,2)) - rad2deg(sv_FZG_psi(ind_0s,2));
delta_v = (sv_FZG_x(ind_1s,2) - sv_FZG_x(ind_0s,2))*3.6;


end

