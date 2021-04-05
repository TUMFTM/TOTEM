% Init_Veh
% Script for the overall initialization of the whole vehicle including
% the powertrain and the glider. 

%% cmd-line output 
if Optimierung.Modus ~= 1
disp('Zuweisen der segmentspezifischen Daten...')
tic
end

%% load vehicle class parameters
if(Neues_Fahrzeug == 1 || Neues_Fahrzeug_Speichern == 1 || Vorhandene_Konfiguration == 1)
    config.segment_parameter = Input_Parameter(Segment);
else % bei Optimierung
    Segment = 'T';
    config.segment_parameter = Input_Parameter(Segment);
end

%% tictoc
if Optimierung.Modus ~= 1
toc
end

%% par_Tir (load tire files)
if Optimierung.Modus ~= 1
disp('Initialisierung Reifen...')
tic
end

if Optimierung.linux_paths == 1
    tire_file_path = './../1.1 Preprocessing/02 Glider/tire/';
else 
    tire_file_path = './1.1 Preprocessing/02 Glider/tire/';
end

[par_TIR, par_ASR] = PARAM_tire_model(tire_file_path, Segment, config.segment_parameter);

if Optimierung.Modus ~= 1
toc
end

%% par_MDT (design and calculate the powertrain)
if Optimierung.Modus ~= 1
disp('Initialisierung modularer Antriebsstrang...')
tic
end

if(Vorhandene_Konfiguration == 1)
    load(Fahrzeugkonfiguration);           % load chosen configuration
else
    
    %%axle specific powertrain design
    par_MDT = Antriebsstrang_achsspezifisch(config, par_TIR, Optimierung);
    
    
    %% save configuration
    if(Neues_Fahrzeug_Speichern == 1)
        Dateiname = inputdlg('Dateinamen eingeben:');
        if Optimierung.linux_paths == 1
            filename1 = './../1.1 Preprocessing/99 Konfigurationen/';
        else 
            filename1 = './1.1 Preprocessing/99 Konfigurationen/';
        end
        filename2 = Dateiname{1};
        filename = [filename1 filename2];
        save(filename,'par_MDT');
    end
    
end

%% weight and mass calculation
[Konst,IP,NR,m,par_VEH, par_MDT] = Masseberechnung(config, par_MDT,par_TIR, Optimierung);

%% calculate overall powertrain (non-axle-specific)
par_MDT = Antriebsstrang_achsuebergreifend(Optimierung, par_MDT, IP);

if Optimierung.Modus ~= 1
toc
end

%% par_Veh: calculate and initialize the glider

if Optimierung.Modus ~= 1
disp('Initialisierung Glider...')
tic
end

[par_TIR,par_VEH] = PARAM_vehicle_model_adaptive(par_MDT,config.segment_parameter, Segment, m, NR, par_VEH, par_TIR);

if Optimierung.Modus ~= 1
toc
end

%% par_ECU: initialize variables for control algorithms / operational strategy
if Optimierung.Modus ~= 1
disp('Initialisierung Betriebsstrategie...')
tic
end

par_MDT.VA.trans.n_gears = max([par_MDT.VA.trans.n_gears,1]);
par_MDT.HA.trans.n_gears = max([par_MDT.HA.trans.n_gears,1]);
par_MDT.VA.trans.i_gears (par_MDT.VA.trans.i_gears == 0) = 0.01;
par_MDT.HA.trans.i_gears (par_MDT.HA.trans.i_gears == 0) = 0.01;
par_MDT.VA.trans.wkg(par_MDT.VA.trans.wkg == 0) = 0.01;
par_MDT.HA.trans.wkg(par_MDT.HA.trans.wkg == 0) = 0.01;

par_VEH = PARAM_ECU(par_MDT, par_VEH);
temp_betriebsstrategie.Betriebsstrategiewahl = 0;
Spline;
if Optimierung.Modus ~= 1
toc
end


