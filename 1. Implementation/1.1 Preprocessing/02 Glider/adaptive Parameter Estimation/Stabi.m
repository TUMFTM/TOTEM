function par_VEH = Stabi(par_VEH,par_TIR,IP)
%%Stabilisator-Auslegung
% Source:
% C. Angerer, B. Mößner, M. Lüst, A. Holtz, F. Sträußl, und M. Lienkamp, 
% “Parameter-Adaption for a Vehicle Dynamics Model for the Evaluation 
% of Powertrain Concept Designs,” in International Conference on 
% New Energy Vehicle and Vehicle Engineering (NEVVE), Seoul, Korea, 2018.


%%Berechnung Achslast VA/HA
R_VA = 1 - (par_VEH.xSP / par_VEH.l);
R_HA = par_VEH.xSP / par_VEH.l;

%Wankmomentabstützungsverhältnis und Wankwinkelgradient
if R_VA < 0.5 %Abstützungsverhältnis muss für hecklastige Fahrzeuge stärker angehoben werden als es für frontlastige abgesenkt wird. -> Unterschiedliche Linearkoeffizienten
    R_Stab_r = 4 + 50 * (0.5 - R_VA);
else %R_VA > 0.5
    R_Stab_r = 4 + 30 * (0.5 - R_VA);
end
masse = par_VEH.m - 1500;
R_Stab_m = 1 + (1*masse/8000);
R_Stab = R_Stab_r * R_Stab_m;
if R_Stab < 0.1 %Minimalwert für R_Stab um Division durch "0" zu vermeiden
    R_Stab = 0.1;
else
end
%%evalin-Befehl laesst Werte aus Workspace in Funktionen einlesen
% R_Stab = evalin('base', 'R_Stab');
% R_Stab = 6; 
WWG = 0.45;                                                   %WWG = Wankwinkelgradient
WWG_rad = WWG * pi / 180;

%Wankachsenhöhe und Hebelarm
slope_WA = (par_VEH.zRCr - par_VEH.zRCf)/IP.Radstand*1000;      %Berechnung der Wankachsenneigung
H_r = abs(par_VEH.zRCf + par_VEH.xSP * slope_WA - par_VEH.zSP); %Berechnung des Wankmomentenhebelarms

%Absenkung des Schwerpunkts durch Einfederung der Reifen durch Fahrzeuggewicht
z_tire_static = (0.25 * par_VEH.m * par_VEH.g) / ...
                ((par_TIR(1).VERTICAL_STIFFNESS + par_TIR(2).VERTICAL_STIFFNESS) / 2); %Berechnung der Reifeneinfederung
H_r_korr = H_r - z_tire_static;                                                        %Reifeneinfederung von Ausgangshebelarm abziehen
            
%Reifenkorrekturfaktoren zur Erfassung des Wankmomentenanteils, der nicht durch die Aufbaufederung, 
%sondern durch die Radlenker auf die Reifen übertragen wird. Dieser Wankmomentenanteil erzeugt eine zusätzliche Einfederung der Reifen,
%die hier mittels einer verringerten Reifenvertikalsteifigkeit (Korrekturfaktoren < 1) berücksichtigt wird.
Tire_stiffness_korr_F = 1 / (1+ 2*(par_VEH.lR/par_VEH.l)*((par_VEH.zRCf+par_TIR(1).UNLOADED_RADIUS-z_tire_static)/H_r_korr));
Tire_stiffness_korr_R = 1 / (1+ 2*(par_VEH.lF/par_VEH.l)*((par_VEH.zRCr+par_TIR(2).UNLOADED_RADIUS-z_tire_static)/H_r_korr));

% Wankmomente aus Schwerpunktverschiebung und Querbeschleunigung
M_Schwerpunktverschiebung = 2 * par_VEH.m * par_VEH.g * (par_VEH.zSP-z_tire_static+((par_TIR(1).UNLOADED_RADIUS+par_TIR(2).UNLOADED_RADIUS)/2));
M_Querbeschl = 2 * par_VEH.m * H_r_korr;

%Vorbereitung der Variablen zur Stabiberechnung
y = (M_Querbeschl / WWG_rad) + M_Schwerpunktverschiebung;
a = Tire_stiffness_korr_F * par_TIR(1).VERTICAL_STIFFNESS * par_VEH.sF^2;
b = par_VEH.csF * par_VEH.ssF^2;
c = Tire_stiffness_korr_R * par_TIR(2).VERTICAL_STIFFNESS * par_VEH.sR^2;
d = par_VEH.csR * par_VEH.ssR^2;
r = R_Stab;

%Berechnung Stabilisatorsteifigkeiten
% "select_arb_solver" wählt aus, ob die Stabisteifigkeiten mittels numerischem Matlabsolver ("1")
% oder bereits aufgelöster Gleichung ("0") berechnet werdnen soll.
select_arb_solver = 0;

if select_arb_solver == 0
    carbF_sarbF_squared = (-1/(2*(a+c-y)))*(b*c + c*d*r + a*(b+c+((c+d)*r)-y) - b*y - c*r*y - ...
                      d*r*y - sqrt(4*r*(a+c-y)*(-b*c*d - a*(c*d + b*(c+d)) + a*(c+d)*y + b*(c+d)*y) + ...
                            (c*(b+d*r) + a*(b+c+(c+d)*r-y) - (b+(c+d)*r)*y)^2));  %carbF_sarbF_squared entspricht dem Produkt aus Stabisteifigkeit und Stabispurweite zum Quadrat                  
else
    syms x
    eq = ((a^(-1))+((x+b)^(-1)))^(-1) + ((c^(-1))+(((1/r)*x + d)^(-1)))^(-1) == y;
    Ergebnis = solve(eq,x);

    if double(Ergebnis(1)) > 0 %Gleichung hat zwei Lösungen. Die hier gesuchte Lösung ist die positive der beiden.
        carbF_sarbF_squared = double(Ergebnis(1))
    else
        carbF_sarbF_squared = double(Ergebnis(2))
    end
end

par_VEH.carbF = carbF_sarbF_squared / par_VEH.sarbF^2;                            %Stabispurweite rausrechnen
par_VEH.carbR = ((1/r) * carbF_sarbF_squared) / par_VEH.sarbR^2;                  %Stabisteifigkeit an der HA mittels R_Stab berechnen

end
