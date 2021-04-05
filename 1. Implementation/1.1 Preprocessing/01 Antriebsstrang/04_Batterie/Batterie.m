function [Batterie_Gewicht ,Batterie_Kosten, Batt_Kap, Cells_serial, Cells_parallel, Daten_Batteriemodell, Cell_Kap] = Batterie ...
    (Optimierung,  U_DC_HV, IP, par_MDT)

% Berechnung aller batteriebezogenen Daten
par_MDT.AUS.batt.Kosten=par_MDT.AUS.batt.Kapazitaet*IP.spez_Batt_kosten;

%% Allgemeine Batteriedaten
Batterie_Energiedichte = IP.Energiedichte;   %Wh/kg aus Paper von Matz (2016): Beschreibung der Modellierungsart und -parameter von Elektro-fahrzeugen in der Konzeptphase
Batterie_preis = IP.spez_Batt_kosten;           %€/kWh aus Paper von Fries (2017): An Overview of Costs for Vehicle Components, Fuels, Greenhouse Gas Emissions and Total Cost of Ownership
Cell_Kap=2.808;                 %Ah Kapazität einer Zelle (aus Datenblatt "Panasonic NCR18650PF")
U_cell=3.6;                     %V (pro Zelle 3.6V, Eigenschaften von "Panasonic NCR18650PF")

Batt_Kap = par_MDT.AUS.batt.Kapazitaet;
%% Kosten
Batterie_Kosten = Batt_Kap  * Batterie_preis;    %Berechnung der Batteriekosten

%% Gewicht
Batterie_Gewicht =  Batt_Kap *1000/ Batterie_Energiedichte; %Berechnung des Batteriegewichts

%% Leistungsabhängiger Wirkungsgrad
Cells_serial=ceil(U_DC_HV/U_cell);                                %Berechnung der seriell verschalteten Zellen  -> nur ganze Zahlen möglich
Cells_parallel=ceil(Batt_Kap*1000/(Cell_Kap*Cells_serial*U_cell));              %Berechnung der parallel verschaltete Zellen  -> nur ganze Zahlen möglich

% Einlesen der Daten für das Batteriemodell 
% Source: Wassiliadis, Nikolaos
if Optimierung.linux_paths == 1
    Daten_Batteriemodell=load('./../1.1 Preprocessing/01 Antriebsstrang/04_Batterie/BatPara_MR-07_2RC.mat');
else 
    Daten_Batteriemodell=load('./1.1 Preprocessing/01 Antriebsstrang/04_Batterie/BatPara_MR-07_2RC.mat');
end

end