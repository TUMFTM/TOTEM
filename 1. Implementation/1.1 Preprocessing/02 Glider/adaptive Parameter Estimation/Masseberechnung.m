function [Konst,IP,NR,m,par_VEH, par_MDT] = Masseberechnung(config,par_MDT,par_TIR,Optimierung)
% MASS CALCULATION of the whole Glider
% mass calculation of structure, chassis, drivetrain, electronic components,
% exterieur, interieur
% Regressions base on:
%     S. Fuchs, “Verfahren zur parameterbasierten Gewichtsabschätzung neuer 
%     Fahrzeugkonzepte,” Dissertation, Lehrstuhl für Fahrzeugtechnik, 
%     Technische Universität München, München, 2014.
%
%


%%Konstanten
Konst.m_driver =      75;%Fahrermasse [kg]
Konst.m_passenger =   75;%Beifahrermasse [kg]
   
IP=config.segment_parameter;    %Überführung der Segmentparameter

par_VEH.cx = IP.cw;     %cx=cw [-]
par_VEH.rhoair = 1.2041; %air density [kg/m^3]
par_VEH.Afront = IP.A;    %Frontal area [m^2]
par_VEH.l =     IP.Radstand/1000;      %wheelbase [m]
par_VEH.lF=0.5*par_VEH.l;
par_VEH.lR=0.5*par_VEH.l;
par_VEH.zSP_r=0.51;
par_VEH.g  = 9.81;      %acceleration of gravity




%%Nebenrechnungen
NR.m_empty =    1.2159*(IP.Radstand + IP.UeH_v + IP.UeH_v) - 3748.9; %Startgewichtsschätzung für Gewichtsspirale

for i = 1:100
NR.Laenge =             IP.Radstand + IP.UeH_v + IP.UeH_h; %Länge [mm]
NR.SpW_avg =            (IP.SpW_v + IP.SpW_h)/2; %mittlere Spurweite [mm]
NR.GC =                 0.14 * IP.Hoehe; %Ground Clearance/Bodenfreiheit [mm]
NR.CH =                 IP.Hoehe - NR.GC; %Chassis Height [mm]
NR.vol =                (IP.Radstand + IP.UeH_v * 0.5 + IP.UeH_h * 0.75)* IP.Breite * IP.Hoehe / 1e9; %Ersatzvolumen Structure [m³]
NR.m_full =             NR.m_empty + Konst.m_driver + Konst.m_passenger + IP.Zul_max; %Masse vollbeladenes Fahrzeug
NR.m_est_st_curb =      NR.vol * 2.4334E+02 - 4.7656E+02; %Erwartetes Gesamt-Gewicht
NR.delta_m_curb =       NR.m_full - NR.m_est_st_curb; %Delta Berechnet Erwartet Gesamtgewicht
NR.p_correct_frame =    3.4/4.9 * NR.delta_m_curb / NR.m_est_st_curb; %Korrekturfaktor für Karosserie
NR.d_wheel =            0.0254 * par_TIR(1).RIM + par_TIR(1).WIDTH*1000 * par_TIR(1).ASPECT_RATIO*100 * 2 / 100 / 1000; %Außendurchmesser des Reifens [m] 
NR.area_hood =          IP.Radstand * IP.Breite * 6.954E-07 -1.9921; %Motorhaubenfläche [m^2]
NR.area_ws =            0.25 * IP.Breite * IP.Hoehe /sind(IP.WSSW) * 1e-06; %Windschutzscheibenfläche [m^2]
NR.area_swf =           0.08 * 1.1 * IP.Radstand * IP.Hoehe / cosd(IP.SSW) * 1e-06; %Seitenscheibenfläche vorne [m^2]
NR.area_swr =           0.06 * 1.1 * IP.Radstand * IP.Hoehe / cosd(IP.SSW) * 1e-06; %Seitenscheibenfläche hinten [m^2]
NR.area_rw =            0.2 * IP.Breite * IP.Hoehe /sind(IP.HSW) * 1e-06; %Heckscheibenfläche [m^2]


