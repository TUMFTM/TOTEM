function [K_gesamt, K_Material, K_Anbauteile, K_Fertigung]=Kostenrechnung_Getriebe(az, OD, TV, TS, n_Gaenge, i_Gaenge, m_GH, m_Zahnraeder_Wellen, m_Korb,m_torque_cost, m_eTV, Stkzahl, Standort)
 


%% Materialkostenrechnung
K_Material=         Materialkostenrechnung_GT(az, OD, TV, TS, m_GH, m_Zahnraeder_Wellen, m_Korb, m_torque_cost, m_eTV, Stkzahl); %An dieser Stelle werden den den dimensionierten Komponenten Materialkosten zugeordnet.

%% Anbauteilkostenrechnung
K_Anbauteile=       Anbauteilkosten_GT(az, OD, TV, TS, n_Gaenge, i_Gaenge, Stkzahl);             %Berechnung der Anbauteilkosten

%% Fertigungskostenrechnung
K_Fertigung=        Fertigungskosten_GT(Standort, n_Gaenge, i_Gaenge, TV, OD, TS, Stkzahl);            %Stückzahabhängige Berechnung der Fertigungskosten

%% Gesamtkosten
K_gesamt=           Gesamtkosten_Getriebe(K_Material, K_Anbauteile, K_Fertigung, Stkzahl);

