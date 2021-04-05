%% Berechnung Querdynamikerfüllungsgrad stationär: QDEGS
% Umbenennung der modifizierten Eigenschaftsdeltas
EDmod_2 = ones(4,1);
EDmod_2(1) = EDmod.LWG_14;                   % Lenkrawinkelgradient zwischen 1 und 4 m/s^2
EDmod_2(2) = EDmod.LWG_67;                   % Lenkrawinkelgradient zwischen 6 und 7 m/s^2
EDmod_2(3) = EDmod.a_y_max;                  % max. Querbeschleunigung
EDmod_2(4) = EDmod.v_char;                   % Charakteristische Geschwindigkeit

% Vektor mit Gewichtungsfaktoren (Die Reihenfolge der Einträge entspricht
% der Nummernierung der obigen Umbenennung)
% Die Einträge g_2(i) des Vektors g_2 können die Werte 1, 2 oder 3
% annehmen.
g_2(1) = 1;
g_2(2) = 1;
g_2(3) = 1;
g_2(4) = 1;

% Vektor mit Potenzfaktoren (Die Reihenfolge der Einträge entspricht
% der Nummernierung der obigen Umbenennung)
q_2(1) = 1;
q_2(2) = 1;
q_2(3) = 1;
q_2(4) = 1;
    
% Querdynamikerfüllungsgrad stationär(QDEGS) in %
% Der Idealwert des QDEGS liegt bei 100%, Werte >100% entsprechen einer
% Übererfüllung, Werte <100% einer Untererfüllung.
G = sum(g_2);
sum_QDEGS = 0;
for i = 1:4
    QDEGS_step = 0;
    QDEGS_step = EDmod_2(i)*(g_2(i)/G);
    sum_QDEGS = sum_QDEGS+QDEGS_step;
end
QDEGS = -100*sum_QDEGS + 40;

assignin('base', 'QDEGS', QDEGS);