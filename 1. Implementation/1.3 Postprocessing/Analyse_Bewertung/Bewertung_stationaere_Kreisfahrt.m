%% Einlesen der zur Auswertung benötigten Werte aus der Simulation
% Maximale Querbeschleunigung
% Charakteristische Geschwindigkeit

% Finde Index, bei dem a_y = 1 m/s^2
ind_1 = find(abs(sv_FZG_y(:,3)-1) == min(abs(sv_FZG_y(:,3)-1)));

% Finde Index, bei dem a_y = 4 m/s^2
ind_4 = find(abs(sv_FZG_y(:,3)-4) == min(abs(sv_FZG_y(:,3)-4)));

% Finde Index, bei dem a_y = 6 m/s^2
ind_6 = find(abs(sv_FZG_y(:,3)-6) == min(abs(sv_FZG_y(:,3)-6)));

% Finde Index, bei dem a_y = 7 m/s^2
ind_7 = find(abs(sv_FZG_y(:,3)-7) == min(abs(sv_FZG_y(:,3)-7)));

%Berechnung des Lenkradwinkelgradienten zwischen 1 und 4 m/s^2
LWG_14 = sum(diff(rad2deg(sv_FAH_delta_h1(ind_1:ind_4)))./diff(sv_FZG_y(ind_1:ind_4,3)))/numel(diff(rad2deg(sv_FAH_delta_h1(ind_1:ind_4))));

%Berechnung des Lenkradwinkelgradienten zwischen 6 und 7 m/s^2
LWG_67 = sum(diff(rad2deg(sv_FAH_delta_h1(ind_6:ind_7)))./diff(sv_FZG_y(ind_6:ind_7,3)))/numel(diff(rad2deg(sv_FAH_delta_h1(ind_6:ind_7))));

ind_a_max = size(sv_time,1);
for  i = ind_6 : size(sv_time,1)-1
    Grad_deltah = diff(rad2deg(sv_FAH_delta_h1(i:i+1)))./diff(sv_FZG_y(i:i+1,3));
    if Grad_deltah < 0
        ind_a_max = i;
        break
    end
end
       
%Auswertung des Eigenlenkverhaltens
V_psip = sv_FZG_psi(300:ind_a_max,2)./sv_FAH_delta_h1(300:ind_a_max);
V_psip_neutral = sv_FZG_x(300:ind_a_max,2)/(par_VEH.l*par_VEH.isteer_skalar);
V_psip_diff = V_psip_neutral - V_psip;
uebersteuern = 0;
for i = ind_6:length(V_psip_diff)
    if V_psip_diff(i) < 0
        uebersteuern = 1;
        break
    end
end

%Berechnung der maximalen Querbeschleunigung
a_y_max = sv_FZG_y(ind_a_max,3);

%Berechnung der charakteristischen Geschwindigkeit 
ind_max = find(V_psip == max(V_psip));
v_char = 3.6*sv_FZG_x(ind_max,2);


%% Bewertung Lenkradwinkelgradient zwischen 1 und 4 m/s^2:
% Bewertung
pkt_10 = 0.5;                                          % 10 Punkte bis 0,5
pkt_5 = 6;                                           % 5 Punkte ab 6
Ziel.LWG_14 = 8;                                     % Zielwert (Referenzwert SUV)

if uebersteuern == 0
    % Korrelationsfunktion
    Bewertung.LWG_14=Korrelationsfunktion(pkt_5,pkt_10,'LWG_14',LWG_14);
else
    Bewertung.LWG_14 = 5;
end

if(Optimierung.Modus == 1)
    % Eigenschaftsdelta: ED
    ED.LWG_14 = Bewertung.LWG_14 - Ziel.LWG_14;          % Eigenschaftsdelta

    % Modifiziertes Eigenschaftsdelta: EDmod
    s = 1;                                                % Formfaktor
    n = 1;                                                  % Verhältnis Über-/Untererfüllung
    if(ED.LWG_14 <= 0) EDmod.LWG_14 = -(1/5^s)*abs(ED.LWG_14)^s;
    else EDmod.LWG_14 = (1/5^s)*n*ED.LWG_14^s;
    end
