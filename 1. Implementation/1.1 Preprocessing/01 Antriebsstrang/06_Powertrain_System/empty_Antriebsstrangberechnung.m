function RES=empty_Antriebsstrangberechnung(par_MDT, Optimierung)

Achsmoment_Motor=               0;     % an der Achse verbautes Motormoment
Nenndrehzahl_Motor=             0;     % Nenndrehzahl der Motoren
Maximale_Drehzahl=              0;     % Maximaldrehzahl der E-Maschine(n)
Maschinentyp=                   0;     % PSM oder ASM
n_Gaenge=                       0;     % Anzahl der Gänge
i_Gaenge=                       0;     % Übersetzung der Gänge
az=                             0;     % 1 für achszentralen Antrieb
etv=                            0;     % 1 für elektrisches Torque Vectoring (nur in Verbindung mit Achszentralem Antriebe und ohne Differential)
TS=                             0;     % 1 für Torque Splitter (nur in Verbindung mit Achszentralem Antriebe und ohne Differential)
OD=                             0;    % 1 für offenes Differential (nur in Verbindung mit achsezentralem Antrieb ohne TV)
Stkzahl=                        par_MDT.AUS.Stkzahl;    % Produzierte Stückzahl pro Jahr (maximal 2 Mio.)
Standort=                       par_MDT.AUS.Standort;    % Deutschland=1, USA=2, Rumaenien=3, Tschechien=4
Magnetpreise=                   par_MDT.AUS.Magnetpreise;    % stabil=1, sinkend=2, steigend=3 Stkzahl,
Optimierung_Gesamttopologie=    0;    % Optimierung der Gesamttopologie

delta_M_TV_max=         0;                   % Maximales Differenzmoment des TV
Spurweite=              2000;                % Spurweite [mm]
d_TIR=                  0.6;                 % Reifendurchmesser [m]

% Alle Ergebnisse werden in den Structure-array "RES" gespeichert.
RES.em.typ_EM =             Maschinentyp;
RES.trans.n_gears=          n_Gaenge;
RES.trans.i_gears =         i_Gaenge;
RES.em.nmax=                Maximale_Drehzahl;
RES.em.nnenn=               Nenndrehzahl_Motor;
RES.em.Mnenn_achs=          Achsmoment_Motor;
RES.em.U_RMS=               160;                            %V 
RES.em.U_linetoline=        160*sqrt(3);                    %V linetoline Spannung
RES.akt.az=                 az;
RES.akt.etv=                etv;
RES.akt.TS=                 TS;
RES.akt.OD=                 OD;
RES.cost.Stkzahl=           Stkzahl;
RES.cost.Standort=          Standort;
RES.cost.Magnetpreise=      Magnetpreise;
RES.trans.etv.delta_M=      delta_M_TV_max;

% M_nenn für radnahen Antrieb bereits in Benutzeroberflaeche_Fahrzeugkonfiguration halbiert!
RES.em.Mnenn_mot=Achsmoment_Motor;
    
%% Motor

% Geometrie der Maschine
RES.em.Motoraussendurchmesser_in_Meter         =0;
RES.em.Maschinenlaenge_in_Meter                =0;
RES.em.Statoraussendurchmesser_in_Meter        =0;
RES.em.Rotoraussendurchmesser_in_Meter         =0;

% Masse 
RES.em.Motormasse                              =0;

% Kosten 
RES.em.K_ges                                   =0;  %Berechnung der Herstellkosten des Motors an der VA

% Wirkungsgradkennfeld und Überlas
RES.em.M_max_mot                                = 0;
RES.em.MaxMotorTrqCurve_w                       = (1:201);
RES.em.MaxMotorTrqCurve_M                       = (1:201);
RES.em.MaxGeneratorTrqCurve_w                   = (1:201);
RES.em.MaxGeneratorTrqCurve_M                   = (1:201);
RES.em.MotorEffMap3D_w                          = (1:201);
RES.em.MotorEffMap3D_M                          = (1:101);
RES.em.MotorEffMap3D                            =(1:201)'*(1:101);
RES.em.GeneratorEffMap3D_w                      = (1:201); 
RES.em.GeneratorEffMap3D_M                      = (1:101);
RES.em.GeneratorEffMap3D                        =(1:201)'*(1:101);

