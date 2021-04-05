%% Einlesen der zur Auswertung benötigten Werte aus der Simulation
% Beschleunigungszeit von 0 auf 100 km/h auf mu-high:     t_0_100_high
% Beschleunigungszeit von 80 auf 120 km/h auf mu-high:     t_80_120_high
% Beschleunigungszeit von 0 auf 100 km/h auf mu-low:     t_0_100_low
% Beschleunigungszeit von 0 auf 100 km/h auf mu-split:     t_0_100_split
% Lenkwinkelaufwand:                                        delta_h_max

% Index mit der Geschwindigkeit, die einer Geschwindigkeit von 80 km/h am
% nächsten kommt
ind_v_80 = find(abs(sv_FZG_x(:,2)-22.22) == min(abs(sv_FZG_x(:,2)-22.22)));

% Index mit der Geschwindigkeit, die einer Geschwindigkeit von 100 km/h am
% nächsten kommt
ind_v_100 = find(abs(sv_FZG_x(:,2)-27.78) == min(abs(sv_FZG_x(:,2)-27.78)));

% Index mit der Geschwindigkeit, die einer Geschwindigkeit von 120 km/h am
% nächsten kommt
ind_v_120 = find(abs(sv_FZG_x(:,2)-33.33) == min(abs(sv_FZG_x(:,2)-33.33)));

% Endgeschwindigkeit des Fahrzeuges
v_end = sv_FZG_x(end,2);

% Berechnung der Beschleunigungszeit von 0 auf 100 km/h; Beschleunigungsbeginn
% nach 5s
if v_end < 27.78
    t_0_100 = 21;        % falls 100 km/h nicht erreicht werden, erhält das Fahrzeug die Note 5
else
    t_0_100 = sv_time(ind_v_100)-1;
end


% Berechnung der Beschleunigungszeit von 80 auf 120 km/h; 
if v_end < 33.33
    t_80_120 = 12;        % falls 120 km/h nicht erreicht werden, erhält das Fahrzeug die Note 5
else
    t_80_120 = sv_time(ind_v_120)-sv_time(ind_v_80);
end

% Maximaler Lenkradwinkel zur Stabilisierung des Fzgs
delta_h_max = rad2deg(max(abs(sv_FAH_delta_h1(1:ind_v_100))));

if(select_mu_traktion == 1)
%% Bewertung Beschleunigung/Elastizität auf mu-high:
% Bewertung Beschleunigungszeit von 0 auf 100 km/h
pkt_10 = 2.7;                                              % 10 Punkte ab 2,7 s
pkt_5 = 12;                                               % 5 Punkte bis 12 s
Ziel.t_0_100_high = 8;                                     % Bewerteter Zielwert (entspricht der Bewertung "gut")
t_0_100_high = t_0_100;

% Korrelationsfunktion
Bewertung.t_0_100_high=Korrelationsfunktion(pkt_5,pkt_10,'t_0_100 auf mu-high',t_0_100_high);

if(Optimierung.Modus == 1)
    % Eigenschaftsdelta: ED
    ED.t_0_100_high = Bewertung.t_0_100_high - Ziel.t_0_100_high;  % Eigenschaftsdelta

    % Modifiziertes Eigenschaftsdelta: EDmod
    s = 1;                                                % Formfaktor
    n = 1;                                                  % Verhältnis Über-/Untererfüllung
    if(ED.t_0_100_high <= 0) EDmod.t_0_100_high = -(1/5^s)*abs(ED.t_0_100_high)^s;
    else EDmod.t_0_100_high = (1/5^s)*n*ED.t_0_100_high^s;
    end
end

Werte_Bewertung.t_0_100_high = t_0_100_high;

% Bewertung Beschleunigungszeit von 80 auf 120 km/h
pkt_10 = 2.1;                                              % 10 Punkte ab 2,1 s
pkt_5 = 11.5;                                               % 5 Punkte bis 11,5 s
Ziel.t_80_120_high = 8;                                     % Bewerteter Zielwert (entspricht der Bewertung "gut")
t_80_120_high = t_80_120;

% Korrelationsfunktion
Bewertung.t_80_120_high=Korrelationsfunktion(pkt_5,pkt_10,'Elastizität auf mu-high',t_80_120_high);

if(Optimierung.Modus == 1)
    % Eigenschaftsdelta: ED
    ED.t_80_120_high = Bewertung.t_80_120_high - Ziel.t_80_120_high;  % Eigenschaftsdelta

    % Modifiziertes Eigenschaftsdelta: EDmod
    s = 1;                                                % Formfaktor
    n = 1;                                                  % Verhältnis Über-/Untererfüllung
    if(ED.t_80_120_high <= 0) EDmod.t_80_120_high = -(1/5^s)*abs(ED.t_80_120_high)^s;
    else EDmod.t_80_120_high = (1/5^s)*n*ED.t_80_120_high^s;
    end
end

