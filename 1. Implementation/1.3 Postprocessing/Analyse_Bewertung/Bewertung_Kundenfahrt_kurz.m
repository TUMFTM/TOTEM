E_el_Batt=trapz(P_Batt.Time, P_Batt.data);
                
if strcmp(get_param('simulation/Vehicle/Fahrzeugmodell/Configurable_model','BlockChoice'),'simplified_vehicle_model')
    vx=sv_FZG_x(:,2);
    v=vx;
    clear vx
else
    vx=sv_FZG_x(:,2);
    vy=sv_FZG_y(:,2);
    v=sqrt(vx.^2+vy.^2);
    clear vy vx
end

weg=trapz(sv_time, v);
sv_time;

consumption=E_el_Batt/weg/3600*100;
assignin('base', 'consumption', consumption);

if Optimierung.Modus ~= 1
disp(['verbrauchte Energie:    ', num2str(E_el_Batt/1000/3600), ' kWh'])
disp(['gefahrene Strecke:      ', num2str(weg/1000), ' km'])
disp(['Durchschnittsverbrauch: ', num2str(consumption), ' kWh/100km'])
end

clear P_el_EM_sum E_el_EM v weg