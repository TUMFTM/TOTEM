function [ alpha_wt,S_F_12,S_H_12,d_A_A,d_A_B,b_A,b_B,b_1,d_1,d_2,i_12 ,z_1,z_2,d_a1,d_a2,m_A,m_B,d_sh_A,d_sh_B,d_1_A,d_1_B,d_inn_1,Fehlerbit,Fehlercode,d_f1,d_f2,epsilon_beta_12,epsilon_alpha,ID_A,ID_B] = set_welle_1_new_vec( T_max,T_nenn,n_eck,m_n,d_1,d_2,b_1,i_12,b_d,spalt,beta,values,Fehlerbit,Fehlercode,ueberlast,sigma_fe,sigma_hlim)
%Festlegung der ersten Welle inklusive der Lager
%Breite der Parkbremse festlegen:__________________________________________
b_park=13;

[w,u]=size(T_max);
iteration=zeros(1,u);
while 1

%Bestimmung der Zahngeometrien_____________________________________________
[ d_1,d_a1, d_f1, d_b1, z_1,d_2,d_a2, d_f2, d_b2, z_2 ,i_12, alpha_t,beta,Fehlerbit,Fehlercode] = calculate_wheel_data_vec(d_1,i_12,m_n,beta,Fehlerbit,Fehlercode);

%Auswahl der passenden Lager_______________________________________________
[ l_1,s_1,d_sh_A,d_sh_B,a,alpha_wt,m_A,m_B,d_A_A,d_A_B,b_A,b_B,d_1_A,d_1_B,d_inn_1,Fehlerbit,Fehlercode,ID_A,ID_B] = set_bearings_welle_1_vec( T_nenn,T_max, n_eck, d_1, d_2, b_1, beta,alpha_t,m_n,z_1,z_2,values,spalt,b_park,Fehlerbit,Fehlercode,ueberlast);

%Es wird für die Berechung der Faktoren der größere Wellendurchmesser
%verwendet:
d_sh_r=zeros(1,u);
for k=1:u
    d_sh_r(k)=max(d_sh_A(k),d_sh_B(k));
end
%Berechnung der Mulitplikationsfaktoren____________________________________
K_strich=0.48;
[ K_a, K_v, K_h_beta, K_f_beta, K_f_alpha, K_h_alpha, Y_epsilon, Z_epsilon, beta_b, beta, epsilon_beta, epsilon_alpha, F_n_t , alpha_wt,b_1] = calculate_factors_vec(n_eck,d_1, d_b1,d_a1, d_2, d_b2,d_a2,d_sh_r, b_1,T_max,z_1,z_2,i_12,l_1, s_1, m_n,K_strich,beta);
%Berechnung der Sicherheiten_______________________________________________
[ S_F_12 ] = calculate_S_F_vec( beta, beta_b, epsilon_beta, Y_epsilon, F_n_t,b_1,m_n, K_a, K_v, K_f_beta, K_f_alpha, z_1,sigma_fe);
[ S_H_12 ] = calculate_S_H_vec( alpha_wt, alpha_t,d_a1,d_a2,d_b1,d_b2,beta,Z_epsilon,K_a, K_v, K_h_beta, K_h_alpha, beta_b, z_1, epsilon_alpha, z_2, i_12, F_n_t , d_1, b_1,sigma_hlim);

%Überprüfen der Sicherheit_________________________________________________
for k=1:u
    if(S_H_12(k)<1.0 || S_F_12(k)<1.4)
       b_1(k)=b_1(k)+0.25;
       d_1(k)=b_1(k)/b_d;
       iteration(k)=iteration(k)+1;

    end
end
%Werte für die Sprungüberdeckung überprüfen
err=zeros(1,u);
for k=1:u
    err(k)=abs(epsilon_beta(k)-round(epsilon_beta(k)));
    if(err(k)>0.02)
        b_1(k)=b_1(k)+0.1; 
    end
end
para=zeros(1,u);
for k=1:u
        if(S_H_12(k)>=1.0 && S_F_12(k)>=1.4 && err(k)<=0.02)
            para(1,k)=1;
        elseif(iteration(k)>150)
            para(1,k)=1;
            Fehlerbit(k)=1;
            Fehlercode(1,k)={'Fehler bei Welle 1. Die Sicherheit konnte nach 150 Iterationsschritten nicht erreicht werden.'};
        else
            para(1,k)=0;
        end
end
%Wenn der Hilfsparamter überall 1 ist, die Summe also die Anzahl der
%Elemente ist, ist die Sicherheit überall erreicht_________________________
if(sum(para)==u)
    break;
end

end
epsilon_beta_12=epsilon_beta;

end

