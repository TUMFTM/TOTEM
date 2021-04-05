function [par_VEH] = torque_vectoring_control(par_VEH,par_TIR)
% Source: 
% M. Lüst, “Regelung der Momentenquerverteilung und Entwurf einer 
% automatisierten Fahrdynamikabstimmung in einer Simulationsumgebung,” 
% Semesterarbeit, Lehrstuhl für Fahrzeugtechnik, Technische Universität 
% München, München, 2018.


%% Reifenvermessung
Ks = 0.95;                      % Korrekturfaktor zur Berücksichtigung des Einflusses der Federsteifigkeitsverteilung auf das Eigenlenkverhalten

FZ_F = (par_VEH.lR / par_VEH.l)*(par_VEH.m * 9.81) / 2;                %Reifenaufstandskraft vorne
FZ_R = (par_VEH.lF / par_VEH.l)*(par_VEH.m * 9.81) / 2;                %Reifenaufstandskraft hinten

KAPPA = 0.0005;           %Längsschlupf
ALPHA = -0.02;            %Schräglaufwinkel
GAMMA = 0.4 * (pi/180);     %Sturz
VX = 100/3.6;             %Längsgeschwindigkeit

FY_F = -lateral_tire_force(FZ_F, KAPPA, ALPHA, GAMMA, VX, par_TIR, 1); %Reifenseitenkraft vorne
FY_R = -lateral_tire_force(FZ_R, KAPPA, ALPHA, GAMMA, VX, par_TIR, 2); %Reifenseitenkraft hinten

par_VEH.cornering_stiffness_F = 2*Ks*FY_F/ALPHA;      %Schräglaufsteifigkeit vorne
par_VEH.cornering_stiffness_R = 2*FY_R/ALPHA;      %Schräglaufsteifigkeit hinten

%% Parameter vorbereiten
use_lqr = 0; %Wenn auf "1" wird LQR-Berechnung genutzt. Wenn auf "0" wird Polplatzierung genutzt.

%for itv=1
itv = 1;

CF = par_VEH.cornering_stiffness_F;
CR = par_VEH.cornering_stiffness_R;
m  = par_VEH.m;
Jz = par_VEH.Iz;
LF = par_VEH.lF;
LR = par_VEH.lR;
v  = 27.8;

%% Zustandsraummodell (zsrm) des Einspurmodells bedaten 
zsrm(itv,1) = -(CF+CR)/(m*v);
zsrm(itv,2) = ((CR*LR + CF*LF)/(m*(v^2)))-1;
zsrm(itv,3) = (CR*LR + CF*LF)/Jz;
zsrm(itv,4) = -(CR*(LR^2) + CF*(LF^2))/(Jz*v);

zsrm(itv,5) = 0;
zsrm(itv,6) = 1/Jz;

A = [zsrm(itv,1) zsrm(itv,2);
     zsrm(itv,3) zsrm(itv,4)];
B = [zsrm(itv,5);
     zsrm(itv,6)];

%% Gewichtungsmatrizen für Linear Quadratischen Regler (LQR)
Q = [1          0;
     0 1600000000];
R = [1];

%% Eigenwerte für Polplatzierung
EW=[-11 -11.5];

%% P-Wert des TV-Reglers berechnen
if use_lqr == 1
    [K(itv,:),~,~] = lqr(A,B,Q,R); %LQR: Riccati-Gleichung berechnen
else
    K=place(A,B,EW); %Polplatzierung
end

par_VEH.tv_control = K(2); %Berechneter Wert dem Vehicle-Parameter-Struct zuweisen
%end

end

