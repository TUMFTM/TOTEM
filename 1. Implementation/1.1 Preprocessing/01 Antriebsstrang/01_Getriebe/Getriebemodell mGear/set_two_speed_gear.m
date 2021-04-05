function [ l_ges,h_ges,t_ges,m_ges,J_ges_antr_gang_1,J_ges_antr_gang_2,J_ges_abtr_gang_1,J_ges_abtr_gang_2,Fehlerbit,Fehlercode,d_a1_1,d_a1_2,d_a2_1,d_a2_2,d_a3,d_a4,b_1_1,b_1_2,b_3,z_1_1,z_1_2,z_2_1,z_2_2,z_3,z_4,S_H_12_1,S_H_12_2,S_H_34,S_F_12_1,S_F_12_2,S_F_34,d_1_1,d_1_2,d_2_1,d_2_2,d_3,d_4,alpha,zeta,d_motor,variante,gamma_1,gamma_2,gamma_3,gamma_1_B,gamma_2_B,d_1_g,d_2_g,d_4_g,gamma_3_B,m_A,m_B,m_C,m_D,m_E,m_F,i_12_1,i_12_2,i_34,epsilon_beta_1,epsilon_beta_2,epsilon_beta_3,epsilon_alpha_1,epsilon_alpha_2,epsilon_alpha_3,ID_A,ID_B,ID_C,ID_D,ID_E,ID_F,neig,ax_bauraum_schalt,rad_bauraum_schalt,m_z1_1,m_z1_2,m_z2_1,m_z2_2,m_z3,m_z4,m_w1,m_w2,m_korb,m_w4,m_kegelraeder,m_diff_stange,m_geh,alpha_wt_1_1,alpha_wt_1_2,alpha_wt_2, m_torque, m_torque_cost,m_Lagersitz, M_nenn_em_Steuer, n_nenn_em_Steuer, n_max_em_Steuer, typ_em_Steuer, M_max_Steuer, MaxMotorTrqCurve_w, MaxMotorTrqCurve_M, MaxGeneratorTrqCurve_w, MaxGeneratorTrqCurve_M, MotorEffMap3D, MotorEffMap3D_w, MotorEffMap3D_M, GeneratorEffMap3D, GeneratorEffMap3D_w, GeneratorEffMap3D_M, z1_I, z2_II, z1_III, z2_III, z2_IV, zP_I_II, zP_III_IV, zVTV_1, zVTV_2, zVTV_3, zVTV_4,i12_I, i12_II, i12_III, i12_IV, iVTV_1, iVTV_2, eta12_I, eta12_II, eta12_III, eta12_IV, etaVTV_12, etaVTV_34, Jred_EM_Steuer, m_eTV, m_em_Steuer,Jred_eTV, Jx_eTV, Jy_eTV, Jz_eTV, Jx_em_Steuer, Jy_em_Steuer, Jz_em_Steuer, l_SEM, x_eTV, y_eTV, z_eTV, x_SEM, y_SEM, z_SEM, eTV_zaehlvariable] ...
= set_two_speed_gear(Maximaldrehmoment,Nenndrehmoment,ueberlast,Eckdrehzahl,i_ges_1,i_ges_2,i_12_1, delta_M, differential,torque_vectoring, torque_splitter, d_motor,m_n_1,m_n_3,beta,b_d,d_geh,spalt,fspalt,sigma_fe,sigma_hlim,roh_geh,values_A,values_B,values_C,Fehlercode,Fehlerbit,neig_uebergabe,i_34,b_park,wunschbauraum,Optimierung_Getriebe, Optimierung_Gesamttopologie,roh_inn, vzkonst, eTV_zaehlvariable, d_TIR, Spurweite)
%Festsetzen eines Zweigang-Stirnradgetriebes in Abhängigkeit der inneren
%Übersetzungen
i_gears= [i_ges_1,i_ges_2];
[w,u]=size(Maximaldrehmoment);

%Benamung anpassen
T_max=Maximaldrehmoment;
T_nenn=Nenndrehmoment;
n_eck=Eckdrehzahl;

%Regression für Differential:::::::::::::::::::::::::::::::::::::::::::::::
d_korb=((0.0043*T_max.*i_ges_1))+70.9945+20;
b_korb=d_korb;
d_kegel=((0.0039*T_max.*i_ges_1))+54.6484;
b_kegel=((0.0014*T_max.*i_ges_1))+17.3580;
d_sh_4=d_kegel-(5*m_n_3);

