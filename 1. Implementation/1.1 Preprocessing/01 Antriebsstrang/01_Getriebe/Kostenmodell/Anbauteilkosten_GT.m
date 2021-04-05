
function K_Anbauteile=Anbauteilkosten_GT(az, OD, TV, TS, n_Gaenge, i_Gaenge, Stkzahl)
%in diesem Skript werden die Anbaukosten für einen Elektromotor berechnet.
%Es erfolgt eine stückzahlvariable Auswahl der Anbauteile und die Lager
%skalieren mit der Nennleistung  
%Für die Anbauteile wurden Getriebe in A2Mac1 weitesgehend analysiert und
%mit Preisen für Massenfertigung in Anlehnung an [12] und [99] beziffert.


if az==1 && OD==1 && TV==0 && n_Gaenge==1 && i_Gaenge<=6 && TS ==0
    Anbauteile_1_Stufe_1_Gang_OD;
elseif az==1 && OD==1 && TV==0 && n_Gaenge==1 && TS==0
    Anbauteile_2_Stufen_1_Gang_OD;
elseif az==1 && OD==1 && TV==0 && n_Gaenge>=2 && TS ==0
    Anbauteile_2_Stufen_2_Gang_OD;
elseif az==1 && OD==0 && TV==1 && n_Gaenge==1 && i_Gaenge<=6 && TS==0
    Anbauteile_1_Stufen_1_Gang_eTV;
elseif az==1 && OD==0 && TV==1 && n_Gaenge==1 && TS==0
    Anbauteile_2_Stufen_1_Gang_eTV;
elseif az==1 && OD==0 && TV==1 && n_Gaenge>=2 && TS==0
    Anbauteile_2_Stufen_2_Gang_eTV; 
elseif az==1 && OD==0 && TV==0 && n_Gaenge==1 && i_Gaenge<=6 && TS==1
    Anbauteile_1_Stufen_1_Gang_TS;
elseif az==1 && OD==0 && TV==0 && n_Gaenge==1 && TS==1
    Anbauteile_2_Stufen_1_Gang_TS;
elseif az==1 && OD==0 && TV==0 && n_Gaenge>=2 && TS==1
    Anbauteile_2_Stufen_2_Gang_TS;   
elseif az==0 && n_Gaenge==1 && i_Gaenge<=6
    Anbauteile_1_Stufen_1_Gang;
elseif az==0 && n_Gaenge==1 && i_Gaenge>6
    Anbauteile_2_Stufen_1_Gang;
elseif az==0 && n_Gaenge>=2
    Anbauteile_2_Stufen_2_Gang;
end
%%
%Verteuerung der Anbauteilkosten für Kleinserienfertigung nach Ehrlenspiel [99]
%Kommt nur bei Stückzahlen <20.000 zum Tragen.

if Stkzahl>=20000
    K_Anbauteile=Anbauteile;    
elseif Stkzahl<20000 && Stkzahl>=3000
    K_Anbauteile=Anbauteile*1.1;    
else Stkzahl<3000
    K_Anbauteile=Anbauteile*1.2;
end

