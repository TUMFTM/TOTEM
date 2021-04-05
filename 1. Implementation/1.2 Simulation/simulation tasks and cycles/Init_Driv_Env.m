% Init_Driv_Env initializes all simulations, launches them and delivers the
% results. The consumption can be calculated in two ways: Using the m-code
% or using the simulink model. The simulink powertrain model is working but
% is not validated in contrast to the m-code consumption-calculation. All
% other simulation task are conducted in simulink.

%% Zuweisen der getätigten Manövereingaben
% "0": Manöver nicht ausgewählt
% "1": Manöver ausgewählt

% Bei Starten der Simulation mit der Eingabemaske
if(Neues_Fahrzeug == 1 || Neues_Fahrzeug_Speichern == 1 || Vorhandene_Konfiguration == 1)
    select_vmax                         = manoever.select_vmax;
    select_Kreisfahrt                   = manoever.select_Kreisfahrt;
    select_Beschleunigung_Elastizitaet  = manoever.select_Beschleunigung_Elastizitaet;
    select_Traktion_low                 = manoever.select_Traktion_low;
    select_Traktion_split               = manoever.select_Traktion_split;
    select_Lenkwinkelsprung             = manoever.select_Lenkwinkelsprung;
    select_Kreisfahrt_beschl            = manoever.select_Kreisfahrt_beschl;
    select_sinus_lenken                 = manoever.select_sinus_lenken;
    select_Kundenfahrt_kurz             = manoever.select_Kundenfahrt_kurz;
    select_Kundenfahrt_lang             = manoever.select_Kundenfahrt_lang;
    select_WLTP_Zyklus                  = manoever.select_WLTP_Zyklus;
    select_To_Wks_akt                   = manoever.select_To_Wks_akt;
    select_WLTP_Zyklus_vektorisiert     = manoever.select_WLTP_Zyklus_vektorisiert;
    
end

% Bei Optimierung
if(Optimierung.Modus == 1)
    select_vmax                         = max(opt.test_vektor_opt(9), opt.test_vektor_opt(2));
    select_Kreisfahrt                   = max(opt.test_vektor_opt(1),opt.test_vektor_opt(4));
    select_Beschleunigung_Elastizitaet  = max(opt.test_vektor_opt(1),opt.test_vektor_opt(7));
    select_Traktion_low                 = max(opt.test_vektor_opt(1),opt.test_vektor_opt(8));
    select_Traktion_split               = max(opt.test_vektor_opt(1),opt.test_vektor_opt(8));
    select_Lenkwinkelsprung             = max(opt.test_vektor_opt(1),opt.test_vektor_opt(5));
    select_Kreisfahrt_beschl            = max([opt.test_vektor_opt(1),opt.test_vektor_opt(6),opt.test_vektor_opt(8)]);
    select_sinus_lenken                 = 0;
    select_Kundenfahrt_kurz             = 0;
    select_Kundenfahrt_lang             = 0;
    select_WLTP_Zyklus                  = 0;
    select_WLTP_Zyklus_vektorisiert     = 1;
    
    
end



%% Wähle Fahrbahnanregung
% ebene Fahrbahn          = 1
% Steigung 10%            = 2
select_road               = 1;



%% Wähle Reibwert
% mu-high                 = 1
% mu-low                  = 2        
% mu-split                = 3
% mu-jump front low       = 4
% mu-jump rear low        = 5
% dirt                    = 6
% gravel                  = 7;
select_mu                 = 1;

%% Wähle Wunscheigenlenkgradienten
EG_wunsch = 0.0009;

%% INITIALIZATION
% % % clear model workspace
if (select_Kreisfahrt || select_Beschleunigung_Elastizitaet ...
        || select_Traktion_low || select_Traktion_split ...
        || select_Lenkwinkelsprung || select_Kreisfahrt_beschl ...
        || select_sinus_lenken  || select_Kundenfahrt_kurz ...
        || select_Kundenfahrt_lang || select_WLTP_Zyklus)
    load_system('simulation');
end

% mod_workspace = get_param('simulation', 'modelworkspace');
% mod_workspace.clear;
% close_system('simulation', 1);



%% INPUT DATA



%% Lade Fahrbahn (ebene bzw. 10%ige Steigung)
%track_left und track_right werden für look-up tables im Environment-Block
%benötigt
switch select_road
    case 1
        track_right = zeros(3001,1); 
        track_left = zeros(3001,1);
    case 2
        track_right = linspace(0,300,3001); 
        track_left = linspace(0,300,3001);
end
 


%% Anlegen von Variablen
Punktewertung = {}; 
deltah_LWS = [];  



%% Sofern ein Manöver ausgewählt wurde, wird eine Subfunktion aufgerufen,
% welche die spezifischen Input-Daten erzeugt und das Manöver simuliert

%% Höchstgeschwindigkeit
if select_vmax == 1
    if(~Optimierung.Modus == 1)
        disp('V_max (vektorisiert) ...')
        tic    
    end
       
    vmax=calc_vmax(par_MDT, par_VEH, par_TIR, 1);
    assignin('base', 'v_max', vmax);
    Bewertung_Hoechstgeschwindigkeit_analytisch
    
    if vmax< 120/3.6 % Wenn das Fahrzeug keine 120 schafft der WLTP-Trajektorie nicht folgen kann 
        % keine weiteren Simulationen durchführen
        select_Kreisfahrt                   = 0;
        select_Beschleunigung_Elastizitaet  = 0;
        select_Traktion_low                 = 0;
        select_Traktion_split               = 0;
        select_Lenkwinkelsprung             = 0;
        select_Kreisfahrt_beschl            = 0;
        select_sinus_lenken                 = 0;
        select_Kundenfahrt_kurz             = 0;
        select_Kundenfahrt_lang             = 0;
        select_WLTP_Zyklus                  = 0;
        
        % schlechte Dummy-Ergebniswerte zurückgeben
        consumption=1000;
        EDmod.LWG_14=-1;                   % Lenkradwinkel zwischen 1 und 4 m/s^2
        EDmod.LWG_67=-1;                   % Lenkradwinkel zwischen 6 und 7 m/s^2
        EDmod.a_y_max=-1;                  % max. Querbeschleunigung
        EDmod.v_char=-1;                   % charakteristische Geschwindigkeit
        EDmod.ratio_psip_lws=-1;           % Bezogene Überschwingweite
        EDmod.T_psip=-1;                   % Response Time
        EDmod.TB=-1;                       % TB-Wert
        EDmod.ratio_beta_fg=-1;            % Verhältnis Schwimmwinkel
        EDmod.Phase=-1;                    % Phasenwinkel bei Frequenz 1 Hz
        EDmod.delta_psip_mu_high(1)=-1;    % Änderung Giergeschwindigkeit mu-high bei 20% Gaspedalstellung
        EDmod.delta_psip_mu_high(2)=-1;    % Änderung Giergeschwindigkeit mu-high bei 60% Gaspedalstellung
        EDmod.delta_psip_mu_high(3)=-1;    % Änderung Giergeschwindigkeit mu-high bei 100% Gaspedalstellung
        EDmod.t_0_100_high=-1;             % Besch.zeit von 0 auf 100 km/h auf mu-high
        EDmod.t_80_120_high=-1;            % Elastizität auf mu-high
        EDmod.vmax=-1;                     % Höchstgeschwindigkeit
        EDmod.t_0_100_low=-1;              % Besch.zeit von 0 auf 100 km/h auf mu-low
        EDmod.t_0_100_split=-1;            % Besch.zeit auf mu-split
        EDmod.delta_psip_mu_low(1)=-1;     % Änderung Giergeschwindigkeit mu-low bei 10% Gaspedalstellung
        EDmod.delta_psip_mu_low(2)=-1;     % Änderung Giergeschwindigkeit mu-low bei 20% Gaspedalstellung
        EDmod.delta_psip_mu_low(3)=-1;     % Änderung Giergeschwindigkeit mu-low bei 30% Gaspedalstellung
        EDmod.a_max_beschl_statKF_auf_mu_low(1)=-1;
        EDmod.a_max_beschl_statKF_auf_mu_low(2)=-1;
        EDmod.a_max_beschl_statKF_auf_mu_low(3)=-1;
        
        if(Optimierung.Modus == 1)
            select_Kreisfahrt                   = 0;
            select_Beschleunigung_Elastizitaet  = 0;
            select_Traktion_low                 = 0;
            select_Traktion_split               = 0;
            select_Lenkwinkelsprung             = 0;
            select_Kreisfahrt_beschl            = 0;
            select_sinus_lenken                 = 0;
        end
    end    
    
    
    if(~Optimierung.Modus == 1)
        toc
    end
