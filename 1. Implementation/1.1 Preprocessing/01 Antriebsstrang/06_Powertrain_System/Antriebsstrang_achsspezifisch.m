function par_MDT = Antriebsstrang_achsspezifisch(config, par_TIR, Optimierung)
% The function Antriebsstrang_achsspezifische calculates and initializes
% the powertrain of a both axles (front and rear). This design includes
% Inverter, electric motor, transmission and differential or torque- 
% vectoring.  

%% Initialisierung von par_MDT Struktur

par_MDT.VA = par_MDT_initialize_Fieldnames();
par_MDT.HA = par_MDT_initialize_Fieldnames();
ohneEmaschine_HA = (config.akt.az_HA==0)&(config.akt.rn_HA==0);
ohneEmaschine_VA = (config.akt.az_VA==0)&(config.akt.rn_VA==0);

%% Designparameters 
par_MDT.AUS.Stkzahl=100000;                     %Produzierte Stückzahl pro Jahr (maximal 2 Mio.)
par_MDT.AUS.Standort=1;                         %Deutschland=1, USA=2, Rumaenien=3, Tschechien=4
par_MDT.AUS.Magnetpreise=1;                     %stabil=1, sinkend=2, steigend=3

%% Auslegungs- Effizienz, Massen, Geometrie und Kostenrechnungen
% front axle
if ohneEmaschine_VA
    % dummy section: no calulation; fills the variables with zero values
    % for non-propelled axles
    par_MDT.VA = empty_Antriebsstrangberechnung(par_MDT, Optimierung);

else

    if config.akt.eTV_VA==1
        par_MDT.VA = Antriebsstrangberechnung(      config.em.Mnenn_achs_VA, ...           % an der Achse verbautes Motormoment
            config.em.nmax_VA, ...                 % Maximaldrehzahl der E-Maschine(n)
            config.em.typ_EM_VA,...                % PSM oder ASM
            config.trans.n_gears_VA, ...           % Anzahl der Gänge
            config.trans.i_gears_VA, ...           % Übersetzung der Gänge
            config.akt.az_VA, ...                  % 1 für achszentralen Antrieb
            config.akt.eTV_VA, ...                 % 1 für elektrisches Torque Vectoring (nur in Verbindung mit Achszentralem Antriebe und ohne Differential)
            config.akt.TS_VA, ...                  % 1 für TS (nur in Verbindung mit Achszentralem Antriebe und ohne Differential)
            config.akt.OD_VA, ...                  % 1 für offenes Differential (nur in Verbindung mit achsezentralem Antrieb ohne TV)
            par_MDT.AUS.Stkzahl, ...              % Produzierte Stückzahl pro Jahr (maximal 2 Mio.)
            par_MDT.AUS.Standort, ...             % Deutschland=1, USA=2, Rumaenien=3, Tschechien=4
            par_MDT.AUS.Magnetpreise, ...         % stabil=1, sinkend=2, steigend=3 Stkzahl,
            Optimierung, ...                       % Optimierung = 1, wenn Gesamttopologieoptimierung aktiv, sonst =0
            config.etv.delta_M_max_VA, ...         % Maximales Differenzmoment des elektrischen Torque Vectorings
            config.segment_parameter.SpW_h, ...    % Spurweite
            par_TIR(1).DIAMETER);                  % Reifendurchmesser
    else
        par_MDT.VA = Antriebsstrangberechnung(      config.em.Mnenn_achs_VA, ...           % an der Achse verbautes Motormoment
            config.em.nmax_VA, ...                 % Maximaldrehzahl der E-Maschine(n)
            config.em.typ_EM_VA,...                % PSM oder ASM
            config.trans.n_gears_VA, ...           % Anzahl der Gänge
            config.trans.i_gears_VA, ...           % Übersetzung der Gänge
            config.akt.az_VA, ...                  % 1 für achszentralen Antrieb
            config.akt.eTV_VA, ...                 % 1 für elektrisches Torque Vectoring (nur in Verbindung mit Achszentralem Antriebe und ohne Differential)
            config.akt.TS_VA, ...                  % 1 für TS (nur in Verbindung mit Achszentralem Antriebe und ohne Differential)
            config.akt.OD_VA, ...                  % 1 für offenes Differential (nur in Verbindung mit achsezentralem Antrieb ohne TV)
            par_MDT.AUS.Stkzahl, ...              % Produzierte Stückzahl pro Jahr (maximal 2 Mio.)
            par_MDT.AUS.Standort, ...             % Deutschland=1, USA=2, Rumaenien=3, Tschechien=4
            par_MDT.AUS.Magnetpreise, ...         % stabil=1, sinkend=2, steigend=3 Stkzahl,
            Optimierung);                          % der Gesamttopologie
    end
end

% rear axle
if ohneEmaschine_HA
    % dummy section: no calulation; fills the variables with zero values
    % for non-propelled axles
    par_MDT.HA = empty_Antriebsstrangberechnung(par_MDT, Optimierung);