%%Massenberechnungen
%%Structure
m.ST.st_ref_frame =     37.452 * NR.vol -6.6381E+01;  %Rahmen Struktur [kg]
m.ST.st_ref_frame_new = (1 + NR.p_correct_frame) * m.ST.st_ref_frame; %Korrigiertes Rahmengewicht [kg]
m.ST.frame =            m.ST.st_ref_frame_new * (IP.mat.steel*(1-IP.mat.hss/100) + IP.mat.steel/100 * IP.mat.hss * 0.9 + IP.mat.alu * 0.7 + IP.mat.cfk * 0.56)/100; %Berücksichtigter Leichtbau Rahmengewicht [kg]
m.ST.crash_fr =         7.6000E-03 * NR.m_full + 1.3000E+00; %Masse Crash-Elemente vorne [kg]
m.ST.crash_re =         9.6000E-03 * NR.m_full + 1.6000E+00; %Masse Crash-Elemente hinten [kg]
m.ST.struct_other =     5.5; % [kg]

m.ST.Summe = m.ST.frame + m.ST.crash_fr + m.ST.crash_re + m.ST.struct_other; %Summe der Strukturmassen [kg]

%%Chassis
m.CH.ax_re_ml =     NR.m_empty * NR.d_wheel * 3.9271E-02 + 1.1747E+01; %Masse Achse hinten Mehrlenker [kg]
m.CH.susp_re_ml =   NR.m_empty * NR.d_wheel * 7.1740E-03 + 2.7409E+00; %Masse Federung hinten Mehrlenker [kg]
m.CH.ax_fr_mcp =    NR.m_empty * NR.d_wheel * 2.8279E-02 + 1.7470E+01; %Masse Achse vorne McPherson [kg]
m.CH.susp_fr_mcp =  NR.m_empty * NR.d_wheel * 1.0287E-02 + 5.5050E+00; %Masse Federung vorne McPherson [kg]

m.CH.steer =        NR.m_empty * IP.Breite * 5.7713E-06 + 6.6326E+00; %Masse Lenkung [kg]
m.CH.brake_total =  NR.m_empty * 4.0719E-02 -1.7353E+00; %Masse Bremsen [kg]
m.CH.pedals =       2.532; %Masse Pedale  [kg]
m.CH.wheels_fr_normal = NR.d_wheel * par_TIR(1).WIDTH*1000 * 2.7641E-01 -4.6820E-01; %Masse Räder vorne  [kg]
m.CH.wheels_re_normal = NR.d_wheel * par_TIR(1).WIDTH*1000 * 2.7641E-01 -4.6820E-01; %Masse Räder hinten  [kg]

m.CH.Summe =  m.CH.ax_re_ml + m.CH.susp_re_ml + m.CH.ax_fr_mcp + m.CH.susp_fr_mcp + m.CH.steer + m.CH.brake_total + ...
            m.CH.pedals + m.CH.wheels_fr_normal + m.CH.wheels_re_normal; %Summe der Chassismassen [kg]

%%Drivetrain

