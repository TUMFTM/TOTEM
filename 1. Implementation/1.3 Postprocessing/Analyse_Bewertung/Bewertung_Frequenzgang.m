%% Zur Auswertung benötigte Werte aus der Simulation
% Phasenwinkel der Giergeschwindigkeit bei f = 1 Hz:    Phase
% Maximaler Schwimmwinkel:                              beta_max_fg
% Stationärer Schwimmwinkel:                            beta_stat_fg

%% Suche peaks und deren Koordinaten von Lenkradwinkel
%Frequenzverlauf logarithmisch
%input_freq = [zeros(3/savestep, 1); 0.2*ones(10/savestep,1); logspace(-0.69897,0.30102999,length(sv_FAH_delta_h1)-13/savestep)'];
%Frequenzverlauf linear
input_freq = [zeros(3/savestep, 1); 0.2*ones(10/savestep,1); linspace(0.2,2,length(sv_FAH_delta_h1)-13/savestep)'];

[p_delta,l_delta] = findpeaks(abs(sv_FAH_delta_h1(3.5/savestep:end))); 
[p_psi,l_psi] = findpeaks(abs(sv_FZG_psi(3.5/savestep:end,2)));

p_delta = p_delta(1:min(length(p_psi), length(p_delta)));
l_delta = l_delta(1:min(length(l_psi), length(l_delta)));

p_psi = p_psi(1:min(length(p_psi), length(p_delta)));
l_psi = l_psi(1:min(length(l_psi), length(l_delta)));

peaks(:,1) = p_delta;
peaks(:,2) = p_psi;
peaks(:,3) = p_psi./p_delta;
peaks(:,4) = input_freq(l_delta+3.5/savestep);

phase(:,1) = l_delta;
phase(:,2) = l_psi;
phase(:,3) = ((l_delta - l_psi)*savestep).*input_freq(l_delta+3.5/savestep)*360;
phase(:,4) = input_freq(l_delta+3.5/savestep);


% Phase: Phasenwinkel der Giergeschwindigkeit bei f = 1 Hz
ind_frequenz_1 = abs(phase(:,4)-1) == min(abs(phase(:,4)-1));
Phase = phase(ind_frequenz_1,3);


%% Auslesen des maximalen Schwimmwinkels
beta_max_fg = max(abs(sv_FZG_beta(:,1)));


%% Bewertung Verhältnis Schwimmwinkel:
% Bewertung
pkt_10 = 0;                                          % 10 Punkte ab 0%
pkt_5 = 20;                                           % 5 Punkte bis 20%
Ziel.ratio_beta_fg = 8;                                     % Zielwert (Referenzwert SUV)

%Berechnung Verhältnis Schwimmwinkel
ratio_beta_fg = (beta_max_fg-beta_stat_fg)/beta_stat_fg*100;

% Korrelationsfunktion
Bewertung.ratio_beta_fg=Korrelationsfunktion(pkt_5,pkt_10,'Verhältnis Schwimmwinkel',ratio_beta_fg);

if(Optimierung.Modus == 1)
    % Eigenschaftsdelta: ED
    %Ziel.freq_45 = m*freq_45_SUV+(5-m*pkt_5);               % Bewertung Ziel-Wert auf 10er-Skala
    ED.ratio_beta_fg = Ziel.ratio_beta_fg - Bewertung.ratio_beta_fg;          % Eigenschaftsdelta

    % Modifiziertes Eigenschaftsdelta: EDmod
    s = 1;                                                % Formfaktor
    n = 1;                                                  % Verhältnis Über-/Untererfüllung
    if(ED.ratio_beta_fg <= 0) EDmod.ratio_beta_fg = -(1/5^s)*abs(ED.ratio_beta_fg)^s;
    else EDmod.ratio_beta_fg = (1/5^s)*n*ED.ratio_beta_fg^s;
    end
end


%% Bewertung Phasenwinkel der Giergeschwindigkeit bei f = 1 Hz:
% Bewertung
pkt_10 = 12.0;                                          % 10 Punkte bis 12,0°
pkt_5 = 39.0;                                           % 5 Punkte ab 39,0°
Ziel.Phase = 8;                                       % Zielwert (Referenzwert SUV)
Phase = abs(Phase);

% Korrelationsfunktion
Bewertung.Phase=Korrelationsfunktion(pkt_5,pkt_10,'Phasenwinkel der Giergeschwindigkeit',Phase);

if(Optimierung.Modus == 1)
    % Eigenschaftsdelta: ED
    %Ziel.Phase = m*Phase_SUV+(10-m*pkt_10);                 % Bewertung auf 10er-Skala
    ED.Phase = Ziel.Phase - Bewertung.Phase;                % Eigenschaftsdelta

    % Modifiziertes Eigenschaftsdelta: EDmod
    s = 1;                                                % Formfaktor
    n = 1;                                                  % Verhältnis Über-/Untererfüllung
    if(ED.Phase <= 0) EDmod.Phase = -(1/5^s)*abs(ED.Phase)^s;
    else EDmod.Phase = (1/5^s)*n*ED.Phase^s;
    end
end

Werte_Bewertung.ratio_beta_fg = ratio_beta_fg;
Werte_Bewertung.Phase = Phase;


clear  p_delta l_delta p_psi l_psi input_freq  peaks phase...   
       ind_frequenz_1 Phase beta_max_fg ratio_beta_fg...
       pkt_10 pkt_5 m Ziel s n  