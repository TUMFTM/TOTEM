function [d_1_1,d_1_2,d_2_1,d_2_2,S_H_12_1,S_H_12_2,S_F_12_1,S_F_12_2,b_1_1,b_1_2,epsilon_beta_1,epsilon_beta_2,Fehlerbit,Fehlercode,d_3,d_4,S_H_34,S_F_34,epsilon_beta_3,b_3,lagerdaten_1,ID_A,ID_B,lagerdaten_2,ID_C,ID_D,F_u_3,F_rad_3,F_ax_3,d_inn_1,d_inn_2,d_a1_1,d_a1_2,d_a2_1,d_a2_2,z_1_1,z_1_2,z_2_1,z_2_2,z_3,z_4,epsilon_alpha_1,epsilon_alpha_2,epsilon_alpha_3,i_12_2,d_a3,d_a4,i_12_1,i_34,d_f2_1,d_f2_2,d_f1_1,d_f1_2,d_f3,d_f4,alpha_wt_1_1,alpha_wt_1_2,alpha_wt_2] = set_welle_1and2_two_speed(T_max,T_nenn,n_eck,m_n_1,m_n_3,b_d,beta,i_12_1,i_34,values_A,spalt,b_park,wunschbauraum,i_ges_1,i_ges_2,ueberlast,sigma_fe,sigma_hlim,d_korb,Fehlercode,Fehlerbit)
%Setzt die erste und zweite Welle des 2-Gang-Getriebes fest
[n,u]=size(T_max);

%Überschlägig Achsabstände und Teilkreisdurchmesser für ersten Gang bestimmen.
[ b_1_1,d_1_1,d_2_1,b_3,d_3,d_4,b_d,Fehlerbit] = calculate_b_d_new_vec( T_max,i_12_1,i_34,b_d,Fehlerbit);


%_______________BEGINN ITERATION___________________________________________
%Lagerdaten initialisieren
Lager_A_beibehalten=0;
Lager_B_beibehalten=0;
b_A=zeros(1,u);
b_B=zeros(1,u);
f0_A=zeros(1,u);
f0_B=zeros(1,u);
C0r_A=zeros(1,u);
C0r_B=zeros(1,u);
C_stat_A=zeros(1,u);
C_stat_B=zeros(1,u);
C_dyn_A=zeros(1,u);
C_dyn_B=zeros(1,u);
b_1_2_beibehalten=zeros(1,u);
b_1_2=zeros(1,u);
d_sh_B=zeros(1,u);
d_sh_A=zeros(1,u);
m_A=zeros(1,u);
m_B=zeros(1,u);
ID_A=cell(1,u);
ID_B=cell(1,u);
d_1_A=zeros(1,u);
d_1_B=zeros(1,u);
d_A_A=zeros(1,u);
d_A_B=zeros(1,u);
Lager_A_angepasst=0;
Lager_B_angepasst=0;


Lager_C_beibehalten=0;
Lager_D_beibehalten=0;
b_C=zeros(1,u);
b_D=zeros(1,u);
f0_C=zeros(1,u);
f0_D=zeros(1,u);
C0r_C=zeros(1,u);
C0r_D=zeros(1,u);
C_stat_C=zeros(1,u);
C_stat_D=zeros(1,u);
C_dyn_C=zeros(1,u);
C_dyn_D=zeros(1,u);

d_sh_C=zeros(1,u);
d_sh_D=zeros(1,u);
m_C=zeros(1,u);
m_D=zeros(1,u);
ID_C=cell(1,u);
ID_D=cell(1,u);
d_1_C=zeros(1,u);
d_1_D=zeros(1,u);
d_A_C=zeros(1,u);
d_A_D=zeros(1,u);
Lager_C_angepasst=0;
Lager_D_angepasst=0;
lagerbreite_anpassen_2_stufe=0;
er_1=zeros(1,u);
er_2=zeros(1,u);
er_3=zeros(1,u);
b_3_hold=zeros(1,u);
sprung_ber=0;
sprung_vernachlaessigen=0;
%Iteration für Sprungüberdeckung___________________________________________
...........................................................................
iteration_3=zeros(1,u);
while 1    