if IP.electric == 0
    m.DT.eng_comb =       IP.M_Max * 2.7520E-01 + 5.0645E+01; %Masse Verbrennungsmotor [kg]
    if strcmp(IP.Getr_Art, 'Hand') 
        m.DT.gearbox =      IP.M_Max * 8.2347E-02 + 3.0620E+01; %Masse Getriebe abhängig der Getriebeart [kg]
        m.DT.transm_oil =   1.66; %Masse Getriebeöl abhängig der Getriebeart [kg]
    elseif strcmp(IP.Getr_Art, 'Auto')
        m.DT.gearbox =      IP.M_Max * 0.0518 + 6.3730E+01;
        m.DT.transm_oil =   2.50;
    end

    if strcmp(IP.Antr_Art, 'FWD') 
        m.DT.shaft =    IP.M_Max * 0.0192 + 1.1999E+01; %Masse der Antriebswellen (inkl. Differential) abhängig der Antriebsart [kg]
    elseif strcmp(IP.Antr_Art, 'AWD')
        m.DT.shaft =    IP.M_Max * 0.0726 + 5.6876E+01;
    end
    
    if strcmp(IP.Fuel, 'Diesel') 
        m.DT.clutch =    IP.M_Max * 2.2100E-02 + 1.2247E+01; %Masse der Kupplung abhängig der Kraftstoffart [kg]
        m.DT.exhaust =   IP.M_Max * 2.0500E-02 + 1.7708E+01; %Masse des Abgastrakts abhängig der Kraftstoffart [kg]
        m.DT.cooling =   IP.Eng_Power * 6.5000E-02 + 4.2212E+00; %Masse der Kühlung abhängig der Kraftstoffart [kg]
        m.DT.fuel =      IP.Tankkap * 0.8325; %Masse des Brennstoffs abhängig der Kraftstoffart [kg]
    elseif strcmp(IP.Fuel, 'Benzin')
        m.DT.clutch =    IP.M_Max * 4.9500E-02 + 6.9672E+00;
        m.DT.exhaust =   IP.M_Max * 1.3660E-01 + 2.9579E+00;
        m.DT.cooling =   IP.Eng_Power * 4.8500E-02 + 2.9038E+00;
        m.DT.fuel =      IP.Tankkap * 0.7475;
    end

    m.DT.air =          IP.M_Max * 2.7200E-02 + 2.5270E-01; % Masse Luftsystem [kg]
    m.DT.oil =          IP.M_Max * 6.9000E-03 + 2.3159E+00; % Masse Motoröl [kg]
    m.DT.cool_fluid =   IP.M_Max * 1.1600E-02 + 3.2587E+00; % Masse Kühlflüssigkeit [kg] 
    m.DT.fuel_systems = 4.4; %Masse Brennstoffsystem
    m.DT.fueltank =     IP.Tankkap * 1.5810E-01 + 1.0976E+00; %Masse Brennstofftank [kg]

    m.DT.Summe =  m.DT.eng_comb + m.DT.gearbox + m.DT.transm_oil + m.DT.shaft + m.DT.clutch + m.DT.exhaust + m.DT.cooling + ...
                m.DT.fuel + m.DT.air + m.DT.oil + m.DT.cool_fluid + m.DT.fuel_systems + m.DT.fueltank;

else 
%   m.DT.NEFZ =     IP.cw * IP.A * 1.90E+4 + NR.m_empty * par_TIR(1).QSY1 * 8.40E+2 + NR.m_empty * 1.1 * 10; %Benötigte Energie in kJ nach NEFZ/100km
    g=9.81;     %Erdbeschl. 
    lambda=1.1; %Drehmassenzuschlagsfaktor nach SA Mößner

    
    par_VEH.m=NR.m_empty; 

    % WLTP-Berechnung
    samplerate=1;
    Automatisierter_zugriff=1;
    consumption =calc_zyklusverbrauch_vektorisiert(par_MDT, par_VEH, par_TIR, Automatisierter_zugriff, samplerate, Optimierung); %Verbrauch in kWh/100km 
    m.DT.WLTP_C3=consumption*3600;
    if isnan(consumption) % Wenn die im WLTP geforderten Fahrzustände durch 
                          % das Konzept nicht dargestellt werden können,
                          % dann wird das Gewicht aus der Näherungsweise
                          % analyteschen Berechnung bestimmt
        E_WLTP_C3=   (IP.cw * IP.A * par_VEH.rhoair * 0.5 *1.192e7 + NR.m_empty * par_TIR(1).QSY1 *g*2.326e4 + NR.m_empty * lambda *1.131)/0.77; % Benötige energie in J für WLTP, Herleitung siehe Guzzella, SA Mößner S.10, Berechnung unter mat-Files/Maneuver/WLTP
        m.DT.WLTP_C3=   E_WLTP_C3/1000/0.2326; %Verbrauch in kJ/100km 
        m.DT.WLTP_C3=   E_WLTP_C3/1000/0.2326*2; %Verbrauch in kJ/100km; Berechnung ist ungenau, das fï¿½hrt zu instabilitï¿½ten. Deshalb wird der Wert verdoppel(=verschlechtert), so dass er bei der Optimierung nicht in den Paretofronten auftaucht und das par_MDT....failed auf 1 bleibt. 
        par_MDT.AUS.batt_auslegung_failed=1;
    else
        par_MDT.AUS.batt_auslegung_failed=0;
    end
    
    m.DT.Batt_Kap = m.DT.WLTP_C3 * 1.3/3600 * IP.Range/100; %Benötigte Batteriekapazität in kWh für gewünschte Reichweite
    m.DT.HVBatt =   m.DT.Batt_Kap * 1000/ IP.Energiedichte; %Batteriegewicht
    m.DT.eng_VA =   par_MDT.VA.em.Motormasse * (2 - par_MDT.VA.akt.az);
    m.DT.eng_HA =   par_MDT.HA.em.Motormasse * (2 - par_MDT.HA.akt.az);
    
    m.DT.GTR_VA =   par_MDT.VA.trans.masse * (2 - par_MDT.AUS.akt.az_VA);
    m.DT.GTR_HA =   par_MDT.HA.trans.masse * (2 - par_MDT.AUS.akt.az_HA);
    
    m.DT.inv_VA =   par_MDT.VA.inv.Masse * (2 - par_MDT.AUS.akt.az_VA);
    m.DT.inv_HA =   par_MDT.HA.inv.Masse * (2 - par_MDT.AUS.akt.az_HA);
    
    m.DT.steuer_VA = par_MDT.VA.trans.etv.m_em_Steuer;
    m.DT.steuer_HA = par_MDT.HA.trans.etv.m_em_Steuer;
    
