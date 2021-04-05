function [l_ges,h_ges,t_ges,m_ges,J_ges_antr,J_ges_abtr,Fehlerbit,Fehlercode,d_a1,d_a2,d_a3,d_a4,b_1,b_3,z_1,z_2,z_3,z_4,S_H_12,S_H_34,S_F_12,S_F_34,d_1,d_2,d_3,d_4,...
    alpha,zeta,d_motor,variante,gamma_1,gamma_2,gamma_3,gamma_1_B,gamma_2_B,d_1_g,d_2_g,d_4_g,gamma_3_B,m_A,m_B,m_C,m_D,m_E,m_F,i_12,i_34,epsilon_beta_12,epsilon_beta_34,...
    epsilon_alpha_12,epsilon_alpha_34,ID_A,ID_B,ID_C,ID_D,ID_E,ID_F,neig,m_z1,m_z23,m_z4,m_korb,m_diff_stange,m_kegelraeder,m_geh,m_w1,m_w2,m_w4,alpha_wt_1,alpha_wt_2, ...
    m_torque,m_torque_cost, m_Lagersitz, M_nenn_em_Steuer, n_nenn_em_Steuer, n_max_em_Steuer, typ_em_Steuer, M_max_Steuer, MaxMotorTrqCurve_w, MaxMotorTrqCurve_M, MaxGeneratorTrqCurve_w, ...
    MaxGeneratorTrqCurve_M, MotorEffMap3D, MotorEffMap3D_w, MotorEffMap3D_M, GeneratorEffMap3D, GeneratorEffMap3D_w, GeneratorEffMap3D_M, z1_I, z2_II, z1_III, z2_III, z2_IV, ...
    zP_I_II, zP_III_IV, zVTV_1, zVTV_2, zVTV_3, zVTV_4,i12_I, i12_II, i12_III, i12_IV, iVTV_1, iVTV_2, eta12_I, eta12_II, eta12_III, eta12_IV, etaVTV_12, etaVTV_34, ...
    Jred_EM_Steuer, m_eTV, m_em_Steuer,Jred_eTV, Jx_eTV, Jy_eTV, Jz_eTV, Jx_em_Steuer, Jy_em_Steuer, Jz_em_Steuer, l_SEM, x_eTV, y_eTV, z_eTV, x_SEM, y_SEM, z_SEM, eTV_zaehlvariable] = ...
    set_gear_1_2_vec(Maximaldrehmoment,Nenndrehmoment,i_12,i_34,Eckdrehzahl, Optimierung_Getriebe, Optimierung_Gesamttopologie,Fehlerbit,Fehlercode,values_A,values_B,values_C,d_motor,neig_uebergabe,sigma_fe,sigma_hlim,roh_inn, delta_M, differential,torque_vectoring, torque_splitter, vzkonst, Gesamtuebersetzung, eTV_zaehlvariable, d_TIR, Spurweite)

%Bestimmung der Hauptabmessungen eines zweistufeigen Stirnradgetriebes
%Uebergabevariablen anpassen:
T_nenn=Nenndrehmoment;
[w,u]=size(T_nenn);
n_eck=Eckdrehzahl;
%Überlastfaktor aus Motortyp ermitteln:
ueberlast=Maximaldrehmoment./T_nenn;
T_max=Maximaldrehmoment;
%__________________________________________________________________________
%Verzahnungsgrößen festlegen
m_n_1=2.4;
m_n_3=2.8;
beta=20*pi/180;
b_d=0.65;
%__________________________________________________________________________
%Spaltmaße festlegen zwischen Ritzel und Lagersitzen auf 1. und 2. Welle
spalt=3;
%Spaltmaß zwischen Ritze/Rad und Gehäuse
fspalt=10;
d_geh=5;
b_park=13;

%Empirische Daten Differential:____________________________________________
%Korbabmessungen aus empirischen Daten
d_korb=((0.0043*T_max.*i_12).*i_34)+70.9945+20;
b_korb=d_korb;

%Kegelraddurchmesser empirisch ermittelt
d_kegel=((0.0039*T_max.*i_12).*i_34)+54.6484;
d_sh_4=d_kegel-(5*m_n_3);

%Breite des Kegelrads:
b_kegel=((0.0014*T_max.*i_12).*i_34)+17.3580;

%__________________________________________________________________________