%Festlegen der ersten und zweiten Welle....................................

[d_1_1,d_1_2,d_2_1,d_2_2,S_H_12_1,S_H_12_2,S_F_12_1,S_F_12_2,b_1_1,b_1_2,epsilon_beta_1,epsilon_beta_2,Fehlerbit,Fehlercode,d_3,d_4,S_H_34,S_F_34,epsilon_beta_3,b_3,lagerdaten_1,ID_A,ID_B,lagerdaten_2,ID_C,ID_D,F_u_3,F_rad_3,F_ax_3,d_inn_1,d_inn_2,d_a1_1,d_a1_2,d_a2_1,d_a2_2,z_1_1,z_1_2,z_2_1,z_2_2,z_3,z_4,epsilon_alpha_1,epsilon_alpha_2,epsilon_alpha_3,i_12_2,d_a3,d_a4,i_12_1,i_34,d_f2_1,d_f2_2,d_f1_1,d_f1_2,d_f3,d_f4,alpha_wt_1_1,alpha_wt_1_2,alpha_wt_2] = ...
    set_welle_1and2_two_speed(T_max,T_nenn,n_eck,m_n_1,m_n_3,b_d,beta,i_12_1,i_34,values_A,spalt,b_park,wunschbauraum,i_ges_1,i_ges_2,ueberlast,sigma_fe,sigma_hlim,d_korb,Fehlercode,Fehlerbit);

%Differential oder Torque-Splitter oder elektrisches Torque-Vectoring hinzufügen..................

if (differential==1)
    %Diff setzen
    m_torque=zeros(1,u);
    m_torque_cost=zeros(1,u);
    J_torque=zeros(1,u);
    l_torque=zeros(1,u);
    [ b_diff,d_diff,m_E,m_F,d_A_E,d_A_F,d_sh_E,d_sh_F,d_korb,b_korb,b_E,b_F,d_kegel,b_kegel,d_sh_4,l_3,d_1_E,d_1_F,Fehlerbit,Fehlercode,ID_E,ID_F] = set_diff(m_n_3,T_max,F_u_3,F_ax_3,F_rad_3,n_eck,d_4,b_3,i_12_1,i_34,values_B,Fehlerbit,Fehlercode,ueberlast,spalt,values_C,d_korb,b_korb,d_kegel,b_kegel);

elseif (torque_splitter==1)
    %Torque-Splitter Modul setzen
    [J_torque,l_torque,d_torque,m_torque,m_torque_cost,m_E,m_F,b_E,b_F,d_A_E,d_A_F,d_sh_E,d_sh_F,d_sh_4,d_1_E,d_1_F,Fehlerbit,Fehlercode,ID_E,ID_F] = set_torque_split(d_kegel,m_n_3,T_max,F_u_3,F_ax_3,F_rad_3,n_eck,d_4,b_3,i_12_1,i_34,values_B,Fehlerbit,Fehlercode,ueberlast,values_C,d_3,d_a2_1,T_nenn);
