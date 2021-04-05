%% Berechnung Offroaderfüllungsgrad: OREG
% Umbenennung der modifizierten Eigenschaftsdeltas
EDmod_6 = ones(6,1);
EDmod_6(1) = EDmod.t_0_100_low;             % Besch.zeit mu-low
EDmod_6(2) = EDmod.t_0_100_split;           % Besch.zeit mu-split
EDmod_6(3) = EDmod.delta_psip_mu_low(1);    % Änderung Giergeschwindigkeit mu-low bei 20% Gaspedalstellung
EDmod_6(4) = EDmod.delta_psip_mu_low(2);    % Änderung Giergeschwindigkeit mu-low bei 60% Gaspedalstellung
EDmod_6(5) = EDmod.delta_psip_mu_low(3);    % Änderung Giergeschwindigkeit mu-low bei 100% Gaspedalstellung
EDmod_6(6) = EDmod.a_max_beschl_statKF_auf_mu_low(3);    % Maximale Beschl. bei beschl. aus stat. KF auf mu-low bei 100% Gaspedalstellung


% Vektor mit Gewichtungsfaktoren (Die Reihenfolge der Einträge entspricht
% der Nummernierung der obigen Umbenennung)
% Die Einträge g_6(i) des Vektors g_6 können die Werte 1, 2 oder 3
% annehmen.
g_6(1) = 1;
g_6(2) = 1;
g_6(3) = 1;
g_6(4) = 1;
g_6(5) = 1;
g_6(6) = 1;

% Vektor mit Potenzfaktoren (Die Reihenfolge der Einträge entspricht
% der Nummerierung der obigen Umbenennung)
q_6(1) = 1;
q_6(2) = 1;
q_6(3) = 1;
q_6(4) = 1;
q_6(5) = 1;
q_6(6) = 1;

% Offroaderfüllungsgrad (OREG) in %
% Der Idealwert des OREG liegt bei 100%, Werte >100% entsprechen einer
% Übererfüllung, Werte <100% einer Untererfüllung.
G = sum(g_6);
sum_OREG = 0;
for i = 1:6
    OREG_step = 0;
    OREG_step = EDmod_6(i)*(g_6(i)/G);
    sum_OREG = sum_OREG+OREG_step;
end
OREG = -100*sum_OREG + 40;

assignin('base', 'OREG', OREG);