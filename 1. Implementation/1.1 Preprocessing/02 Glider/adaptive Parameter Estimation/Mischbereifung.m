function [par_TIR,par_VEH] = Mischbereifung(par_TIR,par_VEH)
%% Berechnung der gewünschten Reifenbreite
R_HA = par_VEH.xSP / par_VEH.l;
par_VEH.EG_opt.RB_rear = par_TIR(2).WIDTH*1000 + (R_HA - 0.5)*400; %(par_TIR(2).WIDTH*1000) * ( par_VEH.xSP / (IP.Radstand/1000 - par_VEH.xSP) );
%% Berechnung Reifenwerte
pressure = par_TIR(2).IP;
aspect_ratio = 100 * par_TIR(2).ASPECT_RATIO * ( (par_TIR(2).WIDTH*1000) / par_VEH.EG_opt.RB_rear );
cz_calc = (0.00028 * pressure * sqrt((-0.004*aspect_ratio + 1.03)*par_VEH.EG_opt.RB_rear*par_TIR(2).DIAMETER*1000) + 3.45)*1000*9.81;
cz = par_TIR(2).VERTICAL_STIFFNESS * ( cz_calc / par_TIR(2).VERTICAL_STIFFNESS_CALC );
croll = par_TIR(2).QSY1 * ( par_VEH.EG_opt.RB_rear / (par_TIR(2).WIDTH*1000) );
wt = par_VEH.EG_opt.RB_rear;
load = 0;
%% Differenzen berechnen
if par_TIR(2).VERTICAL_STIFFNESS == 353364 && par_TIR(2).RIM == 19 %Tesla Reifen erkennen anhand zweier Parameter
        % Berechnung Differenzen mithilfe der Werte von Holtz für den Tesla Regressionsreifen
        d_cz = cz_calc - 260002;
        d_dr = 19 - 18;
        croll = 0.0074732 * ( par_VEH.EG_opt.RB_rear / 215);
        d_croll = croll - 0.0074732;
        d_wt = ( par_VEH.EG_opt.RB_rear - 215 ) / 1000;
        d_dt = 0.7031 - 0.6292;
        d_load = 102 - 85;
        d_speed = 0;
else
        %Berechnung Differenzen mithilfe der Reifenwerte für alle anderen Reifen
        d_cz = cz - par_TIR(2).VERTICAL_STIFFNESS;
        d_dr = 0;
        d_croll = croll - par_TIR(2).QSY1;
        d_wt = ( par_VEH.EG_opt.RB_rear - (par_TIR(2).WIDTH*1000) ) / 1000;
        d_dt = 0;
        d_load = 0; %load - 100;
        d_speed = 0;
end
%% Berechnung Skalierungsfaktoren mithilfe der Differenzen
par_TIR(2).LCX = 0.98 - 4.106 * 1E-7 * d_cz;
par_TIR(2).LMUX = 1.02 + 0.0353 * d_dr - 3.557 * 1E-7 * d_cz;
par_TIR(2).LKX = 1.17 - 64.563 * d_croll + 1.421 * 1E-6 * d_cz;
par_TIR(2).LCY = 1.05 + 2.931 * d_wt - 43.272 * d_croll - 1.834 * 1E-6 * d_cz;
par_TIR(2).LMUY = 1.04 + 0.253 * d_wt + 0.018 * d_dr + 14.12 * d_croll;
par_TIR(2).LKY = 1.07 + 1.298 * d_wt - 0.0183 * d_dr + 9.405 * 1E-7 * d_cz;
par_TIR(2).LTR = 1.01 - 76.79 * d_croll - 5.543 * d_dt;
par_TIR(2).LMX = 0.98 + 8.78 * d_wt - 0.0368 * d_load + 1.905 * 1E-6 * d_cz;
par_TIR(2).LS = 1 + 2.757 * d_wt + 9.11 * 1E-4 * d_speed + 1.382 * 1E-6 * d_cz;
par_TIR(2).LSGAL =  1.05 - 0.172 * d_dr - 46.092 * d_croll - 3.593 * 1E-6 * d_cz;
par_TIR(2).LSGKP = 0.61 - 0.012 * d_load - 7.645 * 1E-6 * d_cz;
%% Neuen Rollwiderstandswert schreiben
par_TIR(2).QSY1 = croll;
end