%Hauptabmessungen festlegen:_______________________________________________
[ b_1,d_1,d_2,b_3,d_3,d_4,b_d,Fehlerbit] = calculate_b_d_new_vec( T_max,i_12,i_34,b_d,Fehlerbit);

%Definieren der ersten Welle:______________________________________________
[ alpha_wt_1,S_F_12,S_H_12,d_A_A,d_A_B,b_A,b_B,b_1,d_1,d_2,i_12 ,z_1,z_2,d_a1,d_a2,m_A,m_B,d_sh_A,d_sh_B,d_1_A,d_1_B,d_inn_1,Fehlerbit,Fehlercode,d_f1,d_f2,epsilon_beta_12,epsilon_alpha_12,ID_A,ID_B] = ...
    set_welle_1_new_vec( T_max,T_nenn,n_eck,m_n_1,d_1,d_2,b_1,i_12,b_d,spalt,beta,values_A,Fehlerbit,Fehlercode,ueberlast,sigma_fe,sigma_hlim);

%Definieren der  zweiten Welle:____________________________________________
[ alpha_wt_2, S_F_34,S_H_34,d_A_C,d_A_D,b_C,b_D,b_3,d_3,d_4,i_34 ,z_3,z_4,F_u_3_vec,F_ax_3_vec,F_rad_3_vec,d_a3,d_a4,m_C,m_D,d_sh_C,d_sh_D,d_1_C,d_1_D,d_inn_2,Fehlerbit,Fehlercode,d_f3,d_f4,epsilon_beta_34,epsilon_alpha_34,ID_C,ID_D] = ...
    set_welle_2_new_vec( T_max,T_nenn,n_eck,m_n_3,i_12,i_34,d_1,d_2,d_3,d_4,b_1,b_3,b_d,spalt,beta,values_A,Fehlerbit,Fehlercode,ueberlast,sigma_fe,sigma_hlim);

    
if (torque_vectoring==0 || torque_vectoring==1 && eTV_zaehlvariable==0) % torque_vectoring==1, set_eTV nur beim letzten Aufruf von set_gear_1_2_vec ausführen (Rechenzeitoptimierung)
    % Wenn kein eTV vorhanden alle Werte initialisieren
    M_nenn_em_Steuer=0; n_nenn_em_Steuer=0; n_max_em_Steuer=0; typ_em_Steuer=0; M_max_Steuer=0; ...
        MaxMotorTrqCurve_w=(1:201); MaxMotorTrqCurve_M=(1:201); MaxGeneratorTrqCurve_w=(1:201); MaxGeneratorTrqCurve_M=(1:201); ...
        MotorEffMap3D=(1:201)'*(1:101); MotorEffMap3D_w=(1:201); MotorEffMap3D_M=(1:101); GeneratorEffMap3D=(1:201)'*(1:101); GeneratorEffMap3D_w=(1:201); ...
        GeneratorEffMap3D_M=(1:101); z1_I=0; z2_II=0; z1_III=0; z2_III=0; z2_IV=0; zP_I_II=0; zP_III_IV=0; zVTV_1=0; zVTV_2=0; ...
        zVTV_3=0; zVTV_4=0;i12_I=0; i12_II=0; i12_III=0; i12_IV=0; iVTV_1=0; iVTV_2=0; eta12_I=0; eta12_II=0; eta12_III=0; ...
        eta12_IV=0; etaVTV_12=0; etaVTV_34=0; Jred_EM_Steuer=0; m_eTV=0; m_em_Steuer=0;Jred_eTV=0; Jx_eTV=0; Jy_eTV=0; Jz_eTV=0; Jx_em_Steuer=0; ...
        Jy_em_Steuer=0; Jz_em_Steuer=0; l_SEM=0; x_eTV=0; y_eTV=0; z_eTV=0; x_SEM=0; y_SEM=0; z_SEM=0;
        m_torque=zeros(1,u);m_torque_cost=zeros(1,u);J_torque=zeros(1,u);l_torque=zeros(1,u);b_diff=226.1;d_diff=229.4;m_E=0.519;m_F=0.922;d_A_E=105;d_A_F=115;d_sh_E=75;d_sh_F=75;d_korb=105.2;b_korb=105.2;b_E=20;b_F=25;d_kegel=67.5;b_kegel=22;d_sh_4=53.5;l_3=206.6;d_1_E=90.5;d_1_F=97.3;ID_E={'32915-'};ID_F={'32015-X'};

end