end
%% WLTP_Zyklus_vektorisiert

if select_WLTP_Zyklus_vektorisiert == 1
    if(~Optimierung.Modus == 1)
        disp('WLTP Zyklus (vektorisiert) ...')
        tic    
    end
    
    samplerate=0.1;
    consumption=    calc_zyklusverbrauch_vektorisiert(par_MDT, par_VEH, par_TIR, Optimierung.Modus, samplerate, Optimierung);
    assignin('base', 'consumption', consumption);
    
    if isnan(consumption) || par_MDT.AUS.batt_auslegung_failed==1 % Wenn das Fahrzeug der WLTP-Trajektorie nicht folgen kann (hier oder in der Batterieauslegung)
        % keine weiteren Simulationen durchführen
        select_Kreisfahrt                   = 0;
        select_Beschleunigung_Elastizitaet  = 0;
        select_Traktion_low                 = 0;
        select_Traktion_split               = 0;
        select_Lenkwinkelsprung             = 0;
        select_Kreisfahrt_beschl            = 0;
        select_sinus_lenken                 = 0;
        select_Kundenfahrt_kurz             = 0;
        select_Kundenfahrt_lang             = 0;
        select_WLTP_Zyklus                  = 0;
        
        % schlechte Dummy-Ergebniswerte zurückgeben
        consumption=1000;
        EDmod.LWG_14=-1;                   % Lenkradwinkel zwischen 1 und 4 m/s^2
        EDmod.LWG_67=-1;                   % Lenkradwinkel zwischen 6 und 7 m/s^2
        EDmod.a_y_max=-1;                  % max. Querbeschleunigung
        EDmod.v_char=-1;                   % charakteristische Geschwindigkeit
        EDmod.ratio_psip_lws=-1;           % Bezogene Überschwingweite
        EDmod.T_psip=-1;                   % Response Time
        EDmod.TB=-1;                       % TB-Wert
        EDmod.ratio_beta_fg=-1;            % Verhältnis Schwimmwinkel
        EDmod.Phase=-1;                    % Phasenwinkel bei Frequenz 1 Hz
        EDmod.delta_psip_mu_high(1)=-1;    % Änderung Giergeschwindigkeit mu-high bei 20% Gaspedalstellung
        EDmod.delta_psip_mu_high(2)=-1;    % Änderung Giergeschwindigkeit mu-high bei 60% Gaspedalstellung
        EDmod.delta_psip_mu_high(3)=-1;    % Änderung Giergeschwindigkeit mu-high bei 100% Gaspedalstellung
        EDmod.t_0_100_high=-1;             % Besch.zeit von 0 auf 100 km/h auf mu-high
        EDmod.t_80_120_high=-1;            % Elastizität auf mu-high
        EDmod.vmax=-1;                     % Höchstgeschwindigkeit
        EDmod.t_0_100_low=-1;              % Besch.zeit von 0 auf 100 km/h auf mu-low
        EDmod.t_0_100_split=-1;            % Besch.zeit auf mu-split
        EDmod.delta_psip_mu_low(1)=-1;     % Änderung Giergeschwindigkeit mu-low bei 10% Gaspedalstellung
        EDmod.delta_psip_mu_low(2)=-1;     % Änderung Giergeschwindigkeit mu-low bei 20% Gaspedalstellung
        EDmod.delta_psip_mu_low(3)=-1;     % Änderung Giergeschwindigkeit mu-low bei 30% Gaspedalstellung
        EDmod.a_max_beschl_statKF_auf_mu_low(1)=-1;
        EDmod.a_max_beschl_statKF_auf_mu_low(2)=-1;
        EDmod.a_max_beschl_statKF_auf_mu_low(3)=-1;

        
        if(Optimierung.Modus == 1)
            select_Kreisfahrt                   = 0;
            select_Beschleunigung_Elastizitaet  = 0;
            select_Traktion_low                 = 0;
            select_Traktion_split               = 0;
            select_Lenkwinkelsprung             = 0;
            select_Kreisfahrt_beschl            = 0;
            select_sinus_lenken                 = 0;
        end
        
    end
    
    if(~Optimierung.Modus == 1)
        toc
    end
    
end

%% Stationäre Kreisfahrt
if(select_Kreisfahrt == 1)
    if Optimierung.Modus ~= 1
    tic
    disp ('Stationäre Kreisfahrt...')
    end
    EG_wunsch = 0.0009;
    % Laden der Manöverdetails
        [input_data, select_delta_h, select_M_wheel,...
        activate_stop, activate_stop_vmax, ay_stop, deltav_ist, simtime, input_time, psip0,...
        savedec,stepsize,savestep, v0,v_final]...
            =  Kreisfahrt();

    % Einstellen der Fahrbahnreibwerte und der Reifen-Scaling-Faktoren
    [par_TIR, mu_road_LF, mu_road_LR, mu_road_RF, mu_road_RR ] = set_mu_road(par_TIR, select_mu);
    
    % Parameter in Workspace schreiben, damit Simulink gestartet werden
    % kann
    vars=whos; 
    for k=1:length(vars) 
       assignin('base', vars(k).name, eval(vars(k).name)) 
    end
    
    % Simulation und Bewertung
    set_param('simulation/Vehicle/Fahrzeugmodell/Configurable_model','BlockChoice','vehicle_model');
    sim('simulation');
    Bewertung_stationaere_Kreisfahrt;

    if Optimierung.Modus ~= 1
    toc
    end

end



%% Beschleunigung/Elastizität          
if(select_Beschleunigung_Elastizitaet == 1)
    if Optimierung.Modus ~= 1
    tic
    disp ('Beschleunigung/Elastizität...')
    end
    EG_wunsch = 0.0009;
    select_mu_traktion = 1; %µ-high
    select_delta_h = 1;
    % Laden der Manöverdetails   
    [input_data, select_M_wheel,...
    activate_stop, activate_stop_vmax, ay_stop, deltav_ist,simtime, input_time, psip0,...
    savedec,stepsize,savestep, v0,v_final]...
            = Beschleunigung_Elastizitaet();

    % Einstellen der Fahrbahnreibwerte und der Reifen-Scaling-Faktoren
    [par_TIR, mu_road_LF, mu_road_LR, mu_road_RF, mu_road_RR ] = set_mu_road(par_TIR, select_mu_traktion);

    % Parameter in Workspace schreiben, damit Simulink gestartet werden
    % kann
    vars=whos; 
    for k=1:length(vars) 
       assignin('base', vars(k).name, eval(vars(k).name)) 
    end
    
    % Simulation und Bewertung
    set_param('simulation/Vehicle/Fahrzeugmodell/Configurable_model','BlockChoice','vehicle_model');
    sim('simulation');
    Bewertung_Traktionsuntersuchung;
    
    if Optimierung.Modus ~= 1
    toc
    end

end

