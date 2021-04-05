function [input_data, select_M_wheel,...
    activate_stop,activate_stop_vmax,ay_stop,deltav_ist,simtime, input_time, psip0,...
    savedec,stepsize,savestep, v0,v_final]...
    = Beschleunigung_Elastizitaet()
%% Skript zum Erzeugen der Input-Daten für das Manöver Beschleunigung von 0-100 km/h

% Simulationsparameter
stepsize = 1e-3;%5e-4;
savestep = 1e-2;
savedec = savestep / stepsize;
psip0 = 0;



% weitere Simulationsparameter
simtime = 40;    %40                                                          % [s] Simulationsdauer
input_time = (0 : stepsize: simtime)';                                       % [s] Zeitvektor
v0 = 0;                                                                      % [m/s] Startgeschwindigkeit
v_final = 70;                                                             % Beispielwert, geht nicht in Berechnungen mit ein

% Vorgaben als Array: [time, data]
input_r = zeros(length(input_time), 1);                                      % Vorgabe Radius (hier nicht verwendet)
input_v = [zeros(1001,1); linspace(250,250,39000)'];      %17500*4               % Vorgabe der Beschleunigung anhand bestem Lit.- WErt
input_psip = zeros(length(input_time), 1);                                   % Nutzung im Fahrerregler
input_delta_h =  zeros(length(input_time), 1);                               % Lenkradwinkel konstant 0
input_M_wheel =  [zeros(2001,1); 1000*ones(length(input_time)-2001, 1)];     % Nutzung bei manueller Vorgabe
input_zroad_RF = zeros(length(input_time), 1);                               % Strassenanregung
input_zroad_LF = zeros(length(input_time), 1);                               % Strassenanregung
input_zroad_RR = zeros(length(input_time), 1);                               % Strassenanregung
input_zroad_LR =  zeros(length(input_time), 1);                              % Strassenanregung

input_data = [input_time, input_r, input_v, input_psip, input_delta_h, input_M_wheel, ...
    input_zroad_RF, input_zroad_LF, input_zroad_RR, input_zroad_LR];

% Step-Bloecke zum Umschalten zwischen Vorgaben: 1 Lenkwinkel, 2 Radius, 3 Gierrate, 4 Spline
%select_delta_h = 1;                                  % []

% Step-Bloecke zum Umschalten zwischen Vorgaben: 1 Radmoment, 2 Geschwindigkeit, 3 Spline
select_M_wheel = 2;                                 % []


% Simulationsstop in quasi-stationaerer Kreisfahrt moeglich bei bestimmter Querbeschleunigung
activate_stop = 0;                                          % 1 um bei Erreichen der Querbeschleunigung zu stoppen
ay_stop = 4.3;

% Simulationsstop in Fahrerregler longitudinal bei entsprechend kleiner Änderung
% der Geschwindigkeit
activate_stop_vmax = 1;                                     % 1 um bei kleiner Änderung der Geschwindigkeit zu stoppen
deltav_ist = 0.00001;

end