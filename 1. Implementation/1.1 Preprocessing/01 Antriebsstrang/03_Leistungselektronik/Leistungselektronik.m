function [efficiency_map_LE, Powerfactor_map_LE, current_LE, voltage_LE, powerfactor_LE, speed_LE, torque_LE, ...
 Kosten_LE, Masse_LE] = Leistungselektronik(Optimierung, n_nenn, M_nenn, EM_Typ, Stkzahl, az, Mmax, U_RMS, n_max, M_achs)
% calculation of efficiency, costs and weight of inverter

%% Wirkungsgradberechnung
[efficiency_map_LE, Powerfactor_map_LE, current_LE, voltage_LE, powerfactor_LE, speed_LE, torque_LE] = ...
Leistungselektronik_Wirkungsgrad(Optimierung, EM_Typ, az, M_achs, n_max, U_RMS);

%% Kostenberechnung
[Kosten_LE] = Leistungselektronik_Kosten(n_nenn,M_nenn,Stkzahl);

%% Massenberechnung
[Masse_LE] = Leistungseletronik_Masse(Mmax, az, n_nenn);



end