%Achsnahe Getriebe-Ausschließen
if(differential==1 || torque_vectoring==1 || torque_splitter==1)
    
    %Differential oder Troque-Vectoring:_______________________________________
    if(differential==1)
        %Differential festlegen:___________________________________________________
    [ b_diff,d_diff,m_E,m_F,d_A_E,d_A_F,d_sh_E,d_sh_F,d_korb,b_korb,b_E,b_F,d_kegel,b_kegel,d_sh_4,l_3,d_1_E,d_1_F,Fehlerbit,Fehlercode,ID_E,ID_F] = ...
        set_diff(m_n_3,T_max,F_u_3_vec,F_ax_3_vec,F_rad_3_vec,n_eck,d_4,b_3,i_12,i_34,values_B,Fehlerbit,Fehlercode,ueberlast,spalt,values_C,d_korb,b_korb,d_kegel,b_kegel);
    torque_splitter=0;
    m_torque=0;
    l_torque=0;
    J_torque=0;   
    m_torque_cost=0;
    elseif(torque_splitter==1) 
        %Torque-Splitter festlegen:
        [J_torque,l_torque,d_torque,m_torque,m_torque_cost,m_E,m_F,b_E,b_F,d_A_E,d_A_F,d_sh_E,d_sh_F,d_sh_4,d_1_E,d_1_F,Fehlerbit,Fehlercode,ID_E,ID_F] = ...
            set_torque_split(d_kegel,m_n_3,T_max,F_u_3_vec,F_ax_3_vec,F_rad_3_vec,n_eck,d_4,b_3,i_12,i_34,values_B,Fehlerbit,Fehlercode,ueberlast,values_C,d_3,d_a2,T_nenn);
        b_diff=0; M_nenn_em_Steuer=0; n_nenn_em_Steuer=0; n_max_em_Steuer=0;
    
    elseif (torque_vectoring==1 && eTV_zaehlvariable==1) %eTV-Berechnung nur beim letzten Aufruf von set_gear_1_2_vec (Rechenzeitoptimierung)
        % elektrisches Torque Vectoring festlegen.
        [M_nenn_em_Steuer, n_nenn_em_Steuer, n_max_em_Steuer, typ_em_Steuer, M_max_Steuer, ...
            MaxMotorTrqCurve_w, MaxMotorTrqCurve_M, MaxGeneratorTrqCurve_w, MaxGeneratorTrqCurve_M, ...
            MotorEffMap3D, MotorEffMap3D_w, MotorEffMap3D_M, GeneratorEffMap3D, GeneratorEffMap3D_w, ...
            GeneratorEffMap3D_M, z1_I, z2_II, z1_III, z2_III, z2_IV, zP_I_II, zP_III_IV, zVTV_1, zVTV_2, ...
            zVTV_3, zVTV_4,i12_I, i12_II, i12_III, i12_IV, iVTV_1, iVTV_2, eta12_I, eta12_II, eta12_III, ...
            eta12_IV, etaVTV_12, etaVTV_34, Jred_EM_Steuer, m_eTV, m_em_Steuer,Jred_eTV, Jx_eTV, Jy_eTV, Jz_eTV, Jx_em_Steuer, ...
            Jy_em_Steuer, Jz_em_Steuer, l_SEM, x_eTV, y_eTV, z_eTV, x_SEM, y_SEM, z_SEM] = ...
            set_eTV(delta_M, d_4, b_3, vzkonst, Maximaldrehmoment, Gesamtuebersetzung,  Optimierung_Gesamttopologie, d_TIR, Spurweite);
           
            % Outputparameter bzw. Inputparameter für Subfunctions initialisieren
             m_torque=zeros(1,u);m_torque_cost=zeros(1,u);J_torque=zeros(1,u);l_torque=zeros(1,u);b_diff=226.1;d_diff=229.4;m_E=0.519;m_F=0.922;d_A_E=105;d_A_F=115;d_sh_E=75;d_sh_F=75;d_korb=105.2;b_korb=105.2;b_E=20;b_F=25;d_kegel=67.5;b_kegel=22;d_sh_4=53.5;l_3=206.6;d_1_E=90.5;d_1_F=97.3;ID_E={'32915-'};ID_F={'32015-X'};
    end


    %__________________________________________________________________________
    %Getriebetiefe berechnen:__________________________________________________
    t_ges=zeros(1,u);
    t_1_rechts=zeros(1,u);
    t_1_links=zeros(1,u);
    t_2_rechts=zeros(1,u);
    t_2_links=zeros(1,u);
    t_3_rechts=zeros(1,u);
    t_3_links=zeros(1,u);
    t_links_rel=zeros(1,u);
    t_rechts_rel=zeros(1,u);
    for k=1:u
        %Tiefe berechnen
        t_1_links(k)=b_A(k)+spalt+b_park+spalt+b_1(k);
        t_1_rechts(k)=spalt+b_B(k);
        t_2_links(k)=b_C(k)+spalt+b_1(k);
        t_2_rechts(k)=b_3(k)+spalt+b_D(k);
        if(differential==1)
            t_3_links(k)=b_E(k)+b_korb(k);
            t_3_rechts(k)=b_3(k)+spalt+b_F(k);
        elseif(torque_splitter==1)
            t_3_links(k)=b_E(k)+l_torque-(b_3(k)/2);
            t_3_rechts(k)=b_3(k)+(l_torque-b_3(k)/2)+b_F(k);
        end
     t_links_arr=[t_1_links(k) t_2_links(k) t_3_links(k)];
     t_links_rel(k)=max(t_links_arr);
        t_rechts_arr=[t_1_rechts(k) t_2_rechts(k) t_3_links(k)];
        t_rechts_rel(k)=max(t_rechts_arr);
        t_ges(k)=(2*d_geh)+t_links_rel(k)+t_rechts_rel(k);

    end
    %__________________________________________________________________________
    %Berechnung der Wellenanordnung je nach Einbauart:_________________________
    [neig,Fehlerbit,Fehlercode] = calc_neig(d_motor,Optimierung_Getriebe,d_1,d_2,d_3,d_4,d_sh_4,Fehlerbit,Fehlercode,d_A_A,d_A_B,m_A,m_B,m_C,m_D,m_E,m_F,b_1,b_3,spalt,d_kegel,b_kegel,d_sh_A,d_sh_B,d_sh_C,d_sh_D,d_sh_E,d_sh_F,b_korb,b_A,b_B,b_C,b_D,b_E,b_F,d_A_C,d_A_D,d_A_E,d_A_F,fspalt,d_inn_1,d_inn_2,d_f2,d_f4,m_n_3,d_1_C,d_1_D,d_1_F,d_korb,neig_uebergabe,roh_inn,differential,torque_vectoring,torque_splitter,m_torque,m_eTV,l_torque,t_links_rel,t_1_links,t_2_links,t_3_links,t_rechts_rel,t_1_rechts,t_2_rechts,t_3_rechts,t_ges);

    %Berechnung der Abmessungen:______________________________________________
    l_ges=zeros(1,u);
    h_ges=zeros(1,u);
    wert=zeros(1,u);
    alpha=zeros(1,u);
    zeta=zeros(1,u);

    for k=1:u
        %Ist Lager oder Ritzel größer?
        arr=[d_1(k) d_A_A(k) d_A_B(k)];
        wert(k)=max(arr);
    
        alpha(k)=neig(k)*pi/180;
        x=(d_1(k)/2)+(d_2(k)/2);
        y=(d_4(k)/2)+(d_3(k)/2);

        zeta(k)=asin((x/y)*sin(alpha(k)));
        z=(x*cos(alpha(k)))+(y*cos(zeta(k)));
 
        l_ges(k)=(wert(k)/2)+(d_4(k)/2)+z;
        if(((d_2(k)/2)+(x*sin(alpha(k))))>(d_4(k)/2))     
            h_ges(k)=(d_2(k)/2)+(d_4(k)/2)+x*sin(alpha(k));
        else
            h_ges(k)=d_4(k);
        end
    end

    %Gehäuse aufaddieren:______________________________________________________
    for k=1:u
        %Länge und Höhe
        if(wert(k)==d_1(k))
            l_ges(k)=l_ges(k)+(2*fspalt)+(2*d_geh); %10mm abstand zur Verzahnung + 5mm Gehäusestärke
        else
            l_ges(k)=l_ges(k)+(2*d_geh);%Falls das Lager den durchmesser bestimmt muss keine Abstand zur gehäusewand eingehalten werden
        end
        h_ges(k)=h_ges(k)+(2*fspalt)+(2*d_geh);
    end

    %Gewicht berechnen:________________________________________________________
    [m_ges,d_stange,abstand_A,roh_inn,d_geh,variante,gamma_1,gamma_2,gamma_3,gamma_1_B,gamma_2_B,d_1_g,d_2_g,d_4_g,gamma_3_B,m_z1,m_z23,m_z4,m_korb, m_diff_stange,m_kegelraeder,m_geh,m_w1,m_w2,m_w4, m_Lagersitz] = ...
        set_mass(m_A,m_B,m_C,m_D,m_E,m_F,d_1,d_2,d_3,d_4,b_1,b_3,spalt,d_kegel,b_kegel,d_sh_A,d_sh_B,d_sh_C,d_sh_D,d_sh_E,d_sh_F,d_sh_4,alpha,zeta,b_korb,b_A,b_B,b_C,b_D,b_E,b_F,d_A_A,d_A_B,d_A_C,d_A_D,d_A_E,d_A_F,wert,fspalt,d_inn_1,d_inn_2,d_f2,d_f4,m_n_3,d_1_C,d_1_D,d_1_F,d_korb,t_ges,Optimierung_Getriebe,roh_inn,differential,torque_vectoring,torque_splitter,m_torque,m_eTV,l_torque,t_links_rel,t_1_links,t_2_links,t_3_links,t_rechts_rel,t_1_rechts,t_2_rechts,t_3_rechts);
    %Trägheitsmoment berechnen:________________________________________________
    [J_ges_antr,J_ges_abtr] = calc_J( spalt,abstand_A,d_geh,roh_inn,d_sh_4,d_stange,d_kegel,b_kegel,b_A,d_sh_A,d_1_A,b_B,d_sh_B,d_1_B,b_C,d_sh_C,d_1_C,b_D,d_sh_D,d_1_D,b_E,d_sh_E,d_1_E,b_F,d_sh_F,d_1_F,i_12,i_34,d_1,d_2,d_3,d_4,b_1,b_3,d_inn_1,d_inn_2,m_n_3,d_f2,d_f4,d_korb,differential,torque_splitter,J_torque,t_links_rel,t_1_links,t_2_links,t_3_links,t_rechts_rel,t_1_rechts,t_2_rechts,t_3_rechts);