%     m.DT.Summe =    m.DT.HVBatt +  m.DT.eng_VA + m.DT.eng_HA + m.DT.GTR_VA + m.DT.GTR_HA ...
%                     + m.DT.inv_VA + m.DT.inv_HA;

        m.DT.Summe =    m.DT.HVBatt +  m.DT.eng_VA + m.DT.eng_HA + m.DT.GTR_VA + m.DT.GTR_HA ...
                    + m.DT.inv_VA + m.DT.inv_HA + m.DT.steuer_VA + m.DT.steuer_HA;


    
end

        
%%Elektronikkomponenten


if IP.electric == 0
    m.EE.bat_12v =      IP.Eng_Power * 1.0600E-01 + 8.6481E+00; %Masse Batterie   
else 
    m.EE.Mnenn =        (par_MDT.VA.em.Mnenn_achs * (2 - par_MDT.AUS.akt.az_VA) + par_MDT.HA.em.Mnenn_achs * (2 - par_MDT.AUS.akt.az_HA));
    m.EE.Mmax =         (par_MDT.VA.em.M_max_achse  * (2 - par_MDT.AUS.akt.az_VA) + par_MDT.HA.em.M_max_achse *  (2 - par_MDT.AUS.akt.az_HA));
    m.EE.bat_12v =      (m.EE.Mnenn * (par_MDT.VA.em.nnenn + par_MDT.HA.em.nnenn)/(2*60*1000)* 2 *pi) * 1.0600E-01 + 8.6481E+00; % Masse Batterie nach Fuchs angepasst von Holtz am 12.02.18
    m.EE.dc_dc =        (m.EE.Mnenn*2*pi*(par_MDT.VA.em.nnenn + par_MDT.HA.em.nnenn)/(2*60*1000))/(0.0405 * m.EE.Mnenn * (par_MDT.VA.em.nnenn + par_MDT.HA.em.nnenn)/(2*60*1000) * 2 *pi + 7.792); %Masse DC-DC-Wandler nach Fuchs angepasst von Holtz am 12.02.18    
    m.EE.invert =       par_MDT.VA.inv.Masse + par_MDT.HA.inv.Masse; %Masse Inverter nach Fuchs angepasst von Holtz am 12.02.18
    m.EE.hv_wiring =    IP.Radstand * 6.7167E-03 - 1.1505E+01; %Masse Verkabelung Hochvolt [kg]
    m.EE.hv_steck =     2 * pi * m.EE.Mnenn * (par_MDT.VA.em.nnenn + par_MDT.HA.em.nnenn)/(60 * 2 * 1000) * 1.0600E-01 + 8.6481E+00; %Masse Hochvolt Stecker [kg] 
