function [m_torque,m_torque_cost,d_torque,l_torque,J_torque] = TS_Auslegung(d_torque_ver,d_sh_4,T_max_torque,T_nenn)
%Ruft die einzelnen TS-Funktionen nacheinander auf um den Torque Splitter
%auszulegen

 %T_nenn     =  Nennmoment der Antriebs E-Maschine, benötigt für Regression in der thermischen Auslegung

 if d_torque_ver >120               % selbst gewählte Begrenzung der max. radialen Bauraums für den TS, falls mehr vorhanden sein sollte.
     d_torque_ver=120;              % aus Kosten-/Trägheitsgründen etc. da er bei sehr großen Getrieben zu groß wird und damit auch die daran gekoppelten Lamellen
 else
     d_torque_ver=d_torque_ver;
 end
 
 

 
 %% Aufruf der Auslegung für das übertragbare Moment

[d_a,A_l,M_s,la,z,] = TS (d_torque_ver,d_sh_4,T_max_torque);

%% Aufruf der thermischen Auslegung mit eventueller Anpassung der Lamellenanzahl la und damit Reibflächenzahl z

[la,z] = TS_thermisch(T_nenn,T_max_torque,A_l,la);

%% Aufruf der Gewichtsfunktion für Gewicht und Trägheit des Lamellenpaketes

[l_torque,m_torque,m_torque_cost,J_torque] =  TS_Gewicht(z,d_torque_ver,d_sh_4);

d_torque= d_torque_ver;
end

