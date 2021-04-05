function Bewertung = Korrelationsfunktion(pkt_5,pkt_10,Eigenschaft,Wert)
%Korrelationsfunktion

m = (5-10)/(pkt_5-pkt_10);                                  % Steigung
Bewertung = m*Wert+(10-m*pkt_10);                           % Bewertung auf 10er-Skala

if (strcmp(Eigenschaft,'Änderung Giergeschwindigkeit mu-high') == 1) || ...
        (strcmp(Eigenschaft,'Änderung Giergeschwindigkeit mu-low') == 1)
        if(Wert > pkt_10) 
            Bewertung = 5;                                     % höchstens 10 Punkte
        elseif(Wert < pkt_5) 
            Bewertung = 5;                                      % mindestens 5 Punkte
        end
end

if      (strcmp(Eigenschaft,'bezogene Überschwingweite') == 1) || ...
        (strcmp(Eigenschaft,'Response Time') == 1) || ...
        (strcmp(Eigenschaft,'TB-Wert') == 1) || ...    
        (strcmp(Eigenschaft,'Phasenwinkel der Giergeschwindigkeit') == 1) || ...
        (strcmp(Eigenschaft,'Verhältnis Schwimmwinkel') == 1) || ...
        (strcmp(Eigenschaft,'t_0_100 auf mu-high') == 1) || ...
        (strcmp(Eigenschaft,'Elastizität auf mu-high') == 1) || ...
        (strcmp(Eigenschaft,'t_0_100 auf mu-low') == 1) || ...
        (strcmp(Eigenschaft,'t_0_100 auf mu-split') == 1) || ...
        (strcmp(Eigenschaft,'Lenkaufwand') == 1)
    if(Wert < pkt_10) 
        Bewertung = 10;                                     % höchstens 10 Punkte
    elseif(Wert > pkt_5) 
        Bewertung = 5;                                      % mindestens 5 Punkte
    end
elseif (strcmp(Eigenschaft,'a_y_max') == 1) || ...
        (strcmp(Eigenschaft,'v_char') == 1) || ...
        (strcmp(Eigenschaft,'Hoechstgeschwindigkeit') == 1) || ...
        (strcmp(Eigenschaft,'a_max_beschl_statKF_auf_mu_low')==1)
    if(Wert > pkt_10) 
        Bewertung = 10;                                     % höchstens 10 Punkte
    elseif(Wert < pkt_5) 
        Bewertung = 5;                                      % mindestens 5 Punkte
    end
elseif (strcmp(Eigenschaft,'LWG_14') == 1) ||...
       (strcmp(Eigenschaft,'LWG_67') == 1)
    if Wert < 0 
        Bewertung = 5;
    elseif (Wert < pkt_10) && (Wert >= 0)
        Bewertung = 10;
    elseif (Wert > pkt_5)
        Bewertung = 5; 
    end
end
end