%Itertaion für Sicherheit der zweiten Welle________________________________
%..........................................................................
while 1
%Iteration für Sicherheit der ersten Welle_________________________________
%--------------------------------------------------------------------------
iteration_1=zeros(1,u);
while 1

    
    if(lagerbreite_anpassen_2_stufe==0)
    
    
    %Verzahnungsgeometrie bestimmen für ersten Gang
    [ d_1_1,d_a1_1, d_f1_1, d_b1_1, z_1_1,d_2_1,d_a2_1, d_f2_1, d_b2_1, z_2_1 ,i_12_1, alpha_t,beta,Fehlerbit,Fehlercode] = calculate_wheel_data_vec(d_1_1,i_12_1,m_n_1,beta,Fehlerbit,Fehlercode);

    %Aus Zwangsbedingung Daten für zweiten Gang berechnen______________________
    z_sum=z_1_1+z_2_1;
    i_34=i_ges_1./i_12_1;
    i_12_2=i_ges_2./i_34;
    z_1_2=zeros(1,u);
    z_2_2=zeros(1,u);
    for k=1:u
        z_1_2(k)=17;
        z_2_2(k)=z_sum(k)-z_1_2(k);
        i_12_2_r=zeros(1,1);
        i=1;
        while 1
            i_12_2_r(i)=z_2_2(k)/z_1_2(k);
            z_1_2(k)=z_1_2(k)+1;
            z_2_2(k)=z_sum(k)-z_1_2(k);
            i=i+1;

            if(z_2_2(k)<18)
                break;
            end
        end
        err=zeros(1,i-1);
        for n=1:i-1
            err(1,n)=abs(i_12_2_r(n)-i_12_2(k));
        end
        min_err=min(err);
        r=0;
        for t=1:i
            if(err(1,t)==min_err)
                break;
            end
            r=r+1;
        end
        z_1_2(k)=17+r;
        z_2_2(k)=z_sum(k)-z_1_2(k);
        i_12_2(k)=z_2_2(k)/z_1_2(k);

    end
    %Aus Übersetzung und Zähnezahl Teilkreisdurchmesser und
    %Verzahnungsgeometrie für zweiten Gang berechnenen
    d_1_2=z_1_2.*m_n_1/cos(beta);
    d_2_2=z_2_2.*m_n_1/cos(beta);
    %Kopfkreisdurchmesser
    d_a1_2=d_1_2+(2*m_n_1);
    d_a2_2=d_2_2+(2*m_n_1);
    %Fußkreisdurchmesser
    c=0.25*m_n_1;
    d_f1_2=d_1_2-(2*(m_n_1+c));
    d_f2_2=d_2_2-(2*(m_n_1+c));
    %Grundkreisdurchmesser
    d_b1_2=d_1_2*cos(alpha_t);
    d_b2_2=d_2_2*cos(alpha_t);
    for k=1:u
        if(b_1_2_beibehalten(k)==0)
            b_1_2(k)=d_1_2(k).*b_d;
        end
    end
    
    end
    
    %__________________________________________________________________________

    %Lager auswählen, bis kein Lager mehr für den anderen Gang angepasst
    %werden muss
    step=0;
    while 1
            
            %Lagerauswahl für ersten Gang der ersten Welle
            gear=1;
            [l_1,s_1_1,s_1_2,d_sh_A,d_sh_B,a_12,alpha_wt,m_A,m_B,d_A_A,d_A_B,b_A,b_B,d_1_A,d_1_B,d_inn_1,Fehlerbit,Fehlercode,ID_A,ID_B,f0_A,f0_B,C0r_A,C0r_B,C_stat_A,C_stat_B,C_dyn_A,C_dyn_B] = bearings_welle_1_two_speed_1(T_nenn,T_max, n_eck, d_1_1,d_1_2, d_2_1,d_2_2, b_1_1,b_1_2, beta,alpha_t,m_n_1,z_1_1,z_2_1,values_A, spalt,b_park,Fehlerbit,Fehlercode,ueberlast,Lager_A_beibehalten,Lager_B_beibehalten,gear,wunschbauraum,f0_A,f0_B,C0r_A,C0r_B,C_stat_A,C_dyn_A,C_stat_B,C_dyn_B,b_3,d_sh_A,d_sh_B,b_A,b_B,m_A,m_B,d_1_A,d_1_B,ID_A,ID_B,d_A_A,d_A_B,Lager_A_angepasst,Lager_B_angepasst);

            Lager_A_beibehalten=1;
            %Lagerauswahl für zweiten Gang der ersten Welle
            gear=2;
            [l_1,s_1_1,s_1_2,d_sh_A,d_sh_B,a_12,alpha_wt,m_A,m_B,d_A_A,d_A_B,b_A,b_B,d_1_A,d_1_B,d_inn_1,Fehlerbit,Fehlercode,ID_A,ID_B,f0_A,f0_B,C0r_A,C0r_B,C_stat_A,C_stat_B,C_dyn_A,C_dyn_B] = bearings_welle_1_two_speed_1(T_nenn,T_max, n_eck, d_1_1,d_1_2, d_2_1,d_2_2, b_1_1,b_1_2, beta,alpha_t,m_n_1,z_1_1,z_2_1,values_A, spalt,b_park,Fehlerbit,Fehlercode,ueberlast,Lager_A_beibehalten,Lager_B_beibehalten,gear,wunschbauraum,f0_A,f0_B,C0r_A,C0r_B,C_stat_A,C_dyn_A,C_stat_B,C_dyn_B,b_3,d_sh_A,d_sh_B,b_A,b_B,m_A,m_B,d_1_A,d_1_B,ID_A,ID_B,d_A_A,d_A_B,Lager_A_angepasst,Lager_B_angepasst);
            Lager_B_beibehalten=1;

            %Lagerauswahl für erste Welle nochmals überprüfen mit den beiden Gesetzen
            %Lager für ersten Gang
            Lager_A_angepasst=0;
            Lager_B_angepasst=0;
            gear=1;
            [l_1,s_1_1,s_1_2,d_sh_A,d_sh_B,a_12,alpha_wt,m_A,m_B,d_A_A,d_A_B,b_A,b_B,d_1_A,d_1_B,d_inn_1,Fehlerbit,Fehlercode,ID_A,ID_B,f0_A,f0_B,C0r_A,C0r_B,C_stat_A,C_stat_B,C_dyn_A,C_dyn_B,Lager_A_angepasst,Lager_B_angepasst] = bearings_welle_1_two_speed_1(T_nenn,T_max, n_eck, d_1_1,d_1_2, d_2_1,d_2_2, b_1_1,b_1_2, beta,alpha_t,m_n_1,z_1_1,z_2_1,values_A, spalt,b_park,Fehlerbit,Fehlercode,ueberlast,Lager_A_beibehalten,Lager_B_beibehalten,gear,wunschbauraum,f0_A,f0_B,C0r_A,C0r_B,C_stat_A,C_dyn_A,C_stat_B,C_dyn_B,b_3,d_sh_A,d_sh_B,b_A,b_B,m_A,m_B,d_1_A,d_1_B,ID_A,ID_B,d_A_A,d_A_B,Lager_A_angepasst,Lager_B_angepasst);
            %Lagerauswahl für erste Welle nochmals überprüfen für zweiten Gang
            gear=2;
            [l_1,s_1_1,s_1_2,d_sh_A,d_sh_B,a_12,alpha_wt,m_A,m_B,d_A_A,d_A_B,b_A,b_B,d_1_A,d_1_B,d_inn_1,Fehlerbit,Fehlercode,ID_A,ID_B,f0_A,f0_B,C0r_A,C0r_B,C_stat_A,C_stat_B,C_dyn_A,C_dyn_B,Lager_A_angepasst,Lager_B_angepasst] = bearings_welle_1_two_speed_1(T_nenn,T_max, n_eck, d_1_1,d_1_2, d_2_1,d_2_2, b_1_1,b_1_2, beta,alpha_t,m_n_1,z_1_1,z_2_1,values_A, spalt,b_park,Fehlerbit,Fehlercode,ueberlast,Lager_A_beibehalten,Lager_B_beibehalten,gear,wunschbauraum,f0_A,f0_B,C0r_A,C0r_B,C_stat_A,C_dyn_A,C_stat_B,C_dyn_B,b_3,d_sh_A,d_sh_B,b_A,b_B,m_A,m_B,d_1_A,d_1_B,ID_A,ID_B,d_A_A,d_A_B,Lager_A_angepasst,Lager_B_angepasst);

            if((Lager_A_angepasst==0 && Lager_B_angepasst==0) || step>20)
                break;
            else
                step=step+1;
                if(step>20)
                Fehlerbit(k)=1;
                Fehlercode(1,k)={'Fehler in Berechnung Welle 1: Die Lagerung konnte nicht sichergestellt werden'};
                end
            end
    end
    %Berechnung der Sicherheitsfaktoren für ersten Gang
    d_sh_r=zeros(1,u);
    for k=1:u
        d_sh_r(k)=max(d_sh_A(k),d_sh_B(k));
    end
    K_strich=0.48;
    [ K_a, K_v, K_h_beta, K_f_beta, K_f_alpha, K_h_alpha, Y_epsilon, Z_epsilon, beta_b, beta, epsilon_beta_1, epsilon_alpha_1, F_n_t , alpha_wt_1_1,b_1_1] = calculate_factors_vec(n_eck,d_1_1, d_b1_1,d_a1_1, d_2_1, d_b2_1,d_a2_1,d_sh_r, b_1_1,T_max,z_1_1,z_2_1,i_12_1,l_1,s_1_1, m_n_1,K_strich,beta); 
    %Berechnung der Sicherheiten für den ersten Gang
    [ S_F_12_1 ] = calculate_S_F_vec( beta, beta_b, epsilon_beta_1, Y_epsilon, F_n_t,b_1_1,m_n_1, K_a, K_v, K_f_beta, K_f_alpha, z_1_1,sigma_fe);
    [ S_H_12_1 ] = calculate_S_H_vec( alpha_wt_1_1, alpha_t,d_a1_1,d_a2_1,d_b1_1,d_b2_1,beta,Z_epsilon,K_a, K_v, K_h_beta, K_h_alpha, beta_b, z_1_1, epsilon_alpha_1, z_2_1, i_12_1, F_n_t , d_1_1, b_1_1,sigma_hlim);
    %Berechnung der Sicherheitsfaktoren für den zweiten Gang
    K_strich=-0.48;
    [ K_a, K_v, K_h_beta, K_f_beta, K_f_alpha, K_h_alpha, Y_epsilon, Z_epsilon, beta_b, beta, epsilon_beta_2, epsilon_alpha_2, F_n_t , alpha_wt_1_2,b_1_2] = calculate_factors_vec(n_eck,d_1_2, d_b1_2,d_a1_2, d_2_2, d_b2_2,d_a2_2,d_sh_r, b_1_2,T_max,z_1_2,z_2_2,i_12_2,l_1,s_1_2, m_n_1,K_strich,beta);
    %Berechnung der Sicherheiten für den zweiten Gang
    [ S_H_12_2 ] = calculate_S_H_vec( alpha_wt_1_2, alpha_t,d_a1_2,d_a2_2,d_b1_2,d_b2_2,beta,Z_epsilon,K_a, K_v, K_h_beta, K_h_alpha, beta_b, z_1_2, epsilon_alpha_2, z_2_2, i_12_2, F_n_t , d_1_2, b_1_2,sigma_hlim);
    [ S_F_12_2 ] = calculate_S_F_vec( beta, beta_b, epsilon_beta_2, Y_epsilon, F_n_t,b_1_2,m_n_1, K_a, K_v, K_f_beta, K_f_alpha, z_1_2,sigma_fe);
    
    %Überprüfen ob Sicherheit zulasten der Sprungüberdeckung kleiner wird
    if(sprung_ber==1)
        for k=1:u
            if((S_H_12_1(k)<S_H_12_1_alt(k))||(S_H_12_2(k)<S_H_12_2_alt(k))||(S_F_12_1(k)<S_F_12_1_alt(k))||(S_F_12_2(k)<S_F_12_2_alt(k)))
                Fehlerbit(k)=0;
                Fehlercode(1,k)={'Die Korrektur der Breite infolge der Sprungüberdeckung führt zu Reduzierung der Sicherheit. Es wird darauf verzichtet'};
                S_H_12_1(k)=S_H_12_1_alt(k);
                S_H_12_2(k)=S_H_12_2_alt(k);
                S_F_12_1(k)=S_F_12_1_alt(k);
                S_F_12_2(k)=S_F_12_2_alt(k);
                b_1_1(k)=b_1_1_alt(k);
                b_1_2(k)=b_1_2_alt(k);
                sprung_vernachlaessigen=1;
            end
            
        end
    end
    
    %Alte Sicherheit abspeichern
    S_F_12_1_alt=S_F_12_1;
    S_F_12_2_alt=S_F_12_2;
    S_H_12_1_alt=S_H_12_1;
    S_H_12_2_alt=S_H_12_2;
    
    %Überprüfen der Sicherheiten
    
    for k=1:u
        if(S_H_12_1(k)<1.0 || S_F_12_1(k)<1.4)
            b_1_1(k)=b_1_1(k)+0.5;
            d_1_1(k)=b_1_1(k)/b_d;
            lagerbreite_anpassen_2_stufe=0;
        end
        if(S_H_12_2(k)<1.0 || S_F_12_2(k)<1.4)
            b_1_2(k)=b_1_2(k)+0.5; %Durchmesser wird wegen Zwangsbedingung gehalten und aus Achsabstand bestimmt
            lagerbreite_anpassen_2_stufe=0;
        end
        iteration_1(k)=iteration_1(k)+1;
    end
    
    %Überprüfen ob Achsabstand groß genug für Differential:::::::::::::::::
    for k=1:u
        while 1
            ab_34=(d_3(k)/2)+(d_4(k)/2);
            if(ab_34-(d_korb(k)/2)>(d_2_2(k)/2))
                break;
            else
                d_3(k)=d_3(k)+1;
                d_4(k)=i_34(k)*d_3(k);
                if(b_3_hold(k)==0)
                b_3(k)=d_3(k)*b_d;
                end
            end
        end
    end
    
    
    
    %Überprüfen der Sprungüberdeckung in eigener Schleife erst wenn sicherheit gegeben
    
    
    para=zeros(1,u);
    for k=1:u
            if(S_H_12_1(k)>=1.0 && S_F_12_1(k)>=1.4 && S_H_12_2(k)>=1.0 && S_F_12_2(k)>=1.4)
                para(1,k)=1;
            elseif(iteration_1(k)>50)
                para(1,k)=1;
                Fehlerbit(k)=1;
                Fehlercode(1,k)={'Fehler bei Welle 1. Die Sicherheit konnte nach 50 Iterationsschritten nicht erreicht werden.'};
            else
                para(1,k)=0;
            end
    end
    
    %Wenn der Hilfsparamter überall 1 ist, die Summe also die Anzahl der
    %Elemente ist, ist die Sicherheit überall erreicht_____________________
    if(sum(para)==u)
        break;
    end
