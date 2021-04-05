function [l_ges,h_ges,t_ges,m_ges,J_ges_antr_gang_1,J_ges_antr_gang_2,J_ges_abtr_gang_1,J_ges_abtr_gang_2,Fehlerbit,Fehlercode,d_a1_1,d_a1_2,d_a2_1,d_a2_2,d_a3,d_a4,b_1_1,b_1_2,b_3,z_1_1,z_1_2,z_2_1,z_2_2,z_3,z_4,S_H_12_1,S_H_12_2,S_H_34,S_F_12_1,S_F_12_2,S_F_34,d_1_1,d_1_2,d_2_1,d_2_2,d_3,d_4,alpha,zeta,d_motor,variante,gamma_1,gamma_2,gamma_3,gamma_1_B,gamma_2_B,d_1_g,d_2_g,d_4_g,gamma_3_B,m_A,m_B,m_C,m_D,m_E,m_F,i_12_1,i_12_2,i_34,epsilon_beta_1,epsilon_beta_2,epsilon_beta_3,epsilon_alpha_1,epsilon_alpha_2,epsilon_alpha_3,ID_A,ID_B,ID_C,ID_D,ID_E,ID_F,neig,ax_bauraum_schalt,rad_bauraum_schalt,m_z1_1,m_z1_2,m_z2_1,m_z2_2,m_z3,m_z4,m_w1,m_w2,m_korb,m_w4,m_kegelraeder,m_diff_stange,m_geh,alpha_wt_1_1,alpha_wt_1_2,alpha_wt_2, m_torque,m_torque_cost, m_Lagersitz, M_nenn_em_Steuer, n_nenn_em_Steuer, n_max_em_Steuer, typ_em_Steuer, M_max_Steuer, MaxMotorTrqCurve_w, MaxMotorTrqCurve_M, MaxGeneratorTrqCurve_w, MaxGeneratorTrqCurve_M, MotorEffMap3D, MotorEffMap3D_w, MotorEffMap3D_M, GeneratorEffMap3D, GeneratorEffMap3D_w, GeneratorEffMap3D_M, z1_I, z2_II, z1_III, z2_III, z2_IV, zP_I_II, zP_III_IV, zVTV_1, zVTV_2, zVTV_3, zVTV_4,i12_I, i12_II, i12_III, i12_IV, iVTV_1, iVTV_2, eta12_I, eta12_II, eta12_III, eta12_IV, etaVTV_12, etaVTV_34, Jred_EM_Steuer, m_eTV, m_em_Steuer,Jred_eTV, Jx_eTV, Jy_eTV, Jz_eTV, Jx_em_Steuer, Jy_em_Steuer, Jz_em_Steuer, l_SEM, x_eTV, y_eTV, z_eTV, x_SEM, y_SEM, z_SEM] = ...
    two_speed_gear(Maximaldrehmoment,Nenndrehmoment,Gesamtuebersetzung_Gang_1,Gesamtuebersetzung_Gang_2,Eckdrehzahl,Durchmesser_eMaschine, delta_M, differential,torque_vectoring, torque_splitter, Optimierung_Getriebe, Optimierung_Gesamttopologie, vzkonst, d_TIR, Spurweite)
%Auslegungstool eines 2-Gang-Getriebes für BEV

d_motor=Durchmesser_eMaschine;
ueberlast=Maximaldrehmoment./Nenndrehmoment;
i_ges_1=Gesamtuebersetzung_Gang_1;
i_ges_2=Gesamtuebersetzung_Gang_2;



[w,u]=size(i_ges_1);

