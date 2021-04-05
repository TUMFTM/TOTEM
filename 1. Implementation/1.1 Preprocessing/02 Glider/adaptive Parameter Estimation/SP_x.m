function [par_VEH] = SP_x(par_VEH, m, IP, NR, par_MDT)

batt_shift = 0; % Reset Batterieverschiebung
batt_shift_done = 0; % Reset Abfrage Batterieverschiebung
par_VEH.EG_opt.trigger = 0; %Reset Trigger für weitere EG Optimierungsmaßnahmen (Bspw. für Mischbereifung)
 
for SPx_counter = 1:2
%%Schwerpunktsberechnung x-Richtung wird einmal ohne und einmal mit
%%Batterieverschiebung durchgeführt.
% Der Schwerpunkt wird absolut berechnet. Am Ende muss der vordere Ueberhang noch abgezogen werden, damit der Schwerpunkt von der Vorderachse aus berechnet wird,
% wie dies im Zweispurmodell geforder ist.

%%Structure
cog.ST.frame =      ((IP.UeH_v * 0.5)*(0.5*IP.UeH_v) +(IP.UeH_v + IP.Radstand* 0.5)*(1.0 * IP.Radstand) + (IP.UeH_v + IP.Radstand + IP.UeH_h * 0.5) * (0.75*IP.UeH_h))/...
                    ((0.5*IP.UeH_v) + (1.0 * IP.Radstand) + (0.75*IP.UeH_h));
cog.ST.crash_fr =   IP.UeH_v  * 0.5;
cog.ST.crash_re =   IP.UeH_v + IP.Radstand + IP.UeH_h * 0.5;

cog.Sum.ST_m =  m.ST.frame + m.ST.crash_fr + m.ST.crash_re;
cog.Sum.ST =    (cog.ST.frame * m.ST.frame + cog.ST.crash_fr * m.ST.crash_fr + cog.ST.crash_re * m.ST.crash_re) / cog.Sum.ST_m;

%%Chassis
cog.CH.ax_re_ml =       IP.UeH_v;
cog.CH.susp_re_ml =     IP.UeH_v;
cog.CH.ax_fr_mcp =      IP.UeH_v + IP.Radstand;
cog.CH.susp_fr_mcp =    IP.UeH_v + IP.Radstand;

cog.CH.steer =              IP.UeH_v * 1.1;     
cog.CH.brake_total =        IP.UeH_v + IP.Radstand * 0.4;
cog.CH.wheels_fr_normal =   IP.UeH_v;
cog.CH.wheels_re_normal =   IP.UeH_v + IP.Radstand;

cog.Sum.CH_m =  m.CH.ax_re_ml + m.CH.susp_re_ml + m.CH.ax_fr_mcp + m.CH.susp_fr_mcp + m.CH.steer + m.CH.brake_total + ...
                m.CH.wheels_fr_normal + m.CH.wheels_re_normal;
cog.Sum.CH =    (m.CH.ax_re_ml * cog.CH.ax_re_ml + m.CH.susp_re_ml * cog.CH.susp_re_ml + m.CH.ax_fr_mcp * cog.CH.ax_fr_mcp + ...
                m.CH.susp_fr_mcp * cog.CH.susp_fr_mcp + m.CH.steer * cog.CH.steer + m.CH.brake_total * cog.CH.brake_total + ...
                m.CH.wheels_fr_normal * cog.CH.wheels_fr_normal + m.CH.wheels_re_normal * cog.CH.wheels_re_normal) / cog.Sum.CH_m;