end
%Ende Iteration für erste Welle
%--------------------------------------------------------------------------

[ d_3,d_a3, d_f3, d_b3, z_3,d_4,d_a4, d_f4, d_b4, z_4 ,i_34, alpha_t,beta,Fehlerbit,Fehlercode] = calculate_wheel_data_vec(d_3,i_34,m_n_3,beta,Fehlerbit,Fehlercode);

%Lagerauswahl für die zweite Welle, bis kein Lager mehr angepasst werden
%muss
step_2=0;
while 1
    %Lagerauswahl für ersten Gang zweite Welle
    gear=1;
    [l_3_1,d_sh_C,d_sh_D,a,alpha_wt_2,m_C,m_D,d_A_C,d_A_D,b_C,b_D,F_u_3,F_ax_3,F_rad_3,d_1_C,d_1_D,d_inn_2,Fehlerbit,Fehlercode,ID_C,ID_D,C_dyn_C,C_dyn_D,C_stat_C,C_stat_D,f0_C,f0_D,C0r_C,C0r_D,Lager_C_angepasst,Lager_D_angepasst] = bearings_welle_2_two_speed_1( T_nenn,T_max, n_eck, d_3,d_4,b_1_1,b_1_2, b_3, beta,alpha_t,m_n_3,z_3,z_4,i_12_1,i_12_2,d_1_1,d_1_2,d_2_1,d_2_2,values_A,spalt,Fehlerbit,Fehlercode,ueberlast,Lager_C_beibehalten,Lager_D_beibehalten,gear,wunschbauraum,b_C,b_D,m_C,m_D,d_sh_D,d_sh_C,d_1_C,d_1_D,C_dyn_C,C_dyn_D,C_stat_C,C_stat_D,f0_C,f0_D,C0r_C,C0r_D,ID_C,ID_D,Lager_C_angepasst,Lager_D_angepasst,d_A_C,d_A_D);
    %Lagerauswahl für zweiten Gang zweite Welle
    gear=2;
    Lager_C_beibehalten=1;
    [l_3_1,d_sh_C,d_sh_D,a,alpha_wt_2,m_C,m_D,d_A_C,d_A_D,b_C,b_D,F_u_3,F_ax_3,F_rad_3,d_1_C,d_1_D,d_inn_2,Fehlerbit,Fehlercode,ID_C,ID_D,C_dyn_C,C_dyn_D,C_stat_C,C_stat_D,f0_C,f0_D,C0r_C,C0r_D,Lager_C_angepasst,Lager_D_angepasst] = bearings_welle_2_two_speed_1( T_nenn,T_max, n_eck, d_3,d_4,b_1_1,b_1_2, b_3, beta,alpha_t,m_n_3,z_3,z_4,i_12_1,i_12_2,d_1_1,d_1_2,d_2_1,d_2_2,values_A,spalt,Fehlerbit,Fehlercode,ueberlast,Lager_C_beibehalten,Lager_D_beibehalten,gear,wunschbauraum,b_C,b_D,m_C,m_D,d_sh_D,d_sh_C,d_1_C,d_1_D,C_dyn_C,C_dyn_D,C_stat_C,C_stat_D,f0_C,f0_D,C0r_C,C0r_D,ID_C,ID_D,Lager_C_angepasst,Lager_D_angepasst,d_A_C,d_A_D);
    %Lagerüberprüfen erster Gang
    gear=1;
    Lager_D_beibehalten=1;
    Lager_C_angepasst=0;
    Lager_D_angepasst=0;
    [l_3_1,d_sh_C,d_sh_D,a,alpha_wt_2,m_C,m_D,d_A_C,d_A_D,b_C,b_D,F_u_3,F_ax_3,F_rad_3,d_1_C,d_1_D,d_inn_2,Fehlerbit,Fehlercode,ID_C,ID_D,C_dyn_C,C_dyn_D,C_stat_C,C_stat_D,f0_C,f0_D,C0r_C,C0r_D,Lager_C_angepasst,Lager_D_angepasst] = bearings_welle_2_two_speed_1( T_nenn,T_max, n_eck, d_3,d_4,b_1_1,b_1_2, b_3, beta,alpha_t,m_n_3,z_3,z_4,i_12_1,i_12_2,d_1_1,d_1_2,d_2_1,d_2_2,values_A,spalt,Fehlerbit,Fehlercode,ueberlast,Lager_C_beibehalten,Lager_D_beibehalten,gear,wunschbauraum,b_C,b_D,m_C,m_D,d_sh_D,d_sh_C,d_1_C,d_1_D,C_dyn_C,C_dyn_D,C_stat_C,C_stat_D,f0_C,f0_D,C0r_C,C0r_D,ID_C,ID_D,Lager_C_angepasst,Lager_D_angepasst,d_A_C,d_A_D);
    %Lagerüberprüfen zweiter Gang
    gear=2;
    [l_3_1,d_sh_C,d_sh_D,a,alpha_wt_2,m_C,m_D,d_A_C,d_A_D,b_C,b_D,F_u_3,F_ax_3,F_rad_3,d_1_C,d_1_D,d_inn_2,Fehlerbit,Fehlercode,ID_C,ID_D,C_dyn_C,C_dyn_D,C_stat_C,C_stat_D,f0_C,f0_D,C0r_C,C0r_D,Lager_C_angepasst,Lager_D_angepasst] = bearings_welle_2_two_speed_1( T_nenn,T_max, n_eck, d_3,d_4,b_1_1,b_1_2, b_3, beta,alpha_t,m_n_3,z_3,z_4,i_12_1,i_12_2,d_1_1,d_1_2,d_2_1,d_2_2,values_A,spalt,Fehlerbit,Fehlercode,ueberlast,Lager_C_beibehalten,Lager_D_beibehalten,gear,wunschbauraum,b_C,b_D,m_C,m_D,d_sh_D,d_sh_C,d_1_C,d_1_D,C_dyn_C,C_dyn_D,C_stat_C,C_stat_D,f0_C,f0_D,C0r_C,C0r_D,ID_C,ID_D,Lager_C_angepasst,Lager_D_angepasst,d_A_C,d_A_D);
    
    if((Lager_C_angepasst==0 && Lager_D_angepasst==0) || step_2>20)
        break;
    else
        step_2=step_2+1;
        if(step_2>20)
        Fehlerbit(k)=1;
        Fehlercode(1,k)={'Fehler in Berechnung Welle 2: Es konnte keine Lagerung sichergestellt werden'};
        end
    end