elseif (torque_vectoring==1 && eTV_zaehlvariable==1) %eTV-Berechnung nur beim letzten Aufruf von set_two_speed_gear (Rechenzeitoptimierung)
    % elektrisches Torque Vectoring festlegen.
    [M_nenn_em_Steuer, n_nenn_em_Steuer, n_max_em_Steuer, typ_em_Steuer, M_max_Steuer, ...
    MaxMotorTrqCurve_w, MaxMotorTrqCurve_M, MaxGeneratorTrqCurve_w, MaxGeneratorTrqCurve_M, ...
    MotorEffMap3D, MotorEffMap3D_w, MotorEffMap3D_M, GeneratorEffMap3D, GeneratorEffMap3D_w, ...
    GeneratorEffMap3D_M, z1_I, z2_II, z1_III, z2_III, z2_IV, zP_I_II, zP_III_IV, zVTV_1, zVTV_2, ... 
    zVTV_3, zVTV_4,i12_I, i12_II, i12_III, i12_IV, iVTV_1, iVTV_2, eta12_I, eta12_II, eta12_III, ...
    eta12_IV, etaVTV_12, etaVTV_34, Jred_EM_Steuer, m_eTV, m_em_Steuer,Jred_eTV, Jx_eTV, Jy_eTV, Jz_eTV, Jx_em_Steuer, ...
    Jy_em_Steuer, Jz_em_Steuer, l_SEM, x_eTV, y_eTV, z_eTV, x_SEM, y_SEM, z_SEM] = ...
    set_eTV(delta_M, d_4, b_3, vzkonst, Maximaldrehmoment, i_gears, Optimierung_Gesamttopologie, d_TIR, Spurweite);
    % Outputparameter bzw. Inputparameter für Subfunctions initialisieren 
    m_torque=zeros(1,u);m_torque_cost=zeros(1,u);J_torque=zeros(1,u);l_torque=zeros(1,u);b_diff=226.1;d_diff=229.4;m_E=0.519;m_F=0.922;d_A_E=105;d_A_F=115;d_sh_E=75;d_sh_F=75;d_korb=105.2;b_korb=105.2;b_E=20;b_F=25;d_kegel=67.5;b_kegel=22;d_sh_4=53.5;l_3=206.6;d_1_E=90.5;d_1_F=97.3;ID_E={'32915-'};ID_F={'32015-X'}; 
else
    [l_3,m_E,m_F,b_E,b_F,d_A_E,d_A_F,d_sh_E,d_sh_F,d_sh_4,d_1_E,d_1_F,Fehlerbit,Fehlercode,ID_E,ID_F] = set_bearings_achsnah( F_u_3,F_ax_3,F_rad_3,i_12_1,i_34,b_3,d_4,n_eck,values_B,Fehlerbit,Fehlercode,ueberlast,values_C,d_sh_4);
    m_torque=zeros(1,u);
    J_torque=zeros(1,u);
    l_torque=zeros(1,u);
    m_torque_cost=zeros(1,u);
end    
    if (torque_vectoring==0 || torque_vectoring==1 && eTV_zaehlvariable==0)% wenn  torque_vectoring==1, set_eTV nur beim letzten Aufruf von set_gear_1_2_vec (Rechenzeitoptimierung)
        % Wenn kein eTV vorhanden alle Werte zu 0 setzen bzw.
        M_nenn_em_Steuer=0; n_nenn_em_Steuer=0; n_max_em_Steuer=0; typ_em_Steuer=0; M_max_Steuer=0; ...
            MaxMotorTrqCurve_w=(1:201); MaxMotorTrqCurve_M=(1:201); MaxGeneratorTrqCurve_w=(1:201); MaxGeneratorTrqCurve_M=(1:201); ...
            MotorEffMap3D=(1:201)'*(1:101); MotorEffMap3D_w=(1:201); MotorEffMap3D_M=(1:101); GeneratorEffMap3D=(1:201)'*(1:101); GeneratorEffMap3D_w=(1:201); ...
            GeneratorEffMap3D_M=(1:101); z1_I=0; z2_II=0; z1_III=0; z2_III=0; z2_IV=0; zP_I_II=0; zP_III_IV=0; zVTV_1=0; zVTV_2=0; ...
            zVTV_3=0; zVTV_4=0;i12_I=0; i12_II=0; i12_III=0; i12_IV=0; iVTV_1=0; iVTV_2=0; eta12_I=0; eta12_II=0; eta12_III=0; ...
            eta12_IV=0; etaVTV_12=0; etaVTV_34=0; Jred_EM_Steuer=0; m_eTV=0;m_em_Steuer=0;Jred_eTV=0; Jx_eTV=0; Jy_eTV=0; Jz_eTV=0; Jx_em_Steuer=0; ...
            Jy_em_Steuer=0; Jz_em_Steuer=0; l_SEM=0; x_eTV=0; y_eTV=0; z_eTV=0; x_SEM=0; y_SEM=0; z_SEM=0;
            b_diff=226.1;d_diff=229.4;m_E=0.519;m_F=0.922;d_A_E=105;d_A_F=115;d_sh_E=75;d_sh_F=75;d_korb=105.2;b_korb=105.2;b_E=20;b_F=25;d_kegel=67.5;b_kegel=22;d_sh_4=53.5;l_3=206.6;d_1_E=90.5;d_1_F=97.3;ID_E={'32915-'};ID_F={'32015-X'};

    end



