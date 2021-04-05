%% Berechnung Längsdynamikerfüllungsgrad: LDEG
% Umbenennung der modifizierten Eigenschaftsdeltas
EDmod_5 = ones(3,1);
EDmod_5(1) = EDmod.t_0_100_high;        % Beschl.zeit mu-high
EDmod_5(2) = EDmod.t_80_120_high;       % Elastizität mu-high
EDmod_5(3) = EDmod.vmax;                % Maximale Geschwindigkeit

% Vektor mit Gewichtungsfaktoren (Die Reihenfolge der Einträge entspricht
% der Nummernierung der obigen Umbenennung)
% Die Einträge g_5(i) des Vektors g_5 können die Werte 1, 2 oder 3
% annehmen.
g_5(1) = 1;
g_5(2) = 1;
g_5(3) = 1;

% Vektor mit Potenzfaktoren (Die Reihenfolge der Einträge entspricht
% der Nummernierung der obigen Umbenennung)
q_5(1) = 1;
q_5(2) = 1;
q_5(3) = 1;

% Längsdynamikerfüllungsgrad (LDEG) in %
% Der Idealwert des LDEG liegt bei 100%, Werte >100% entsprechen einer
% Übererfüllung, Werte <100% einer Untererfüllung.
G = sum(g_5);
sum_LDEG = 0;
for i = 1:3
    LDEG_step = 0;
    LDEG_step = EDmod_5(i)*(g_5(i)/G);
    sum_LDEG = sum_LDEG+LDEG_step;
end
LDEG = -100*sum_LDEG+40;

assignin('base', 'LDEG', LDEG);