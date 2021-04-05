function [K_a, K_v, K_h_beta, K_f_beta, K_f_alpha, K_h_alpha, Y_epsilon, Z_epsilon, beta_b, beta, epsilon_beta, epsilon_alpha, F_n_t , alpha_wt,b] = calculate_factors_vec(n_eck,d_1, d_b1,d_a1, d_2, d_b2,d_a2,d_sh_r, b,T_max,z_1,z_2,i_12,lagerbreite, lagerparameter_s, m_n,K_strich,beta)
%Berechnung der erforderlichen Berechnungsfaktoren für den
%Festigkeitsnachweis
%Lagerbreite und Lagerparameter vom Ritzel
%Kopfspiel für Faktor erforderlich
c=0.25*m_n;
%Definition des Normaleingriffwinkels erforderlich
alpha_n=20*pi/180;
%Eingriffswinkel im Strinschnitt erforderlich
alpha_t=atan(tan(alpha_n)/cos(beta));
%Achsabstand
a=0.5*(d_1+d_2);
%Betriebsengriffwinkel
alpha_wt=acos((z_1+z_2)*m_n*cos(alpha_t)./(2*a*cos(beta)));

%Anwendungsfaktor K_a
K_a=1.5;
%________________________________________________________________
%Dynamikfaktor K_v, hierbei werden die Faktoren K_1 und K_2 fetsgelegt,
%Grundlage ist DIN Verzahnungsqualität 6, sowie vergüteter Werkstoff
K_1=8.6;
K_2=0.0087;
v=((d_1./1000)*pi).*(n_eck/60);
F_n_t=2000*T_max./d_1;
[w,u]=size(b);
K_v=zeros(1,u);
for k=1:u
    K_v(k)=1+((K_1/(K_a*F_n_t(k)/b(k)))+K_2)*((z_1(k)*v(k)/100)*sqrt((i_12(k)^2)/(1+(i_12(k)^2))));
end
%_______________________________________________________________
%Breitenfaktoren K_h_beta und K_f_beta
%for Schleife für Vectorial notwendig

b_vec=b;
l_vec=lagerbreite;
s_vec=lagerparameter_s;
K_h_beta=zeros(1,u);
K_f_beta=zeros(1,u);
for k=1:u
    
    b=b_vec(k);
    %c_gamma für Werkstoffpaarung Stahl/Stahl
    c_gamma=20;

    %f_h_beta ist für Verzahungqualität 6 abhängig von Verzahnugsbreite
    if(b<=20)
        f_h_beta=8;
    elseif(b>20 && b<=40)
        f_h_beta=9;
    elseif(b>40 && b<=100)
        f_h_beta=10;
    else
        f_h_beta=11;
    end

    %f_sh ist abhängig von Lagerbreite, Art der Lagerung und Wellendurchmesser am Ritzel
    %Lagerbreite wird übergeben, muss aber noch angepasst werden
    %Lagerparameter s wird übergeben muss aber noch angepasst werden
    l=l_vec(k);
    s=s_vec(k);
    F_m=F_n_t(k)*K_v(k)*K_a;

    %Faktor K_strich wird aus Tabelle anhand von Lagerung festgelegt

    f_sh=(F_m/b)*0.023*(abs(0.7+(K_strich*l*s/(d_1(k)^2))*((d_1(k)/d_sh_r(k))^4))+0.3)*((b/d_1(k))^2);
    if(f_sh>18)
        f_sh=18; %Literatur: max fsh maximal 18 ym.
    end

    F_beta_x=(1.33*f_sh)+(f_h_beta);
    y_beta=0.15*F_beta_x;
    if(y_beta>6)
        y_beta=6;
    end
    F_beta_y=F_beta_x-y_beta;

    par=(F_beta_y*c_gamma)/(2*F_m/b);
    %Berechnung von K_h_beta
    if(par>=1)
        K_h_beta(k)=sqrt( (2*F_beta_y*c_gamma)/(F_m/b));
    else
        K_h_beta(k)=1+(F_beta_y*c_gamma)/(2*F_m/b);
    end
    %Berechnung von K_f_beta
    h=(2*m_n)+c;

    N_f=((b/h)^2)/(1+(b/h)+((b/h)^2));

    K_f_beta(k)=(K_h_beta(k))^(N_f);
end
b=b_vec;

