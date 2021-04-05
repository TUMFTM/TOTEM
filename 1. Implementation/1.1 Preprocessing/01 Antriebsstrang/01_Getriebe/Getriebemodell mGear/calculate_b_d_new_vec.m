function [ b_1,d_1,d_2,b_3,d_3,d_4,b_d,Fehlerbit] = calculate_b_d_new_vec( T_max,i_12,i_34,b_d,Fehlerbit)
%Bestimmung der Zahnradgrößen über den Achsabstand

%Definition einiger Startfaktoren, die im Verlauf der Auslegung
%nachgerechnet werden.
K_A=0.65;
Z_H=2.25;
Z_E=191.6;
Z_eps=0.95;
Z_beta=0.95;
S=1.2;
sigma_hlim=1200;
%__________________________________________________________________________


%Berechnung des überschlägigen Achsabstandes:______________________________
a_12=(((((Z_H*Z_E*Z_eps*Z_beta)^2)*K_A)/(sigma_hlim^2))*(((i_12+1).^4)./i_12).*((T_max*1000*(S^2))/(4*b_d))).^(1/3);

%Teilkreisdurchmesser des Ritzels
d_1=(2*a_12)./(1+i_12);
%Teilkreisdurchmesser des Rades:
d_2=i_12.*d_1;
%Die Verzahnungsbreite ergibt sich aus dem Verhältnis b_d:
b_1=d_1*b_d;

%für die 2.Welle:__________________________________________________________
a_23=(((((Z_H*Z_E*Z_eps*Z_beta)^2)*K_A)/(sigma_hlim^2))*(((i_34+1).^4)./i_34).*((T_max.*i_12*1000*(S^2))/(4*b_d))).^(1/3);
d_3=(2*a_23)./(1+i_34);
d_4=i_34.*d_3;
b_3=d_3*b_d;


end