end
    
m.EE.nv_wiring =    IP.Radstand * IP.Breite * IP.Hoehe * 6.5699E-09 - 2.6246E+01; %Masse Verkabelung Niedervolt [kg]
m.EE.light_int =    0.423; %Masse Innenbeleuchtung [kg]
m.EE.light_ext =    IP.Radstand * NR.SpW_avg * 3.8742E-06 -6.3723E+00; %Masse Scheinwerfer [kg]
m.EE.light_fog =    1.067; %Masse Nebelleuchte [kg]
m.EE.ee_other =     IP.Radstand * IP.Komf_Int * 5.3030E-04 + 3.2700E-01;  %sonstige Elektronikkomponenten [kg]


if IP.electric == 0
    m.EE.Summe =    m.EE.bat_12v + m.EE.nv_wiring + m.EE.light_int + m.EE.light_ext + m.EE.light_fog + m.EE.ee_other;
    
else 
    m.EE.Summe =    m.EE.bat_12v + m.EE.nv_wiring + m.EE.light_int + m.EE.light_ext + m.EE.light_fog + m.EE.ee_other+...
                    m.EE.dc_dc + m.EE.invert + m.EE.hv_wiring + m.EE.hv_steck;
end


%%Exterieur
m.EX.doors =        2 * IP.Radstand * IP.mat.door * 2.1274E-02 + (2 * -1.7485E+01); %Masse der vier Türen [kg]
m.EX.hood =         IP.mat.hood * NR.area_hood * 1.5621E+01 -8.2790E-01; %Masse der Motorhaubenabdeckung [kg]
m.EX.tg_hat =       IP.mat.tg * IP.Hoehe * IP.Breite /sind(IP.HSW) * 2.6009E-06 + 5.3655E+00; %Masse der Heckklappe [kg]
m.EX.wiper_re =     1.18; %Masse Scheibenwischer vorne [kg]
m.EX.wiper_fr =     3.70; %Masse Scheibenwischer hinten [kg]
m.EX.fender =       2 * IP.UeH_v * IP.mat.fender * 6.2597E-03 + (2 * -2.5676E-01); %Masse Kotflügel [kg]
m.EX.bump_fr =      IP.Hoehe * IP.Breite * IP.UeH_v * 4.0396E-09 + 3.2060E-01; % Masse Stoßstange vorne [kg]
m.EX.bump_re =      IP.Hoehe * IP.Breite * IP.UeH_h * 2.6078E-09 + 1.1076E+00; % Masse stoßstange hinten [kg]
m.EX.win_fr =       NR.area_ws * 0.005 * 2500; %Masse Windschutzscheibe
m.EX.sidws_fr =     2 * NR.area_swf * IP.Komf_Aku * 2500; %Masse Seitenfender vorne  [kg]
m.EX.sidws_re =     2 * NR.area_swr * IP.Komf_Aku * 2500; %Masse Seitenfender hinten  [kg]
m.EX.win_re =       NR.area_rw * 0.0035 * 2500; %Masse Heckscheibe [kg]
m.EX.mirrors =        2.52; %Masse Spiegel

m.EX.Summe =  m.EX.doors + m.EX.hood + m.EX.tg_hat + m.EX.wiper_re + m.EX.wiper_fr + m.EX.fender + m.EX.bump_fr + ...
            m.EX.bump_re + m.EX.win_fr + m.EX.sidws_fr + m.EX.sidws_re + m.EX.win_re + m.EX.mirrors;
   