%% Traktion auf µ-low         
if(select_Traktion_low == 1)
    if Optimierung.Modus ~= 1
        tic
        disp ('Traktion auf µ-low...')
    end   
    EG_wunsch = 0.0009;    

    select_mu_traktion = 2; %µ-low
    select_delta_h = 1;
    % Laden der Manöverdetails   
    [input_data, select_M_wheel,...
    activate_stop, activate_stop_vmax, ay_stop, deltav_ist,simtime, input_time, psip0,...
    savedec,stepsize,savestep, v0,v_final]...
            = Beschleunigung_Elastizitaet();

    % Einstellen der Fahrbahnreibwerte und der Reifen-Scaling-Faktoren
    [par_TIR, mu_road_LF, mu_road_LR, mu_road_RF, mu_road_RR ] = set_mu_road(par_TIR, select_mu_traktion);

    % Parameter in Workspace schreiben, damit Simulink gestartet werden
    % kann
    vars=whos; 
    for k=1:length(vars) 
       assignin('base', vars(k).name, eval(vars(k).name)) 
    end
    
    % Simulation und Bewertung
    set_param('simulation/Vehicle/Fahrzeugmodell/Configurable_model','BlockChoice','vehicle_model');
    sim('simulation');
    Bewertung_Traktionsuntersuchung;
    
    if Optimierung.Modus ~= 1
    toc
    end

end
    


%% Traktion auf µ-split        
if(select_Traktion_split == 1)
    if Optimierung.Modus ~= 1
        tic
        disp ('Traktion auf µ-split...')
    end
    EG_wunsch = 0.0009;
    
    select_mu_traktion = 3; %µ-split
    select_delta_h = 3; %Spurabweichungregelung
    % Laden der Manöverdetails   
    [input_data, select_M_wheel,...
    activate_stop, activate_stop_vmax, ay_stop, deltav_ist,simtime, input_time, psip0,...
    savedec,stepsize,savestep, v0,v_final]...
            = Beschleunigung_Elastizitaet();

    % Einstellen der Fahrbahnreibwerte und der Reifen-Scaling-Faktoren
    [par_TIR, mu_road_LF, mu_road_LR, mu_road_RF, mu_road_RR ] = set_mu_road(par_TIR, select_mu_traktion);

    % Parameter in Workspace schreiben, damit Simulink gestartet werden
    % kann
    vars=whos; 
    for k=1:length(vars) 
       assignin('base', vars(k).name, eval(vars(k).name)) 
    end
    
    % Simulation und Bewertung
    set_param('simulation/Vehicle/Fahrzeugmodell/Configurable_model','BlockChoice','vehicle_model');
    sim('simulation');
    Bewertung_Traktionsuntersuchung;
    
    if Optimierung.Modus ~= 1
        toc
    end

end




%% Lenkwinkelsprung
if(select_Lenkwinkelsprung == 1)
    if Optimierung.Modus ~= 1
    tic
    disp ('Lenkwinkelsprung...')
    end
    EG_wunsch = 0.0009;
    %Vormanöver zuziehende Kreisfahrt bei 100 km/h
    [input_data, select_delta_h, select_M_wheel,...
    activate_stop, activate_stop_vmax,ay_stop, deltav_ist,simtime, input_time, psip0,...
    savedec,stepsize,savestep, v0,v_final]...
        =  Kreisfahrt_vormanoever();

    % Einstellen der Fahrbahnreibwerte und der Reifen-Scaling-Faktoren
    [par_TIR, mu_road_LF, mu_road_LR, mu_road_RF, mu_road_RR ] = set_mu_road(par_TIR, select_mu);

    % Parameter in Workspace schreiben, damit Simulink gestartet werden
    % kann
    vars=whos; 
    for k=1:length(vars) 
       assignin('base', vars(k).name, eval(vars(k).name)) 
    end

    % Simulation und Auswertung
    set_param('simulation/Vehicle/Fahrzeugmodell/Configurable_model','BlockChoice','vehicle_model');
    sim('simulation')
    % Auswertung des Vormanövers zum finden von Lenkradwinkel und
    % Geschwindigkeit bei 4 m/s^2
    [deltah_LWS,v_beschl ] = ANALYSE_Kreisfahrt_fuer_Manoever( sv_FZG_x, sv_FAH_delta_h1, sv_FZG_y,select_mu);
    
    % Hauptmanöver Lenkwinkelsprung
        [input_data, select_delta_h, select_M_wheel,...
        activate_stop, activate_stop_vmax, ay_stop, deltav_ist, simtime, input_time, psip0,...
        savedec,stepsize,savestep, v0,v_final]...
            =  Lenkwinkelsprung(deltah_LWS);

    % Einstellen der Fahrbahnreibwerte und der Reifen-Scaling-Faktoren
    [par_TIR, mu_road_LF, mu_road_LR, mu_road_RF, mu_road_RR ] = set_mu_road(par_TIR, select_mu);
    
    % Parameter in Workspace schreiben, damit Simulink gestartet werden
    % kann
    vars=whos; 
    for k=1:length(vars) 
       assignin('base', vars(k).name, eval(vars(k).name)) 
    end
    
    % Simulation und Bewertung
    sim('simulation');
    Bewertung_Lenkwinkelsprung;
    if Optimierung.Modus ~= 1
    toc
    end

end



%% Beschleunigende Kreisfahrt
if (select_Kreisfahrt_beschl == 1) 
    if Optimierung.Modus ~= 1
        tic
        disp ('Beschleunigende Kreisfahrt...')
    end
    
    
    % angelegte for Schleife kann genutzt werden, um automatisiert mehrere
    % Reibwerte hintereinander zu simulieren (clear des workspace vor
    % Änderung)
   for select_mu_BKF=1:2
       if select_mu_BKF==1
            EG_wunsch = 0;
            delta_psip_high = zeros(3, 1);
            delta_v_high = zeros(3, 1);
        elseif select_mu_BKF==2
            EG_wunsch = 0.0009;
            delta_psip_low = zeros(3, 1);
            delta_v_low = zeros(3, 1);
        end
    %Ermittlung des benötigten Ausgangslenkradwinkels und der Ausgangsgeschwindigkeit
       Radius = 60;
       
       %Vormanöver 1
        [input_data, select_delta_h, select_M_wheel,...
                activate_stop, activate_stop_vmax,ay_stop,deltav_ist,simtime, input_time, psip0,...
                savedec,stepsize,savestep, v0,v_final]...
            =  Kreisfahrt_v_var(Radius);
        
        % Einstellen der Fahrbahnreibwerte und der Reifen-Scaling-Faktoren
        [par_TIR, mu_road_LF, mu_road_LR, mu_road_RF, mu_road_RR ] = set_mu_road(par_TIR, select_mu_BKF);
        
        % Parameter in Workspace schreiben, damit Simulink gestartet werden
        % kann
        vars=whos; 
        for k=1:length(vars) 
           assignin('base', vars(k).name, eval(vars(k).name)) 
        end
        
        % Simulation und Auswertung des Vormanövers
        set_param('simulation/Vehicle/Fahrzeugmodell/Configurable_model','BlockChoice','vehicle_model');
        sim('simulation')

        % Ermittlung des benötigten Lenkradwinkels für die Beschleunigung aus
        % stationärer Kreisfahrt
        [deltah_beschl,v_beschl] = ANALYSE_Kreisfahrt_fuer_Manoever( sv_FZG_x, sv_FAH_delta_h1, sv_FZG_y, select_mu_BKF);

        % Vormanöver 2 zur Ermittlung der maximalen Längsbeschleunigung
        Beschleunigung = 10.3; %Maximale Längsbeschleunigung aus der Lireratur
        [input_data, select_delta_h, select_M_wheel,...
        activate_stop, activate_stop_vmax, ay_stop, deltav_ist, simtime, input_time, psip0,...
        savedec,stepsize,savestep, v0,v_final]...
             =  beschl_Kreisfahrt(v_beschl,Beschleunigung, deltah_beschl, Radius);
                 
        % Einstellen der Fahrbahnreibwerte und der Reifen-Scaling-Faktoren
        [par_TIR, mu_road_LF, mu_road_LR, mu_road_RF, mu_road_RR ] = set_mu_road(par_TIR, select_mu_BKF);                     
        
        % Parameter in Workspace schreiben, damit Simulink gestartet werden
        % kann
        vars=whos; 
        for k=1:length(vars) 
           assignin('base', vars(k).name, eval(vars(k).name)) 
        end
        
        % Simulation uns Auswertung des Vormanövers
        sim('simulation')
        a_max = (sv_FZG_x(end,2)-v_beschl)/2;
        
        % HAUPTMANÖVER Beschleunigung aus stationärer Kreisfahrt
        Beschleunigung = [0.2,0.6,1].*a_max; % Faktor um den die Endgeschwindigkeit erhöht wird und damit eine konstante Erhöhung der Beschleunigung 
        

             for i=1:length(Beschleunigung)
                [input_data, select_delta_h, select_M_wheel,...
                activate_stop, activate_stop_vmax, ay_stop, deltav_ist, simtime, input_time, psip0,...
                savedec,stepsize,savestep, v0,v_final]...
                     =  beschl_Kreisfahrt(v_beschl,Beschleunigung(i), deltah_beschl, Radius);
                 
                % Einstellen der Fahrbahnreibwerte und der Reifen-Scaling-Faktoren
                [par_TIR, mu_road_LF, mu_road_LR, mu_road_RF, mu_road_RR ] = set_mu_road(par_TIR, select_mu_BKF);                     
                
                % Parameter in Workspace schreiben, damit Simulink gestartet werden
                % kann
                vars=whos; 
                for k=1:length(vars) 
                   assignin('base', vars(k).name, eval(vars(k).name)) 
                end
                
                sim('simulation')
                
                if select_mu_BKF==1
                    [delta_v_high(i), delta_psip_high(i)] = ANALYSE_Kreisfahrt_beschl( sv_FZG_psi, sv_time, sv_FZG_x);
                elseif select_mu_BKF==2
                    [delta_v_low(i), delta_psip_low(i)] = ANALYSE_Kreisfahrt_beschl( sv_FZG_psi, sv_time, sv_FZG_x);
                end
             end

    Bewertung_Beschleunigung_Kreisfahrt;

    end
    if Optimierung.Modus ~= 1
        toc
    end
