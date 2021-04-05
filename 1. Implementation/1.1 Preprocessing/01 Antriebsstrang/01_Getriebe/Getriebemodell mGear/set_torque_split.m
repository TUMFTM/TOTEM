function [J_torque,l_torque,d_torque,m_torque,m_torque_cost,m_E,m_F,b_E,b_F,d_A_E,d_A_F,d_sh_E,d_sh_F,d_sh_4,d_1_E,d_1_F,Fehlerbit,Fehlercode,ID_E,ID_F] = ...
    set_torque_split(d_kegel,m_n_3,T_max,F_u_3,F_ax_3,F_rad_3,n_eck,d_4,b_3,i_12,i_34,values_B,Fehlerbit,Fehlercode,ueberlast,values_C,d_3,d_a2_1,T_nenn)

%Gestaltung des Torque Splitters
%Es wird zur Auslegung die Funktion von Alexander Tripps verwendet

%Aufruf der Auslegungsfunktion
d_sh_4=d_kegel-(5*m_n_3);   %Wellendurchmesser der Abtriebswellen
d_torque_ver=(((d_3+d_4)./2)-(d_a2_1./2)).*2; %verfügbarer Durchmesser für Lammellen
T_max_torque=(T_max.*i_12).*i_34;
%Funktionsaufruf

[m_torque,m_torque_cost,d_torque,l_torque,J_torque] = TS_Auslegung(d_torque_ver,d_sh_4,T_max_torque,T_nenn);

% l_torque;
% d_torque;
% m_torque;
%J_torque=0;

%Auslegung der wälzlager
[ l_3,m_E,m_F,b_E,b_F,d_A_E,d_A_F,d_sh_E,d_sh_F,d_sh_4,d_1_E,d_1_F,Fehlerbit,Fehlercode,ID_E,ID_F] = ...
    set_bearings_torque( F_u_3,F_ax_3,F_rad_3,i_12,i_34,b_3,d_4,n_eck,values_B,Fehlerbit,Fehlercode,ueberlast,values_C,d_sh_4,l_torque);


end