end
%Berechnung der Sicherheitsfaktoren für die zweite Welle
d_sh_r=zeros(1,u);
    for k=1:u
        d_sh_r(k)=max(d_sh_C(k),d_sh_D(k));
    end
K_strich=0;
n_factor=n_eck./i_12_1;
T_max_2=T_max.*i_12_1;
[ K_a, K_v, K_h_beta, K_f_beta, K_f_alpha, K_h_alpha, Y_epsilon, Z_epsilon, beta_b, beta, epsilon_beta_3, epsilon_alpha_3, F_n_t , alpha_wt_2,b_3] = calculate_factors_vec(n_factor,d_3, d_b3,d_a3, d_4, d_b4,d_a4,d_sh_r, b_3,T_max_2,z_3,z_4,i_34,l_3_1,s_1_1, m_n_3,K_strich,beta);
%Berechnung der Sicherheiten der zweiten Welle 
[ S_F_34 ] = calculate_S_F_vec( beta, beta_b, epsilon_beta_3, Y_epsilon, F_n_t,b_3,m_n_3, K_a, K_v, K_f_beta, K_f_alpha, z_3,sigma_fe);
[ S_H_34 ] = calculate_S_H_vec( alpha_wt_2, alpha_t,d_a1_1,d_a2_1,d_b1_1,d_b2_1,beta,Z_epsilon,K_a, K_v, K_h_beta, K_h_alpha, beta_b, z_4, epsilon_alpha_3, z_4, i_34, F_n_t , d_3, b_3,sigma_hlim);
%Überprüfen ob Korrektur der Sprungüberdeckung zu lasten der Sicherheit fällt
    if(sprung_ber==1)
        for k=1:u
            if((S_H_34(k)<S_H_34_alt(k))||(S_F_34(k)<S_F_34_alt(k)))
                Fehlerbit(k)=0;
                Fehlercode(1,k)={'Die Korrektur der Breite infolge der Sprungüberdeckung führt zu Reduzierung der Sicerheit. Es wird darauf verzichtet'};
                S_H_34(k)=S_H_34_alt(k);
                S_F_34(k)=S_F_34_alt(k);
                b_3(k)=b_3_alt(k);
                sprung_vernachlaessigen=1;
            end
        end
    end

