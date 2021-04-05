function [m_eTV,Jred_ges] = MasseTraegheit_eTV(z1_I, z2_II, z1_III, z2_III, z2_IV, zP_I_II, zP_III_IV, zVTV_1, zVTV_2, ... 
    zVTV_3, zVTV_4,i12_I, i12_II, i12_III, i12_IV, iVTV_1, iVTV_2,vzkonst, M_EM_max,imax, deltaM_TV)
%Berechnung der einzelnen Massen und Trägheiten der Zahnräder sowie eines
%Gesamtträgheitsmoments auf die Räder reduziert bei Geradeausfahrt
%% Daten

%mod: Modul, m: Masse
%konstante Moduln und Breiten annehmen: nach der VisioM - Konfig in Mueller
mod_TV = vzkonst.mod_eTV_TVE*0.001;   %[m]
mod_Diff = vzkonst.mod_eTV_DiffE*0.001;
b_TV = 0.006; %[m]
b_1IV = 0.013; 
b_2III = 0.006;
b_P_III_IV_1 = 0.013;
b_P_III_IV_2 = 0.021;
b_2IV = 0.013;
rho = vzkonst.rho_st; %[kg/m^3]
%aus Input
z2_II = -z2_II;   %wegen Hohlrad
z2_IV = -z2_IV;   %wegen Hohlrad

%% Massen der Zahnräder für die Trägheiten
%Masse Zahnrad: d = mod*z, m = 0.25*pi*d^2*b*rho
%Masse Hohlrad: m = 0.25*pi*(d2^2-d1^2)*b*rho
%radiale "Dicke" Hohlräder:
dicke_2II = 0.010; %[mm] abgeschätzt über die Zahnhöhe 
g = -0.8175;
dicke_2IV = (1/g-1)*mod_Diff*z2_IV; %Faktor aus scaleeTVDiff (Relation zum Getrieberad)

m_ZR_1I = 0.25*pi*(mod_TV*z1_I)^2*rho*b_TV;   %[kg], zweimal, auch als 1II
m_ZR_P_I_II = 0.25*pi*(mod_TV*zP_I_II)^2*rho*b_TV; %zweimal drei Planeten davon
m_ZR_2II = 0.25*pi*((mod_TV*z2_II+dicke_2II)^2-(mod_TV*z2_II)^2)*rho*b_TV;    %10mm "Raddicke"
m_ZR_2III = 0.25*pi*(mod_Diff*z2_III)^2*rho*b_2III;
m_ZR_1III = 0.25*pi*(mod_Diff*z1_III)^2*rho*b_1IV;
m_ZR_2IV = 0.25*pi*((mod_Diff*z2_IV+dicke_2IV)^2-(mod_Diff*z2_IV)^2)*rho*b_2IV; %20mm "Raddicke"
m_ZR_P_III_IV_1 = 0.25*pi*(mod_Diff*zP_III_IV)^2*rho*b_P_III_IV_1; %drei Planeten davon
m_ZR_P_III_IV_2 = 0.25*pi*(mod_Diff*zP_III_IV)^2*rho*b_P_III_IV_2; %drei Planeten davon
m_ZR_VTV_1 = 0.25*pi*(mod_TV*zVTV_1)^2*rho*b_TV;
m_ZR_VTV_2 = 0.25*pi*(mod_TV*zVTV_2)^2*rho*b_TV;
m_ZR_VTV_3 = 0.25*pi*(mod_TV*zVTV_3)^2*rho*b_TV;
m_ZR_VTV_4 = 0.25*pi*(mod_TV*zVTV_4)^2*rho*b_TV;    %beim VisioM nur drei Stück

%m_ZR_ges = m_ZR_1I+3*m_ZR_P_I_II+m_ZR_2II+m_ZR_2III+m_ZR_1III+m_ZR_2IV+3*m_ZR_P_III_IV_1...
%    +3*m_ZR_P_III_IV_2+m_ZR_VTV_1+m_ZR_VTV_2+m_ZR_VTV_3+m_ZR_VTV_4;
%% Trägheiten um eigene Drehachse
%Vollzylinder: J = 0.5*m*r^2, Hohlzylinder: J = 0.5*m*(r1^2+r2^2)
%Zylindermantel J = m*r^2

%Einzelträgheiten
J_ZR_1I = 0.5*m_ZR_1I*(mod_TV*z1_I/2)^2;       %zweimal
J_ZR_P_I_II = 0.5*m_ZR_P_I_II*(mod_TV*zP_I_II/2)^2; %zweimal
J_ZR_2II = 0.125*m_ZR_2II*((mod_TV*z2_II/2)^2+((mod_TV*z2_II+0.010)/2)^2);
J_ZR_2III = 0.5*m_ZR_2III*(mod_Diff*z2_III/2)^2;
J_ZR_1III = 0.5*m_ZR_1III*(mod_Diff*z1_III/2)^2;
J_ZR_2IV = 0.125*m_ZR_2IV*((mod_Diff*z2_IV/2)^2+((mod_Diff*z2_IV+0.020)/2)^2);
J_ZR_P_III_IV_1 = 0.5*m_ZR_P_III_IV_1*(mod_Diff*zP_III_IV/2)^2;
J_ZR_P_III_IV_2 = 0.5*m_ZR_P_III_IV_2*(mod_Diff*zP_III_IV/2)^2;
J_ZR_VTV_1 = 0.5*m_ZR_VTV_1*(mod_TV*zVTV_1/2)^2;
J_ZR_VTV_2 = 0.5*m_ZR_VTV_2*(mod_TV*zVTV_2/2)^2;
J_ZR_VTV_3 = 0.5*m_ZR_VTV_3*(mod_TV*zVTV_3/2)^2;
J_ZR_VTV_4 = 0.5*m_ZR_VTV_4*(mod_TV*zVTV_4/2)^2;    %[kg*m^2]

