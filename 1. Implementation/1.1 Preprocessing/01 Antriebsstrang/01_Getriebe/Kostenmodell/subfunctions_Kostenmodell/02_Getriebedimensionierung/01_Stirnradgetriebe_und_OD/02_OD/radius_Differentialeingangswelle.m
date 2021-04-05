function r = radius_Differentialeingangswelle(Mmax)

%Mmax = Moment nach Getriebe (Differentialeingangsmoment)
%% Berechnung Wellenradius (Torsion)
% S_D = 2; %Bruchsicherheit
% tau_zul = 300*1e6; %Pa aus Tabelle 1-1 Roloff/Matek 34CrMo4
% r = 0.5*nthroot((16*Mmax*S_D/(pi*tau_zul)),3); %[m]

%% Regression Wellenradius (Werner S.45)
r = Mmax^(1/3)*2.1553*1e-3 + 1.9130*1e-3; %[m]

end