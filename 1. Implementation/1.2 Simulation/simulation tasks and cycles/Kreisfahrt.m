function [input_data, select_delta_h, select_M_wheel,...
    activate_stop,activate_stop_vmax,ay_stop,deltav_ist,simtime, input_time, psip0,...
    savedec,stepsize,savestep, v0,v_final]...
    = Kreisfahrt()
% Erzeugung der Input Daten für eine quasistationäre Kreisfahrt

% Simulationsparameter
stepsize = 5e-4;
savestep = 1e-2;
savedec = savestep / stepsize;

%weitere Simulationsparameter
psip0 = 0;
simtime = 100;                                                               % [s] Simulationsdauer
input_time = (0 : stepsize: simtime)';                                      % [s] Zeitvektor
v0 =4;                                                                  % [m/s] Startgeschwindigkeit
v_final =33;%21;

% Vorgaben als Array: [time, data]
input_r = 100*ones(length(input_time), 1);                                   % Konstanter Radius
input_v = interp1([0, simtime], [v0, v_final], input_time);                  % variierende Geschwindigkeit
input_psip = zeros(length(input_time), 1);                                  % Nutzung im Fahrerregler
input_delta_h =  zeros(length(input_time), 1);                              % Lenkradwinkel
input_M_wheel =  zeros(length(input_time), 1);                              % Nutzung bei manueller Vorgabe
input_zroad_RF = zeros(length(input_time), 1);                              % Strassenanregung
input_zroad_LF = zeros(length(input_time), 1);                              % Strassenanregung
input_zroad_RR = zeros(length(input_time), 1);                              % Strassenanregung
input_zroad_LR = zeros(length(input_time), 1);                              % Strassenanregung
    
input_data = [input_time, input_r, input_v, input_psip, input_delta_h, input_M_wheel, ...
    input_zroad_RF, input_zroad_LF, input_zroad_RR, input_zroad_LR];

% Step-Bloecke zum Umschalten zwischen Vorgaben: 1 Lenkwinkel, 2 Radius, 3 Gierrate, 4 Spline
select_delta_h = 2;                                  % []

% Step-Bloecke zum Umschalten zwischen Vorgaben: 1 Radmoment, 2 Geschwindigkeit, 3 Spline
select_M_wheel = 2;                                 % []                             % []

% Simulationsstop in zweiten Fahrerregler moeglich bei bestimmter Querbeschleunigung
activate_stop = 0;                                          % 1 um bei Erreichen der Querbeschleunigung zu stoppen
ay_stop = 4.3;

% Simulationsstop in Fahrerregler longitudinal bei entsprechend kleiner Änderung
% der Geschwindigkeit
activate_stop_vmax = 0;                                     % 1 um bei kleiner Änderung der Geschwindigkeit zu stoppen
deltav_ist = 0.0001;


end