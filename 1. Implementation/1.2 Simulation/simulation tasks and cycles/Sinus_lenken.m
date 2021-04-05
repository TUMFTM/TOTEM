function [input_data, select_delta_h, select_M_wheel,...
    activate_stop,activate_stop_vmax,ay_stop,deltav_ist,simtime, input_time, psip0,...
    savedec,stepsize,savestep, v0,v_final]...
    = Sinus_lenken( deltah)
% Erzeugung der Input Daten für das Sinus-lenk-Manöver

% Simulationsparameter
stepsize = 5e-4;
savestep = 5e-4; %erforderlich für genaue Auswertung
savedec = savestep / stepsize;
 
% weitere Simulationsparameter
psip0 = 0;
simtime =   100;                                                             % [s] Simulationsdauer
input_time = (0 : stepsize: simtime)';                                       % [s] Zeitvektor
v0 = 22.2;                                                                   % [m/s] Startgeschwindigkeit
v_final = 22.2;                                                              % [m/s] Endgeschwindigkeit

%Einschwingungen bei 0.2 Hz
constfrequ = deltah*sin(linspace(0,2*pi,length(0:stepsize:5)))';
%Logarithmischer Verlauf der Frequenz
%input_delta_h = [zeros(3/stepsize, 1); constfrequ(1:end-1); constfrequ(1:end-1); deltah*chirp(input_time(13/stepsize:end-1)-13,0.2,simtime-13,2,'logarithmic', -90)]; 
%Linearer Verlauf der Frequenz
input_delta_h = [zeros(3/stepsize, 1); constfrequ(1:end-1); constfrequ(1:end-1); deltah*chirp(input_time(13/stepsize:end-1)-13,0.2,simtime-13,2,'linear', -90)];




input_r = zeros(length(input_delta_h), 1);                                   % Kreisfahrt
input_v = v_final*ones(length(input_delta_h), 1);                            % konstante Geschwindigkeit
input_psip = zeros(length(input_delta_h), 1);                                % Nutzung im Fahrerregler
input_M_wheel =  zeros(length(input_delta_h), 1);                            % Nutzung bei manueller Vorgabe
input_zroad_RF = zeros(length(input_delta_h), 1);                            % Strassenanregung
input_zroad_LF = zeros(length(input_delta_h), 1);                            % Strassenanregung
input_zroad_RR = zeros(length(input_delta_h), 1);                            % Strassenanregung
input_zroad_LR = zeros(length(input_delta_h), 1);                            % Strassenanregung
    
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