%Lagerkatalog einmalig einlesen für ersten beiden Stufen___________________
            values_A=[35 72 17 25500 291 13.8000000000000 15300 47.2000000000000 6207;55 90 18 28500 397 15.4000000000000 21200 66.2000000000000 6011;60 95 18 29000 419 15.5000000000000 23200 71.3000000000000 6012;65 100 18 30500 448 15.7000000000000 25000 76.2000000000000 6013;45 85 19 31000 429 14.3000000000000 20400 57.2000000000000 6209;35 80 21 33500 471 13.1000000000000 19000 49.3000000000000 6307;50 90 20 36500 466 14.3000000000000 24000 62 6210;70 110 20 38000 622 15.5000000000000 31000 82.2000000000000 6014;75 115 20 39000 654 15.7000000000000 33500 88.1000000000000 6015;40 90 23 42500 640 13 25000 55.6000000000000 6308;55 100 21 43000 618 14.3000000000000 29000 68.9000000000000 6211;80 125 22 47500 845 15.6000000000000 40000 94 6016;60 110 22 52000 809 14.3000000000000 36000 76.1000000000000 6212;45 100 25 53000 849 13 31500 62.3000000000000 6309;35 100 25 53000 971 12.1000000000000 31500 62 6407;65 120 23 60000 1000 14.3000000000000 41500 82.3000000000000 6213;40 110 27 62000 805 12.2000000000000 38000 68 6408;70 125 24 62000 1090 14.4000000000000 44000 87.1000000000000 6214;50 110 27 62000 1100 13 38000 68.3000000000000 6310;75 130 25 65500 1190 14.7000000000000 49000 92.5000000000000 6215;80 140 26 72000 1460 14.6000000000000 54000 98.5000000000000 6216;55 120 29 76000 1390 12.9000000000000 47500 75.5000000000000 6311;45 120 29 76500 1980 12.1000000000000 47500 75.5000000000000 6409;60 130 31 81500 1750 13.1000000000000 52000 81.6000000000000 6312;50 130 31 81500 1960 13.1000000000000 52000 81.6000000000000 6410;65 140 33 93000 2140 13.2000000000000 60000 88.6000000000000 6313;70 150 35 104000 2550 13.3000000000000 68000 95.1000000000000 6314;60 150 35 104000 2830 13.2000000000000 68000 95.1000000000000 6412;75 160 37 114000 3180 13.2000000000000 76500 101.800000000000 6315;65 160 37 114000 3490 13.2000000000000 76500 101.700000000000 6413;80 170 39 122000 3750 13.2000000000000 86500 108.600000000000 6316;70 185 42 132000 5060 13.3000000000000 96500 114.400000000000 6414];         
            values_B=[60 95 23 82000 614 0.430000000000000 1.39000000000000 80 123000 0.770000000000000;60 95 27 95000 714 0.330000000000000 1.83000000000000 78.6000000000000 148000 1.01000000000000;60 100 30 116000 1010 0.400000000000000 1.51000000000000 81.3000000000000 171000 0.830000000000000;60 110 38 169000 1550 0.400000000000000 1.48000000000000 86.2000000000000 237000 0.820000000000000;65 100 23 82000 620 0.460000000000000 1.31000000000000 85.2000000000000 125000 0.720000000000000;65 100 27 100000 766 0.350000000000000 1.72000000000000 84.6000000000000 161000 0.950000000000000;65 120 24.7500000000000 119000 1270 0.400000000000000 1.48000000000000 90 200000 0.810000000000000;65 110 34 149000 1310 0.390000000000000 1.55000000000000 84.6000000000000 225000 0.850000000000000;70 100 20 71000 494 0.320000000000000 1.90000000000000 85.9000000000000 116000 1.05000000000000;70 110 25 104000 967 0.430000000000000 1.38000000000000 92 159000 0.760000000000000;70 110 31 136000 1140 0.280000000000000 2.11000000000000 91 223000 1.16000000000000;70 120 37 174000 1710 0.380000000000000 1.58000000000000 96 260000 0.870000000000000;75 105 20 74000 519 0.330000000000000 1.80000000000000 90.5000000000000 124000 0.990000000000000;75 115 25 105000 922 0.460000000000000 1.31000000000000 97.3000000000000 165000 0.720000000000000;75 115 31 139000 1160 0.300000000000000 2.01000000000000 96.4000000000000 232000 1.11000000000000;75 125 37 178000 1790 0.400000000000000 1.51000000000000 101.400000000000 275000 0.830000000000000;80 125 29 137000 1290 0.420000000000000 1.42000000000000 103.600000000000 211000 0.780000000000000;80 140 28.2500000000000 154000 1680 0.420000000000000 1.43000000000000 106.900000000000 190000 0.790000000000000;80 125 36 175000 1670 0.280000000000000 2.16000000000000 102.600000000000 290000 1.19000000000000;80 130 37 188000 1900 0.420000000000000 1.44000000000000 106.600000000000 300000 0.790000000000000;85 140 29 141000 1360 0.440000000000000 1.36000000000000 109.500000000000 224000 0.750000000000000;85 150 30.5000000000000 178000 2290 0.420000000000000 1.43000000000000 114.400000000000 224000 0.790000000000000;85 130 36 184000 1750 0.290000000000000 2.06000000000000 108.500000000000 315000 1.13000000000000;85 140 41 221000 2380 0.410000000000000 1.48000000000000 114.200000000000 350000 0.810000000000000;90 140 32 164000 1760 0.420000000000000 1.42000000000000 115.300000000000 255000 0.780000000000000;90 140 39 216000 2480 0.270000000000000 2.23000000000000 116 365000 123;90 150 42 265000 3190 0.400000000000000 1.51000000000000 121.500000000000 420000 0.830000000000000;95 130 23 181000 825 0.360000000000000 1.68000000000000 113 181000 0.920000000000000;95 145 32 275000 1860 0.440000000000000 1.36000000000000 121 275000 0.750000000000000;95 145 39 380000 2330 0.280000000000000 2.16000000000000 120.200000000000 380000 1.19000000000000;100 150 32 285000 1940 0.460000000000000 1.31000000000000 126.600000000000 285000 0.720000000000000;100 150 39 395000 2420 0.290000000000000 2.09000000000000 124.700000000000 395000 1.15000000000000;100 165 47 470000 4250 0.320000000000000 1.88000000000000 131.300000000000 470000 1.04000000000000;105 145 25 217000 1150 0.340000000000000 1.75000000000000 125 217000 0.960000000000000;105 160 35 330000 2330 0.440000000000000 1.35000000000000 133 202000 0.740000000000000;105 160 43 450000 3340 0.280000000000000 2.12000000000000 131.500000000000 450000 1.17000000000000;110 150 25 231000 1260 0.360000000000000 1.69000000000000 130.900000000000 231000 0.930000000000000;110 170 38 395000 3350 0.430000000000000 1.39000000000000 141 395000 0.770000000000000;110 170 47 520000 4160 0.290000000000000 2.09000000000000 139.200000000000 520000 1.15000000000000;120 165 29 176000 1820 0.350000000000000 1.72000000000000 141 305000 0.950000000000000;120 180 38 250000 3290 0.460000000000000 1.31000000000000 151 420000 0.720000000000000;120 180 48 310000 4550 0.310000000000000 1.97000000000000 148.500000000000 560000 1.08000000000000;130 180 32 208000 2400 0.340000000000000 1.77000000000000 154.700000000000 370000 0.970000000000000;130 200 45 325000 5020 0.430000000000000 1.38000000000000 166.200000000000 550000 0.760000000000000;130 230 43.7500000000000 355000 7080 0.440000000000000 1.38000000000000 177.100000000000 470000 0.760000000000000;140 190 32 214000 2600 0.360000000000000 1.67000000000000 164.800000000000 395000 0.920000000000000;140 210 45 340000 5390 0.460000000000000 1.31000000000000 175.800000000000 590000 0.720000000000000;140 250 45.7500000000000 415000 8810 0.440000000000000 1.38000000000000 187 560000 0.760000000000000];
            values_C={'32012-X';'33012-';'33112-';'33212-';'32013-X';'33013-';'30213-A';'33113-';'32914-';'32014-X';'33014-';'33114-';'32915-';'32015-X';'33015-';'33115-';'32016-X';'30216-A';'33016-';'33116-';'32017-X';'30217-A';'33017-';'33117-';'32018-XA';'33018-';'33118-';'32919-';'32019-XA';'33019-A';'32020-X';'33020-';'T2EE100';'32921-';'32021-X';'33021-';'32922-';'32022-X';'33022-';'32924-';'32024-X';'33024-';'32926-';'32026-X';'32026-A';'32928-';'32028-X';'30228-A'};
