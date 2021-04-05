function [deltah_beschl,v_beschl ] = ANALYSE_Kreisfahrt_fuer_Manoever( sv_FZG_x, sv_FAH_delta_h1, sv_FZG_y,select_mu)
%% Funktion die die Geschwindigkeit und den Lenkradwinkel bei einer best. Querbeschleunigung sucht

%% Suche Indizes bei denen eine Querbeschleunigung von 4 m/s^2 bzw. 1.5 m/s^2 herrscht
if select_mu == 2
%     ind_ay0 = find(abs(sv_FZG_y(length(sv_FAH_delta_h1)/3:length(sv_FAH_delta_h1)*2/3,3)-2) == min(abs(sv_FZG_y(length(sv_FAH_delta_h1)/3:length(sv_FAH_delta_h1)*2/3,3)-2)));
    ind_ay0 = 99 + find((sv_FZG_y(100:end,3)-1.5)>0, 1,'first'); %-2 wurde druch -1 ersetzt
    deltah_beschl = sv_FAH_delta_h1(ind_ay0);
    v_beschl = sv_FZG_x(ind_ay0,2);
else
ind_ay0 = find(abs(sv_FZG_y(floor(length(sv_FAH_delta_h1)/3):end,3)-4) == min(abs(sv_FZG_y(floor(length(sv_FAH_delta_h1)/3):end,3)-4)));
deltah_beschl = sv_FAH_delta_h1(ind_ay0+(round(length(sv_FAH_delta_h1)/3)));
v_beschl = sv_FZG_x(ind_ay0+(round(length(sv_FAH_delta_h1)/3)),2);
end
% ind_ay0 = find(abs(sv_FZG_y(:,3)-1.2) == min(abs(sv_FZG_y(:,3)-1.2)));

end

