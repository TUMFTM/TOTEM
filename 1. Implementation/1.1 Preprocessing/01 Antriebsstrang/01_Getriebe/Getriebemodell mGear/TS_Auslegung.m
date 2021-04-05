function [m_torque,m_torque_cost,d_torque,l_torque,J_torque] = TS_Auslegung(d_torque_ver,d_sh_4,T_max_torque,T_nenn)
%Ruft die einzelnen TS-Funktionen nacheinander auf um den Torque Splitter
%auszulegen

 %T_nenn     =  Nennmoment der Antriebs E-Maschine, ben�tigt f�r Regression in der thermischen Auslegung

 if d_torque_ver >120               % selbst gew�hlte Begrenzung der max. radialen Bauraums f�r den TS, falls mehr vorhanden sein sollte.
     d_torque_ver=120;              % aus Kosten-/Tr�gheitsgr�nden etc. da er bei sehr gro�en Getrieben zu gro� wird und damit auch die daran gekoppelten Lamellen
 else
     d_torque_ver=d_torque_ver;
 end
 
 

 
 %% Aufruf der Auslegung f�r das �bertragbare Moment

[d_a,A_l,M_s,la,z,] = TS (d_torque_ver,d_sh_4,T_max_torque);

%% Aufruf der thermischen Auslegung mit eventueller Anpassung der Lamellenanzahl la und damit Reibfl�chenzahl z

[la,z] = TS_thermisch(T_nenn,T_max_torque,A_l,la);

%% Aufruf der Gewichtsfunktion f�r Gewicht und Tr�gheit des Lamellenpaketes

[l_torque,m_torque,m_torque_cost,J_torque] =  TS_Gewicht(z,d_torque_ver,d_sh_4);

d_torque= d_torque_ver;
end

