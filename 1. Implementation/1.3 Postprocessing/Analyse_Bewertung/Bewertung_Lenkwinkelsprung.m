%% Einlesen der zur Auswertung benötigten Werte aus der Simulation
% Stationärer Lenkradwinkel:        delta_h_stat
% Stationäre Giergeschwindigkeit:   psip_stat_lws
% Maximale Giergeschwindigkeit:     psip_max_lws
% Response Time:               T_psip_max
% Stationärer Schwimmwinkel:        beta_stat

%Stationäre Giergeschwindigkeit
psip_stat_lws = rad2deg(sv_FZG_psi(end,2));

%Index für die Zeit = 4.5 s
ind_psi_peak = find(sv_time(:)==4.5);

%Index für die Response-Time (psip = 0.9*psip_stat_lws)
ind_90_psip_stat = find(sv_FZG_psi(:,2)>0.9*pi/180*psip_stat_lws,1,'first');

%Response Time
T_psip = sv_time(ind_90_psip_stat)- sv_time(find((sv_FAH_delta_h1-sv_FAH_delta_h1(end)/2)>0,1,'first'));

% Index des ersten Peaks der Giergeschwindigkeit
ind_psip_max = find(sv_FZG_psi(1:ind_psi_peak,2) == max(sv_FZG_psi(1:ind_psi_peak,2)));

% Maximale Giergeschwindigkeit
psip_max_lws = rad2deg(sv_FZG_psi(ind_psip_max,2));

% Peak-Response Time
T_psip_max = sv_time(ind_psip_max)- sv_time(find((sv_FAH_delta_h1-sv_FAH_delta_h1(end)/2)>0,1,'first'));

% Stationärer Schwimmwinkel
beta_stat = abs(rad2deg(sv_FZG_beta(end,1)));



%% Bewertung bezogene Überschwingweite:
% Bewertung
pkt_10 = 0;                                                   % 10 Punkte bis 0%
pkt_5 = 27;                                                   % 5 Punkte ab 27%
Ziel.ratio_psip_lws = 8;                                      % Zielwert (Referenzwert SUV)

% Berechnung bezogene Überschwingweite
ratio_psip_lws = abs(100*((psip_max_lws/psip_stat_lws)-1));

% Korrelationsfunktion
Bewertung.ratio_psip_lws=Korrelationsfunktion(pkt_5,pkt_10,'bezogene Überschwingweite',ratio_psip_lws);

if(Optimierung.Modus == 1)
    % Eigenschaftsdelta: ED
    %Ziel.ratio_psip_lws = m*ratio_psip_lws_SUV+(10-m*pkt_10);       % Bewertung auf 10er-Skala
    ED.ratio_psip_lws = Bewertung.ratio_psip_lws - Ziel.ratio_psip_lws;   % Eigenschaftsdelta

    % Modifiziertes Eigenschaftsdelta: EDmod
    s = 1;                                                       % Formfaktor
    n = 1;                                                         % Verhältnis Über-/Untererfüllung
    if(ED.ratio_psip_lws <= 0) EDmod.ratio_psip_lws = -(1/5^s)*abs(ED.ratio_psip_lws)^s;
    else EDmod.ratio_psip_lws = (1/5^s)*n*ED.ratio_psip_lws^s;
    end
end


%% Bewertung Response Time:
% Bewertung
pkt_10 = 0.1;                                          % 10 Punkte bis 0,1s
pkt_5 = 0.3;                                           % 5 Punkte ab 0,3s
Ziel.T_psip = 8;                                  % Zielwert (Referenzwert SUV)

% Korrelationsfunktion
Bewertung.T_psip=Korrelationsfunktion(pkt_5,pkt_10,'Response Time',T_psip);

if(Optimierung.Modus == 1)
    % Eigenschaftsdelta: ED
    %Ziel.T_psip_max = m*T_psip_max_SUV+(10-m*pkt_10);       % Bewertung auf 10er-Skala
    ED.T_psip = Bewertung.T_psip - Ziel.T_psip; % Eigenschaftsdelta

    % Modifiziertes Eigenschaftsdelta: EDmod
    s = 1;                                                % Formfaktor
    n = 1;                                                  % Verhältnis Über-/Untererfüllung
    if(ED.T_psip <= 0) EDmod.T_psip = -(1/5^s)*abs(ED.T_psip)^s;
    else EDmod.T_psip = (1/5^s)*n*ED.T_psip.^s;
    end
end



%% Bewertung TB-Wert:
% Bewertung
pkt_10 = 0.08;                                          % 10 Punkte bis 0,08
pkt_5 = 0.81;                                           % 5 Punkte ab 0,81
Ziel.TB = 8;                                          % Zielwert (Referenzwert SUV)

% Berechnung TB-Wert
TB = T_psip_max*beta_stat;

% Korrelationsfunktion
Bewertung.TB=Korrelationsfunktion(pkt_5,pkt_10,'TB-Wert',TB);

if(Optimierung.Modus == 1)
    % Eigenschaftsdelta: ED
    %Ziel.TB = m*TB_SUV+(10-m*pkt_10);                       % Bewertung auf 10er-Skala
    ED.TB = Bewertung.TB - Ziel.TB;                         % Eigenschaftsdelta

    % Modifiziertes Eigenschaftsdelta: EDmod
    s = 1;                                                % Formfaktor
    n = 1;                                                  % Verhältnis Über-/Untererfüllung
    if(ED.TB <= 0) EDmod.TB = -(1/5^s)*abs(ED.TB)^s;
    else EDmod.TB = (1/5^s)*n*ED.TB.^s;
    end
end

Werte_Bewertung.ratio_psip_lws = ratio_psip_lws;
Werte_Bewertung.T_psip = T_psip;
Werte_Bewertung.TB = TB;

clear ind_psi_peak ind_90_psip_stat T_psip ind_psip_max psip_max_lws ...
    psip_stat_lws T_psip_max beta_stat pkt_10 pkt_5 ...
    ratio_psip_lws Ziel s n delta_LWS v_beschl TB