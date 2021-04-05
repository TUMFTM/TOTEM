function [M_nenn_em_Steuer, n_nenn_em_Steuer, n_max_em_Steuer, typ_em_Steuer, M_max_Steuer, ...
    MaxMotorTrqCurve_w, MaxMotorTrqCurve_M, MaxGeneratorTrqCurve_w, MaxGeneratorTrqCurve_M, ...
    MotorEffMap3D, MotorEffMap3D_w, MotorEffMap3D_M, GeneratorEffMap3D, GeneratorEffMap3D_w, ...
    GeneratorEffMap3D_M, z1_I, z2_II, z1_III, z2_III, z2_IV, zP_I_II, zP_III_IV, zVTV_1, zVTV_2, ...
    zVTV_3, zVTV_4,i12_I, i12_II, i12_III, i12_IV, iVTV_1, iVTV_2, eta12_I, eta12_II, eta12_III, ...
    eta12_IV, etaVTV_12, etaVTV_34, Jred_EM_Steuer, m_eTV, m_em_Steuer, Jred_eTV, Jx_eTV, Jy_eTV, Jz_eTV, Jx_em_Steuer, ...
    Jy_em_Steuer, Jz_em_Steuer, l_SEM, x_eTV, y_eTV, z_eTV, x_SEM, y_SEM, z_SEM] ...
    = set_eTV(delta_M, d_Abtriebsrad, b_Abtriebsrad, vzkonst, Maximaldrehmoment_Antrieb, i_gears, Optimierung_Gesamttopologie, d_TIR, Spurweite)

delta_M=                delta_M/0.99;       % mech. Wirkungsgrad 99% nach Seeger berücksichtigen
Ueberlastfaktor=        2;                  % mit Metamodell nur Ueberlastfaktor = 2 zulässig
i_Steuer=               48.5;               % mit Metamodell nur i_Steuer=48.5 zulässig! Analog zu visio.m
typ_em_Steuer=          'PSM';              % mit Metamodell nur PSM möglich


n_nenn_em_Steuer=       5856;               % [U/min] Auslegung vgl. BA Klass
n_max_em_Steuer=        2*n_nenn_em_Steuer; % Feldschwächungsfaktor = 2 nach nach Pesce
M_nenn_em_Steuer=       delta_M/(i_Steuer*Ueberlastfaktor); % mech. Wirkungsgrad von 99% wurde bereits berücksichtigt
M_max_Steuer=           M_nenn_em_Steuer*Ueberlastfaktor;


%% Kennfeldberechnung mit Metamodell

% Für diese diskreten Werte von delta_M sind Kennfelder hinterlegt
Stufen=[200 223 246 269 292 315 338 361 384 407 430 453 476 499 522 545 568 591 614 637 660 683 706 729 752 775 798 821 844 867 890 913 936 959 982 1005 1028 1051 1074 1097 1120 1143 1166 1189 1212 1235 1258 1281 1304 1327 1350 1373 1396 1419 1442 1465 1488 1511 1534 1557 1580 1603 1626 1649 1672 1695 1718 1741 1764 1787 1810 1833 1856 1879 1902 1925 1948 1971 1994 2017 2040 2063 2086 2109 2132 2155 2178 2201 2224 2247 2270 2293 2316 2339 2362 2385 2408 2431 2454 2477 2500];

% Finde die zwei zu inteprolierenden Werte von delta_M
x1 = [];
for find_Stufen=2:length(Stufen)
    if (delta_M <= Stufen(find_Stufen)&& delta_M >= Stufen(find_Stufen-1))
        x1=Stufen(find_Stufen-1);
        x2=Stufen(find_Stufen);
        break
    end
end
if isempty(x1)
    disp('Fehler; delta_M nur zwischen 200 und 2450 Nm möglich')
    return
end

% Lade zu interpolierende Kennfelder
eval(['load Kennfelder' num2str(x1) '.mat;']);
Kennfelder_low=Kennfelder;
eval(['load Kennfelder' num2str(x2) '.mat;']);
Kennfelder_high=Kennfelder;

% Nutzt nächstgelegenes WKG-Kennfeld ohne Interpolation
if delta_M-x1>x2-delta_M
    MotorEffMap3D_M=Kennfelder_high.MotorEffMap3D_M;
    MotorEffMap3D_w=Kennfelder_high.MaxMotorTrqCurve_w;
    MotorEffMap3D=Kennfelder_high.MotorEffMap3D;
