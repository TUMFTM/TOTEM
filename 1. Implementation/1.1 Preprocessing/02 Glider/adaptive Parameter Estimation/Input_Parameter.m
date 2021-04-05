function IP = Input_Parameter(Segment)
% Load inputparameter for defined vehicle segments. In TOTEM only Segment T
% that represents the Tesla Model S is validated. The Segment-parameters 
% contain main parameters of the glider such as wheelbase air drag 
% coefficient or outer dimensions. These parameters are needed as an input
% for the weight estimation and the vehicle dynamics model. 


% Allgemeine Parameter für alle Segmente außer "T", %Source: Thesis Benedikt Mößner
    IP.c_R =          0.0085; %Rollwiderstandsbeiwert [-]
    IP.Energiedichte =   200; %Energiedichte der Hochvoltbatterie [Wh/kg]     
    IP.electric =          1; %Auswahl Elektrofahrzeug
    IP.Range =           400;... %Reichweite [km]
    IP.Zul_max =         585; %maximale Zuladung [kg]
    IP.WSSW =           32.0; %Windschutzscheibenwinkel [°]
    IP.SSW =            25.0; %Seitenscheibenwinkel [°]
    IP.HSW =            32.0; %Heckscheibenwinkel [°]
    IP.Komf_Int =          4; %Komfortfaktor Interieur
    IP.Komf_Aku =     0.0050; %Komfortfaktor Akustik (>3 = 0.0035, >=3 = 0.0050)

if Segment == 'A' %Source: Thesis Benedikt Mößner
    %z.B. Golf, A-Klasse, Q3, X1
    IP.Radstand =       2647; %Radstand [mm]
    IP.Breite =         1816; %Fahrzeugbreite [mm]
    IP.Hoehe =          1651; %Fahrzeughöhe [mm]
    IP.UeH_v =          0.52 * (4404-2647); %Überhang vorne [mm]
    IP.UeH_h =          0.48 * (4404-2647); %Überhang hinten [mm]
    IP.SpW_v =          1550; %Spurweite vorne [mm]
    IP.SpW_h =          1555; %Spurweite hinten [mm]
    IP.cw =            0.292; %Luftwiderstandsbeiwert cw [-]
    IP.A =             2.549; %Strömungsquerschnittsfläche [m²]
    
    IP.FD =             17; %Felgendurchmesser [zoll]
    IP.RB =            225; %Reifenbreite [mm]
    IP.HtoW =           55; %Reifenhöhe / Breite [%]

elseif Segment == 'B' %Source: Thesis Benedikt Mößner
    %z.B. A4, C-Klasse, Q5, X3
    IP.Radstand =       2786; %Radstand [mm]
    IP.Breite =         1919; %Fahrzeugbreite [mm]
    IP.Hoehe =          1702; %Fahrzeughöhe [mm]
    IP.UeH_v =          0.52 * (4646-2786); %Überhang vorne [mm]
    IP.UeH_h =          0.48 * (4646-2786); %Überhang hinten [mm]
    IP.SpW_v =          1638; %Spurweite vorne [mm]
    IP.SpW_h =          1644; %Spurweite hinten [mm]
    IP.cw =            0.301; %Luftwiderstandsbeiwert cw [-]
    IP.A =             2.776; %Strömungsquerschnittsfläche [m²]

    IP.FD =             18; %Felgendurchmesser [zoll]
    IP.RB =            245; %Reifenbreite [mm]
    IP.HtoW =           45; %Reifenhöhe / Breite [%]
    
