function [par_VEH] = Sturzgradient(par_VEH)
%Adaptive Auslegung der Sturzgradienten
% Source:
% C. Angerer, B. Mößner, M. Lüst, A. Holtz, F. Sträußl, und M. Lienkamp, 
% “Parameter-Adaption for a Vehicle Dynamics Model for the Evaluation 
% of Powertrain Concept Designs,” in International Conference on 
% New Energy Vehicle and Vehicle Engineering (NEVVE), Seoul, Korea, 2018.


% Wankkompensationsfaktoren legen fest, welcher Anteil der Sturzänderung durch das Wanken 
% mithilfe der Radhubkinematik kompensiert werden soll. K_Komp = 1 entspricht kompletter Wanksturzkompensation
K_Komp_F = 0.15; % Wankkompensationsfaktor vorne (Werte orientieren sich an "Fahrwerkshandbuch" von Ersoy und Gies, S.43)
K_Komp_R = 0.23; % Wankkompensationsfaktor hinten

%Berechnung der Wanksturzgradienten
wsg_F_rad = ( -2 / par_VEH.sF ) * K_Komp_F; %vorne
wsg_R_rad = ( -2 / par_VEH.sR ) * K_Komp_R; %hinten

%Umrechnung der Wanksturzgradienten von rad/m nach °/m
par_VEH.wsg_F = wsg_F_rad * (180/pi);
par_VEH.wsg_R = wsg_R_rad * (180/pi);
end