%--------------------------------------------------------------------------
            
%globale Variablen Festlegen:..............................................
m_n_1=2.4; %Modul erste Stufe
m_n_3=2.8; %Modul zweite Stufe
beta=20*pi/180; %globaler Schrägungswinkel
b_d=0.65; %Globales b/d-Verhältnis
spalt=3; %Spaltmaß zwischen Lagersitz und Zahnrad
fspalt=10; %Spaltmaß zwischen Zahnrad und Gehäusewand
%Werkstoffkennwerte aus GUI oder hier setzen
sigma_fe=860;
sigma_hlim=1470;
roh_inn=7.72/1000000;
wunschbauraum=0;
neig_uebergabe=0;
%Optimierung_Getriebe={'Höhe'};

%Gehäusematerial: AlSi9Cu3
roh_geh=2.75/1000000; %kg/mm^3
%Wandstärke Gehäuse
d_geh=4;
%Parkbremse
b_park=13;



%..........................................................................

%Übersetzungen auf beide Stufen aufteilen. Erster Anhaltswert
i_12_1=0.8*(i_ges_1.^(2/3));
i_12_1=i_12_1+0.5;
i_34=i_ges_1./i_12_1;
%Überprüfen der Eingaben___________________________________________________
%Fehlerbit initialisieren:_________________________________________________
Fehlerbit=zeros(1,u);
Fehlercode=cell(1,u);
for k=1:u
    if(Nenndrehmoment(k)>300|| Nenndrehmoment(k)<30)
        Fehlerbit(1,k)=1;
        Nenndrehmoment(k)=100;
        Fehlercode(1,k)={'Uebergabeparameter ungueltig: Nenndrehmoment zu gross. In der Berechnung ist ein Nenndrehmoment von max. 300 Nm vorgesehen'};
    elseif(i_ges_1(k) < 3.5 || i_ges_1(k) > 16)
        Fehlerbit(k)=1;
        i_12_1(k)=2;
        i_34(k)=2;
        Fehlercode(1,k)={'Uebergabeparameter ungueltig: Die Uebersetzungen liegen nicht im Fenster von 1.5 - 4.0.'};
    elseif(strcmp(Optimierung_Getriebe(1,k),'Länge')==0 && strcmp(Optimierung_Getriebe(1,k),'Höhe')==0 && strcmp(Optimierung_Getriebe(1,k),'Masse')==0 && strcmp(Optimierung_Getriebe(1,k),'Manual')==0)
        Fehlerbit(k)=1;
        Optimierung_Getriebe(1,k)={'Länge'};
        Fehlercode(1,k)={'Uebergabeparameter ungueltig: Die Einbauart wird nicht verwendet. Es wurde Fronteinbau angenommen.'};
    elseif(Eckdrehzahl(1,k)>8000)
        Eckdrehzahl(1,k)=3500;
    end