%Abspeichern der alten Sicherheiten
S_F_34_alt=S_F_34;
S_H_34_alt=S_F_34;
%Überprüfen der Sicherheiten
for k=1:u
        if(S_H_34(k)<1.0 || S_F_34(k)<1.4)
            b_3(k)=b_3(k)+0.25;
            d_3(k)=b_3(k)/b_d;
            lagerbreite_anpassen_2_stufe=1;
        end
        iteration_3(k)=iteration_3(k)+1;
end
    
    para=zeros(1,u);
    for k=1:u
            if(S_H_34(k)>=1.0 && S_F_34(k)>=1.4)
                para(1,k)=1;
            elseif(iteration_3(k)>50)
                para(1,k)=1;
                Fehlerbit(k)=1;
                Fehlercode(1,k)={'Fehler bei Welle 2. Die Sicherheit konnte nach 50 Iterationsschritten nicht erreicht werden.'};
            else
                para(1,k)=0;
            end
    end
    
    %Wenn der Hilfsparamter überall 1 ist, die Summe also die Anzahl der
    %Elemente ist, ist die Sicherheit überall erreicht_____________________
    if(sum(para)==u)
        break;
    end
    
end
%Iteration für beide Sprungüberdeckungen hier überprüfen und nur Breite
%anpassen
%alte Breite abspeichern
if(sprung_ber==0)
b_1_1_alt=b_1_1;
b_1_2_alt=b_1_2;
b_3_alt=b_3;
end
%alte Sprungüberdeckung abspeichern
if(sprung_ber==0)
eps_beta_1_alt=epsilon_beta_1;
eps_beta_2_alt=epsilon_beta_2;
eps_beta_3_alt=epsilon_beta_3;
end

    for k=1:u
        er_1(k)=abs(epsilon_beta_1(k)-round(epsilon_beta_1(k)));
        er_2(k)=abs(epsilon_beta_2(k)-round(epsilon_beta_2(k)));
        er_3(k)=abs(epsilon_beta_3(k)-round(epsilon_beta_3(k)));
        while 1
            if((abs(((b_1_1(k)*sin(beta))/(m_n_1*pi))-round(((b_1_1(k)*sin(beta))/(m_n_1*pi)))))>0.05)
                b_1_1(k)=b_1_1(k)+0.2;
                lagerbreite_anpassen_2_stufe=1;
                sprung_ber=1;
                var_1=1;
            else
                var_1=0;
            end
            if((abs(((b_1_2(k)*sin(beta))/(m_n_1*pi))-round(((b_1_2(k)*sin(beta))/(m_n_1*pi)))))>0.05)
                b_1_2(k)=b_1_2(k)+0.2;
                lagerbreite_anpassen_2_stufe=1;
                sprung_ber=1;
                var_2=1;
            else
                var_2=0;
            end
            if((abs(((b_3(k)*sin(beta))/(m_n_3*pi))-round(((b_3(k)*sin(beta))/(m_n_3*pi)))))>0.05)
                b_3(k)=b_3(k)+0.2;
                b_3_hold(k)=1;
                lagerbreite_anpassen_2_stufe=1;
                sprung_ber=1;
                var_3=1;
            else
                var_3=0;
            end
            if(var_1+var_2+var_3==0)
                break;
            end
        end
    end
    %Überdeckungen Final prüfen
    for k=1:u
        if(er_1(k)<=0.05 && er_2(k)<=0.05 && er_3(k)<=0.05)
            para(k)=1;
        else
            para(k)=0;
        end
        if(sprung_vernachlaessigen==1)
            %Alte Sprungüberdeckungen ausgeben
            epsilon_beta_1(k)=eps_beta_1_alt(k);
            epsilon_beta_2(k)=eps_beta_2_alt(k);
            epsilon_beta_3(k)=eps_beta_3_alt(k);
            para(k)=1;
        end
    end
    if(sum(para)==u)
        break;
    end