end


%% Bewertung Lenkradwinkelgradient zwischen 6 und 7 m/s^2:
% Bewertung
pkt_10 = 1;                                          % 10 Punkte bis 1
pkt_5 = 13;                                           % 5 Punkte ab 13
Ziel.LWG_67 = 8;                                     % Zielwert (Referenzwert SUV)

if uebersteuern == 0
    % Korrelationsfunktion
    Bewertung.LWG_67=Korrelationsfunktion(pkt_5,pkt_10,'LWG_67',LWG_67);
else
    Bewertung.LWG_67 = 5;
end

if(Optimierung.Modus == 1)
    % Eigenschaftsdelta: ED
    ED.LWG_67 = Bewertung.LWG_67 - Ziel.LWG_67;          % Eigenschaftsdelta

    % Modifiziertes Eigenschaftsdelta: EDmod
    s = 1;                                                % Formfaktor
    n = 1;                                                  % Verhältnis Über-/Untererfüllung
    if(ED.LWG_67 <= 0) EDmod.LWG_67 = -(1/5^s)*abs(ED.LWG_67)^s;
    else EDmod.LWG_67 = (1/5^s)*n*ED.LWG_67^s;
    end
end


%% Bewertung maximaler Querbeschleunigung:
% Bewertung
pkt_10 = 10;                                          % 10 Punkte bis 10
pkt_5 = 7.5;                                           % 5 Punkte ab 7.5
Ziel.a_y_max = 8;                                     % Zielwert (Referenzwert SUV)

if uebersteuern == 0
    % Korrelationsfunktion
    Bewertung.a_y_max=Korrelationsfunktion(pkt_5,pkt_10,'a_y_max',a_y_max);
else
    Bewertung.a_y_max = 5;
end

if(Optimierung.Modus == 1)
    % Eigenschaftsdelta: ED
    ED.a_y_max = Bewertung.a_y_max - Ziel.a_y_max;          % Eigenschaftsdelta

    % Modifiziertes Eigenschaftsdelta: EDmod
    s = 1;                                                % Formfaktor
    n = 1;                                                  % Verhältnis Über-/Untererfüllung
    if(ED.a_y_max <= 0) EDmod.a_y_max = -(1/5^s)*abs(ED.a_y_max)^s;
    else EDmod.a_y_max = (1/5^s)*n*ED.a_y_max^s;
    end
end


%% Bewertung charakteristischer Geschwindigkeit:
% Bewertung
pkt_10 = 100;                                          % 10 Punkte bis 100
pkt_5 = 65;                                           % 5 Punkte ab 65
Ziel.v_char = 8;                                     % Zielwert (Referenzwert SUV)

if uebersteuern == 0
% Korrelationsfunktion
    Bewertung.v_char=Korrelationsfunktion(pkt_5,pkt_10,'v_char',v_char);
else
    Bewertung.v_char = 5;
end

if(Optimierung.Modus == 1)
    % Eigenschaftsdelta: ED
    ED.v_char = Bewertung.v_char - Ziel.v_char;          % Eigenschaftsdelta

    % Modifiziertes Eigenschaftsdelta: EDmod
    s = 1;                                                % Formfaktor
    n = 1;                                                  % Verhältnis Über-/Untererfüllung
    if(ED.v_char <= 0) EDmod.v_char = -(1/5^s)*abs(ED.v_char)^s;
    else EDmod.v_char = (1/5^s)*n*ED.v_char^s;
    end
end

Werte_Bewertung.LWG_14 = LWG_14;
Werte_Bewertung.LWG_67 = LWG_67;
Werte_Bewertung.a_y_max = a_y_max;
Werte_Bewertung.v_char = v_char;


clear ind_1 ind_4 ind_6 ind_7 ind_a_max ind_max LWG_14 LWG_67 pkt_10 pkt_5 v_char a_y_max...
    Ziel s n V_psip V_psip_neutral V_psip_diff uebersteuern Grad_deltah