%%Drivetrain
if IP.electric == 0
    if strcmp(IP.Mot_Einb, 'long') 
        cog.DT.eng_comb =   IP.UeH_v * (1 - 7/18);
        cog.DT.gearbox =    IP.UeH_v * (1 + 7/18); 
        cog.DT.clutch =     IP.UeH_v + 700 + 50;
    elseif strcmp(IP.Mot_Einb, 'tran')
        cog.DT.eng_comb =   IP.UeH_v * 0.5; 
        cog.DT.gearbox =    IP.UeH_v * 0.5;
        cog.DT.clutch =     IP.UeH_v * 0.5;
    end


    if strcmp(IP.Antr_Art, 'FWD') 
        cog.DT.shaft =      IP.UeH_v;
    elseif strcmp(IP.Antr_Art, 'AWD')
        cog.DT.shaft =      IP.UeH_v + IP.Radstand * 0.5;
    end

    cog.DT.exhaust =    IP.UeH_v + (IP.Radstand + IP.UeH_h) * 0.5;
    cog.DT.fuel =       IP.UeH_v + IP.Radstand + 450;
    
    cog.Sum.DT_m =  m.DT.eng_comb + m.DT.gearbox + m.DT.shaft + m.DT.clutch + m.DT.exhaust + m.DT.fuel + m.DT.fueltank;
    cog.Sum.DT =    (m.DT.eng_comb * cog.DT.eng_comb + m.DT.gearbox * cog.DT.gearbox + m.DT.shaft * cog.DT.shaft + m.DT.clutch * cog.DT.clutch + ...
                m.DT.exhaust * cog.DT.exhaust + m.DT.fuel * cog.DT.fuel + m.DT.fueltank * cog.DT.fuel) / cog.Sum.DT_m;
else
    cog.DT.HVBatt =     IP.UeH_v + IP.Radstand/2 - batt_shift; %batt_shift: Batterieverschiebung nach vorn
    cog.DT.eng_VA =     IP.UeH_v; %Anpassen mit Daten von Frederik
    cog.DT.eng_HA =     IP.UeH_v + IP.Radstand;%Anpassen mit Daten von Frederik
    %cog.DT.AW_VA =      IP.UeH_v; %Anpassen mit Daten von Frederik
    %cog.DT.AW_HA =      IP.UeH_v + IP.Radstand; %Anpassen mit Daten von Frederik
    
    %cog.DT.OD_VA =      IP.UeH_v; %Anpassen mit Daten von Frederik
    %cog.DT.OD_HA =      IP.UeH_v + IP.Radstand; %Anpassen mit Daten von Frederik
    %cog.DT.eTV_VA =     IP.UeH_v; %Anpassen mit Daten von Frederik
    %cog.DT.eTV_HA =     IP.UeH_v + IP.Radstand; %Anpassen mit Daten von Frederik
    cog.DT.GTR_VA =     IP.UeH_v; %Anpassen mit Daten von Frederik
    cog.DT.GTR_HA =     IP.UeH_v + IP.Radstand; %Anpassen mit Daten von Frederik
    cog.DT.steuer_VA =     IP.UeH_v; %Anpassen mit Daten von Frederik
    cog.DT.steuer_HA =     IP.UeH_v + IP.Radstand; %Anpassen mit Daten von Frederik
    
    cog.Sum.DT_m =   m.DT.HVBatt +  m.DT.eng_VA + m.DT.eng_HA + m.DT.GTR_VA + m.DT.GTR_HA + m.DT.steuer_VA + m.DT.steuer_HA;
                     %m.DT.AW_VA + m.DT.AW_HA + m.DT.OD_VA + m.DT.OD_HA + ...
                     % + m.DT.eTV_VA + m.DT.eTV_HA  ;
    cog.Sum.DT =    (m.DT.HVBatt * cog.DT.HVBatt +  m.DT.eng_VA * cog.DT.eng_VA + m.DT.eng_HA * cog.DT.eng_HA +...
                     m.DT.GTR_VA * cog.DT.GTR_VA + m.DT.GTR_HA * cog.DT.GTR_HA + m.DT.steuer_VA*cog.DT.steuer_VA + + m.DT.steuer_HA*cog.DT.steuer_HA) /  cog.Sum.DT_m;
                     %m.DT.AW_VA * cog.DT.AW_VA + m.DT.AW_HA * cog.DT.AW_HA + m.DT.OD_VA * cog.DT.OD_VA + ...
                     %m.DT.OD_HA * cog.DT.OD_HA + m.DT.eTV_VA * cog.DT.eTV_VA + m.DT.eTV_HA * cog.DT.eTV_HA + ...
end

