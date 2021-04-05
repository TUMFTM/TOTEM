function [ S_F ] = calculate_S_F_vec( beta, beta_b, epsilon_beta, Y_epsilon, F_n_t,b,m_n, K_a, K_v, K_f_beta, K_f_alpha, z_1,sigma_fe)
%Brechnug der Zahnfußtragfähigkeit
[w,u]=size(z_1);
%Ersatzzähnezahl 
z_n=z_1./((cos(beta_b)^2)*cos(beta));
Y_beta=zeros(1,u);
for k=1:u
    if(epsilon_beta(k)>1)
    %Schrägungsfaktor
        epsilon_beta(k)=1;
    end
    Y_beta(k)=1-(epsilon_beta(k)*((beta*180/pi)/120));
end
%Formfaktor ist von Ersatzzähnezahl abhängig, Profilverschiebung = 0
Y_Fa=zeros(1,u);
Y_Sa=zeros(1,u);
for k=1:u
    if(z_n(k)<15)
        Y_Fa(k)=3.36;
    elseif(z_n(k)>=15 && z_n(k)<16)
        Y_Fa(k)=3.25;
    elseif(z_n(k)>=16 && z_n(k)<17)
        Y_Fa(k)=3.16;    
    elseif(z_n(k)>=17 && z_n(k)<18)
        Y_Fa(k)=3.09;
    elseif(z_n(k)>=18 && z_n(k)<19)
        Y_Fa(k)=3.02;
    elseif(z_n(k)>=19 && z_n(k)<20)
        Y_Fa(k)=2.96;
    elseif(z_n(k)>=20 && z_n(k)<21)
        Y_Fa(k)=2.91;
    elseif(z_n(k)>=21 && z_n(k)<22)
        Y_Fa(k)=2.87;
    elseif(z_n(k)>=22 && z_n(k)<23)
        Y_Fa(k)=2.83;
    elseif(z_n(k)>=23 && z_n(k)<24)
        Y_Fa(k)=2.80;
    elseif(z_n(k)>=24 && z_n(k)<25)
        Y_Fa(k)=2.75;
    elseif(z_n(k)>=25 && z_n(k)<30)
        Y_Fa(k)=2.72;
    elseif(z_n(k)>=30 && z_n(k)<40)
        Y_Fa(k)=2.60;
    elseif(z_n(k)>=40 && z_n(k)<50)
        Y_Fa(k)=2.45; 
    elseif(z_n(k)>=50 && z_n(k)<60)
        Y_Fa(k)=2.36;
    elseif(z_n(k)>=60 && z_n(k)<100)
        Y_Fa(k)=2.32;
    elseif(z_n(k)>=100 && z_n(k)<200)
        Y_Fa(k)=2.21;
    elseif(z_n(k)>=200 && z_n(k)<400)
        Y_Fa(k)=2.14;
    else
        Y_Fa(k)=2.10;
    end
    %Spannungskorrekturfaktor
    if(z_n(k)<18)
        Y_Sa(k)=1.57;
    elseif(z_n(k)>=18 && z_n(k)<19)
        Y_Sa(k)=1.58;
    elseif(z_n(k)>=19 && z_n(k)<20)
        Y_Sa(k)=1.59;
    elseif(z_n(k)>=20 && z_n(k)<22)
        Y_Sa(k)=1.60;
    elseif(z_n(k)>=22 && z_n(k)<24)
        Y_Sa(k)=1.63;
    elseif(z_n(k)>=24 && z_n(k)<26)
        Y_Sa(k)=1.64;
    elseif(z_n(k)>=26 && z_n(k)<28)
        Y_Sa(k)=1.66;
    elseif(z_n(k)>=28 && z_n(k)<30)
        Y_Sa(k)=1.68;
    elseif(z_n(k)>=30 && z_n(k)<35)
        Y_Sa(k)=1.69;
    elseif(z_n(k)>=35 && z_n(k)<40)
        Y_Sa(k)=1.73;
    elseif(z_n(k)>=40 && z_n(k)<45)
        Y_Sa(k)=1.75;
    elseif(z_n(k)>=45 && z_n(k)<50)
        Y_Sa(k)=1.78;
    elseif(z_n(k)>=50 && z_n(k)<60)
        Y_Sa(k)=1.80;
    elseif(z_n(k)>=60 && z_n(k)<70)
        Y_Sa(k)=1.84;
    elseif(z_n(k)>=70 && z_n(k)<80)
        Y_Sa(k)=1.87;
    elseif(z_n(k)>=80 && z_n(k)<100)
        Y_Sa(k)=1.90;
    elseif(z_n(k)>=100 && z_n(k)<150)
        Y_Sa(k)=1.94;
    elseif(z_n(k)>=150 && z_n(k)<200)
        Y_Sa(k)=2.02;
    elseif(z_n(k)>=200 && z_n(k)<400)
        Y_Sa(k)=2.06;
    else
        Y_Sa(k)=2.17;
    end
end
%Zahnfussnennspannung
sigma_f_0=zeros(1,u);
for k=1:u
    sigma_f_0(k)=(F_n_t(k)/(b(k)*m_n))*Y_Fa(k)*Y_Sa(k)*Y_beta(k)*Y_epsilon(k);
end
%Zahnfußspannung
sigma_f=(((sigma_f_0*K_a).*K_v).*K_f_beta).*K_f_alpha;
%Sicherheitswert
%sigma_fe ist eine Werkstoffkennwert: 16MnCr5 mit Wechselbeanspruchung 
sigma_fe_w=0.7*sigma_fe;
S_F=zeros(1,u);
for k=1:u
    S_F(k)=sigma_fe_w*1.8/sigma_f(k);
end

end

