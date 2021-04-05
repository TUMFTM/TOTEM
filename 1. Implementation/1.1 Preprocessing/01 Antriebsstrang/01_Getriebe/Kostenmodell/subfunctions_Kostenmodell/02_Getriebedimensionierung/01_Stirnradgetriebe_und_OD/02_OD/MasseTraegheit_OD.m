 function [ m_OD, J_Komp, J_PKR,J_Sonnen,J_AW,Jx,Jy,Jz] = MasseTraegheit_OD(M_EM_max, imax)
%% Modell nach Fuchs für Abmaße
%rho = 7800;
M_Diff_max = M_EM_max*imax; %[Nm]
differential_struct = differential_calculation_init();
r_Eingangswelle = radius_Differentialeingangswelle(M_Diff_max); %[m]
[~, ~, r_korb_a, r_korb_i, r_planet,r_Sonne,r_AW,l_Korb] = differential_calculation(M_Diff_max, differential_struct, r_Eingangswelle); %[kg]

%% Massenberechnung der Komponenten Planeten, Sonnen, Ausgleichswellen und Körbe über (abgespeicherte) Regressionen, weil besser als Modell
% load('./mat-Files/Regressionen/Massenkoeffizienten_OD_planet.mat');
% load('./mat-Files/Regressionen/Massenkoeffizienten_OD_sun.mat');
% load('./mat-Files/Regressionen/Massenkoeffizienten_OD_shaft.mat');
% load('./mat-Files/Regressionen/Massenkoeffizienten_OD_case.mat');
p_planet=   [8.82248084886502e-05 0.112913510825240];
p_sun=      [0.000217747951768644 0.215141999350271];
p_shaft=	[6.88769312907770e-05 0.0496698724855278];
p_case=     [6.88769312907770e-05 0.0496698724855278];
%load('./mat-Files/Regressionen/Massenkoeffizienten_OD_Komp.mat');
m_Planeten = p_planet(1)*M_Diff_max + p_planet(2);
m_Sonnen = p_sun(1)*M_Diff_max + p_sun(2);
m_Ausgleichswelle = p_shaft(1)*M_Diff_max + p_shaft(2);
m_Korb = p_case(1)*M_Diff_max + p_case(2);
m_OD = m_Planeten + m_Sonnen + m_Ausgleichswelle + m_Korb;
%m_OD = p_Komp(1)*M_Diff_max + p_Komp(2);

%% Trägheiten für Konsistenz mit diesen Massen errechnen
%Trägheit Korbkomplex
J_Komp = (m_Korb + m_Planeten + m_Ausgleichswelle)*(r_korb_a^2+r_korb_i^2)/2;
%Trägheit Planetenkegelräder mit allerdings errechneten Radien; Körper =
%Zylinder nicht hohl, homogen
J_PKR = 0.5*m_Planeten*r_planet^2;
%Trägheiten Sonnen
J_Sonnen = 0.5*m_Sonnen*r_Sonne^2;
%Trägheit AW
J_AW =  0.5*m_Ausgleichswelle*r_AW^2;
%% Gesamte Trägheit unm Hauptachsen (ersetzt TraegheitAchsen_OD.m)
%Modell Hohlzylinder -> y-Achse ist achsparallel
%Trägheit Hohlzylinder um Querachse: m*(1/12)*(3(r_a^2+r_i^2)+h^2)
Jy = J_Komp;
Jx = m_OD*(1/12)*(3*(r_korb_a^2+r_korb_i^2)+l_Korb^2);
Jz = Jx;
end