elseif Segment == 'C' %Source: Thesis Benedikt Mößner
    %z.B. A6, E-Klasse, Q7, X5
    IP.Radstand =       2910; %Radstand [mm]
    IP.Breite =         1935; %Fahrzeugbreite [mm]
    IP.Hoehe =          1743; %Fahrzeughöhe [mm]
    IP.UeH_v =          0.52 * (4846-2910); %Überhang vorne [mm]
    IP.UeH_h =          0.48 * (4846-2910); %Überhang hinten [mm]
    IP.SpW_v =          1652; %Spurweite vorne [mm]
    IP.SpW_h =          1657; %Spurweite hinten [mm]
    IP.cw =            0.298; %Luftwiderstandsbeiwert cw [-]
    IP.A =             2.867; %Strömungsquerschnittsfläche [m²]
    
    IP.FD =             18; %Felgendurchmesser [zoll]
    IP.RB =            245; %Reifenbreite [mm]
    IP.HtoW =           45; %Reifenhöhe / Breite [%]  

elseif Segment == 'T' %Source: Master-Thesis Andreas Holtz
    % Tesla Model S
    IP.Radstand =       2960; %Radstand [mm]
    IP.Breite =         1964; %Fahrzeugbreite [mm]
    IP.Hoehe =          1445; %Fahrzeughöhe [mm]
    IP.UeH_v =          937; %Überhang vorne [mm]
    IP.UeH_h =          1081; %Überhang hinten [mm]
    IP.SpW_v =          1662; %Spurweite vorne [mm]
    IP.SpW_h =          1700; %Spurweite hinten [mm]
    IP.cw =            0.24; %Luftwiderstandsbeiwert cw [-]
    IP.A =             2.34; %Strömungsquerschnittsfläche [m²]
    
    IP.FD =             19; %Felgendurchmesser [zoll]
    IP.RB =            245; %Reifenbreite [mm]
    IP.HtoW =           45; %Reifenhöhe / Breite [%]
    
    % Allgemeine Parameter für Segment "T"
    IP.c_R =          0.008602402; %Rollwiderstandsbeiwert [-]
    IP.Energiedichte =   200; %Energiedichte der Hochvoltbatterie [Wh/kg]     
    IP.spez_Batt_kosten= 130; %130€/kWh aus Fries Paper 2017
    IP.electric =          1; %Auswahl Elektrofahrzeug
    IP.Range =           502;... %Reichweite [km]
    IP.Zul_max =         433; %maximale Zuladung [kg]
    IP.WSSW =           26.0; %Windschutzscheibenwinkel [°]
    IP.SSW =            20.0; %Seitenscheibenwinkel [°]
    IP.HSW =            22.0; %Heckscheibenwinkel [°]
    IP.Komf_Int =          4; %Komfortfaktor Interieur
    IP.Komf_Aku =     0.0050; %Komfortfaktor Akustik (>3 = 0.0035, >=3 = 0.0050)
    
end


%%Material Parameter 
%Sources: Thesis Benedikt Mößner / Dissertation Stephan Fuchs
% B. Mößner, “Adaptive Parametrierung des Gliders eines Zweispurmodells für Sport-Utility-Vehicles,” Semesterarbeit, Lehrstuhl für Fahrzeugtechnik, Technische Universität München, München, 2017.
% S. Fuchs, “Verfahren zur parameterbasierten Gewichtsabschätzung neuer Fahrzeugkonzepte,” Dissertation, Lehrstuhl für Fahrzeugtechnik, Technische Universität München, München, 2014.

IP.mat = struct(...
    'steel',       0,... %Stahl
    'hss',         0,... %davon hochfester Stahl
    'alu',       100,... %Aluminium
    'cfk',         0,... %CFK
    'door',      0.7,... %Material der Türen (Stahl 1, Alu 0.7) [-]
    'hood',      0.7,... %Material der Motorhaube (Stahl 1, Alu 0.7) [-]
    'tg',        0.7,... %Material der Heckklappe (Stahl 1, Alu 0.7) [-]
    'fender',    0.7);   %Material des Kotflügels (Stahl 1, Alu 0.7) [-]

% cw = 4.74659e-4*IP.Breite*IP.Hoehe/(IP.Radstand+IP.UeH_v+IP.UeH_h) + 2.04693e-2;
% A = 0.85*IP.Breite*IP.Hoehe;