end


%% Frequenzgang
if(select_sinus_lenken == 1)
    if Optimierung.Modus ~= 1
    tic
    disp ('Frequenzgang...')
    end
    EG_wunsch = 0.0009;
    %Vormanöver
          
    [input_data, select_delta_h, select_M_wheel,...
    activate_stop, activate_stop_vmax,ay_stop, deltav_ist, simtime, input_time, psip0,...
    savedec,stepsize,savestep, v0,v_final]...
        =  Kreisfahrt_fuer_sinus_lenken();

    % Einstellen der Fahrbahnreibwerte und der Reifen-Scaling-Faktoren
    [ par_TIR, mu_road_LF, mu_road_LR, mu_road_RF, mu_road_RR ] = set_mu_road(par_TIR, select_mu);
    
    % Parameter in Workspace schreiben, damit Simulink gestartet werden
    % kann
    vars=whos; 
    for k=1:length(vars) 
       assignin('base', vars(k).name, eval(vars(k).name)) 
    end
    
    set_param('simulation/Vehicle/Fahrzeugmodell/Configurable_model','BlockChoice','vehicle_model');
    
    sim('simulation')

    % Auswertung des Vormanövers, finde Lenkradwinkel bei 4 m/s^2
    [delta_h, psip_stat_fg, beta_stat_fg] = ANALYSE_Kreisfahrt_fuer_sinuslenken( sv_FZG_y, sv_FAH_delta_h1,sv_FZG_beta, sv_FZG_psi);

    % Hauptmanöver Sinus-lenken
        [input_data, select_delta_h, select_M_wheel,...
        activate_stop, activate_stop_vmax, ay_stop, deltav_ist, simtime, input_time, psip0,...
        savedec,stepsize,savestep, v0,v_final]...
        =  Sinus_lenken(delta_h);

    % Einstellen der Fahrbahnreibwerte und der Reifen-Scaling-Faktoren
    [ par_TIR, mu_road_LF, mu_road_LR, mu_road_RF, mu_road_RR ] = set_mu_road(par_TIR, select_mu);
    
    % Parameter in Workspace schreiben, damit Simulink gestartet werden
    % kann
    vars=whos; 
    for k=1:length(vars) 
       assignin('base', vars(k).name, eval(vars(k).name)) 
    end
    
    % Simulation und Bewertung
    sim('simulation')
   
%     Bewertung_Frqgang;
    Bewertung_Frequenzgang;

    if Optimierung.Modus ~= 1
    toc
    end
end



%% Kundenfahrt kurz
if(select_Kundenfahrt_kurz == 1 && (Neues_Fahrzeug == 1 || Neues_Fahrzeug_Speichern == 1 || Vorhandene_Konfiguration == 1))
    tic
    disp ('Kundenfahrt kurz...')
    
            [input_data, select_delta_h, select_M_wheel,...
            activate_stop, activate_stop_vmax, ay_stop, deltav_ist, simtime, input_time, psip0,...
            mu_road_RF,mu_road_LF,mu_road_RR,mu_road_LR, ...
            savedec,stepsize,savestep, v0,v_final, t]...
            =  Kundenfahrt_kurz_Filter(select_mu, Optimierung);
     
    % Anpassung der Reifenparameter für dirt oder gravel        
    if select_mu == 6;
            par_TIR(1).LMUY = 0.573;
            par_TIR(2).LMUY = 0.573;
            par_TIR(1).LKY = 0.69;
            par_TIR(2).LKY = 0.69;
    end

    if select_mu == 7;
            par_TIR(1).LMUY= 0.490;
            par_TIR(2).LMUY = 0.490;
            par_TIR(1).LKY(:) = 0.602;
            par_TIR(2).LKY(:) = 0.602;
    end
    
% Fahrdynamik-Betriebsstrategie

% temp_betriebsstrategie.Betriebsstrategiewahl = 0;
% 
% 
% disp ('Fahrdynamik-Betriebsstrategie gestartet...')
% tic
% sim ('simulation')
% toc
% 
% mkdir ('.\Betriebsstrategie_Vergleich')
% save ('.\Betriebsstrategie_Vergleich\letzte_Ergebnisse_BTS_Dyn.mat', 'Ev_ges', 'pv_ges', 'sv_kappa', ...
%     'sv_FZG_M_antr', 'sv_FZG_omega', 'sv_FZG_x', 'sv_FZG_y', 'P_loss_opt', 'sv_FAH_delta_h1', ...
%     'sv_time', 'input_data', 'simtime', 'sv_FZG_psi', 'sv_FZG_M_brems', 'sv_Gangwahl')

% Effizienz-Betriebsstrategie

temp_betriebsstrategie.Betriebsstrategiewahl = 1;

disp ('simuliere kurzen Kundenzyklus mit Effizienz-Betriebsstrategie...')

set_param('simulation/Vehicle/Fahrzeugmodell/Configurable_model','BlockChoice','vehicle_model');

sim ('simulation')


%save ('.\Betriebsstrategie_Vergleich\letzte_Ergebnisse_BTS_Eff.mat', 'Ev_ges', 'pv_ges', 'sv_kappa', ...
%    'sv_FZG_M_antr', 'sv_FZG_omega', 'sv_FZG_x', 'sv_FZG_y', 'sv_FAH_delta_h1', ...
%   'sv_time', 'input_data', 'simtime', 'sv_FZG_psi', 'sv_FZG_M_brems', 'sv_Gangwahl_eff', 'P_loss_opt')


