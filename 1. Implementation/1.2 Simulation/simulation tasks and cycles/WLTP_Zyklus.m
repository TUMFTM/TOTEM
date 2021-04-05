function [input_data, select_delta_h, select_M_wheel,...
    activate_stop,activate_stop_vmax,ay_stop,deltav_ist,simtime, input_time, psip0,...
    mu_road_RF,mu_road_LF,mu_road_RR,mu_road_LR, ...
    savedec,stepsize,savestep, v0,v_final]...
    = WLTP_Zyklus(Optimierung, select_mu)

% Erzeugung der Input Daten für die lange Kundenfahrt



if Optimierung.linux_paths == 1
    load ('./../maneuver/Zyklen/WLTP_class_3.mat')
else 
    load ('./maneuver/Zyklen/WLTP_class_3.mat')
end

% sonstige Simulationsparameter
stepsize = 5e-4;
savestep = 1;
savedec = savestep / stepsize;

switch select_mu 
     case 1
        mu_road_RF = 0.8;
        mu_road_LF = 0.8;
        mu_road_RR = 0.8;
        mu_road_LR = 0.8;

    case 2
        mu_road_RF = 0.2;
        mu_road_LF = 0.2;
        mu_road_RR = 0.2;
        mu_road_LR = 0.2;
    case 3
        mu_road_RF = 0.8;
        mu_road_LF = 0.2;
        mu_road_RR = 0.8;
        mu_road_LR = 0.2;
    case 4
        mu_road_RF = 0.2;
        mu_road_LF = 0.2;
        mu_road_RR = 0.8;
        mu_road_LR = 0.8;
    case 5
        mu_road_RF = 0.8;
        mu_road_LF = 0.8;
        mu_road_RR = 0.2;
        mu_road_LR = 0.2;
    case 6
        mu_road_RF = 0.458;
        mu_road_LF = 0.458;
        mu_road_RR = 0.458;
        mu_road_LR = 0.458;
    case 7
        mu_road_RF = 0.392;
        mu_road_LF = 0.392;
        mu_road_RR = 0.392;
        mu_road_LR = 0.392;

end

psip0 = 0;

time = dc.time;
simtime = max(time);                                                        % [s] Simulationsdauer
input_time = time;                                                         % [s] Zeitvektor
v0 = 0;                                                                     % [m/s] Startgeschwindigkeit
v_final = 10000;

% Vorgaben als Array: [time, data]
input_r = zeros(length(input_time), 1);                                     %  Kreisfahrt
% input_v = [zeros interp1([0,simtime], [v0, v_final], input_time);         % Nutzung in quasi-stationaerer Kreisfahrt sowie Fahrerregler
% input_v = [zeros(10001,1); linspace(0,27.78*4,8200*4)'];
input_v = dc.speed;
input_psip = zeros(length(input_time), 1);                                                     % Nutzung im Fahrerregler
input_delta_h =  zeros(length(input_time), 1);                              % 
input_M_wheel =  zeros(length(input_time), 1);                              % Nutzung bei manueller Vorgabe
%Angabe der Anregung für 1000 Meter, ein Wert alle 10 cm
input_zroad_RF = zeros(length(input_time), 1);                              % Strassenanregung
input_zroad_LF = zeros(length(input_time), 1);                              % Strassenanregung
input_zroad_RR = zeros(length(input_time), 1);                              % Strassenanregung
% input_zroad_LR = -1*ones(length(input_time), 1);                          % Strassenanregung
input_zroad_LR =  zeros(length(input_time), 1);     
% input_zroad_RF = linspace(0;                                              % Strassenanregung
% input_zroad_LF = zeros(length(input_time), 1);                            % Strassenanregung
% input_zroad_RR = zeros(length(input_time), 1);                            % Strassenanregung
% % input_zroad_LR = -1*ones(length(input_time), 1);                        % Strassenanregung
% input_zroad_LR =  zeros(length(input_time), 1);   

% 
input_data = [input_time, input_r, input_v, input_psip, input_delta_h, input_M_wheel, ...
    input_zroad_RF, input_zroad_LF, input_zroad_RR, input_zroad_LR];
% input_data = [input_time, input_r, input_v, input_psip, input_delta_h, input_M_wheel, ...
%     zeros(length(input_time), 1), zeros(length(input_time), 1), zeros(length(input_time), 1), zeros(length(input_time), 1)];


% Step-Bloecke zum Umschalten zwischen Vorgaben: 1 Lenkwinkel, 2 Radius, 3 Gierrate, 4 Spline
select_delta_h = 3;                                  % []

% Step-Bloecke zum Umschalten zwischen Vorgaben: 1 Radmoment, 2 Geschwindigkeit, 3 Spline
select_M_wheel = 2;                                 % []

% Simulationsstop in quasi-stationaerer Kreisfahrt moeglich bei bestimmter Querbeschleunigung
activate_stop = 0;                                                          % 1 um bei Erreichen der Querbeschleunigung zu stoppen
ay_stop = 4.3;

% Simulationsstop in Fahrerregler longitudinal bei entsprechend kleiner Änderung
% der Geschwindigkeit
activate_stop_vmax = 0;                                     % 1 um bei kleiner Änderung der Geschwindigkeit zu stoppen
deltav_ist = 0.0001;


end