%%EE
if IP.electric == 0
    cog.EE.bat_12v =    IP.UeH_v + IP.Radstand * 0.5;
    cog.EE.nv_wiring =  IP.UeH_v + (IP.Radstand + IP.UeH_h) * 0.5;
    cog.EE.light_ext =  (IP.UeH_v + IP.Radstand + IP.UeH_h) * 0.5;

    cog.Sum.EE_m =  m.EE.bat_12v + m.EE.nv_wiring + m.EE.light_ext;
    cog.Sum.EE =    (m.EE.bat_12v * cog.EE.bat_12v + m.EE.nv_wiring * cog.EE.nv_wiring + m.EE.light_ext * cog.EE.light_ext) / cog.Sum.EE_m;
else
    cog.EE.bat_12v =    IP.UeH_v + IP.Radstand * 0.5;
    cog.EE.nv_wiring =  IP.UeH_v + (IP.Radstand + IP.UeH_h) * 0.5;
    cog.EE.light_ext =  (IP.UeH_v + IP.Radstand + IP.UeH_h) * 0.5;
    
    cog.EE.dc_dc =        IP.UeH_v + IP.Radstand * 0.5;
    cog.EE.invert =       IP.UeH_v + IP.Radstand * 0.5;
    cog.EE.hv_wiring =    IP.UeH_v + IP.Radstand * 0.5;
    cog.EE.hv_steck =     IP.UeH_v + IP.Radstand * 0.5;
    
    cog.Sum.EE_m =  m.EE.bat_12v + m.EE.nv_wiring + m.EE.light_ext + m.EE.dc_dc + m.EE.invert + m.EE.hv_wiring + m.EE.hv_steck;
    cog.Sum.EE =    (m.EE.bat_12v * cog.EE.bat_12v + m.EE.nv_wiring * cog.EE.nv_wiring + m.EE.light_ext * cog.EE.light_ext +...
                    m.EE.dc_dc * cog.EE.dc_dc + m.EE.invert * cog.EE.invert + m.EE.hv_wiring * cog.EE.hv_wiring + ...
                    m.EE.hv_steck * cog.EE.hv_steck) / cog.Sum.EE_m;
end

%%Exterieur
cog.EX.doors =      IP.UeH_v + IP.Radstand * 5.0/8.65;
cog.EX.hood =       IP.UeH_v * 2.0/2.7;
cog.EX.tg_hat =     IP.UeH_v + IP.Radstand + IP.UeH_h - 50; 
cog.EX.fender =     (IP.UeH_v + IP.Radstand + IP.UeH_h) * 0.5;
cog.EX.bump_fr =    50;
cog.EX.bump_re =    IP.UeH_v + IP.Radstand + IP.UeH_h - 50;
cog.EX.win_fr =     IP.UeH_v * 4.1/2.7 + 1.3/5.2 * IP.Hoehe / tand(IP.WSSW) * 0.5;
cog.EX.sidws =      IP.UeH_v + IP.Radstand * 5.0/8.65;
cog.EX.win_re =     IP.UeH_v + IP.Radstand + IP.UeH_h - 300;

cog.Sum.EX_m =  m.EX.doors + m.EX.hood + m.EX.tg_hat + m.EX.fender + m.EX.bump_fr + m.EX.bump_re + m.EX.win_fr + m.EX.sidws_fr + m.EX.sidws_re + m.EX.win_re;
cog.Sum.EX =    (m.EX.doors * cog.EX.doors + m.EX.hood * cog.EX.hood + m.EX.tg_hat * cog.EX.tg_hat + m.EX.fender * cog.EX.fender + ...
                m.EX.bump_fr * cog.EX.bump_fr + m.EX.bump_re * cog.EX.bump_re + m.EX.win_fr * cog.EX.win_fr + ...
                (m.EX.sidws_fr + m.EX.sidws_re) * cog.EX.sidws + m.EX.win_re * cog.EX.win_re) / cog.Sum.EX_m;