%Stege: Eigenmasse unbekannt; Planetenmasse muss mitbeschleunigt werden.
%Die Planetenmassen werden als Zylindermantel mit Radius r_Mantel = r_Sonne
%+ r_Planet genähert. Die Eigenmasse müsste  für eine vollständige Betrachtung
%berücksichtigt werden!

%Radien der Stege zu den Planeten
r_Steg_I_II = (mod_TV*z1_I/2)+(mod_TV*zP_I_II/2);
r_Steg_IV_1 = (mod_Diff*z1_III/2)+(mod_Diff*zP_III_IV/2);   %kleiner Steg III/IV
r_Steg_IV_2 = (mod_Diff*z2_III/2)+(mod_Diff*zP_III_IV/2);   %großer Steg III/IV
%Einzelträgheiten der Stege und der Planeten in Umfangsrichtung des Steges
J_Steg_I = 0;   %Eigenträgheit des Steges; (noch?) kein Modellierungsansatz, also 0 gesetzt
J_trans_P_I_II = 3*m_ZR_P_I_II*r_Steg_I_II^2;   %Modellierung Punktmassen auf Radius entspricht Zylindermantel
J_Steg_II = 0;  %s.Steg_I
J_Steg_III_IV = 0;  %s.Steg_I
J_trans_P_III_IV_1 = m_ZR_P_III_IV_1*r_Steg_IV_1^2;
J_trans_P_III_IV_2 = m_ZR_P_III_IV_2*r_Steg_IV_2^2;
%Reduktionsdrehzahlen
i_red_2I = 1-1/i12_I;
i_red_P_I_II = z1_I/zP_I_II;
%zusammengesetzte Trägheiten (zusammenhängende Bauteile)
J_Steg_I_ges = J_Steg_I + 3*J_trans_P_I_II + J_ZR_1III;
Jred_2II = J_ZR_2II*i_red_2I^2;
J_Steg_II_ges = J_Steg_II + 3*J_trans_P_I_II + J_ZR_2III;
Jred_P_I_II = J_ZR_P_I_II*i_red_P_I_II^2;   %P_I_II drehen nämlich auch bei Geradeausfahrt
J_Steg_III_ges = J_Steg_III_IV + 3*J_trans_P_III_IV_1 + 3*J_trans_P_III_IV_2;   %diese Planeten stehen
%gesamte auf Raddrehzahl reduzierte Trägheit
Jred_ges = J_Steg_I_ges + Jred_2II + J_Steg_II_ges + 3*Jred_P_I_II + J_Steg_III_ges + J_ZR_2IV;

%auf den Steuer-EM reduzierte Trägheit der Vorstufen und 1_II:
Jred_EM_Steuer = J_ZR_VTV_1 + (J_ZR_VTV_2 + J_ZR_VTV_3)/iVTV_1^2 + J_ZR_VTV_4/iVTV_2^2;
%% Massenberechnung des Gesamtgetriebes via doppelte Skalierung
%skalierter Teil: in beiden Fällen die reine Zahnradmasse ohne Gehäuse,
%welches gegen das Hohlrad aufgewogen wird
M_achs_max = M_EM_max*imax;
% %Differentialteil skaliert linear mit Differentialeingangsmoment
% mref_VisioM_DiffEH = 2.18 + 2.87; %Mueller (Masse des Differentials und des Final Drive)
% MDiffref_VisioM = 757.5; %aus M_EM_max*imax = 75*10.267 = 770, Daten aus Mueller, obwohl dort 757.5 angegeben werden
% m_DiffEH_eTV = (mref_VisioM_DiffEH/MDiffref_VisioM) * M_achs_max;
% 
% %Torque-Vectoring-Einheit skaliert linear mit maximalem Verlagerungsmoment
% mref_VisioM_TVEH = 1.93; %aus Müller, TV_Einheit inkl. Vorstufe
% deltaMref_VisioM = 595; %aus Müller
% m_TVEH_eTV = (mref_VisioM_TVEH/deltaMref_VisioM) * deltaM_TV;
% 
% m_eTV = m_DiffEH_eTV + m_TVEH_eTV;

masse_etv_visioM = 11.5; % "Lightweight Torque-Vectoring Transmission for the Electric Vehicle Visio.M", Gwinner et al., 2014, CoFAT, Fig. 12
achsmoment_etv_visioM = 758; %Diplomarbeit Müller, Moritz, 2013, S. 105

m_eTV=masse_etv_visioM/achsmoment_etv_visioM*M_achs_max;

end