else
    MotorEffMap3D_M=Kennfelder_low.MotorEffMap3D_M;
    MotorEffMap3D_w=Kennfelder_low.MaxMotorTrqCurve_w;
    MotorEffMap3D=Kennfelder_low.MotorEffMap3D;
end

% Interpolation des n-M-Kennfelds
for hilf2=1:201
    MaxMotorTrqCurve_M(hilf2)=Kennfelder_low.MaxMotorTrqCurve_M(hilf2)+(Kennfelder_high.MaxMotorTrqCurve_M(hilf2)-Kennfelder_low.MaxMotorTrqCurve_M(hilf2))/(x2-x1)*(delta_M-x1);
end

% Werte für folgende Größen ergeben sich aus den bereits bestimmten Größen
GeneratorEffMap3D       =  	MotorEffMap3D;
GeneratorEffMap3D_w     =   MotorEffMap3D_w;
GeneratorEffMap3D_M     =   MotorEffMap3D_M;
MaxGeneratorTrqCurve_w  =   MotorEffMap3D_w;
MaxMotorTrqCurve_w      =   MotorEffMap3D_w;
MaxGeneratorTrqCurve_M  =   MaxMotorTrqCurve_M;

%% Geometrie- & Wirkungsgradberechnung
[z1_I, z2_II, z1_III, z2_III, z2_IV, zP_I_II, zP_III_IV, zVTV_1, zVTV_2, zVTV_3, zVTV_4, ...
    i12_I, i12_II, i12_III, i12_IV, iVTV_1, iVTV_2, eta12_I, eta12_II, eta12_III, eta12_IV, etaVTV_12, etaVTV_34] ...
    = GeometrieWKG_eTV(delta_M, M_max_Steuer, d_Abtriebsrad, vzkonst);

%% Masse und Trägheitsberechnung
imax = max([i_gears]);

Jred_EM_Steuer =   Traegheit_EM(M_nenn_em_Steuer, n_nenn_em_Steuer, typ_em_Steuer, i_gears);

m_em_Steuer = Masse_SteuerEM(M_nenn_em_Steuer, n_nenn_em_Steuer);

M_max_em_Steuer=2*M_nenn_em_Steuer;
m_LE_Steuer = Leistungseletronik_Masse(M_max_em_Steuer, 1, n_nenn_em_Steuer);

m_em_Steuer=m_em_Steuer+m_LE_Steuer;

[m_eTV,Jred_eTV] = MasseTraegheit_eTV(z1_I, z2_II, z1_III, z2_III, z2_IV, zP_I_II, zP_III_IV, zVTV_1, zVTV_2, ...
    zVTV_3, zVTV_4,i12_I, i12_II, i12_III, i12_IV, iVTV_1, iVTV_2,vzkonst,Maximaldrehmoment_Antrieb, imax, delta_M);

[Jx_eTV, Jy_eTV, Jz_eTV] = TraegheitAchsen_eTV(m_eTV, b_Abtriebsrad, d_Abtriebsrad);%[kg m^2]

[Jx_em_Steuer, Jy_em_Steuer, Jz_em_Steuer] =  TraegheitAchsen_EM(typ_em_Steuer, M_nenn_em_Steuer,  n_nenn_em_Steuer);

%% Schwerpunkte [m] relativ zur jeweiligen Achse

%Abmaße
dVTV2 = zVTV_2*vzkonst.mod_eTV_TVE;%Durchmesser VTV2 eTV[mm]
dVTV4 = zVTV_4*vzkonst.mod_eTV_TVE;%Durchmesser VTV4 eTV[mm]

%Länge der Motoren aus Regressionen
[l_SEM] = Laenge_EM(typ_em_Steuer,M_nenn_em_Steuer, n_nenn_em_Steuer, Optimierung_Gesamttopologie);%[mm]

%Berechnung Schwerpunkt
[x_eTV, y_eTV, z_eTV] = SP_eTV(b_Abtriebsrad);
[x_SEM, y_SEM, z_SEM] = SP_SEM(b_Abtriebsrad, dVTV2, dVTV4, l_SEM);

end