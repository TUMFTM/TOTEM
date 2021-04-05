function [wkg_gears]= Wirkungsgradberechnung_Getriebe_konstant(n_Gaenge, i_Gaenge, i_Stufen, z_Ritzel)

wkg_gears = 0.95*ones(1,n_Gaenge); %Quelle Tschochner

%mitlaufende Gänge berücksichtigen -> jeder maximale Gangwirkungsgrad wird
%um n_mitlaufendeGänge*eta_leer verschlechtert
eta_leer = 0.99;    %Pesce/Literatur
wkg_gears = wkg_gears.*eta_leer^(n_Gaenge-1);
%Kein Getriebe vorhanden? Dann:
if all(i_Gaenge == 1)
    wkg_gears = 1;
end