Werte_Bewertung.t_80_120_high = t_80_120_high;

%% Bewertung Höchstgeschwindigkeit

vmax = sv_FZG_x(end,2);

%% Bewertung

pkt_10 = 69.44;                                         % 10 Punkte ab 69.44 m/s (entspricht 250 km/h)
pkt_5 = 38.89;                                          % 5 Punkte ab 38.89 m/s (entspricht 140 km/h)
% vmax_SUV = 58.33;                                       % Zielwert (210 km/h) (Referenzwert SUV)
Ziel.vmax = 8;
% Korrelationsfunktion
Bewertung.vmax=Korrelationsfunktion(pkt_5,pkt_10,'Hoechstgeschwindigkeit',vmax);

if(Optimierung.Modus == 1)
    % Eigenschaftsdelta: ED
%     Ziel.vmax = m*vmax_SUV+(10-m*pkt_10);             % Bewertung auf 10er-Skala
    ED.vmax = Bewertung.vmax - Ziel.vmax;          % Eigenschaftsdelta

    % Modifiziertes Eigenschaftsdelta: EDmod
    s = 1;                                                % Formfaktor
    n = 1;                                                  % Verhältnis Über-/Untererfüllung
    if(ED.vmax <= 0) EDmod.vmax = -(1/5^s)*abs(ED.vmax)^s;
    else EDmod.vmax = (1/5^s)*n*ED.vmax^s;
    end
end

Werte_Bewertung.vmax = vmax;

elseif(select_mu_traktion == 2)
%% Bewertung Traktion auf mu-low:
% Bewertung
pkt_10 = 11.3;                                              % 10 Punkte ab 11.3 s
pkt_5 = 20.7;                                               % 5 Punkte bis 20.7 s
Ziel.t_0_100_low = 8;                                      % Bewerteter Zielwert (entspricht der Bewertung "gut")
t_0_100_low = t_0_100;

% Korrelationsfunktion
Bewertung.t_0_100_low=Korrelationsfunktion(pkt_5,pkt_10,'t_0_100 auf mu-low',t_0_100_low);

if(Optimierung.Modus == 1)
    % Eigenschaftsdelta: ED
    ED.t_0_100_low = Bewertung.t_0_100_low -Ziel.t_0_100_low;     % Eigenschaftsdelta

    % Modifiziertes Eigenschaftsdelta: EDmod
    s = 1;                                                % Formfaktor
    n = 1;                                                  % Verhältnis Über-/Untererfüllung
    if(ED.t_0_100_low <= 0) EDmod.t_0_100_low = -(1/5^s)*abs(ED.t_0_100_low)^s;
    else EDmod.t_0_100_low = (1/5^s)*n*ED.t_0_100_low^s;
    end
end

Werte_Bewertung.t_0_100_low = t_0_100_low;

elseif( select_mu_traktion == 3)
%% Bewertung Beschleunigung auf mu-split:
% Bewertung
pkt_10 = 9.3;                                                  % 10 Punkte ab 11,3 s
pkt_5 = 20.7;                                                   % 5 Punkte bis 20,7 s
Ziel.t_0_100_split = 8;                                        % Bewerteter Zielwert (entspricht der Bewertung "gut")
t_0_100_split = t_0_100;

% Korrelationsfunktion
Bewertung.t_0_100_split=Korrelationsfunktion(pkt_5,pkt_10,'t_0_100 auf mu-split',t_0_100_split);

if(Optimierung.Modus == 1)
    % Eigenschaftsdelta: ED
    ED.t_0_100_split = Bewertung.t_0_100_split - Ziel.t_0_100_split;   % Eigenschaftsdelta

    % Modifiziertes Eigenschaftsdelta: EDmod
    s = 1;                                                % Formfaktor
    n = 1;                                                  % Verhältnis Über-/Untererfüllung
    if(ED.t_0_100_split <= 0) EDmod.t_0_100_split = -(1/5^s)*abs(ED.t_0_100_split)^s;
    else EDmod.t_0_100_split = (1/5^s)*n*ED.t_0_100_split^s;
    end
end

Werte_Bewertung.t_0_100_split = t_0_100_split;

%% Bewertung Spurabweichung: Lenkaufwand
% Bewertung
if Optimierung.Modus~=1
    pkt_10 = 0.0;                                           % 10 Punkte bis 0,0°
    pkt_5 = 10;                                            % 5 Punkte ab 10°

    % Korrelationsfunktion
    Bewertung.delta_h_max=Korrelationsfunktion(pkt_5,pkt_10,'Lenkaufwand',delta_h_max);

    Werte_Bewertung.delta_h_max = delta_h_max;
end
end



clear ind_v_80 ind_v_100 ind_v_120 v_end pkt_10 pkt_5 ...
    Ziel t_0_100_high  t_80_120_high vmax t_0_100_low m ...
    t_0_100_split delta_h_max t_0_100 t_80_120 s n select_delta_h select_mu_traktion