%__________________________________________________________________________
%Stirnfaktoren K_f_alpha und K_h_alpha
%maßgebende Umfangskraft im Strinschnitt
F_t_h=F_n_t.*K_v*K_a;
F_t_h=F_t_h.*K_h_beta;
%zulässige Eingriffsteilungsabweichung für Verzahnungsqualität DIN 6 ist
%abhängig von d und Modul,
%nach Tab. 23.6 Decker
d_1_vec=d_1;
d_a1_vec=d_a1;
d_b1_vec=d_b1;
a_vec=a;
alpha_wt_vec=alpha_wt;
d_a2_vec=d_a2;
d_b2_vec=d_b2;
b_vec=b;
K_f_alpha=zeros(1,u);
K_h_alpha=zeros(1,u);
epsilon_alpha_vec=zeros(1,u);
epsilon_beta_vec=zeros(1,u);
%For schleife für Vectorial notwendig
for k=1:u
    
    d_1=d_1_vec(k);
    d_a1=d_a1_vec(k);
    d_b1=d_b1_vec(k);
    d_a2=d_a2_vec(k);
    d_b2=d_b2_vec(k);
    a=a_vec(k);
    alpha_wt=alpha_wt_vec(k);
    b=b_vec(k);
    
    if(d_1<=50)
        if(m_n<=3.55)
            f_pe=7;
        elseif(m_n>3.55 && m_n<=6)
            f_pe=8;
        else
            f_pe=10;
        end
    elseif(d_1>50 && d_1<=125)
        if(m_n<=3.55)
            f_pe=7;
        elseif(m_n>3.55 && m_n<=6)
            f_pe=9;
        elseif(m_n>6 && m_n<10)
            f_pe=10;
        else
            f_pe=12;
        end
    else
        if(m_n<=3.55)
            f_pe=8;
        elseif(m_n>3.55 && m_n<=6)
            f_pe=9;
        elseif(m_n>6 && m_n<10)
            f_pe=11;
        else
            f_pe=16;
        end
    end
    %einlaufbetrag y_alpha
    y_alpha=0.075*f_pe;

    %Gesamtüberdeckung
    p_et=m_n*pi*cos(alpha_t)/cos(beta);

    epsilon_alpha=(sqrt((d_a1^2)-(d_b1^2))+sqrt((d_a2^2)-(d_b2^2))-(2*a*sin(alpha_wt)))/(2*p_et);

    epsilon_beta=b*sin(beta)/(m_n*pi);

    epsilon_gamma=epsilon_beta+epsilon_alpha;

    if(epsilon_gamma>2)
        K_f_alpha(k)=0.9+(0.4*(sqrt((2*(epsilon_gamma-1))/epsilon_gamma)*(c_gamma*(f_pe-y_alpha)/(F_t_h(k)/b))));
        K_h_alpha(k)=K_f_alpha(k);
    else
        K_f_alpha(k)=(epsilon_gamma/2)*(0.9+(0.4*(c_gamma*(f_pe-y_alpha)/(F_t_h(k)/b))));
        K_h_alpha(k)=K_f_alpha(k);
    end
    epsilon_alpha_vec(k)=epsilon_alpha;
    epsilon_beta_vec(k)=epsilon_beta;
end
b=b_vec;  
alpha_wt=alpha_wt_vec;
epsilon_beta=epsilon_beta_vec;
epsilon_alpha=epsilon_alpha_vec;

%__________________________________________________________________________
%Überdeckungsfaktor für Zahnfußtragfähigkeit
%Grundschrägungswinkel
beta_b=acos(sin(alpha_n)/sin(alpha_t));
Y_epsilon=zeros(1,u);
for k=1:u
    Y_epsilon(k)=0.25+(0.75/(epsilon_alpha_vec(k)/(cos(beta_b)^2)));
end
%__________________________________________________________________________
%Überdeckungsfaktor für Flankentragfähigkeit
Z_epsilon=zeros(1,u);
for k=1:u
    if(epsilon_beta_vec(k)>1)
        epsilon_beta_vec(k)=1;
    end
    Z_epsilon(k)=sqrt((((4-epsilon_alpha_vec(k))/3)*(1-epsilon_beta_vec(k)))+(epsilon_beta_vec(k)/epsilon_alpha_vec(k)));

end

end