%%Interieur
m.IN.seats_fr =         IP.Radstand * IP.Breite * IP.Komf_Int * 5.9020E-07 + 3.3190E+01;
m.IN.seats_re =         IP.Breite * IP.Hoehe * 4.44867E-05	-90.06185169;
%m.IN.seats_re =         IP.Breite * IP.Hoehe * 2.5081E-05 -3.9031E+01;
m.IN.airbag =           1.265 + 2.157 + 0.374 + 1.224 + 2.4;
m.IN.restrain =         7.225;
m.IN.security_addit =   0.95;
m.IN.cover_side =       IP.Radstand * IP.Hoehe * 6.0933E-06 -1.5554E+01;
m.IN.cover_roof =       IP.Radstand * NR.SpW_avg * 6.1800E-07 -5.3160E-01;
m.IN.cover_doors =      NR.Laenge * 6.0969E-03 -1.6193E+01;
m.IN.cover_rear =       NR.Laenge * 4.6234E-03 -1.3863E+01;
m.IN.ccb =              7;
m.IN.glovebox =         1.961;
m.IN.black_shelf =      1.527;
m.IN.door_box =         4 * 0.448;
m.IN.middle_box =       0.34;
m.IN.trunk_box =        1.242;
m.IN.dashboard =        NR.SpW_avg * 1.8062E-02 -1.9605E+01;
m.IN.centerconsole =    IP.Radstand * IP.Hoehe * IP.Komf_Int * 3.7870E-07 -4.3800E-02;
m.IN.radio =            1.957;
m.IN.speaker =          0.532 + 0.461;
m.IN.lcd =              0.7665;
m.IN.infotainment =     0.6;
m.IN.instrumentation =  2.451;
m.IN.heating =          IP.Radstand * IP.Komf_Int * 5.8460E-04 + 6.7677E+00;
m.IN.aircond =          8.778;
m.IN.insul =            IP.Radstand * NR.SpW_avg * 1.6408E-05 -4.6559E+01;
m.IN.int_other =        0.701;

m.IN.Summe =  m.IN.seats_fr + m.IN.seats_re + m.IN.airbag + m.IN.restrain + m.IN.security_addit +  m.IN.cover_side + ...
            m.IN.cover_roof + m.IN.cover_doors + m.IN.cover_rear + m.IN.ccb + m.IN.glovebox + m.IN.black_shelf + ...
            m.IN.door_box + m.IN.middle_box + m.IN.trunk_box + m.IN.dashboard + m.IN.centerconsole + m.IN.radio + ...
            m.IN.lcd + m.IN.infotainment + m.IN.instrumentation + m.IN.heating + m.IN.aircond + m.IN.insul + m.IN.int_other;


%%Sonstiges
m.OT.firstaid =         0.415;
m.OT.warning_triangle = 0.672;
m.OT.compressor_kit =   2.515;
m.OT.sparetire =        0;

m.OT.Summe = m.OT.firstaid + m.OT.warning_triangle + m.OT.compressor_kit + m.OT.sparetire;


%Gewichtsspirale
NR.m_vehicle =  m.ST.Summe + m.CH.Summe + m.DT.Summe + m.EE.Summe + m.EX.Summe + m.IN.Summe + m.OT.Summe; 
if NR.m_vehicle / NR.m_empty < 1.0001 && NR.m_vehicle / NR.m_empty > 0.9999
    break
end
NR.m_empty = NR.m_vehicle;
end

par_MDT.AUS.batt.Kapazitaet=m.DT.Batt_Kap;
par_MDT.AUS.batt.Masse=m.DT.HVBatt;
par_MDT.AUS.Gesamtmasse_Antrieb=m.DT.Summe;

par_VEH.m = NR.m_empty + Konst.m_driver;
par_VEH.m_usF = 0.5 * m.CH.ax_fr_mcp + 0.5 * m.CH.susp_fr_mcp + m.CH.wheels_fr_normal + 0.85 * 0.6 * m.CH.brake_total;
par_VEH.m_usR = 0.5 * m.CH.ax_re_ml + 0.5 * m.CH.susp_re_ml + m.CH.wheels_re_normal + 0.85 * 0.4 * m.CH.brake_total;
par_VEH.mss = par_VEH.m-par_VEH.m_usR-par_VEH.m_usF;

end

