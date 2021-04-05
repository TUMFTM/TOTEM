function [Laenge_m, Durchmesser_aussen_m, Volumen_l]=... 
    Maschinengeometrie(M_nenn, n_max_rpm, Maschinentyp)
% calculates the outer Motor-Dimensions based on technical data

%Regressions for Geometry origin from Dissertation by Matthias
%Felgenhauer: "Automated Development of Modular Systems for Passenger Cars 
%within the Vehicle Front", Insititute for Automotive Technology, 
%Technical University of Munich, 2019

% L/D-Verhältnis und Maschinenvolumen
Verhaeltnis_Laenge_zu_Durchmesser= 0.261 + (7.02*(10^(-5)))*n_max_rpm;
if strcmp(Maschinentyp, 'PSM')
    % PSM Volumen
    Volumen_l = 5.696 + 0.052*M_nenn; %Felgenhauer
elseif strcmp(Maschinentyp, 'ASM')
    % ASM Volumen
    Volumen_l = 5.696 + 0.104*M_nenn; %Felgenhauer
end

Durchmesser_aussen_m     = ((4*Volumen_l/(Verhaeltnis_Laenge_zu_Durchmesser*pi))^(1/3))/10;
Laenge_m                      = Verhaeltnis_Laenge_zu_Durchmesser*Durchmesser_aussen_m;

