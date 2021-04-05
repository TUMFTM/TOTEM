%% Berechnung Laengs_querdynamikerfüllungsgrad: LQDEG
% Umbenennung der modifizierten Eigenschaftsdeltas
EDmod_4 = ones(3,1);
EDmod_4(1) = EDmod.delta_psip_mu_high(1);   % Änderung Giergeschwindigkeit mu-high bei 20% Gaspedalstellung
EDmod_4(2) = EDmod.delta_psip_mu_high(2);   % Änderung Giergeschwindigkeit mu-high bei 60% Gaspedalstellung
EDmod_4(3) = EDmod.delta_psip_mu_high(3);   % Änderung Giergeschwindigkeit mu-high bei 100% Gaspedalstellung

% Vektor mit Gewichtungsfaktoren (Die Reihenfolge der Einträge entspricht
% der Nummernierung der obigen Umbenennung)
% Die Einträge g_4(i) des Vektors g_4 können die Werte 1, 2 oder 3
% annehmen.
g_4(1) = 1;
g_4(2) = 1;
g_4(3) = 1;

% Vektor mit Potenzfaktoren (Die Reihenfolge der Einträge entspricht
% der Nummernierung der obigen Umbenennung)
q_4(1) = 1;
q_4(2) = 1;
q_4(3) = 1;

% Gesamteigenschaftserfüllungsgrad (GEEG) in %
% Der Idealwert des GEEG liegt bei 100%, Werte >100% entsprechen einer
% Übererfüllung, Werte <100% einer Untererfüllung.
G = sum(g_4);
sum_LQDEG = 0;
for i = 1:3
    LQDEG_step = 0;
    LQDEG_step = EDmod_4(i)*(g_4(i)/G);
    sum_LQDEG = sum_LQDEG+LQDEG_step;
end
LQDEG = -100*sum_LQDEG + 40;

assignin('base', 'LQDEG', LQDEG);