% Importiert Effizienz Ergebnisse ins Workspace
% 
% Ev_ges_eff = load ('.\Betriebsstrategie_Vergleich\letzte_Ergebnisse_BTS_Eff.mat', 'Ev_ges'); 
% pv_ges_eff = load ('.\Betriebsstrategie_Vergleich\letzte_Ergebnisse_BTS_Eff.mat', 'pv_ges'); 
% sv_kappa_eff = load ('.\Betriebsstrategie_Vergleich\letzte_Ergebnisse_BTS_Eff.mat', 'sv_kappa');
% sv_FZG_M_antr_eff = load ('.\Betriebsstrategie_Vergleich\letzte_Ergebnisse_BTS_Eff.mat', 'sv_FZG_M_antr');
% sv_FZG_omega_eff = load ('.\Betriebsstrategie_Vergleich\letzte_Ergebnisse_BTS_Eff.mat', 'sv_FZG_omega');
% sv_FZG_x_eff = load ('.\Betriebsstrategie_Vergleich\letzte_Ergebnisse_BTS_Eff.mat', 'sv_FZG_x');
% sv_FZG_y_eff = load ('.\Betriebsstrategie_Vergleich\letzte_Ergebnisse_BTS_Eff.mat', 'sv_FZG_y');
% sv_time_eff = load ('.\Betriebsstrategie_Vergleich\letzte_Ergebnisse_BTS_Eff.mat', 'sv_time');
% input_data_eff = load ('.\Betriebsstrategie_Vergleich\letzte_Ergebnisse_BTS_Eff.mat', 'input_data');
% simtime_eff = load ('.\Betriebsstrategie_Vergleich\letzte_Ergebnisse_BTS_Eff.mat', 'simtime');
% sv_FZG_psi_eff = load ('.\Betriebsstrategie_Vergleich\letzte_Ergebnisse_BTS_Eff.mat', 'sv_FZG_psi');
% sv_FZG_M_brems_eff = load ('.\Betriebsstrategie_Vergleich\letzte_Ergebnisse_BTS_Eff.mat', 'sv_FZG_M_brems');
% sv_FAH_delta_h1_eff = load ('.\Betriebsstrategie_Vergleich\letzte_Ergebnisse_BTS_Eff.mat', 'sv_FAH_delta_h1');
% load ('.\Betriebsstrategie_Vergleich\letzte_Ergebnisse_BTS_Eff.mat', 'sv_Gangwahl_eff');
% load ('.\Betriebsstrategie_Vergleich\letzte_Ergebnisse_BTS_Eff.mat', 'P_loss_opt');
% 
% % Importiert Dynamik Ergebnisse ins Workspace
% 
% Ev_ges_dyn = load ('.\Betriebsstrategie_Vergleich\letzte_Ergebnisse_BTS_Dyn.mat', 'Ev_ges'); 
% pv_ges_dyn = load ('.\Betriebsstrategie_Vergleich\letzte_Ergebnisse_BTS_Dyn.mat', 'pv_ges'); 
% sv_kappa_dyn = load ('.\Betriebsstrategie_Vergleich\letzte_Ergebnisse_BTS_Dyn.mat', 'sv_kappa');
% sv_FZG_M_antr_dyn = load ('.\Betriebsstrategie_Vergleich\letzte_Ergebnisse_BTS_Dyn.mat', 'sv_FZG_M_antr');
% sv_FZG_omega_dyn = load ('.\Betriebsstrategie_Vergleich\letzte_Ergebnisse_BTS_Dyn.mat', 'sv_FZG_omega');
% sv_FZG_x_dyn = load ('.\Betriebsstrategie_Vergleich\letzte_Ergebnisse_BTS_Dyn.mat', 'sv_FZG_x');
% sv_FZG_y_dyn = load ('.\Betriebsstrategie_Vergleich\letzte_Ergebnisse_BTS_Dyn.mat', 'sv_FZG_y');
% sv_time_dyn = load ('.\Betriebsstrategie_Vergleich\letzte_Ergebnisse_BTS_Dyn.mat', 'sv_time');
% input_data_dyn = load ('.\Betriebsstrategie_Vergleich\letzte_Ergebnisse_BTS_Dyn.mat', 'input_data');
% simtime_dyn = load ('.\Betriebsstrategie_Vergleich\letzte_Ergebnisse_BTS_Dyn.mat', 'simtime');
% sv_FZG_psi_dyn = load ('.\Betriebsstrategie_Vergleich\letzte_Ergebnisse_BTS_Dyn.mat', 'sv_FZG_psi');
% sv_FZG_M_brems_dyn = load ('.\Betriebsstrategie_Vergleich\letzte_Ergebnisse_BTS_Dyn.mat', 'sv_FZG_M_brems');
% sv_FAH_delta_h1_dyn = load ('.\Betriebsstrategie_Vergleich\letzte_Ergebnisse_BTS_Eff.mat', 'sv_FAH_delta_h1');
% sv_Gangwahl_dyn = load ('.\Betriebsstrategie_Vergleich\letzte_Ergebnisse_BTS_Dyn.mat', 'sv_Gangwahl');

% Bewertung_Kundenfahrt;
Bewertung_Kundenfahrt_kurz;
toc
end


%% Kundenfahrt kurz bei Optimierung
if(select_Kundenfahrt_kurz == 1 && Optimierung.Modus == 1)
   
    
            [input_data, select_delta_h, select_M_wheel,...
            activate_stop, activate_stop_vmax, ay_stop, deltav_ist,simtime, input_time, psip0,...
            mu_road_RF,mu_road_LF,mu_road_RR,mu_road_LR, ...
            savedec,stepsize,savestep, v0,v_final, t]...
            =  Kundenfahrt_kurz_Filter(select_mu, Optimierung);

     
    % Anpassung der Reifenparameter für dirt oder gravel        
    if select_mu == 6;
            par_TIR(1).LMUY = 0.573;
            par_TIR(2).LMUY = 0.573;
            par_TIR(1).LKY = 0.69;
            par_TIR(2).LKY = 0.69;
    end

    if select_mu == 7;
            par_TIR(1).LMUY= 0.490;
            par_TIR(2).LMUY = 0.490;
            par_TIR(1).LKY(:) = 0.602;
            par_TIR(2).LKY(:) = 0.602;
    end
    
% Fahrdynamik-Betriebsstrategie

% temp_betriebsstrategie.Betriebsstrategiewahl = 0;
% 
% 
% disp ('Fahrdynamik-Betriebsstrategie gestartet...')
% tic
% sim ('simulation')
% toc
% 
% mkdir ('.\Betriebsstrategie_Vergleich')
% save ('.\Betriebsstrategie_Vergleich\letzte_Ergebnisse_BTS_Dyn.mat', 'Ev_ges', 'pv_ges', 'sv_kappa', ...
%     'sv_FZG_M_antr', 'sv_FZG_omega', 'sv_FZG_x', 'sv_FZG_y', 'P_loss_opt', 'sv_FAH_delta_h1', ...
%     'sv_time', 'input_data', 'simtime', 'sv_FZG_psi', 'sv_FZG_M_brems', 'sv_Gangwahl')

% Effizienz-Betriebsstrategie

temp_betriebsstrategie.Betriebsstrategiewahl = 1;


% Parameter in Workspace schreiben, damit Simulink gestartet werden
    % kann
    vars=whos; 
    for k=1:length(vars) 
       assignin('base', vars(k).name, eval(vars(k).name)) 
    end
 
set_param('simulation/Vehicle/Fahrzeugmodell/Configurable_model','BlockChoice','vehicle_model');    
    
sim ('simulation')

