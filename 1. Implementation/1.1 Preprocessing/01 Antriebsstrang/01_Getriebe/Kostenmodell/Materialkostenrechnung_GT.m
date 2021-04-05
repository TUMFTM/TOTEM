function MK_gesamt_GT=Materialkostenrechnung_GT(az, OD, TV, TS, m_GH, m_Zahnraeder_Wellen, m_Korb, m_torque_cost, m_eTV, Stkzahl) % in diesem Skript werden die Materialkosten des Getriebes berechnet

%% Materialdaten

Di_AL=2700; %Dichte Aluminium in kg/m^3         Quelle: [34]
Di_ST=7700; %Dichte Stahllegierung in kg/m^3    Quelle: [34]
Di_SL=7700; %Dichte Stahllegierung in kg/m^3    Quelle: [34]

Ko_AL=3.6;  %Kosten Aluminium in €/kg                            Quelle: [34]
Ko_ST=1.5;  %Kosten Stahllergierung in €/kg                      Quelle: [12]
Ko_SL=2;    %Kosten Stahllergierung (einsatzgehärtet) in €/kg    Quelle: [12]

%% Materialverluste

Ve_AL=0.1;          %Aluminiumverluste durch spanende Bearbeitung in %   Quelle: [80]
Ve_ST=0.1;          %Stahlverluste durch spanende Bearbeitung in %       Quelle: [80]
Ve_SL=0.1;          %Stahlverluste durch spanende Bearbeitung in %       Quelle: [80]


%% Kosten der einzelnen Komponenten in €

MK_GH=      m_GH*                   Ko_AL*(1+Ve_AL);        % Gehäuse
MK_ZR=      m_Zahnraeder_Wellen*    Ko_SL*(1+Ve_SL);        % Zahnräder
MK_OD_KO=   m_Korb*                 Ko_ST*(1+Ve_ST);        % Differentialkorb
MK_eTV=     m_eTV*                  Ko_SL*(1+Ve_SL);        % Torque-Vectoring-Zahnräder
MK_TS=      m_torque_cost*          Ko_ST*(1+Ve_SL);        % Torque-Splitter 
%% Berechnung der Materialgesamtkosten abhängig von gewählter Topologie

   MK_gesamt_GT_OD=MK_GH+MK_ZR+MK_OD_KO;  
   MK_gesamt_GT_ohne_OD=MK_GH+MK_ZR;
   MK_gesamt_GT_eTV=MK_GH+MK_ZR+MK_eTV;  
   MK_gesamt_GT_TS=MK_GH+MK_ZR+MK_TS;
   
%% Gesamte Materialkosten in € inkl. MGK-Zuschlag (stückzahlabhängige Skalierung erfolgt für <20000 Stk.)
%Zuschlagskosten nach Ehrenspiel adaptiert für verschiedene Stückzahlen [99]


    if Stkzahl>=100000
        MK_gesamt_GT_OD=MK_gesamt_GT_OD*1.1;
        MK_gesamt_GT_ohne_OD=MK_gesamt_GT_ohne_OD*1.1;
        MK_gesamt_GT_eTV=MK_gesamt_GT_eTV*1.1;
        MK_gesamt_GT_TS= MK_gesamt_GT_TS*1.1;
     elseif Stkzahl<100000 && Stkzahl>=50000
        MK_gesamt_GT_OD=MK_gesamt_GT_OD*1.1*1.1;
        MK_gesamt_GT_ohne_OD=MK_gesamt_GT_ohne_OD*1.1*1.1;
        MK_gesamt_GT_eTV=MK_gesamt_GT_eTV*1.1*1.1;
        MK_gesamt_GT_TS= MK_gesamt_GT_TS*1.1*1.1;
    elseif Stkzahl<50000 && Stkzahl>=20000
        MK_gesamt_GT_OD=MK_gesamt_GT_OD*1.1*1.2;
        MK_gesamt_GT_ohne_OD=MK_gesamt_GT_ohne_OD*1.1*1.2;
        MK_gesamt_GT_eTV=MK_gesamt_GT_eTV*1.1*1.2;
        MK_gesamt_GT_TS= MK_gesamt_GT_TS*1.1*1.2;
    elseif Stkzahl<20000 && Stkzahl>=3000
        MK_gesamt_GT_OD=MK_gesamt_GT_OD*1.15*1.5;
        MK_gesamt_GT_ohne_OD=MK_gesamt_GT_ohne_OD*1.15*1.5;
        MK_gesamt_GT_eTV=MK_gesamt_GT_eTV*1.15*1.5;
        MK_gesamt_GT_TS= MK_gesamt_GT_TS*1.1*1.5;
    else Stkzahl<3000
        MK_gesamt_GT_OD=MK_gesamt_GT_OD*1.18*1.8;
        MK_gesamt_GT_ohne_OD=MK_gesamt_GT_ohne_OD*1.18*1.8;
        MK_gesamt_GT_eTV=MK_gesamt_GT_eTV*1.18*1.8;
        MK_gesamt_GT_TS= MK_gesamt_GT_TS*1.1*1.8;
    end
    
%% Zuordnung der Materialgesamtkosten abhängig von gewähltem Getriebetyp

if     az==1 && OD==1 && TV==0 && TS ==0
    MK_gesamt_GT=MK_gesamt_GT_OD;
elseif az==1 && OD==0 && TV==1 && TS ==0
    MK_gesamt_GT=MK_gesamt_GT_eTV;
elseif az==1 && OD==0 && TV==0 && TS ==0
    MK_gesamt_GT=MK_gesamt_GT_ohne_OD;
elseif az==1 && OD==0 && TV==0 && TS ==1
    MK_gesamt_GT=MK_gesamt_GT_TS;
elseif az==0
    MK_gesamt_GT=MK_gesamt_GT_ohne_OD;
end