end
%Zwischenspreichern der alten Übersetzung, da diese innerhalb der Auslegung
%angepasst wird
i_12_uebergabe=i_12_1;
i=1;
err_S_H=zeros(u,16);
err_S_F=zeros(u,16);
eTV_zaehlvariable=0; %Initialisierung der Zaehlvariable des eTVs
while 1
    %FUNKTIONSAUFRUF FÜR ZWEIGANG-Getriebe

    [ l_ges,h_ges,t_ges,m_ges,J_ges_antr_gang_1,J_ges_antr_gang_2,J_ges_abtr_gang_1,J_ges_abtr_gang_2,Fehlerbit,Fehlercode,d_a1_1,d_a1_2,d_a2_1,d_a2_2,d_a3,d_a4,b_1_1,b_1_2,b_3,z_1_1,z_1_2,z_2_1,z_2_2,z_3,z_4,S_H_12_1,S_H_12_2,S_H_34,S_F_12_1,S_F_12_2,S_F_34,d_1_1,d_1_2,d_2_1,d_2_2,d_3,d_4,alpha,zeta,d_motor,variante,gamma_1,gamma_2,gamma_3,gamma_1_B,gamma_2_B,d_1_g,d_2_g,d_4_g,gamma_3_B,m_A,m_B,m_C,m_D,m_E,m_F,i_12_1,i_12_2,i_34,epsilon_beta_1,epsilon_beta_2,epsilon_beta_3,epsilon_alpha_1,epsilon_alpha_2,epsilon_alpha_3,ID_A,ID_B,ID_C,ID_D,ID_E,ID_F,neig,ax_bauraum_schalt,rad_bauraum_schalt,m_z1_1,m_z1_2,m_z2_1,m_z2_2,m_z3,m_z4,m_w1,m_w2,m_korb,m_w4,m_kegelraeder,m_diff_stange,m_geh,alpha_wt_1_1,alpha_wt_1_2,alpha_wt_2, m_torque,m_torque_cost, m_Lagersitz, M_nenn_em_Steuer, n_nenn_em_Steuer, n_max_em_Steuer, typ_em_Steuer, M_max_Steuer, MaxMotorTrqCurve_w, MaxMotorTrqCurve_M, MaxGeneratorTrqCurve_w, MaxGeneratorTrqCurve_M, MotorEffMap3D, MotorEffMap3D_w, MotorEffMap3D_M, GeneratorEffMap3D, GeneratorEffMap3D_w, GeneratorEffMap3D_M, z1_I, z2_II, z1_III, z2_III, z2_IV, zP_I_II, zP_III_IV, zVTV_1, zVTV_2, zVTV_3, zVTV_4,i12_I, i12_II, i12_III, i12_IV, iVTV_1, iVTV_2, eta12_I, eta12_II, eta12_III, eta12_IV, etaVTV_12, etaVTV_34, Jred_EM_Steuer, m_eTV, m_em_Steuer,Jred_eTV, Jx_eTV, Jy_eTV, Jz_eTV, Jx_em_Steuer, Jy_em_Steuer, Jz_em_Steuer, l_SEM, x_eTV, y_eTV, z_eTV, x_SEM, y_SEM, z_SEM, eTV_zaehlvariable] = ...
        set_two_speed_gear(Maximaldrehmoment,Nenndrehmoment,ueberlast,Eckdrehzahl,i_ges_1,i_ges_2,i_12_1, delta_M, differential,torque_vectoring, torque_splitter,d_motor,m_n_1,m_n_3,beta,b_d,d_geh,spalt,fspalt,sigma_fe,sigma_hlim,roh_geh,values_A,values_B,values_C,Fehlercode,Fehlerbit,neig_uebergabe,i_34,b_park,wunschbauraum,Optimierung_Getriebe, Optimierung_Gesamttopologie,roh_inn, vzkonst, eTV_zaehlvariable, d_TIR, Spurweite);
    %Vergleich der Sicherheiten in beiden Stufen zur Aufteilung der
    %Gesamtübersetzung
    %Unterschied in Flankentragfähigkeit und Fußtragfähigkeit überprüfen
    err_S_H(:,i)=abs(S_H_12_1-S_H_34)';
    err_S_F(:,i)=abs(S_F_12_1-S_F_34)';
    i=i+1;
    i_12_1=i_12_uebergabe-(0.1*(i-1));
    i_34=i_ges_1./i_12_1;
    if(i>11)
        break;
    end  