maxAbweichung_v = 5;%km/h
Referenz_v = sqrt(t.v0(1,:).^2+t.v0(2,:).^2);
Referenz_t = 1/t.f*[0:length(t.v0(1,:))-1];
Ziel_v = interp1(Referenz_t,Referenz_v,sv_time,'linear','extrap');
Abweichung_v = (max(abs(Ziel_v-sv_FZG_x(:,2)))*3.6)> maxAbweichung_v;
if Abweichung_v
    error('Geschwindigkeitsziel im Kundenfahrtkurzzyklus nicht erreichbar');
end


%save ('.\Initialisierung\Betriebsstrategie\Betriebsstrategie_Vergleich\letzte_Ergebnisse_BTS_Eff.mat', 'Ev_ges', 'pv_ges', 'sv_kappa', ...
%     'sv_FZG_M_antr', 'sv_FZG_omega', 'sv_FZG_x', 'sv_FZG_y', 'sv_FAH_delta_h1', ...
%     'sv_time', 'input_data', 'simtime', 'sv_FZG_psi', 'sv_FZG_M_brems', 'sv_Gangwahl_eff', 'P_loss_opt')


% Importiert Effizienz Ergebnisse ins Workspace
% 
% Ev_ges_eff = load ('.\Betriebsstrategie_Vergleich\letzte_Ergebnisse_BTS_Eff.mat', 'Ev_ges'); 
% pv_ges_eff = load ('.\Betriebsstrategie_Vergleich\letzte_Ergebnisse_BTS_Eff.mat', 'pv_ges'); 
% sv_kappa_eff = load ('.\Betriebsstrategie_Vergleich\letzte_Ergebnisse_BTS_Eff.mat', 'sv_kappa');
% sv_FZG_M_antr_eff = load ('.\Betriebsstrategie_Vergleich\letzte_Ergebnisse_BTS_Eff.mat', 'sv_FZG_M_antr');
% sv_FZG_omega_eff = load ('.\Betriebsstrategie_Vergleich\letzte_Ergebnisse_BTS_Eff.mat', 'sv_FZG_omega');
% sv_FZG_x_eff = load ('.\Betriebsstrategie_Vergleich\letzte_Ergebnisse_BTS_Eff.mat', 'sv_FZG_x');
% sv_FZG_y_eff = load ('.\Betriebsstrategie_Vergleich\letzte_Ergebnisse_BTS_Eff.mat', 'sv_FZG_y');
% sv_time_eff = load ('.\Betriebsstrategie_Vergleich\letzte_Ergebnisse_BTS_Eff.mat', 'sv_time');
% input_data_eff = load ('.\Betriebsstrategie_Vergleich\letzte_Ergebnisse_BTS_Eff.mat', 'input_data');
% simtime_eff = load ('.\Betriebsstrategie_Vergleich\letzte_Ergebnisse_BTS_Eff.mat', 'simtime');
% sv_FZG_psi_eff = load ('.\Betriebsstrategie_Vergleich\letzte_Ergebnisse_BTS_Eff.mat', 'sv_FZG_psi');
% sv_FZG_M_brems_eff = load ('.\Betriebsstrategie_Vergleich\letzte_Ergebnisse_BTS_Eff.mat', 'sv_FZG_M_brems');
% sv_FAH_delta_h1_eff = load ('.\Betriebsstrategie_Vergleich\letzte_Ergebnisse_BTS_Eff.mat', 'sv_FAH_delta_h1');
% load ('.\Betriebsstrategie_Vergleich\letzte_Ergebnisse_BTS_Eff.mat', 'sv_Gangwahl_eff');
% load ('.\Betriebsstrategie_Vergleich\letzte_Ergebnisse_BTS_Eff.mat', 'P_loss_opt');
% 
% % Importiert Dynamik Ergebnisse ins Workspace
% 
% Ev_ges_dyn = load ('.\Betriebsstrategie_Vergleich\letzte_Ergebnisse_BTS_Dyn.mat', 'Ev_ges'); 
% pv_ges_dyn = load ('.\Betriebsstrategie_Vergleich\letzte_Ergebnisse_BTS_Dyn.mat', 'pv_ges'); 
% sv_kappa_dyn = load ('.\Betriebsstrategie_Vergleich\letzte_Ergebnisse_BTS_Dyn.mat', 'sv_kappa');
% sv_FZG_M_antr_dyn = load ('.\Betriebsstrategie_Vergleich\letzte_Ergebnisse_BTS_Dyn.mat', 'sv_FZG_M_antr');
% sv_FZG_omega_dyn = load ('.\Betriebsstrategie_Vergleich\letzte_Ergebnisse_BTS_Dyn.mat', 'sv_FZG_omega');
% sv_FZG_x_dyn = load ('.\Betriebsstrategie_Vergleich\letzte_Ergebnisse_BTS_Dyn.mat', 'sv_FZG_x');
% sv_FZG_y_dyn = load ('.\Betriebsstrategie_Vergleich\letzte_Ergebnisse_BTS_Dyn.mat', 'sv_FZG_y');
% sv_time_dyn = load ('.\Betriebsstrategie_Vergleich\letzte_Ergebnisse_BTS_Dyn.mat', 'sv_time');
% input_data_dyn = load ('.\Betriebsstrategie_Vergleich\letzte_Ergebnisse_BTS_Dyn.mat', 'input_data');
% simtime_dyn = load ('.\Betriebsstrategie_Vergleich\letzte_Ergebnisse_BTS_Dyn.mat', 'simtime');
% sv_FZG_psi_dyn = load ('.\Betriebsstrategie_Vergleich\letzte_Ergebnisse_BTS_Dyn.mat', 'sv_FZG_psi');
% sv_FZG_M_brems_dyn = load ('.\Betriebsstrategie_Vergleich\letzte_Ergebnisse_BTS_Dyn.mat', 'sv_FZG_M_brems');
% sv_FAH_delta_h1_dyn = load ('.\Betriebsstrategie_Vergleich\letzte_Ergebnisse_BTS_Eff.mat', 'sv_FAH_delta_h1');
% sv_Gangwahl_dyn = load ('.\Betriebsstrategie_Vergleich\letzte_Ergebnisse_BTS_Dyn.mat', 'sv_Gangwahl');
%     
% Bewertung_Kundenfahrt;
Bewertung_Kundenfahrt_kurz;
end



%% Kundenfahrt_lang
if(select_Kundenfahrt_lang == 1)
    if Optimierung.Modus ~= 1
    disp('Kundenfahrt lang...')
    tic
    end
    
            [input_data, select_delta_h, select_M_wheel,...
            activate_stop, activate_stop_vmax, ay_stop, deltav_ist, simtime, input_time, psip0,...
            mu_road_RF,mu_road_LF,mu_road_RR,mu_road_LR, ...
            savedec,stepsize,savestep, v0,v_final, t]...
            =  Kundenfahrt_lang(select_mu, Optimierung);
     
    % Anpassung der Reifenparameter für dirt oder gravel        
    if select_mu == 6;
            par_TIR(1).LMUY = 0.573;
            par_TIR(2).LMUY = 0.573;
            par_TIR(1).LKY = 0.69;
            par_TIR(2).LKY = 0.69;
    end

    if select_mu == 7;
            par_TIR(1).LMUY= 0.490;
            par_TIR(2).LMUY = 0.490;
            par_TIR(1).LKY(:) = 0.602;
            par_TIR(2).LKY(:) = 0.602;
    end
    
