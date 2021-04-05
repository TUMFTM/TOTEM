function RES=Antriebsstrangberechnung(varargin)
% calculates the drive-unit for a certain axle based on the input design-
% variables, that describe the topology, the choice of components and
% the scaling of the components

Achsmoment=                     varargin{1};     % nominal axle Torque
Maximale_Drehzahl=              varargin{2};     % maximum motor speed 
Maschinentyp=                   varargin{3};     % Motortype: PSM or ASM (IM)
n_Gaenge=                       varargin{4};     % Number of gears
i_Gaenge=                       varargin{5};     % transmission ratio(s)
az=                             varargin{6};     % 1 for central drive
etv=                            varargin{7};     % 1 for elektric Torque Vectoring (only in combination with central drive and without differential)
TS=                             varargin{8};     % 1 for Torque Splitter (only in combination with central drive and without differential)
OD=                             varargin{9};     % 1 for open differential (only in combination with central drive without torque-vectoring)
Stkzahl=                        varargin{10};    % Produzierte Stückzahl pro Jahr (maximal 2 Mio.)
Standort=                       varargin{11};    % Deutschland=1, USA=2, Rumaenien=3, Tschechien=4
Magnetpreise=                   varargin{12};    % stabil=1, sinkend=2, steigend=3 Stkzahl,
Optimierung=    varargin{13};    % Optimierung der Gesamttopologie

if nargin>14
    delta_M_TV_max=         varargin{14};        % Maximales Differenzmoment des TV
    Spurweite=              varargin{15};        % Spurweite [mm]
    d_TIR=                  varargin{16};        % Reifendurchmesser [m]
else
    delta_M_TV_max=         0;                   % Maximales Differenzmoment des TV
    Spurweite=              2000;                % Spurweite [mm]
    d_TIR=                  0.6;                 % Reifendurchmesser [m]
end
                  
% Alle Ergebnisse werden in den Structure-array "RES" gespeichert.
RES.em.typ_EM =             Maschinentyp;
RES.trans.n_gears=          n_Gaenge;
RES.trans.i_gears =         i_Gaenge;
RES.em.nmax=                Maximale_Drehzahl;
RES.em.Mnenn_achs=          Achsmoment;
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

% M_nenn_mot für radnahen Antrieb halbieren
if (RES.akt.az == 0)
    RES.em.Mnenn_mot=Achsmoment*0.5;
else
    RES.em.Mnenn_mot=Achsmoment;
end

%% Motor
[RES.em.Motorlaenge_m, RES.em.Durchmesser_aussen_m, RES.em.Volumen_l]=... 
    Maschinengeometrie(RES.em.Mnenn_mot, RES.em.nmax, RES.em.typ_EM);

% Kennfeld
 [RES.em.M_max_mot,RES.em.MaxMotorTrqCurve_w, ...     
    RES.em.MaxMotorTrqCurve_M, RES.em.MaxGeneratorTrqCurve_w, ...
    RES.em.MaxGeneratorTrqCurve_M, RES.em.MotorEffMap3D_w, ...
    RES.em.MotorEffMap3D_M, RES.em.MotorEffMap3D, ...
    RES.em.GeneratorEffMap3D_w, RES.em.GeneratorEffMap3D_M, ...
    RES.em.GeneratorEffMap3D, RES.em.nnenn, RES.em.E_Motorobject] = ...
    Kennfeldberechnung_Motor_Tschochner(RES.em.Mnenn_mot, RES.em.nmax, RES.em.typ_EM);

% Überschreiben der NaN-Werte für die Beschl. / Traktion
I=isnan(RES.em.MotorEffMap3D);
RES.em.MotorEffMap3D(I)=1;

% Masse der einzelnen Komponenten
RES.em.Motormasse = Masse_Metamodell_Emaschine(RES.em.Mnenn_mot, RES.em.typ_EM);

% costs 
RES.em.K_ges    = Kosten_Metamodell_Motor(RES.em.nnenn, RES.em.Mnenn_mot, RES.em.typ_EM);

% Inertia
[RES.em.Jx, RES.em.Jy, RES.em.Jz] =   TraegheitAchsen_EM(RES.em.typ_EM, RES.em.Mnenn_mot, RES.em.nnenn);
RES.em.Jred = Traegheit_EM(RES.em.Mnenn_mot,RES.em.nnenn,RES.em.typ_EM,RES.trans.i_gears);

% Maximales Achsmoment berechnen
if az==1
    RES.em.M_max_achse=RES.em.M_max_mot;
else
    RES.em.M_max_achse=RES.em.M_max_mot*2;
end


%% Inverter
[RES.inv.efficiency_map, RES.inv.Powerfactor_map, RES.inv.current, RES.inv.voltage, RES.inv.powerfactor, ...
 RES.inv.speed, RES.inv.torque, RES.inv.Kosten, RES.inv.Masse] = Leistungselektronik ...
(Optimierung, RES.em.nnenn, RES.em.Mnenn_mot, RES.em.typ_EM, RES.cost.Stkzahl, RES.akt.az, RES.em.M_max_mot, RES.em.U_RMS, RES.em.nmax, RES.em.Mnenn_achs);