%..........................................................................
%Lagerdaten der ersten und zweiten Welle extrahieren
d_sh_A=lagerdaten_1(1,:);
d_sh_B=lagerdaten_1(2,:);
d_1_A=lagerdaten_1(3,:);
d_1_B=lagerdaten_1(4,:);
d_A_A=lagerdaten_1(5,:);
d_A_B=lagerdaten_1(6,:);
b_A=lagerdaten_1(7,:);
b_B=lagerdaten_1(8,:);
m_A=lagerdaten_1(9,:);
m_B=lagerdaten_1(10,:);

d_sh_C=lagerdaten_2(1,:);
d_sh_D=lagerdaten_2(2,:);
d_1_C=lagerdaten_2(3,:);
d_1_D=lagerdaten_2(4,:);
d_A_C=lagerdaten_2(5,:);
d_A_D=lagerdaten_2(6,:);
b_C=lagerdaten_2(7,:);
b_D=lagerdaten_2(8,:);
m_C=lagerdaten_2(9,:);
m_D=lagerdaten_2(10,:);

%Breite der inneren Komponenten berechnen:
t_1_links=b_A+spalt+b_1_1+spalt+wunschbauraum; %Welle 1
t_2_links=b_B+spalt+b_1_1+spalt+wunschbauraum; %Welle 2
if(differential==1)
    t_3_links=b_E+b_korb; %Welle 3
elseif(torque_splitter==1)
    t_3_links=b_E+(l_torque-(b_3./2));
else
    t_3_links=b_E+spalt;
end
t_1_rechts=b_B+spalt+b_1_2+spalt+b_3; %Welle 1
t_2_rechts=b_D+spalt+b_1_2+spalt+b_3; %Welle 2
if(differential==1)
    t_3_rechts=b_F+spalt+b_3; %Welle 3
elseif(torque_splitter==1)
    t_3_rechts=b_F+(l_torque-(b_3./2))+b_3;
else
    t_3_rechts=b_F+spalt+b_3;
end
t_links_rel=zeros(1,u);
t_rechts_rel=zeros(1,u);
t_ges_inn=zeros(1,u);
for k=1:u
    arr_links=[t_1_links(k) t_2_links(k) t_3_links(k)];
    t_links_rel(k)=max(arr_links);
    arr_rechts=[t_1_rechts(k) t_2_rechts(k) t_3_rechts(k)];
    t_rechts_rel(k)=max(arr_rechts);
    t_ges_inn(k)=t_links_rel(k)+t_rechts_rel(k);
end

%Neigungswinkel aus Getriebe-Optimierungsziel bestimmen..............................
[ neig,Fehlerbit,Fehlercode] = calc_neig_two_speed( d_motor,Optimierung_Getriebe,d_1_1,d_1_2,d_2_1,d_2_2,d_3,d_4,d_sh_4,Fehlerbit,Fehlercode,d_A_A,d_A_B,m_A,m_B,m_C,m_D,m_E,m_F,b_1_1,b_1_2,b_3,spalt,d_kegel,b_kegel,d_sh_A,d_sh_B,d_sh_C,d_sh_D,d_sh_E,d_sh_F,b_A,b_B,b_C,b_D,b_E,b_F,d_A_C,d_A_D,d_A_E,d_A_F,fspalt,d_inn_1,d_inn_2,d_f2_1,d_f2_2,d_f4,m_n_1,m_n_3,d_1_C,d_1_D,d_1_F,d_korb,neig_uebergabe,roh_inn,roh_geh,d_geh,t_1_links,t_2_links,t_3_links,t_1_rechts,t_2_rechts,t_3_rechts,t_ges_inn,differential,torque_vectoring,torque_splitter,m_torque,m_eTV);

%Getriebeabmessungen berechnen:............................................
%Berechnung der inneren Abmessungen:_______________________________________
l_ges=zeros(1,u);
h_ges=zeros(1,u);
wert=zeros(1,u);
alpha=zeros(1,u);
zeta=zeros(1,u);