end

%minimale Abweichung bei den Sicherheiten ermitteln
err_sum=err_S_H+err_S_F;
for k=1:u
    min_err=min(err_sum(k,:));
    for j=1:11
        if(min_err==err_sum(k,j))
            i_12_1(k)=i_12_uebergabe(k)-(0.1*(j-1));
        end
    end
end
i_34=i_ges_1./i_12_1;


%Mit den Übersetzungen, für die die Sicherheiten in etwa gleich sind wird
%nun das Getriebe final ausgelegt.
Fehlerbit=zeros(1,u);
Fehlercode=cell(1,u);
for k=1:u
    if(Nenndrehmoment(k)>300|| Nenndrehmoment(k)<30)
        Fehlerbit(1,k)=1;
        Nenndrehmoment(k)=100;
        Fehlercode(1,k)={'Uebergabeparameter ungueltig: Nenndrehmoment zu gross. In der Berechnung ist ein Nenndrehmoment von max. 300 Nm vorgesehen'};
    elseif(i_ges_1(k) < 3.5 || i_ges_1(k) > 16)
        Fehlerbit(k)=1;
        i_12_1(k)=2;
        i_34(k)=2;
        Fehlercode(1,k)={'Uebergabeparameter ungueltig: Die Uebersetzungen liegen nicht im Fenster von 1.5 - 4.0.'};
    elseif(strcmp(Optimierung_Getriebe(1,k),'Länge')==0 && strcmp(Optimierung_Getriebe(1,k),'Höhe')==0 && strcmp(Optimierung_Getriebe(1,k),'Masse')==0 && strcmp(Optimierung_Getriebe(1,k),'Manual')==0)
        Fehlerbit(k)=1;
        Optimierung_Getriebe(1,k)={'Länge'};
        Fehlercode(1,k)={'Uebergabeparameter ungueltig: Die Getriebe-Optimierung kann nicht ausgeführt werden. Das Getriebe wurde nach der Länge optimiert'};
    elseif(Eckdrehzahl(1,k)>8000)
        Eckdrehzahl(1,k)=3500;
    end
