function [input_data, select_delta_h, select_M_wheel,...
    activate_stop,activate_stop_vmax,ay_stop,deltav_ist,simtime, input_time, psip0,...
    savedec,stepsize,savestep, v0,v_final]...
    = Lenkwinkelsprung(deltah_LWS)
% Erzeugung der Input Daten für Lenkwinkelsprung

% Simulationsparameter
stepsize = 5e-4;
savestep = 1e-2;
savedec = savestep / stepsize;

%weitere Simulationsparameter
psip0 = 0;
simtime = 10;                                                                % [s] Simulationsdauer
input_time = (0 : stepsize: simtime)';                                       % [s] Zeitvektor
v0 = 27.8;                                                                   % [m/s] Startgeschwindigkeit
v_final = 27.8;                                                              % [m/s] Endgeschwindigkeit

% Vorgaben als Array: [time, data]
input_r = 80 * ones(length(input_time), 1);                                  %  Kreisfahrt
input_v = interp1([0,simtime], [v0, v_final], input_time);                   % konstante Geschwindigkeit
input_psip = zeros(length(input_time), 1);                                   % Nutzung im Fahrerregler
% Einschwingvorgang, dann Anregung auf Lenkwinkel (bestimmt im Vormanöver
% s.d. 4 m/s²)
input_delta_h =  [zeros(1,8001) (linspace(0,deltah_LWS,200)) deltah_LWS*ones(1,length(input_time)-8201) ]' ;    % Lenkwinkelsprung
input_M_wheel =  zeros(length(input_time), 1);                               % Nutzung bei manueller Vorgabe
input_zroad_RF = zeros(length(input_time), 1);                               % Strassenanregung
input_zroad_LF = zeros(length(input_time), 1);                               % Strassenanregung
input_zroad_RR = zeros(length(input_time), 1);                               % Strassenanregung
input_zroad_LR = zeros(length(input_time), 1);                               % Strassenanregung
    
input_data = [input_time, input_r, input_v, input_psip, input_delta_h, input_M_wheel, ...
    input_zroad_RF, input_zroad_LF, input_zroad_RR, input_zroad_LR];

% Step-Bloecke zum Umschalten zwischen Vorgaben: 1 Lenkwinkel, 2 Radius, 3 Gierrate, 4 Spline
select_delta_h = 1;                                  % []

% Step-Bloecke zum Umschalten zwischen Vorgaben: 1 Radmoment, 2 Geschwindigkeit, 3 Spline
select_M_wheel = 2;                                 % []

% Simulationsstop in quasi-stationaerer Kreisfahrt moeglich bei bestimmter Querbeschleunigung
activate_stop = 0;                                          % 1 um bei Erreichen der Querbeschleunigung zu stoppen
ay_stop = 4.3;

% Simulationsstop in Fahrerregler longitudinal bei entsprechend kleiner Änderung
% der Geschwindigkeit
activate_stop_vmax = 0;                                     % 1 um bei kleiner Änderung der Geschwindigkeit zu stoppen
deltav_ist = 0.0001;

end

