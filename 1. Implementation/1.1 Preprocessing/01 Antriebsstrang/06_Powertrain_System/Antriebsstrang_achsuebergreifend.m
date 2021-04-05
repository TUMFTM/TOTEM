function par_MDT = Antriebsstrang_achsuebergreifend(Optimierung, par_MDT, IP)
% Calculation of non axle-specific powertrain parameters such as for the 
% battery and integral values

par_MDT.AUS.batt.U_DC_HV=           400;                            %V max Spannung aus Datenblatt

%% Batterie
[par_MDT.AUS.batt.Masse ,par_MDT.AUS.batt.Kosten, par_MDT.AUS.batt.Kapazitaet, par_MDT.AUS.batt.Cells_serial, par_MDT.AUS.batt.Cells_parallel, ...
    par_MDT.AUS.batt.Daten_Batteriemodell, par_MDT.AUS.batt.Kapazitaet_Zellen ] ... 
= Batterie(Optimierung,  par_MDT.AUS.batt.U_DC_HV, IP, par_MDT);

%% Gesamtkostenrechnung
if par_MDT.AUS.akt.az_VA == 0 && par_MDT.AUS.akt.rn_VA == 0
    par_MDT.VA.cost.Gesamtkosten = 0;
end
    
if par_MDT.AUS.akt.az_HA == 0 && par_MDT.AUS.akt.rn_HA == 0
    par_MDT.HA.cost.Gesamtkosten = 0;
end

par_MDT.AUS.Gesamtkosten_Topologie = par_MDT.VA.cost.Gesamtkosten + par_MDT.HA.cost.Gesamtkosten ...
                                     + par_MDT.AUS.batt.Kosten;                           
                               
%% Sonstiges

%konstanter max. Kegelwirkungsgrad
par_MDT.AUS.eta_Kegel = 0.98; %Roloff/Matek S.702

end