end

eTV_zaehlvariable=1;  %eTV-Berechnung nur beim letzten Aufruf von set_gear_1_2_vec (Rechenzeitoptimierung)
%Funktionsaufruf für vollständiges Zweigang-Getriebe
    [ l_ges,h_ges,t_ges,m_ges,J_ges_antr_gang_1,J_ges_antr_gang_2,J_ges_abtr_gang_1,J_ges_abtr_gang_2,Fehlerbit,Fehlercode,d_a1_1,d_a1_2,d_a2_1,d_a2_2,d_a3,d_a4,b_1_1,b_1_2,b_3,z_1_1,z_1_2,z_2_1,z_2_2,z_3,z_4,S_H_12_1,S_H_12_2,S_H_34,S_F_12_1,S_F_12_2,S_F_34,d_1_1,d_1_2,d_2_1,d_2_2,d_3,d_4,alpha,zeta,d_motor,variante,gamma_1,gamma_2,gamma_3,gamma_1_B,gamma_2_B,d_1_g,d_2_g,d_4_g,gamma_3_B,m_A,m_B,m_C,m_D,m_E,m_F,i_12_1,i_12_2,i_34,epsilon_beta_1,epsilon_beta_2,epsilon_beta_3,epsilon_alpha_1,epsilon_alpha_2,epsilon_alpha_3,ID_A,ID_B,ID_C,ID_D,ID_E,ID_F,neig,ax_bauraum_schalt,rad_bauraum_schalt,m_z1_1,m_z1_2,m_z2_1,m_z2_2,m_z3,m_z4,m_w1,m_w2,m_korb,m_w4,m_kegelraeder,m_diff_stange,m_geh,alpha_wt_1_1,alpha_wt_1_2,alpha_wt_2, m_torque,m_torque_cost, m_Lagersitz, M_nenn_em_Steuer, n_nenn_em_Steuer, n_max_em_Steuer, typ_em_Steuer, M_max_Steuer, MaxMotorTrqCurve_w, MaxMotorTrqCurve_M, MaxGeneratorTrqCurve_w, MaxGeneratorTrqCurve_M, MotorEffMap3D, MotorEffMap3D_w, MotorEffMap3D_M, GeneratorEffMap3D, GeneratorEffMap3D_w, GeneratorEffMap3D_M, z1_I, z2_II, z1_III, z2_III, z2_IV, zP_I_II, zP_III_IV, zVTV_1, zVTV_2, zVTV_3, zVTV_4,i12_I, i12_II, i12_III, i12_IV, iVTV_1, iVTV_2, eta12_I, eta12_II, eta12_III, eta12_IV, etaVTV_12, etaVTV_34, Jred_EM_Steuer, m_eTV, m_em_Steuer,Jred_eTV, Jx_eTV, Jy_eTV, Jz_eTV, Jx_em_Steuer, Jy_em_Steuer, Jz_em_Steuer, l_SEM, x_eTV, y_eTV, z_eTV, x_SEM, y_SEM, z_SEM, eTV_zaehlvariable] = ...
        set_two_speed_gear(Maximaldrehmoment,Nenndrehmoment,ueberlast,Eckdrehzahl,i_ges_1,i_ges_2,i_12_1, delta_M, differential,torque_vectoring, torque_splitter,d_motor,m_n_1,m_n_3,beta,b_d,d_geh,spalt,fspalt,sigma_fe,sigma_hlim,roh_geh,values_A,values_B,values_C,Fehlercode,Fehlerbit,neig_uebergabe,i_34,b_park,wunschbauraum,Optimierung_Getriebe, Optimierung_Gesamttopologie,roh_inn, vzkonst, eTV_zaehlvariable, d_TIR, Spurweite);
    Fehlercode=Fehlercode{1,1};
if(isempty(Fehlercode))
    Fehlercode='Keine Fehler in der Berechnung';
end

ID_A=ID_A{1,1};
ID_B=ID_B{1,1};
ID_C=ID_C{1,1};
ID_D=ID_D{1,1};
ID_E=ID_E{1,1};
ID_F=ID_F{1,1};
end