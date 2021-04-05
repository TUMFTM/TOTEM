function [delta_h, psip_stat_fg, beta_stat_fg] = ANALYSE_Kreisfahrt_fuer_sinuslenken( sv_FZG_y, sv_FAH_delta_h,sv_FZG_beta, sv_FZG_psi)
%% Funktion die das Eingangsmanöver für sinus-lenken analysiert

%% suche Indizes bei dem die Querbeschleunigung gleich 4 m/s^2 beträgt 
ind_4 = find(abs(sv_FZG_y(:,3)-4) == min(abs(sv_FZG_y(:,3)-4)));

%% suche lenkradwinkel
delta_h = sv_FAH_delta_h(ind_4);
%% suche Gierrate
psip_stat_fg = rad2deg(sv_FZG_psi(ind_4, 2));

%% suche Schwimmwinkel 
beta_stat_fg = abs(sv_FZG_beta(ind_4, 1));

end

