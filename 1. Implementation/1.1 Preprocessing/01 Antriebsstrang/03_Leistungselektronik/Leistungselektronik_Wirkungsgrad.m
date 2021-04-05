function [efficiency_map_LE, Powerfactor_map_LE, current_LE, voltage_LE, powerfactor_LE, speed_LE, torque_LE]...
   = Leistungselektronik_Wirkungsgrad(Optimierung, EM_Typ, az, M_achs, n_max, U_RMS)
% loading and scaling Efficiency-maps of Inverter
% (only used for simulink model. Consumption calculation in Matlab already 
% includes inverter losses)

%% Wirkungsgradberechnung der LE
%Modell von Fengqi Chang; 
%Source: DOI:10.23919/EPE17ECCEEurope.2017.8099071 zugrunde
% F. Chang, O. Ilina, O. Hegazi, L. Voss, und M. Lienkamp, “Adopting MOSFET multilevel inverters to improve the partial load efficiency of electric vehicles,” in 2017 19th European Conference on Power Electronics and Applications (EPE'17 ECCE Europe): IEEE, 2017, P.1-P.13.

%Berechnung des maximalen Stroms:
P_max=2*pi*M_achs*n_max/60;         %[W] Berechnung maximale Leistung
I_max_AC=P_max/U_RMS/3;             %[A] Berechnung des maximalen Stroms

%Laden der Efficiency_Map für den Inverter

if Optimierung.linux_paths == 1
    efficiency_map_LE=load('./../1.1 Preprocessing/01 Antriebsstrang/03_Leistungselektronik/EfficiencyMap_LE.mat');
else 
    efficiency_map_LE=load('./1.1 Preprocessing/01 Antriebsstrang/03_Leistungselektronik/EfficiencyMap_LE.mat');
end


%Festlegung der Powerfactor Map:
    if EM_Typ=='PSM'
        [Powerfactor_map_LE] = Leistungselektronik_PowerfactorMap_PSM();
    elseif EM_Typ=='ASM'
        [Powerfactor_map_LE] = Leistungselektronik_PowerfactorMap_ASM();
    end
    
%Festlegung der Achsen der Look-Up Table (abhängig ob az oder rn)
if az==1
    torque_LE = linspace(1, M_achs, 275);     %Drehmomentvektor
    speed_LE = linspace(1,n_max,1201);          %Drehzahlvektor
    [powerfactor_LE] = Powerfactor_LE();    %Powerfactor
    I_LE=I_max_AC;                          %Strom
    current_LE=linspace(1,I_LE,450);        
   
    
elseif az==0
    torque_LE = linspace(1, M_achs/2, 275);     %Drehmomentvektor
    speed_LE = linspace(1,n_max,1201);          %Drehzahlvektor
    [powerfactor_LE] = Powerfactor_LE();        %Powerfactor
    I_LE=I_max_AC/2;                            %Strom
    current_LE=linspace(1,I_LE,450);
   
end

% Spannung ist gleich, egal ob AZ oder RN
voltage_LE=linspace(1,U_RMS,160);

%% Nur nötig zur initialen Berechnung der Efficiency Map
% Alle diese Formeln und Transaktionen sind nur ein mal initial auszuführen
% um die Efficiency-Map aus den Loss-Maps (die von Fengqi Chang erhalten wurden) 
%zu erzeugen. Dannach wird die Efficiency-Map als .mat-file abgespeichert und 
%von dort bei jeder iteration geladen. Dann wird nur noch die Strom-Achse
%angepasst


%load('./Initialisierung/Antriebsstrang/05_Leistungselektronik/Conductionloss.mat')
%load('./Initialisierung/Antriebsstrang/05_Leistungselektronik/Switchingloss.mat')

%Laden des Powerfactorvektors:
%[powerfactor_LE] = Powerfactor_LE();

% Transistoreigenschaften
%U=160;    %max Spannung des Transistors in V
%I=450;    %max Strom des Transistors

%Anpassung des Switchingloss an Schaltfrequenz Kennfeldes: (im Moment auf 24 kHz)
%Switchingloss=Switchingloss./2.4; %Anpassung der Schaltfrequenz des Inverters 

%Voltage=Tabelle mit Einträgen in der ersten Zeile von 1 bis U_nenn:
%voltage_LE=linspace(1,U,U);

%Current=Tabelle mit Einträgen in der ersten Zeile von 1 bis I:
%current_LE=linspace(1,I,I);

%Berechnung der (Current*Voltage*Switchingloss) Matrix B:
%A = 3*current_LE'*voltage_LE;

%B = zeros(length(Current'),length(Voltage),length(Powerfactor));

%for i=1:length(Powerfactor)
%    B(:,:,i) = A * Powerfactor(i);
%end

%B=reshape(bsxfun(@times,A(:),powerfactor_LE),length(current_LE),length(voltage_LE),[]); %--> von Matlab Support vorgeschlagen
  
%Berechnung der Efficiency Map
%efficiency_map_LE=1-((Switchingloss + Conductionloss)./(B+Switchingloss + Conductionloss)); %Verluste in Efficiency Map umwandeln
end