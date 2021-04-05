%% Einlesen der zur Auswertung benötigten Werte aus der Simulation
% Änderung der Giergeschwindigkeit nach einer Sekunde:   delta_psip




if(select_mu_BKF == 1)
%% Bewertung Änderung Giergeschwindigkeit auf mu-high:
% Berechnung des optimalen Wertes:
% Optimaler Wert: Änderung der Giergeschwindigkeit nach einer Sekunde ohne
% Aus- oder Eindrehen des Fahrzeuges
% delta_psip_opt:           Optimaler Wert in °/s
% delta_v_1s:               Geschwindigkeitsänderung nach einer Sekunde in m/s
% r:                        Radius in m
r = 60;         % konstant für Optimalverhalten

for i=1:length(delta_v_high)
    
    delta_psip_opt = rad2deg(delta_v_high(i)/3.6/r);

    % Bewertung
    pkt_10 = 1.1*delta_psip_opt;                                % 10 Punkte bei delta_psi_opt
    pkt_5 = 0;                                              % 5 Punkte bei 0°/s
    Ziel.delta_psip = 8;                                    % Bewerteter Zielwert (entspricht der Bewertung "gut")

    % Korrelationsfunktion
    Bewertung.delta_psip_mu_high(i)=Korrelationsfunktion(pkt_5,pkt_10,'Änderung Giergeschwindigkeit mu-high',delta_psip_high(i));

    if(Optimierung.Modus == 1)
        % Eigenschaftsdelta: ED
        ED.delta_psip_mu_high(i) = Bewertung.delta_psip_mu_high(i) - Ziel.delta_psip;          % Eigenschaftsdelta

        % Modifiziertes Eigenschaftsdelta: EDmod
        s = 1;                                              % Formfaktor
        n = 1;                                                % Verhältnis Über-/Untererfüllung
        if(ED.delta_psip_mu_high(i) <= 0) EDmod.delta_psip_mu_high(i) = -(1/5^s)*abs(ED.delta_psip_mu_high(i))^s;
        else EDmod.delta_psip_mu_high(i) = (1/5^s)*n*ED.delta_psip_mu_high(i)^s;
        end
    end

    Werte_Bewertung.delta_psip_mu_high(i) = delta_psip_high(i);
end
    
elseif(select_mu_BKF == 2)
%% Bewertung Änderung Giergeschwindigkeit auf mu-low:
% Berechnung des optimalen Wertes:
% Optimaler Wert: Änderung der Giergeschwindigkeit nach einer Sekunde ohne
% Aus- oder Eindrehen des Fahrzeuges
% delta_psip_opt:           Optimaler Wert in °/s
% delta_v_1s:               Geschwindigkeitsänderung nach einer Sekunde in m/s
% r:                        Radius in m

r = 60;         % konstant für Optimalverhalten

for i=1:length(delta_v_low)
    
    delta_psip_opt = rad2deg(delta_v_low(i)/3.6/r);

    % Bewertung
    pkt_10 = 1.1*delta_psip_opt;                                % 10 Punkte bei delta_psi_opt
    pkt_5 = 0;                                              % 5 Punkte bei 0°/s
    Ziel.delta_psip = 8;                                    % Bewerteter Zielwert (entspricht der Bewertung "gut")

    % Korrelationsfunktion
    Bewertung.delta_psip_mu_low(i)=Korrelationsfunktion(pkt_5,pkt_10,'Änderung Giergeschwindigkeit mu-low',delta_psip_low(i));

    if(Optimierung.Modus == 1)
        % Eigenschaftsdelta: ED
        ED.delta_psip_mu_low(i) = Bewertung.delta_psip_mu_low(i) - Ziel.delta_psip;          % Eigenschaftsdelta

        % Modifiziertes Eigenschaftsdelta: EDmod
        s = 1;                                                % Formfaktor
        n = 1;                                                  % Verhältnis Über-/Untererfüllung
        if(ED.delta_psip_mu_low(i) <= 0) EDmod.delta_psip_mu_low(i) = -(1/5^s)*abs(ED.delta_psip_mu_low(i))^s;
        else EDmod.delta_psip_mu_low(i) = (1/5^s)*n*ED.delta_psip_mu_low(i)^s;
        end
    end

    Werte_Bewertung.delta_psip_mu_low(i) = delta_psip_low(i);
end

%% Bewertung der maximalen Beschleunigung auf mu-low:
% Berechnung des optimalen Wertes:
% Optimaler Wert:       2 m/s^2
% schlechtester Wert:   0.25 m/s^2
    pkt_5=0.25;
    pkt_10=2;
    Ziel.a_max_beschl_statKF_auf_mu_low=8;
    
for i=1:length(delta_v_low)

    a_x(i)=delta_v_low(i)/3.6;

    Bewertung.a_max_beschl_statKF_auf_mu_low(i)  = Korrelationsfunktion(pkt_5,pkt_10,'a_max_beschl_statKF_auf_mu_low',a_x(i));
    Werte_Bewertung.a_x(i)                    = a_x(i);
    
    % ED-Berechnung
    if(Optimierung.Modus == 1)
        % Eigenschaftsdelta: ED
        ED.a_max_beschl_statKF_auf_mu_low(i) = Bewertung.a_max_beschl_statKF_auf_mu_low(i) - Ziel.a_max_beschl_statKF_auf_mu_low;          % Eigenschaftsdelta

        % Modifiziertes Eigenschaftsdelta: EDmod
        s = 1;                                                % Formfaktor
        n = 1;                                                  % Verhältnis Über-/Untererfüllung
        if(ED.a_max_beschl_statKF_auf_mu_low(i) <= 0) 
            EDmod.a_max_beschl_statKF_auf_mu_low(i) = -(1/5^s)*abs(ED.a_max_beschl_statKF_auf_mu_low(i))^s;
        else
            EDmod.a_max_beschl_statKF_auf_mu_low(i) = (1/5^s)*n*ED.a_max_beschl_statKF_auf_mu_low(i)^s;
        end
    end

end

end


%% 
clear r delta_psip_opt ...
    pkt_10 pkt_5 Ziel s n select_mu_BKF delta_pisp_high delta_psip_low a_max Radius Beschleunigung deltah_beschl v_beschl