for k=1:u
    %Ist Lager oder Ritzel größer?
    arr=[d_1_1(k)+(2*fspalt) d_1_2(k)+(2*fspalt) d_A_A(k)+10 d_A_B(k)+10];
    wert(k)=max(arr);
    
    alpha(k)=neig(k)*pi/180;
    x=(d_1_1(k)/2)+(d_2_1(k)/2);
    y=(d_4(k)/2)+(d_3(k)/2);

    zeta(k)=asin((x/y)*sin(alpha(k)));
    z=(x*cos(alpha(k)))+(y*cos(zeta(k)));
 
    l_ges(k)=(wert(k)/2)+(d_4(k)/2)+z;
    if(((d_2_1(k)/2)+(x*sin(alpha(k))))>(d_4(k)/2))     
        h_ges(k)=(d_2_1(k)/2)+(d_4(k)/2)+x*sin(alpha(k));
    else
        h_ges(k)=d_4(k);
    end
end

%Gehäuse aufaddieren:______________________________________________________
t_ges=zeros(1,u);
for k=1:u
    if(wert(k)==d_1_1(k)+(2*fspalt) || wert(k)==d_1_2(k)+(2*fspalt))
        l_ges(k)=l_ges(k)+(2*fspalt)+(2*d_geh); 
    else
        l_ges(k)=l_ges(k)+(2*d_geh);%Falls das Lager den durchmesser bestimmt muss keine Abstand zur gehäusewand eingehalten werden
    end
    h_ges(k)=h_ges(k)+(2*fspalt)+(2*d_geh);
    t_ges(k)=t_ges_inn(k)+(2*d_geh); %in der Tiefe wird nur die Gehäusestärke auf beiden Seiten aufaddiert, da Lager im Gehäuse sitzen
end

%Berechnung der gesamten Masse.............................................
[ m_ges,d_stange,abstand_A,abstand_B,abstand_C,abstand_D,abstand_E,abstand_F,roh_inn,d_geh,variante,gamma_1,gamma_2,gamma_3,gamma_1_B,gamma_2_B,d_1_g,d_2_g,d_4_g,gamma_3_B,m_z1_1,m_z1_2,m_z2_1,m_z2_2,m_z3,m_z4,m_w1,m_w2,m_korb,m_w4,m_kegelraeder,m_diff_stange,m_geh, m_Lagersitz] = ...
    set_mass_two_speed_gear(m_A,m_B,m_C,m_D,m_E,m_F,d_1_1,d_1_2,d_2_1,d_2_2,d_3,d_4,b_1_1,b_1_2,b_3,spalt,d_kegel,b_kegel,d_sh_A,d_sh_B,d_sh_C,d_sh_D,d_sh_E,d_sh_F,d_sh_4,alpha,zeta,b_A,b_B,b_C,b_D,b_E,b_F,d_A_A,d_A_B,d_A_C,d_A_D,d_A_E,d_A_F,fspalt,d_inn_1,d_inn_2,d_f2_1,d_f2_2,d_f4,m_n_1,m_n_3,d_1_C,d_1_D,d_1_F,d_korb,Optimierung_Getriebe,roh_inn,roh_geh,d_geh,t_ges_inn,t_1_links,t_2_links,t_3_links,t_1_rechts,t_2_rechts,t_3_rechts,differential,torque_vectoring,torque_splitter,m_torque, m_eTV);

%Berechnung der Trägheitsmomente...........................................
[ J_ges_antr_gang_1,J_ges_antr_gang_2,J_ges_abtr_gang_1,J_ges_abtr_gang_2 ] = calc_J_two_speed( spalt,abstand_A,abstand_E,abstand_F,d_geh,roh_inn,d_sh_4,d_stange,d_kegel,b_kegel,b_A,d_sh_A,d_1_A,b_B,d_sh_B,d_1_B,b_C,d_sh_C,d_1_C,b_D,d_sh_D,d_1_D,b_E,d_sh_E,d_1_E,b_F,d_sh_F,d_1_F,i_12_1,i_12_2,i_34,d_1_1,d_1_2,d_2_1,d_2_2,d_3,d_4,b_1_1,b_1_2,b_3,d_inn_1,d_inn_2,m_n_1,m_n_3,d_f2_1,d_f2_2,d_f4,d_korb,differential,torque_splitter,J_torque,l_torque);

%Ermittlung des verfügbaren Bauraums für das Schaltmodul und
%Torque-Vectoring-Modul
ax_bauraum_schalt=t_ges-(2*d_geh)-b_A-b_B-spalt-spalt-b_1_1-b_1_2-abstand_A-abstand_B;
rad_bauraum_schalt=d_1_g;

end

