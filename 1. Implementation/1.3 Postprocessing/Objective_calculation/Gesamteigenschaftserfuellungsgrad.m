%% Berechnung Gesamteigenschaftserfüllungsgrad: GEEG
% Umbenennung der modifizierten Eigenschaftsdeltas
EDmod_1 = ones(18,1);
EDmod_1(1) = EDmod.LWG_14;                   % Lenkradwinkelgradient zwischen 1 und 4 m/s^2
EDmod_1(2) = EDmod.LWG_67;                   % Lenkradwinkelgradient zwischen 6 und 7 m/s^2
EDmod_1(3) = EDmod.a_y_max;                  % max. Querbeschleunigung
EDmod_1(4) = EDmod.v_char;                   % charakteristische Geschwindigkeit
EDmod_1(5) = EDmod.ratio_psip_lws;           % Bezogene Überschwingweite
EDmod_1(6) = EDmod.T_psip;                   % Response Time
EDmod_1(7) = EDmod.TB;                       % TB-Wert
EDmod_1(8) = EDmod.delta_psip_mu_high(1);   % Änderung Giergeschwindigkeit mu-high bei 20% Gaspedalstellung
EDmod_1(9) = EDmod.delta_psip_mu_high(2);   % Änderung Giergeschwindigkeit mu-high bei 60% Gaspedalstellung
EDmod_1(10) = EDmod.delta_psip_mu_high(3);   % Änderung Giergeschwindigkeit mu-high bei 100% Gaspedalstellung
EDmod_1(11) = EDmod.t_0_100_high;            % Besch.zeit von 0 auf 100 km/h auf mu-high
EDmod_1(12) = EDmod.t_80_120_high;           % Elastizität auf mu-high
EDmod_1(13) = EDmod.vmax;                    % Höchstgeschwindigkeit
EDmod_1(14) = EDmod.t_0_100_low;             % Besch.zeit von 0 auf 100 km/h auf mu-low
EDmod_1(15) = EDmod.t_0_100_split;           % Besch.zeit auf mu-split
EDmod_1(16) = EDmod.delta_psip_mu_low(1);    % Änderung Giergeschwindigkeit mu-low bei 20% Gaspedalstellung
EDmod_1(17) = EDmod.delta_psip_mu_low(2);    % Änderung Giergeschwindigkeit mu-low bei 60% Gaspedalstellung
EDmod_1(18) = EDmod.delta_psip_mu_low(3);    % Änderung Giergeschwindigkeit mu-low bei 100% Gaspedalstellung
EDmod_1(19) = EDmod.a_max_beschl_statKF_auf_mu_low(3);    % Maximale Beschl. bei beschl. aus stat. KF auf mu-low bei 100% Gaspedalstellung


% Vektor mit Gewichtungsfaktoren (Die Reihenfolge der Einträge entspricht
% der Nummernierung der obigen Umbenennung)
% Die Einträge g_1(i) des Vektors g_1 können die Werte 1, 2 oder 3
% annehmen.
g_1(1) = 1/3/3/4;
g_1(2) = 1/3/3/4;
g_1(3) = 1/3/3/4;
g_1(4) = 1/3/3/4;
g_1(5) = 1/3/3/3;
g_1(6) = 1/3/3/3;
g_1(7) = 1/3/3/3;
g_1(8) = 1/3/3/3;
g_1(9) = 1/3/3/3;
g_1(10) = 1/3/3/3;
g_1(11) = 1/3/2;
g_1(12) = 1/3/2;
g_1(13) = 0;
g_1(14) = 1/3/6;
g_1(15) = 1/3/6;
g_1(16) = 1/3/6;
g_1(17) = 1/3/6;
g_1(18) = 1/3/6;
g_1(19) = 1/3/6;

% Vektor mit Potenzfaktoren (Die Reihenfolge der Einträge entspricht
% der Nummernierung der obigen Umbenennung)
q_1(1) = 1;
q_1(2) = 1;
q_1(3) = 1;
q_1(4) = 1;
q_1(5) = 1;
q_1(6) = 1;
q_1(7) = 1;
q_1(8) = 1;
q_1(9) = 1;
q_1(10) = 1;
q_1(11) = 1;
q_1(12) = 1;
q_1(13) = 1;
q_1(14) = 1;
q_1(15) = 1;
q_1(16) = 1;
q_1(17) = 1;
q_1(18) = 1;
q_1(19) = 1;

% Gesamteigenschaftserfüllungsgrad (GEEG) in %
% Der Idealwert des GEEG liegt bei 100%, Werte >100% entsprechen einer
% Übererfüllung, Werte <100% einer Untererfüllung.
G = sum(g_1);
sum_GEEG = 0;
for i = 1:19
    GEEG_step = 0;
    GEEG_step = EDmod_1(i)*(g_1(i)/G);
    sum_GEEG = sum_GEEG+GEEG_step;
end
GEEG = -100*sum_GEEG + 40;

assignin('base', 'GEEG', GEEG);