%% Getriebe
[RES.trans.masse, RES.trans.masse_TS, RES.trans.Jred, RES.trans.wkg, ...
RES.trans.d_Abtriebsrad, RES.trans.b_Abtriebsrad, ...
RES.trans.Getriebebreite_in_Meter, RES.trans.Getriebelaenge_in_Meter, RES.trans.Getriebehoehe_in_Meter, ...
RES.trans.J_x, RES.trans.J_y, RES.trans.J_z, ...
RES.trans.K_ges, RES.trans.imax, ...
RES.trans.vzkonst, ...
RES.trans.m_geh, RES.trans.m_Zahnraeder_Wellen, RES.trans.m_korb, ...
RES.trans.etv.M_nenn_em_Steuer, RES.trans.etv.n_nenn_em_Steuer, RES.trans.etv.n_max_em_Steuer, RES.trans.etv.typ_em_Steuer, RES.trans.etv.M_max_Steuer, RES.trans.etv.Kennfelder.MaxMotorTrqCurve_w, RES.trans.etv.Kennfelder.MaxMotorTrqCurve_M, RES.trans.etv.Kennfelder.MaxGeneratorTrqCurve_w, RES.trans.etv.Kennfelder.MaxGeneratorTrqCurve_M, RES.trans.etv.Kennfelder.MotorEffMap3D, RES.trans.etv.Kennfelder.MotorEffMap3D_w, RES.trans.etv.Kennfelder.MotorEffMap3D_M, RES.trans.etv.Kennfelder.GeneratorEffMap3D, RES.trans.etv.Kennfelder.GeneratorEffMap3D_w, RES.trans.etv.Kennfelder.GeneratorEffMap3D_M, RES.trans.etv.z.z1_I, RES.trans.etv.z.z2_II, RES.trans.etv.z.z1_III, RES.trans.etv.z.z2_III, RES.trans.etv.z.z2_IV, RES.trans.etv.z.zP_I_II, RES.trans.etv.z.zP_III_IV, RES.trans.etv.z.zVTV_1, RES.trans.etv.z.zVTV_2, RES.trans.etv.z.zVTV_3, RES.trans.etv.z.zVTV_4,RES.trans.etv.i.i12_I, RES.trans.etv.i.i12_II, RES.trans.etv.i.i12_III, RES.trans.etv.i.i12_IV, RES.trans.etv.i.iVTV_1, RES.trans.etv.i.iVTV_2, RES.trans.etv.eta.eta12_I, RES.trans.etv.eta.eta12_II, RES.trans.etv.eta.eta12_III, RES.trans.etv.eta.eta12_IV, RES.trans.etv.eta.etaVTV_12, RES.trans.etv.eta.etaVTV_34, RES.trans.etv.J.Jred_EM_Steuer, RES.trans.etv.m_eTV, RES.trans.etv.m_em_Steuer, RES.trans.etv.J.Jred_eTV, RES.trans.etv.J.Jx_eTV, RES.trans.etv.J.Jy_eTV, RES.trans.etv.J.Jz_eTV, RES.trans.etv.J.Jx_em_Steuer, RES.trans.etv.J.Jy_em_Steuer, RES.trans.etv.J.Jz_em_Steuer, RES.trans.etv.laenge_em_Steuer, RES.trans.etv.COG.x_eTV, RES.trans.etv.COG.y_eTV, RES.trans.etv.COG.z_eTV, RES.trans.etv.COG.x_SEM, RES.trans.etv.COG.y_SEM, RES.trans.etv.COG.z_SEM]= ...
Getriebe(                   RES.trans.n_gears, ...
                                RES.trans.i_gears, ...
                                RES.em.M_max_mot, ...
                                RES.em.Mnenn_mot, ...
                                RES.em.nnenn, ...
                                RES.em.Durchmesser_aussen_m, ... 
                                RES.trans.etv.delta_M, ...
                                RES.akt.etv, ...
                                RES.akt.TS, ...
                                RES.akt.az, ...
                                RES.akt.OD, ...
                                RES.cost.Stkzahl, ...
                                RES.cost.Standort, ...
                                Optimierung, ... % der Gesamttopologie
                                d_TIR, ...
                                Spurweite); 

%% Topologieübergreifende Berechnung

% Breite der Topologie
if az==1
RES.Geometrie.Topologie.Topologiebreite_in_Meter=RES.trans.Getriebebreite_in_Meter+RES.em.Motorlaenge_m;
else
RES.Geometrie.Topologie.Topologiebreite_in_Meter=(RES.trans.Getriebebreite_in_Meter-0.015+RES.em.Motorlaenge_m)*2; % 15 mmm weniger aufgrund Gehäuseteilung bei radnaher Anordnung
end

% Gesamtkostenrechnung
%Kosten_gesamt=RES.em.K_ges + RES.trans.K_ges + RES.LE.K_ges;
if az == 1
RES.cost.Gesamtkosten = RES.em.K_ges + RES.trans.K_ges + RES.inv.Kosten;
else
RES.cost.Gesamtkosten = (RES.em.K_ges + RES.trans.K_ges + RES.inv.Kosten) * 2;
end

% Datenzuordnung
if az == 1
    RES.Masse.Topologie_Gesamtmasse=    RES.em.Motormasse+RES.trans.masse+RES.trans.etv.m_em_Steuer+RES.inv.Masse;
else
    RES.Masse.Topologie_Gesamtmasse=    (RES.em.Motormasse+RES.trans.masse+RES.trans.etv.m_em_Steuer+RES.inv.Masse)* 2;
end

%% Position of Center of Gravity [m] 
[l_EM] = RES.em.Motorlaenge_m; %m
[l_GTR] = RES.trans.Getriebelaenge_in_Meter; %m
[b_GTR] = RES.trans.Getriebebreite_in_Meter; %m

[RES.em.CoG_x, RES.em.CoG_y, RES.em.CoG_z] = SP_EM(l_EM,l_GTR,b_GTR,RES.akt.az); %m
[RES.trans.CoG_x, RES.trans.CoG_y, RES.trans.CoG_z] = SP_GTR(l_EM, l_GTR, b_GTR, RES.akt.az);