else
    if config.akt.eTV_HA==1
        par_MDT.HA = Antriebsstrangberechnung(      config.em.Mnenn_achs_HA, ...           % an der Achse verbautes Motormoment
            config.em.nmax_HA, ...                 % Maximaldrehzahl der E-Maschine(n)
            config.em.typ_EM_HA,...                % PSM oder ASM
            config.trans.n_gears_HA, ...           % Anzahl der Gänge
            config.trans.i_gears_HA, ...           % Übersetzung der Gänge
            config.akt.az_HA, ...                  % 1 für achszentralen Antrieb
            config.akt.eTV_HA, ...                 % 1 für elektrisches Torque Vectoring (nur in Verbindung mit Achszentralem Antriebe und ohne Differential)
            config.akt.TS_HA, ...                  % 1 für TS (nur in Verbindung mit Achszentralem Antriebe und ohne Differential)
            config.akt.OD_HA, ...                  % 1 für offenes Differential (nur in Verbindung mit achsezentralem Antrieb ohne TV)
            par_MDT.AUS.Stkzahl, ...              % Produzierte Stückzahl pro Jahr (maximal 2 Mio.)
            par_MDT.AUS.Standort, ...             % Deutschland=1, USA=2, Rumaenien=3, Tschechien=4
            par_MDT.AUS.Magnetpreise, ...         % stabil=1, sinkend=2, steigend=3 Stkzahl,
            Optimierung, ....                      % Optimierung = 1, wenn Gesamttopologieoptimierung aktiv, sonst =0
            config.etv.delta_M_max_HA, ...         % Maximales Differenzmoment des elektrischen Torque Vectorings
            config.segment_parameter.SpW_h, ...    % Spurweite
            par_TIR(1).DIAMETER);                  % Reifendurchmesser
    else
        par_MDT.HA = Antriebsstrangberechnung(      config.em.Mnenn_achs_HA, ...           % an der Achse verbautes Motormoment
            config.em.nmax_HA, ...                 % Maximaldrehzahl der E-Maschine(n)
            config.em.typ_EM_HA,...                % PSM oder ASM
            config.trans.n_gears_HA, ...           % Anzahl der Gänge
            config.trans.i_gears_HA, ...           % Übersetzung der Gänge
            config.akt.az_HA, ...                  % 1 für achszentralen Antrieb
            config.akt.eTV_HA, ...                 % 1 für elektrisches Torque Vectoring (nur in Verbindung mit Achszentralem Antriebe und ohne Differential)
            config.akt.TS_HA, ...                  % 1 für TS (nur in Verbindung mit Achszentralem Antriebe und ohne Differential)
            config.akt.OD_HA, ...                  % 1 für offenes Differential (nur in Verbindung mit achsezentralem Antrieb ohne TV)
            par_MDT.AUS.Stkzahl, ...              % Produzierte Stückzahl pro Jahr (maximal 2 Mio.)
            par_MDT.AUS.Standort, ...             % Deutschland=1, USA=2, Rumaenien=3, Tschechien=4
            par_MDT.AUS.Magnetpreise, ...         % stabil=1, sinkend=2, steigend=3 Stkzahl,
            Optimierung); ...                      % Optimierung = 1, wenn Gesamttopologieoptimierung aktiv, sonst =0
    end
end

%% Aktivators (used for distinguishing between different Topologies)
%New substruct AUS (Achsunspezifisch = non-axle-specific)
par_MDT.AUS.akt.az_VA = config.akt.az_VA; 
par_MDT.AUS.akt.az_HA = config.akt.az_HA;
par_MDT.AUS.akt.rn_VA = config.akt.rn_VA;
par_MDT.AUS.akt.rn_HA = config.akt.rn_HA;

%MVS
par_MDT.AUS.akt.OD_VA = config.akt.OD_VA;
par_MDT.AUS.akt.eTV_VA = config.akt.eTV_VA;
par_MDT.AUS.akt.TS_VA = config.akt.TS_VA;
par_MDT.AUS.akt.OD_HA = config.akt.OD_HA;
par_MDT.AUS.akt.eTV_HA = config.akt.eTV_HA;
par_MDT.AUS.akt.TS_HA = config.akt.TS_HA;

% switches für die Multconfig.segment_parameterorts
par_MDT.AUS.switch.MVS_VA = 0;
if par_MDT.AUS.akt.az_VA == 0
    par_MDT.AUS.switch.MVS_VA = 1;
end
if par_MDT.AUS.akt.OD_VA == 1
    par_MDT.AUS.switch.MVS_VA = 2;
end
if par_MDT.AUS.akt.eTV_VA == 1
    par_MDT.AUS.switch.MVS_VA = 3;
end
if par_MDT.AUS.akt.TS_VA == 1
    par_MDT.AUS.switch.MVS_VA = 4;
end

par_MDT.AUS.switch.MVS_HA = 0;
if par_MDT.AUS.akt.az_HA == 0
    par_MDT.AUS.switch.MVS_HA = 1;
end
if par_MDT.AUS.akt.OD_HA == 1
    par_MDT.AUS.switch.MVS_HA = 2;
end
if par_MDT.AUS.akt.eTV_HA == 1
    par_MDT.AUS.switch.MVS_HA = 3;
end
if par_MDT.AUS.akt.TS_HA == 1
    par_MDT.AUS.switch.MVS_HA = 4;
end



end