RES.em.E_Motorobject                            = MotorScaling(); %Source: Tschochner, Maximilian (PCT)
PeakPower_kW=20000;
n_max_radps=100000;
RES.em.E_Motorobject                = Scale(RES.em.E_Motorobject, PeakPower_kW, n_max_radps);
calc_Consumption(RES.em.E_Motorobject)

% Maximales Achsmoment berechnen 
RES.em.M_max_achse=RES.em.M_max_mot;


%% Leistungselektronik

RES.inv.current         =linspace(1,450,450);
RES.inv.voltage         =linspace(1,160,160); 
RES.inv.powerfactor     =linspace(1,101,101);
RES.inv.speed           =linspace(1,1201,1201);
RES.inv.torque          =linspace(1,275,275);
RES.inv.Kosten          =0; 
RES.inv.Masse           =0;
if Optimierung.linux_paths == 1
    RES.inv.efficiency_map=load('./../Initialisierung/Antriebsstrang/05_Leistungselektronik/EfficiencyMap_LE.mat');
    else 
    RES.inv.efficiency_map=load('./Initialisierung/Antriebsstrang/05_Leistungselektronik/EfficiencyMap_LE.mat');
    end
   [RES.inv.Powerfactor_map] = Leistungselektronik_PowerfactorMap_ASM();


%% Getriebe
RES.trans.masse                                     =0;
RES.trans.wkg                                       =0;
RES.trans.K_ges                                     =0;
RES.trans.imax                                      =0;
RES.trans.etv.M_nenn_em_Steuer                      =0;
RES.trans.etv.n_nenn_em_Steuer                      =0;
RES.trans.etv.m_em_Steuer                           =0;
RES.trans.etv.n_max_em_Steuer                       =0; 
RES.trans.etv.typ_em_Steuer                         =0;
RES.trans.etv.M_max_Steuer                          =0;

%Kennfelder
RES.trans.etv.Kennfelder.MaxMotorTrqCurve_w         = (1:201);
RES.trans.etv.Kennfelder.MaxMotorTrqCurve_M         = (1:201);
RES.trans.etv.Kennfelder.MaxGeneratorTrqCurve_w     = (1:201);
RES.trans.etv.Kennfelder.MaxGeneratorTrqCurve_M     = (1:201);
RES.trans.etv.Kennfelder.MotorEffMap3D              =(1:201)'*(1:101);
RES.trans.etv.Kennfelder.MotorEffMap3D_w            = (1:201);
RES.trans.etv.Kennfelder.MotorEffMap3D_M            = (1:101);
RES.trans.etv.Kennfelder.GeneratorEffMap3D          =(1:201)'*(1:101);
RES.trans.etv.Kennfelder.GeneratorEffMap3D_w        = (1:201);
RES.trans.etv.Kennfelder.GeneratorEffMap3D_M        = (1:101);

%Zähnezahlen
RES.trans.etv.z.z1_I                                 =0;
RES.trans.etv.z.z2_II                                =0; 
RES.trans.etv.z.z1_III                               =0; 
RES.trans.etv.z.z2_III                               =0;
RES.trans.etv.z.z2_IV                                =0;
RES.trans.etv.z.zP_I_II                              =0; 
RES.trans.etv.z.zP_III_IV                            =0;
RES.trans.etv.z.zVTV_1                               =0;
RES.trans.etv.z.zVTV_2                               =0;
RES.trans.etv.z.zVTV_3                               =0;
RES.trans.etv.z.zVTV_4                               =0;

%Übersetzungen
RES.trans.etv.i.i12_I                                =0; 
RES.trans.etv.i.i12_II                               =0;
RES.trans.etv.i.i12_III                              =0;
RES.trans.etv.i.i12_IV                               =0;
RES.trans.etv.i.iVTV_1                               =0;
RES.trans.etv.i.iVTV_2                               =0;

%Wirkunsgrade
RES.trans.etv.eta.eta12_I                            =0;
RES.trans.etv.eta.eta12_II                           =0; 
RES.trans.etv.eta.eta12_III                          =0;
RES.trans.etv.eta.eta12_IV                           =0;
RES.trans.etv.eta.etaVTV_12                          =0;
RES.trans.etv.eta.etaVTV_34                          =0;


%% Topologieübergreifende Berechnung

% Breite der Topologie
RES.Geometrie.Topologie.Topologiebreite_in_Meter=0;

% Gesamtkostenrechnung
RES.cost.Gesamtkosten = 0;

% Datenzuordnung
RES.Masse.Topologie_Gesamtmasse=0;

