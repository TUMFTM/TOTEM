function [par_VEH] = Spurgradient(par_VEH,par_TIR,IP)
% Source:
% C. Angerer, B. Mößner, M. Lüst, A. Holtz, F. Sträußl, und M. Lienkamp, 
% “Parameter-Adaption for a Vehicle Dynamics Model for the Evaluation 
% of Powertrain Concept Designs,” in International Conference on 
% New Energy Vehicle and Vehicle Engineering (NEVVE), Seoul, Korea, 2018.


% Parameter
EG_neutral = 0.0009;          % Eigenlenkgradient des neutralen Referenzfahrzeugs
Ks = 0.95;                      % Korrekturfaktor zur Berücksichtigung des Einflusses der restlichen Parametrierung auf das Eigenlenkverhalten
Kg = 1.1;                       % Korrekturfaktor wird benötigt, da kurveninneres Rad beim Wanken in andere Richtung lenkt wie kurvenäußeres -> Muss kompensiert werden
wlg_max = 8.1;                  % Maximaler Wanklenkgradient

% Aufruf der Funktion zur Berechnung der Reifenseitenkraft und der Berechnung der Schräglaufsteifigkeit
FZ_F = (par_VEH.lR / par_VEH.l)*(par_VEH.m * 9.81) / 2;                %Reifenaufstandskraft vorne
FZ_R = (par_VEH.lF / par_VEH.l)*(par_VEH.m * 9.81) / 2;                %Reifenaufstandskraft hinten

KAPPA = 0.0005;           %Längsschlupf
ALPHA = -0.02;            %Schräglaufwinkel
GAMMA = 0.7 * (pi/180);   %Sturz
VX = 100/3.6;             %Längsgeschwindigkeit

FY_F = -lateral_tire_force(FZ_F, KAPPA, ALPHA, GAMMA, VX, par_TIR, 1); %Reifenseitenkraft vorne
FY_R = -lateral_tire_force(FZ_R, KAPPA, ALPHA, GAMMA, VX, par_TIR, 2); %Reifenseitenkraft hinten

CF = FY_F/ALPHA;      %Schräglaufsteifigkeit vorne
CR = FY_R/ALPHA;      %Schräglaufsteifigkeit hinten

% Wankachsenhöhe und Hebelarm
slope_WA = (par_VEH.zRCr - par_VEH.zRCf)/IP.Radstand*1000;      % Wankachsneigung
H_r = abs(par_VEH.zRCf + par_VEH.xSP * slope_WA - par_VEH.zSP); % Wankmomenthebelarm

%Absenkung des Schwerpunkts durch Einfederung der Reifen durch Fahrzeuggewicht
z_tire_static = (0.25 * par_VEH.m * par_VEH.g) / ...
                ((par_TIR(1).VERTICAL_STIFFNESS + par_TIR(2).VERTICAL_STIFFNESS) / 2); %Berechnung der Reifeneinfederung
H_r_korr = H_r - z_tire_static;                                                        %Reifeneinfederung von Ausgangshebelarm abziehen

% Eigenlenkgradient 
EG = (par_VEH.m/par_VEH.l) * ( par_VEH.lR/(2*CF*Ks) - par_VEH.lF/(2*CR));

% Wanksteifigkeit und Einfluss der Schwerpunktverschiebung
cW = par_VEH.carbF*(par_VEH.sarbF^2) + par_VEH.carbR*(par_VEH.sarbR^2) + ...
    par_VEH.csF*(par_VEH.ssF^2)  + par_VEH.csR*(par_VEH.ssR^2);
M_Schwerpunktverschiebung = 2 * par_VEH.m * par_VEH.g * (par_VEH.zSP-z_tire_static+((par_TIR(1).UNLOADED_RADIUS+par_TIR(2).UNLOADED_RADIUS)/2));
cW_korr = cW - M_Schwerpunktverschiebung; %Schwerpunktverschiebung wirkt wie "Antifeder", reduziert also Wanksteifigkeit

% Wanklenkgradient
NR = 1 / ((par_VEH.m * H_r_korr * (par_VEH.sF + par_VEH.sR)) / cW_korr);  %NR = Nebenrechnung
wlg_rad = NR * ( EG - EG_neutral);
par_VEH.wlg = Kg * wlg_rad * (180/pi);

% Limits
if par_VEH.wlg > wlg_max
    par_VEH.wlg = wlg_max;
    disp('kinematischer Ausgleich des Eigenlenkverhaltens am Limit')
elseif    par_VEH.wlg < -wlg_max
    par_VEH.wlg = -wlg_max;
    disp('kinematischer Ausgleich des Eigenlenkverhaltens am Limit')
end
