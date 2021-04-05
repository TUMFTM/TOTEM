function [l_kontakt,p,d_2,m_rad_voll,m_rad_hohl] = kegelrad(F_U,p_zul,r_1,r_2,d_1,alpha,rho)
%% Berechnung Kegelrad

l_kontakt = (r_2 - r_1) / (cos((2*pi/360) * alpha));                        % Kontaktlänge [m]
d_kontakt = 0.25 * l_kontakt;                                               % Kontaktbreite [m]

A_kontakt = l_kontakt * d_kontakt;                                          % Kontaktfläche [m^2]
p = F_U / (A_kontakt)/1e6;                                                  % Flächenpressung [MPa]

while p>p_zul                                                               % überprüfen der Flächenpressungsbedingung
    
    d_kontakt = d_kontakt * 1.01;                                           % Erhöhung der Kontaktbreite
    A_kontakt = l_kontakt * d_kontakt;
    p = F_U / (A_kontakt)/1e6;

end
    
d_2 = l_kontakt * sin((2*pi/360) * alpha);                                  % Kontaktbreite Gegenritzel [m]

h_voll = r_2*d_2/(r_2-r_1);                                                 % Höhe Kegelrad [m]

V_rad_voll = (r_2^2*pi*d_1 + ( (1/3 * pi * h_voll * r_2^2)  - (1/3 * pi * (h_voll-d_2) * r_1^2) ) );   % Volumen Kegelrad voll [m^3]

V_rad_hohl = V_rad_voll - r_1^2*pi*(d_1+d_2);                               % Volumen Kegelrad hohl [m^3]

m_rad_voll = V_rad_voll * rho;                                              % Masse Kegelrad voll [kg]
m_rad_hohl = V_rad_hohl * rho;                                              % Masse Kegelrad hohl [kg]