% % Fahrdynamik-Betriebsstrategie
% 
% temp_betriebsstrategie.Betriebsstrategiewahl = 0;
% 
% 
% disp ('Fahrdynamik-Betriebsstrategie gestartet...')
% tic
% sim ('simulation')
% toc
% 
% mkdir ('.\Betriebsstrategie_Vergleich')
% save ('.\Betriebsstrategie_Vergleich\letzte_Ergebnisse_BTS_Dyn.mat', 'Ev_ges', 'pv_ges', 'sv_kappa', ...
%     'sv_FZG_M_antr', 'sv_FZG_omega', 'sv_FZG_x', 'sv_FZG_y', 'P_loss_opt', 'sv_FAH_delta_h1', ...
%     'sv_time', 'input_data', 'simtime', 'sv_FZG_psi', 'sv_FZG_M_brems', 'sv_Gangwahl')

% Effizienz-Betriebsstrategie

temp_betriebsstrategie.Betriebsstrategiewahl = 1;
if Optimierung.Modus ~= 1
disp ('Effizienz-Betriebsstrategie gestartet...')
end

set_param('simulation/Vehicle/Fahrzeugmodell/Configurable_model','BlockChoice','vehicle_model');

sim ('simulation')


% save ('.\Betriebsstrategie_Vergleich\letzte_Ergebnisse_BTS_Eff.mat', 'Ev_ges', 'pv_ges', 'sv_kappa', ...
%     'sv_FZG_M_antr', 'sv_FZG_omega', 'sv_FZG_x', 'sv_FZG_y', 'sv_FAH_delta_h1', ...
%     'sv_time', 'input_data', 'simtime', 'sv_FZG_psi', 'sv_FZG_M_brems', 'sv_Gangwahl_eff', 'P_loss_opt')
% 
% 
% % Importiert Effizienz Ergebnisse ins Workspace
% 
% Ev_ges_eff = load ('.\Betriebsstrategie_Vergleich\letzte_Ergebnisse_BTS_Eff.mat', 'Ev_ges'); 
% pv_ges_eff = load ('.\Betriebsstrategie_Vergleich\letzte_Ergebnisse_BTS_Eff.mat', 'pv_ges'); 
% sv_kappa_eff = load ('.\Betriebsstrategie_Vergleich\letzte_Ergebnisse_BTS_Eff.mat', 'sv_kappa');
% sv_FZG_M_antr_eff = load ('.\Betriebsstrategie_Vergleich\letzte_Ergebnisse_BTS_Eff.mat', 'sv_FZG_M_antr');
% sv_FZG_omega_eff = load ('.\Betriebsstrategie_Vergleich\letzte_Ergebnisse_BTS_Eff.mat', 'sv_FZG_omega');
% sv_FZG_x_eff = load ('.\Betriebsstrategie_Vergleich\letzte_Ergebnisse_BTS_Eff.mat', 'sv_FZG_x');
% sv_FZG_y_eff = load ('.\Betriebsstrategie_Vergleich\letzte_Ergebnisse_BTS_Eff.mat', 'sv_FZG_y');
% sv_time_eff = load ('.\Betriebsstrategie_Vergleich\letzte_Ergebnisse_BTS_Eff.mat', 'sv_time');
% input_data_eff = load ('.\Betriebsstrategie_Vergleich\letzte_Ergebnisse_BTS_Eff.mat', 'input_data');
% simtime_eff = load ('.\Betriebsstrategie_Vergleich\letzte_Ergebnisse_BTS_Eff.mat', 'simtime');
% sv_FZG_psi_eff = load ('.\Betriebsstrategie_Vergleich\letzte_Ergebnisse_BTS_Eff.mat', 'sv_FZG_psi');
% sv_FZG_M_brems_eff = load ('.\Betriebsstrategie_Vergleich\letzte_Ergebnisse_BTS_Eff.mat', 'sv_FZG_M_brems');
% sv_FAH_delta_h1_eff = load ('.\Betriebsstrategie_Vergleich\letzte_Ergebnisse_BTS_Eff.mat', 'sv_FAH_delta_h1');
% load ('.\Betriebsstrategie_Vergleich\letzte_Ergebnisse_BTS_Eff.mat', 'sv_Gangwahl_eff');
% load ('.\Betriebsstrategie_Vergleich\letzte_Ergebnisse_BTS_Eff.mat', 'P_loss_opt');
% 
% % Importiert Dynamik Ergebnisse ins Workspace
% 
% Ev_ges_dyn = load ('.\Betriebsstrategie_Vergleich\letzte_Ergebnisse_BTS_Dyn.mat', 'Ev_ges'); 
% pv_ges_dyn = load ('.\Betriebsstrategie_Vergleich\letzte_Ergebnisse_BTS_Dyn.mat', 'pv_ges'); 
% sv_kappa_dyn = load ('.\Betriebsstrategie_Vergleich\letzte_Ergebnisse_BTS_Dyn.mat', 'sv_kappa');
% sv_FZG_M_antr_dyn = load ('.\Betriebsstrategie_Vergleich\letzte_Ergebnisse_BTS_Dyn.mat', 'sv_FZG_M_antr');
% sv_FZG_omega_dyn = load ('.\Betriebsstrategie_Vergleich\letzte_Ergebnisse_BTS_Dyn.mat', 'sv_FZG_omega');
% sv_FZG_x_dyn = load ('.\Betriebsstrategie_Vergleich\letzte_Ergebnisse_BTS_Dyn.mat', 'sv_FZG_x');
% sv_FZG_y_dyn = load ('.\Betriebsstrategie_Vergleich\letzte_Ergebnisse_BTS_Dyn.mat', 'sv_FZG_y');
% sv_time_dyn = load ('.\Betriebsstrategie_Vergleich\letzte_Ergebnisse_BTS_Dyn.mat', 'sv_time');
% input_data_dyn = load ('.\Betriebsstrategie_Vergleich\letzte_Ergebnisse_BTS_Dyn.mat', 'input_data');
% simtime_dyn = load ('.\Betriebsstrategie_Vergleich\letzte_Ergebnisse_BTS_Dyn.mat', 'simtime');
% sv_FZG_psi_dyn = load ('.\Betriebsstrategie_Vergleich\letzte_Ergebnisse_BTS_Dyn.mat', 'sv_FZG_psi');
% sv_FZG_M_brems_dyn = load ('.\Betriebsstrategie_Vergleich\letzte_Ergebnisse_BTS_Dyn.mat', 'sv_FZG_M_brems');
% sv_FAH_delta_h1_dyn = load ('.\Betriebsstrategie_Vergleich\letzte_Ergebnisse_BTS_Eff.mat', 'sv_FAH_delta_h1');
% sv_Gangwahl_dyn = load ('.\Betriebsstrategie_Vergleich\letzte_Ergebnisse_BTS_Dyn.mat', 'sv_Gangwahl');
%     
% Bewertung_Kundenfahrt;
if Optimierung.Modus ~= 1
toc
end
end