%%Interieur
cog.IN.seats_fr =       IP.UeH_v + 3.5/8.65 * IP.Radstand + IP.UeH_v * 1.25/2.7;
cog.IN.seats_re =       IP.UeH_v + 6.2/8.65 * IP.Radstand + IP.UeH_v * 1.25/2.7;
cog.IN.cover_side =     IP.UeH_v + IP.Radstand * 0.5;
cog.IN.cover_doors =    IP.UeH_v + IP.Radstand * 0.5;
cog.IN.cover_rear =     IP.UeH_v + IP.Radstand + IP.UeH_h * 0.5;
cog.IN.dashboard =      IP.UeH_v + IP.Radstand * 2.5/8.65;
cog.IN.centerconsole =  IP.UeH_v + IP.Radstand * 2.5/8.65;
cog.IN.insul =           IP.UeH_v + IP.Radstand * 0.5;

cog.Sum.IN_m =  m.IN.seats_fr + m.IN.seats_re + m.IN.cover_side + m.IN.cover_doors + m.IN.cover_rear + m.IN.dashboard + m.IN.centerconsole +  m.IN.insul;
cog.Sum.IN =    (m.IN.seats_fr * cog.IN.seats_fr  + m.IN.seats_re * cog.IN.seats_re + m.IN.cover_side * cog.IN.cover_side + ... 
                m.IN.cover_doors * cog.IN.cover_doors + m.IN.cover_rear * cog.IN.cover_rear + m.IN.dashboard * cog.IN.dashboard + ...
                m.IN.centerconsole * cog.IN.centerconsole +  m.IN.insul * cog.IN.insul) / cog.Sum.IN_m;
            
            
%%Calculation                 
cog.Sum.masse = cog.Sum.ST_m + cog.Sum.CH_m + cog.Sum.DT_m + cog.Sum.EE_m + cog.Sum.EX_m + cog.Sum.IN_m;
cog.Sum.x =     (cog.Sum.ST_m * cog.Sum.ST + cog.Sum.CH_m * cog.Sum.CH + cog.Sum.DT_m * cog.Sum.DT + ...
                cog.Sum.EE_m * cog.Sum.EE + cog.Sum.EX_m * cog.Sum.EX + cog.Sum.IN_m * cog.Sum.IN) / cog.Sum.masse;
            
par_VEH.xSP = (cog.Sum.x - IP.UeH_v)/1000;       
            
            
cog.Sum.front = 1 -  ((cog.Sum.x - IP.UeH_v) / IP.Radstand);

%%Batterieverschiebung zur Optimierung der Gewichtsverteilung 
if batt_shift_done == 0 %Batterieverschiebung nur im ersten Schleifendurchgang durchführen
    batt_shift = (par_VEH.m / m.DT.HVBatt) * (par_VEH.xSP*1000 - IP.Radstand/2);
    batt_shift_done = 1;
    
    % Aktivierung weiterer Optimierungsmaßnahmen bei Erreichen der maximal möglichen Verschiebung
    E_Batt = 333.33; %volumetrische Energiedichte auf Packebene ohne Packnebenkomponenten
    t_Batt = 100; %Batteriehoehe auf Packebene ohne Packnebenkomponenten
    b_Batt = IP.Breite - 2*100; %Batteriebreite ist Fahrzeugbreite abzgl. Schwellerbreiten
    max_batt_shift_pos = IP.Radstand/2 - (m.DT.Batt_Kap * 1000 * 1000000 / E_Batt / t_Batt / b_Batt)/2;
    max_batt_shift_neg = -max_batt_shift_pos;
    if batt_shift > max_batt_shift_pos
        batt_shift = max_batt_shift_pos;
        disp('Batterieverschiebung reicht nicht aus um COG-Position zu kompensieren')
        par_VEH.EG_opt.trigger = 1;
    elseif batt_shift < max_batt_shift_neg
        batt_shift = max_batt_shift_neg;
        par_VEH.EG_opt.trigger = 1;
        disp('Batterieverschiebung reicht nicht aus um COG-Position zu kompensieren')
    end
    par_VEH.EG_opt.batt_shift = batt_shift;
    par_VEH.EG_opt.max_shift = max_batt_shift_pos;
else
    
end

end

end          
            
            
            
            
          
            
            
            
            
            