end

%Ende Iteration zweite Welle
%..........................................................................

%Lagerdaten der ersten Welle in Matrix abspeichern:
lagerdaten_1=zeros(10,u);
lagerdaten_1(1,:)=d_sh_A;
lagerdaten_1(2,:)=d_sh_B;
lagerdaten_1(3,:)=d_1_A;
lagerdaten_1(4,:)=d_1_B;
lagerdaten_1(5,:)=d_A_A;
lagerdaten_1(6,:)=d_A_B;
lagerdaten_1(7,:)=b_A;
lagerdaten_1(8,:)=b_B;
lagerdaten_1(9,:)=m_A;
lagerdaten_1(10,:)=m_B;
%ID wird so übergeben

%Lagerdaten der zweiten Welle in Matrix speichern:
lagerdaten_2=zeros(10,u);
lagerdaten_2(1,:)=d_sh_C;
lagerdaten_2(2,:)=d_sh_D;
lagerdaten_2(3,:)=d_1_C;
lagerdaten_2(4,:)=d_1_D;
lagerdaten_2(5,:)=d_A_C;
lagerdaten_2(6,:)=d_A_D;
lagerdaten_2(7,:)=b_C;
lagerdaten_2(8,:)=b_D;
lagerdaten_2(9,:)=m_C;
lagerdaten_2(10,:)=m_D;
%ID wird so übergeben

    
end