%% WLTP_Zyklus (in Simulink simuliert)
if select_WLTP_Zyklus == 1
      disp('WLTP Zyklus...')
      tic    

      [input_data, select_delta_h, select_M_wheel,...
          activate_stop,activate_stop_vmax,ay_stop,deltav_ist,simtime, input_time, psip0,...
          mu_road_RF,mu_road_LF,mu_road_RR,mu_road_LR, ...
          savedec,stepsize,savestep, v0,v_final]...
          = WLTP_Zyklus(Optimierung, select_mu);

        % Anpassung der Reifenparameter für dirt oder gravel        
        if select_mu == 6;
                par_TIR(1).LMUY = 0.573;
                par_TIR(2).LMUY = 0.573;
                par_TIR(1).LKY = 0.69;
                par_TIR(2).LKY = 0.69;
        end

        if select_mu == 7;
                par_TIR(1).LMUY= 0.490;
                par_TIR(2).LMUY = 0.490;
                par_TIR(1).LKY(:) = 0.602;
                par_TIR(2).LKY(:) = 0.602;
        end

    % Fahrdynamik-Betriebsstrategie

    % temp_betriebsstrategie.Betriebsstrategiewahl = 0;
    % 
    % 
    % disp ('Fahrdynamik-Betriebsstrategie gestartet...')
    % sim ('simulation')
    % 
    % mkdir ('.\Betriebsstrategie_Vergleich')
    % save ('.\Betriebsstrategie_Vergleich\letzte_Ergebnisse_BTS_Dyn.mat', 'Ev_ges', 'pv_ges', 'sv_kappa', ...
    %     'sv_FZG_M_antr', 'sv_FZG_omega', 'sv_FZG_x', 'sv_FZG_y', 'P_loss_opt', 'sv_FAH_delta_h1', ...
    %     'sv_time', 'input_data', 'simtime', 'sv_FZG_psi', 'sv_FZG_M_brems', 'sv_Gangwahl')
    % 
    % Effizienz-Betriebsstrategie

    temp_betriebsstrategie.Betriebsstrategiewahl = 1;

    disp ('Effizienz-Betriebsstrategie gestartet...')
    %Set vehicle model to simplified model
    set_param('simulation/Vehicle/Fahrzeugmodell/Configurable_model','BlockChoice','simplified_vehicle_model');
    %Comments all To Workspace blocks, apart from the strictly necessary ones
    if select_To_Wks_akt == 0
        blcks = find_system('simulation','BlockType','ToWorkspace');
        for i = 1:length(blcks)
            set_param(blcks{i},'commented','on');
        end
    set_param('simulation/To Workspace1','commented','off');
    set_param('simulation/Vehicle/Antriebsstrang und Radmomentenverteilung/To Workspace3','commented','off');
    end

    sim ('simulation')
    % 
    % 
    % save ('.\Betriebsstrategie_Vergleich\letzte_Ergebnisse_BTS_Eff.mat', 'Ev_ges', 'pv_ges', 'sv_kappa', ...
    %     'sv_FZG_M_antr', 'sv_FZG_omega', 'sv_FZG_x', 'sv_FZG_y', 'sv_FAH_delta_h1', ...
    %     'sv_time', 'input_data', 'simtime', 'sv_FZG_psi', 'sv_FZG_M_brems', 'sv_Gangwahl_eff', 'P_loss_opt')


    % Importiert Effizienz Ergebnisse ins Workspace

    % Ev_ges_eff = load ('.\Betriebsstrategie_Vergleich\letzte_Ergebnisse_BTS_Eff.mat', 'Ev_ges'); 
    % pv_ges_eff = load ('.\Betriebsstrategie_Vergleich\letzte_Ergebnisse_BTS_Eff.mat', 'pv_ges'); 
    % sv_kappa_eff = load ('.\Betriebsstrategie_Vergleich\letzte_Ergebnisse_BTS_Eff.mat', 'sv_kappa');
    % sv_FZG_M_antr_eff = load ('.\Betriebsstrategie_Vergleich\letzte_Ergebnisse_BTS_Eff.mat', 'sv_FZG_M_antr');
    % sv_FZG_omega_eff = load ('.\Betriebsstrategie_Vergleich\letzte_Ergebnisse_BTS_Eff.mat', 'sv_FZG_omega');
    % sv_FZG_x_eff = load ('.\Betriebsstrategie_Vergleich\letzte_Ergebnisse_BTS_Eff.mat', 'sv_FZG_x');
    % sv_FZG_y_eff = load ('.\Betriebsstrategie_Vergleich\letzte_Ergebnisse_BTS_Eff.mat', 'sv_FZG_y');
    % sv_time_eff = load ('.\Betriebsstrategie_Vergleich\letzte_Ergebnisse_BTS_Eff.mat', 'sv_time');
    % input_data_eff = load ('.\Betriebsstrategie_Vergleich\letzte_Ergebnisse_BTS_Eff.mat', 'input_data');
    % simtime_eff = load ('.\Betriebsstrategie_Vergleich\letzte_Ergebnisse_BTS_Eff.mat', 'simtime');
    % sv_FZG_psi_eff = load ('.\Betriebsstrategie_Vergleich\letzte_Ergebnisse_BTS_Eff.mat', 'sv_FZG_psi');
    % sv_FZG_M_brems_eff = load ('.\Betriebsstrategie_Vergleich\letzte_Ergebnisse_BTS_Eff.mat', 'sv_FZG_M_brems');
    % sv_FAH_delta_h1_eff = load ('.\Betriebsstrategie_Vergleich\letzte_Ergebnisse_BTS_Eff.mat', 'sv_FAH_delta_h1');
    % load ('.\Betriebsstrategie_Vergleich\letzte_Ergebnisse_BTS_Eff.mat', 'sv_Gangwahl_eff');
    % load ('.\Betriebsstrategie_Vergleich\letzte_Ergebnisse_BTS_Eff.mat', 'P_loss_opt');

    % Importiert Dynamik Ergebnisse ins Workspace

    % Ev_ges_dyn = load ('.\Betriebsstrategie_Vergleich\letzte_Ergebnisse_BTS_Dyn.mat', 'Ev_ges'); 
    % pv_ges_dyn = load ('.\Betriebsstrategie_Vergleich\letzte_Ergebnisse_BTS_Dyn.mat', 'pv_ges'); 
    % sv_kappa_dyn = load ('.\Betriebsstrategie_Vergleich\letzte_Ergebnisse_BTS_Dyn.mat', 'sv_kappa');
    % sv_FZG_M_antr_dyn = load ('.\Betriebsstrategie_Vergleich\letzte_Ergebnisse_BTS_Dyn.mat', 'sv_FZG_M_antr');
    % sv_FZG_omega_dyn = load ('.\Betriebsstrategie_Vergleich\letzte_Ergebnisse_BTS_Dyn.mat', 'sv_FZG_omega');
    % sv_FZG_x_dyn = load ('.\Betriebsstrategie_Vergleich\letzte_Ergebnisse_BTS_Dyn.mat', 'sv_FZG_x');
    % sv_FZG_y_dyn = load ('.\Betriebsstrategie_Vergleich\letzte_Ergebnisse_BTS_Dyn.mat', 'sv_FZG_y');
    % sv_time_dyn = load ('.\Betriebsstrategie_Vergleich\letzte_Ergebnisse_BTS_Dyn.mat', 'sv_time');
    % input_data_dyn = load ('.\Betriebsstrategie_Vergleich\letzte_Ergebnisse_BTS_Dyn.mat', 'input_data');
    % simtime_dyn = load ('.\Betriebsstrategie_Vergleich\letzte_Ergebnisse_BTS_Dyn.mat', 'simtime');
    % sv_FZG_psi_dyn = load ('.\Betriebsstrategie_Vergleich\letzte_Ergebnisse_BTS_Dyn.mat', 'sv_FZG_psi');
    % sv_FZG_M_brems_dyn = load ('.\Betriebsstrategie_Vergleich\letzte_Ergebnisse_BTS_Dyn.mat', 'sv_FZG_M_brems');
    % sv_FAH_delta_h1_dyn = load ('.\Betriebsstrategie_Vergleich\letzte_Ergebnisse_BTS_Eff.mat', 'sv_FAH_delta_h1');
    % sv_Gangwahl_dyn = load ('.\Betriebsstrategie_Vergleich\letzte_Ergebnisse_BTS_Dyn.mat', 'sv_Gangwahl');
    %     
    Bewertung_Kundenfahrt_kurz;
    %Uncomment all to workspace blocks
    if select_To_Wks_akt == 0
        for i = 1:length(blcks)
           set_param(blcks{i},'commented','off');
        end
    end
    set_param('simulation/Vehicle/Fahrzeugmodell/Configurable_model','BlockChoice','vehicle_model');
    %Checks if Simulink windows is open, if not closes without saving
        if strcmp(get_param('simulation','Shown'),'off')
            bdclose('simulation')
        end
    toc
end


%% Temp-files die Simulink erstellt löschen
Simulink.sdi.clear


