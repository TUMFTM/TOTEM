function [la_nach_therm,z_nach_therm] = TS_thermisch(Nenndrehmoment,T_max_torque,A_l,la)
%Berechnet die benötigten Kennwerte für die Thermische Modellierung des
%Torque Splitters


M_Max = T_max_torque;
M_s = M_Max*1.2;            %M_s ist das mit dem Faktor 1,2 korrigierte Maximale Moment aus der Funktion TS 
M_nenn = Nenndrehmoment;    % der E-Maschine

 
%Gehäuseoberfläche und Abmessungen aus Regression des Eingang-Gehäuses 

A_geh_mm = (1.8196 * M_Max + 1802.4);   % in mm²
A_geh = A_geh_mm /10000;                % in m²

%Höhe des Getriebes
h_geh_mm = (0.0482*M_Max + 165.66);     % in mm
h_geh = h_geh_mm/1000;                  % in m

%Länge des Getriebes
l_geh_mm = (0.0484*M_Max + 267.8) ;     % in mm
l_geh = l_geh_mm/1000;                  % in m

%Berechnung von alpha_außen Methode nach Niemann Winter Höhn

T_um  = 293.15;         % in K
T_oel = 373.15;         % in K
T_geh = T_oel;
f_k   = 3.6;            % aus Durchschnittsgeschwindigkeit NEFZ und Tabelle aus Nieman Winter Höhn, ME2, S. 226
alpha_au = f_k * (10+0.07*(T_geh-T_um))*((1/h_geh)^0.15) ;

%Berechnung von k
lambda_geh=115;         % Gehäusewerkstoff AlSi9Cu3 ; in W/mK
alpha_in = 200;         % W/m²K; Wärmeübergangszahl von Öl an Gehäuseinnenseite 

k = 1/((1/alpha_in)+(0.05/lambda_geh)+(1/alpha_au));

%% Berechnung des Wärmestroms durch Gehäuse
T_oel=373.15; %Annahme aus Literatur für max. Öltemperatur in einem Getriebe in Kelvin  

Q_punkt_geh = k * A_geh * (T_oel-T_um);


%% Verlustleistung des Getriebes berechnen
% Faktor_belastung_lastspiele = 0.33 ;% Aus Auslegung Müller
eta_gear = 0.98 ;% Aus Wirkungsgradberechnung Seeger 
 
%P_V_gear_max = 2*pi*M_nenn*Faktor_belastung_lastspiele*(7000/60)*(1-eta_min)

P_V_gear_max = 2*pi*M_nenn*(5000/60)*(1-eta_gear);
 

%% Wärme Leistung abgeführt an den Lamellen durch Öl
alpha_la = 2025 ;   % W/Km² %Diss Wohlleber
Ant_nut=0.44 ;      % Nutflächenanteil der Belaglamelle 
dT_max = 150 ;      % maximale Temperaturdifferenz in Kelvin ( öl = 100°C zu Tmax = 250°C Lamellen)

P_V_la = alpha_la * Ant_nut * A_l * la * 2 * dT_max  ; 


%% Wärme Leistung eines Torque Splitters bei max Belastung
delta_omega_max=2.5; % in rad/s

P_V_TS = (M_s/2) * delta_omega_max;


%% Verfügbarkeit berechnen
 delta_Q_verfueg =Q_punkt_geh - P_V_gear_max  ;% berechnet wie viel Kühlleistung
                                               % des Gehäuses nach Abzug der Getriebeverluste noch zur Verfügung steht. 
 Verfueg_faktor = delta_Q_verfueg / P_V_TS;


%% Lamellenzahl berechnen um thermisch i.O zu sein. So lange eine Reiblamelle zum Kupplungspaket hinzufügen, 
%  bis die abgeführte Wärme kleiner der zugeführten ist

while P_V_TS > P_V_la
    la=la+1;
    P_V_la = alpha_la * Ant_nut * A_l * la * 2 * dT_max  ;
end

la_nach_therm=la;                % neue Lamellenanzahl
z_nach_therm=2*la_nach_therm;    % neue Reibflächenanzahl
end

