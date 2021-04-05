%% Berechnung Querdynamikerfüllungsgrad instationär: QDEGI
% Umbenennung der modifizierten Eigenschaftsdeltas
EDmod_3 = ones(3,1);
EDmod_3(1) = EDmod.ratio_psip_lws;           % Bezogene Überschwingweite der Gierrate
EDmod_3(2) = EDmod.T_psip;                   % Response Time
EDmod_3(3) = EDmod.TB;                       % TB-Wert

% Vektor mit Gewichtungsfaktoren (Die Reihenfolge der Einträge entspricht
% der Nummernierung der obigen Umbenennung)
% Die Einträge g_3(i) des Vektors g_3 können die Werte 1, 2 oder 3
% annehmen.
g_3(1) = 1;
g_3(2) = 1;
g_3(3) = 1;

% Vektor mit Potenzfaktoren (Die Reihenfolge der Einträge entspricht
% der Nummernierung der obigen Umbenennung)
q_3(1) = 1;
q_3(2) = 1;
q_3(3) = 1;
    
% Querdynamikerfüllungsgrad stationär(QDEGS) in %
% Der Idealwert des QDEGS liegt bei 100%, Werte >100% entsprechen einer
% Übererfüllung, Werte <100% einer Untererfüllung.
G = sum(g_3);
sum_QDEGI = 0;
for i = 1:3
    QDEGI_step = 0;
    QDEGI_step = EDmod_3(i)*(g_3(i)/G);
    sum_QDEGI = sum_QDEGI+QDEGI_step;
end
QDEGI = -100*sum_QDEGI + 40;

assignin('base', 'QDEGSI', QDEGI);