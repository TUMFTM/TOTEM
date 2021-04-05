function [alpha_wt,S_F_34,S_H_34,d_A_C,d_A_D,b_C,b_D,b_3,d_3,d_4,i_34 ,z_3,z_4,F_u_3_vec,F_ax_3_vec,F_rad_3_vec,d_a3,d_a4,m_C,m_D,d_sh_C,d_sh_D,d_1_C,d_1_D,d_inn_2,Fehlerbit,Fehlercode,d_f3,d_f4,epsilon_beta_34,epsilon_alpha,ID_C,ID_D] = set_welle_2_new_vec( T_max,T_nenn,n_eck,m_n,i_12,i_34,d_1,d_2,d_3,d_4,b_1,b_3,b_d,spalt,beta,values,Fehlerbit,Fehlercode,ueberlast,sigma_fe,sigma_hlim)
%Festlegung der zweiten Welle inklusive der Lager
[w,u]=size(T_max);
%Es muss überprüft werden, ob der Achsabstand der zweiten und dritten Welle
%größer als der Radius des Diff-Gehäuses ist
d_4=i_34.*d_3;
%Regression Differential
d_korb=((0.0043*T_max.*i_12).*i_34)+70.9945+20;

for k=1:u
    while 1
        ab_34=(d_3(k)/2)+(d_4(k)/2);
        if(ab_34-(d_korb(k)/2)>(d_2(k)/2))
            break;
        else
            d_3(k)=d_3(k)+1;
            d_4(k)=i_34(k)*d_3(k);
            b_3(k)=d_3(k)*b_d;
        end
    end
end

iteration=zeros(1,u);

while 1
    %Festlegung der Verzahnungsgeometrie:
    [ d_3,d_a3, d_f3, d_b3, z_3,d_4,d_a4, d_f4, d_b4, z_4 ,i_34, alpha_t,beta,Fehlerbit,Fehlercode] = calculate_wheel_data_vec(d_3,i_34,m_n,beta,Fehlerbit,Fehlercode);
    
    %Auswahl der passenden Lager:
    [ l_2,s_2,d_sh_C,d_sh_D,a,alpha_wt,m_C,m_D,d_A_C,d_A_D,b_C,b_D,F_u_3_vec,F_ax_3_vec,F_rad_3_vec,d_1_C,d_1_D,d_inn_2,Fehlerbit,Fehlercode,ID_C,ID_D] = set_bearings_welle_2_vec( T_nenn,T_max, n_eck, d_3,d_4, b_1,b_3, beta,alpha_t,m_n,z_3,z_4,i_12,d_1,d_2,values,spalt,Fehlerbit,Fehlercode,ueberlast);
    %Es wird für die Berechung der Faktoren der größere Wellendurchmesser
    %verwendet:
    d_sh_r=zeros(1,u);
    for k=1:u
        d_sh_r(k)=max(d_sh_C(k),d_sh_D(k));
    end
    
    %Berechnung der Multiplikationsfaktoren
    K_strich=(-0.6);
    n_factor=n_eck./i_12;
    T_max_2=T_max.*i_12;
    [ K_a, K_v, K_h_beta, K_f_beta, K_f_alpha, K_h_alpha, Y_epsilon, Z_epsilon, beta_b, beta, epsilon_beta, epsilon_alpha, F_n_t , alpha_wt,b_3] = calculate_factors_vec(n_factor,d_3, d_b3,d_a3, d_4, d_b4,d_a4,d_sh_r, b_3,T_max_2,z_3,z_4,i_34,l_2, s_2, m_n,K_strich,beta);
    %Berechnung der Sicherheiten
    [ S_F_34 ] = calculate_S_F_vec( beta, beta_b, epsilon_beta, Y_epsilon, F_n_t,b_3,m_n, K_a, K_v, K_f_beta, K_f_alpha, z_3,sigma_fe);
    [ S_H_34 ] = calculate_S_H_vec( alpha_wt, alpha_t,d_a3,d_a4,d_b3,d_b4,beta,Z_epsilon,K_a, K_v, K_h_beta, K_h_alpha, beta_b, z_3, epsilon_alpha, z_4, i_34, F_n_t , d_3, b_3,sigma_hlim);
   
    
    
%Das Fenster wird nur noch zur Absicherung verwendet, falls bei
%unglücklichen Wertekombinationen S nach den Hautpabmessungen doch weit
%über S_min liegt.
%Iterationsvariable einführen
for k=1:u
        
    if(S_H_34(k)<1.0 || S_F_34(k)<1.4)
       b_3(k)=b_3(k)+0.25;
       d_3(k)=b_3(k)/b_d;
       iteration(k)=iteration(k)+1;

    end
end
%Werte für die Sprungüberdeckung überprüfen
err=zeros(1,u);
for k=1:u
    err(k)=abs(epsilon_beta(k)-round(epsilon_beta(k)));
    if(err(k)>0.02)
        b_3(k)=b_3(k)+0.1; 
    end
end
para=zeros(1,u);
for k=1:u
    if(S_H_34(k)<=5 || S_F_34(k)<=5 || iteration(k)>100)
        
        if(S_H_34(k)>=1.0 && S_F_34(k)>=1.4 && err(k)<=0.02)
            
            para(1,k)=1;
        elseif(iteration(k)>150)
            para(1,k)=1;
            Fehlerbit(k)=1;
            Fehlercode(1,k)={'Fehler bei Welle 2. Die Sicherheit konnte nach 150 Iterationsschritten nicht erreicht werden.'};
        else
            para(1,k)=0;
        end
    else
        para(1,k)=0;
    end
end

if(sum(para)==u)
    break;
end
    
end
epsilon_beta_34=epsilon_beta;

end

