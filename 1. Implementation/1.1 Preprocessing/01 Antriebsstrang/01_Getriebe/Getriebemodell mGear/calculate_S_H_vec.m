function [ S_H ] = calculate_S_H_vec( alpha_wt, alpha_t,d_a1,d_a2,d_b1,d_b2,beta,Z_epsilon,K_a, K_v, K_h_beta, K_h_alpha, beta_b, z_1, epsilon_alpha, z_2, i_12, F_n_t , d_1, b,sigma_hlim)
%Berechnug der Sicherheit gegen Zahnflankenversagen
[w,u]=size(b);

%Zonenfaktor
Z_h=zeros(1,u);
for k=1:u
    Z_h(k)=sqrt((2*cos(beta_b))/((cos(alpha_t)^2)*tan(alpha_wt(k))));
end
%Ritzel-Einzeleingriffsfaktor
Z_b=zeros(1,u);
for k=1:u
    Z_b(k)=tan(alpha_wt(k))/(sqrt(((sqrt(((d_a1(k)^2)/(d_b1(k)^2))-1)-((2*pi)/z_1(k)))*(sqrt(((d_a2(k)^2)/(d_b2(k)^2))-1)-((epsilon_alpha(k)-1)*(2*pi/z_2(k)))))));
    if(Z_b(k)<1)
        Z_b(k)=1;
    end
end
%Elastizitätsfaktor für Werkstoffpaarung Stahl 210.000 n/mm^2
Z_e=sqrt(0.35*210000*210000/(210000+210000));
%Schrägungsfaktor
Z_beta=sqrt(cos(beta));
%Nominelle Flankenpressung
sigma_h0=zeros(1,u);
for k=1:u
    sigma_h0(k)=sqrt(((i_12(k)+1)/i_12(k))*(F_n_t(k)/(d_1(k)*b(k))))*Z_h(k)*Z_e*Z_epsilon(k)*Z_beta;
end
%maßgebende Flankenpressung
sigma_h=zeros(1,u);
for k=1:u
    sigma_h(k)=Z_b(k)*sigma_h0(k)*sqrt(K_a*K_v(k)*K_h_beta(k)*K_h_alpha(k));
end
%Sicherheit gegen Flankenversagen
%sigma_hlim ist ein Werkstoffkennwert: Wird in GUI gesetzt
S_H=zeros(1,u);
for k=1:u
    S_H(k)=sigma_hlim*1.6/sigma_h(k);
end

end

