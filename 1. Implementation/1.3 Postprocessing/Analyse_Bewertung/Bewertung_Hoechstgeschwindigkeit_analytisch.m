%% Bewertung Höchstgeschwindigkeit


pkt_10 = 69.44;                                         % 10 Punkte ab 69.44 m/s (entspricht 250 km/h)
pkt_5 = 38.89;                                          % 5 Punkte ab 38.89 m/s (entspricht 140 km/h)
vmax_SUV = 58.33;                                       % Zielwert (210 km/h) (Referenzwert SUV)

m = (5-10)/(pkt_5-pkt_10);                                  % Steigung
Bewertung.vmax = m*vmax+(10-m*pkt_10);                           % Bewertung auf 10er-Skala


    if(vmax > pkt_10) 
        Bewertung.vmax = 10;                                     % höchstens 10 Punkte
    elseif(vmax < pkt_5) 
        Bewertung.vmax = 5;                                      % mindestens 5 Punkte
    end
% Korrelationsfunktion

if(Optimierung.Modus == 1)
    % Eigenschaftsdelta: ED
    Ziel.vmax = m*vmax_SUV+(10-m*pkt_10);             % Bewertung auf 10er-Skalavmax=55
    
    ED.vmax = Bewertung.vmax - Ziel.vmax;          % Eigenschaftsdelta

    % Modifiziertes Eigenschaftsdelta: EDmod
    s = 1;                                                % Formfaktor
    n = 1;                                                  % Verhältnis Über-/Untererfüllung
    if(ED.vmax <= 0) EDmod.vmax = -(1/5^s)*abs(ED.vmax)^s;
    else EDmod.vmax = (1/5^s)*n*ED.vmax^s;
    end
end

Werte_Bewertung.vmax = vmax;

clear m n s pkt_10 pkt_5 vmax_SUV