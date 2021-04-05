% TOTEM - Topology Optimization Tool for Electric Mobility 
% -> MANUAL SIMULATION GUI
% ------------
% Created on 21 May 2019
% ------------
% For version: Matlab2018b
% ------------
% GOAL:
% Run the Manual Simulation GUI to manually chose a certain Powertrain 
% design and start a simulation        
% ------------
% RESULTS:
% to visualize results of vehicle dynamics simulation run 
% - ANALYSE_plot_simulation.m
% - ANALYSE_plot_tire_forces.m




%% switch off warning
warning('off','all')

%% add paths
tic;
addpath(genpath(cd));
Hinzufuegen_Ordner;

%% launch GUI and ask for user input
Benutzeroberflaeche_Start;
uiwait(Benutzeroberflaeche_Start);

Optimierung.Modus = 0; % Optimization-Mode switched off
Optimierung.Cluster=0; % Cluster-Mode off
Optimierung.linux_paths=0; % do not use linux path syntax

if(Vorhandene_Konfiguration == 1)
    Benutzeroberflaeche_Segment;
    uiwait(Benutzeroberflaeche_Segment)
    Benutzeroberflaeche_Info;
    uiwait(Benutzeroberflaeche_Info)
    Fahrzeugkonfiguration = uigetfile('./1.1 Preprocessing/99 Konfigurationen', 'mat');
    Benutzeroberflaeche_Manoever;
    uiwait(Benutzeroberflaeche_Manoever);
end

if(Neues_Fahrzeug == 1 || Neues_Fahrzeug_Speichern == 1)
    Benutzeroberflaeche_Fahrzeugkonfiguration;
    uiwait(Benutzeroberflaeche_Fahrzeugkonfiguration);
    Benutzeroberflaeche_Manoever;
    uiwait(Benutzeroberflaeche_Manoever);
end



%% Vehicle model and MVS
Init_Veh; % initialize vehicle model
Init_Sim; 
Init_Driv_Env; % initialize and run simulation

    
toc;