else
    m_torque=0;
    l_torque=0;
    J_torque=0;
    m_torque_cost=0;
    %Achsnahes Getriebe fertig gestalten
        %Lager der dritten Welle festlegen
        [ l_3,m_E,m_F,b_E,b_F,d_A_E,d_A_F,d_sh_E,d_sh_F,d_sh_4,d_1_E,d_1_F,Fehlerbit,Fehlercode,ID_E,ID_F] = set_bearings_achsnah( F_u_3_vec,F_ax_3_vec,F_rad_3_vec,i_12,i_34,b_3,d_4,n_eck,values_B,Fehlerbit,Fehlercode,ueberlast,values_C,d_sh_4);
        %Getriebetiefe ermitteln
        t_ges=zeros(1,u);
        t_1_rechts=zeros(1,u);
        t_1_links=zeros(1,u);
        t_2_rechts=zeros(1,u);
        t_2_links=zeros(1,u);
        t_3_rechts=zeros(1,u);
        t_3_links=zeros(1,u);
        t_links_rel=zeros(1,u);
        t_rechts_rel=zeros(1,u);
        for k=1:u
            t_1_links(k)=spalt+b_A(k)+b_1(k);
            t_2_links(k)=spalt+b_C(k)+b_1(k);
            t_3_links(k)=b_E(k)+spalt;
            t_1_rechts(k)=b_B(k)+spalt;
            t_2_rechts(k)=b_D(k)+spalt+b_3(k);
            t_3_rechts(k)=b_F(k)+spalt+b_3(k);
            t_links_rel(k)=max([t_1_links(k) t_2_links(k) t_3_links(k)]);
            t_rechts_rel(k)=max([t_1_rechts(k) t_2_rechts(k) t_3_rechts(k)]);
            t_ges(k)=(2*d_geh)+t_links_rel(k)+t_rechts_rel(k);
        end
        %Neigungswinkel berechnen
        [neig,Fehlerbit,Fehlercode] = calc_neig(d_motor,Optimierung_Getriebe,d_1,d_2,d_3,d_4,d_sh_4,Fehlerbit,Fehlercode,d_A_A,d_A_B,m_A,m_B,m_C,m_D,m_E,m_F,b_1,b_3,spalt,d_kegel,b_kegel,d_sh_A,d_sh_B,d_sh_C,d_sh_D,d_sh_E,d_sh_F,b_korb,b_A,b_B,b_C,b_D,b_E,b_F,d_A_C,d_A_D,d_A_E,d_A_F,fspalt,d_inn_1,d_inn_2,d_f2,d_f4,m_n_3,d_1_C,d_1_D,d_1_F,d_korb,neig_uebergabe,roh_inn,differential,torque_vectoring,torque_splitter,m_torque,m_eTV,l_torque,t_links_rel,t_1_links,t_2_links,t_3_links,t_rechts_rel,t_1_rechts,t_2_rechts,t_3_rechts,t_ges);
        %Berechnung der Abmessungen:______________________________________________
        l_ges=zeros(1,u);
        h_ges=zeros(1,u);
        wert=zeros(1,u);
        alpha=zeros(1,u);
        zeta=zeros(1,u);

        for k=1:u
            %Ist Lager oder Ritzel größer?
            arr=[d_1(k) d_A_A(k) d_A_B(k)];
            wert(k)=max(arr);
    
            alpha(k)=neig(k)*pi/180;
            x=(d_1(k)/2)+(d_2(k)/2);
            y=(d_4(k)/2)+(d_3(k)/2);

            zeta(k)=asin((x/y)*sin(alpha(k)));
            z=(x*cos(alpha(k)))+(y*cos(zeta(k)));
 
            l_ges(k)=(wert(k)/2)+(d_4(k)/2)+z;
            if(((d_2(k)/2)+(x*sin(alpha(k))))>(d_4(k)/2))     
                h_ges(k)=(d_2(k)/2)+(d_4(k)/2)+x*sin(alpha(k));
            else
                h_ges(k)=d_4(k);
            end
        end

        %Gehäuse aufaddieren:______________________________________________________
        for k=1:u
        %Länge und Höhe
            if(wert(k)==d_1(k))
                l_ges(k)=l_ges(k)+(2*fspalt)+(2*d_geh); %10mm abstand zur Verzahnung + 5mm Gehäusestärke
            else
                l_ges(k)=l_ges(k)+(2*d_geh);%Falls das Lager den durchmesser bestimmt muss keine Abstand zur gehäusewand eingehalten werden
            end
            h_ges(k)=h_ges(k)+(2*fspalt)+(2*d_geh);
        end
        
        %Masse Berechnen
        [ m_ges,d_stange,abstand_A,roh_inn,d_geh,variante,gamma_1,gamma_2,gamma_3,gamma_1_B,gamma_2_B,d_1_g,d_2_g,d_4_g,gamma_3_B,m_z1,m_z23,m_z4,m_korb,m_diff_stange,m_kegelraeder,m_geh,m_w1,m_w2,m_w4, m_Lagersitz] = ...
            set_mass(m_A,m_B,m_C,m_D,m_E,m_F,d_1,d_2,d_3,d_4,b_1,b_3,spalt,d_kegel,b_kegel,d_sh_A,d_sh_B,d_sh_C,d_sh_D,d_sh_E,d_sh_F,d_sh_4,alpha,zeta,b_korb,b_A,b_B,b_C,b_D,b_E,b_F,d_A_A,d_A_B,d_A_C,d_A_D,d_A_E,d_A_F,wert,fspalt,d_inn_1,d_inn_2,d_f2,d_f4,m_n_3,d_1_C,d_1_D,d_1_F,d_korb,t_ges,Optimierung_Getriebe,roh_inn,differential,torque_vectoring,torque_splitter,m_torque,m_eTV,l_torque,t_links_rel,t_1_links,t_2_links,t_3_links,t_rechts_rel,t_1_rechts,t_2_rechts,t_3_rechts);
        %Trägheitsmoment berechnen
        [J_ges_antr,J_ges_abtr] = calc_J( spalt,abstand_A,d_geh,roh_inn,d_sh_4,d_stange,d_kegel,b_kegel,b_A,d_sh_A,d_1_A,b_B,d_sh_B,d_1_B,b_C,d_sh_C,d_1_C,b_D,d_sh_D,d_1_D,b_E,d_sh_E,d_1_E,b_F,d_sh_F,d_1_F,i_12,i_34,d_1,d_2,d_3,d_4,b_1,b_3,d_inn_1,d_inn_2,m_n_3,d_f2,d_f4,d_korb,differential,torque_splitter,J_torque,t_links_rel,t_1_links,t_2_links,t_3_links,t_rechts_rel,t_1_rechts,t_2_rechts,t_3_rechts);
        
        
end

