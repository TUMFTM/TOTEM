function [par_VEH, I] = I_y(par_VEH, m, IP, NR, par_MDT)
%%Berechnung des Trägheitsmoment um die y-Achse

xSP = par_VEH.xSP * 1000 + IP.UeH_v;
%%Structure
a_ges =     0.5 * IP.UeH_v + 1.0 * IP.Radstand + 0.75 * IP.UeH_h;
a_front =   0.5 * IP.UeH_v / a_ges;
a_mid =     1.0 * IP.Radstand / a_ges;
a_rear =    0.75 * IP.UeH_h / a_ges;

r_front =   a_front * (IP.UeH_v * 0.5 + par_VEH.xSP)^2;
r_mid =     1.8/12 * a_mid * ((IP.Radstand)^2 + (IP.Hoehe)^2) + ...
            a_mid * ((0.5 * IP.Radstand)^2 + (0.5 * IP.Hoehe)^2); 
r_rear =    a_rear * (IP.UeH_v + IP.Radstand + IP.UeH_h * 0.5 - xSP)^2;

I.ST.frame =      m.ST.frame * (r_front + r_mid + r_rear);
I.ST.crash_fr =   m.ST.crash_fr * (IP.UeH_v * 4.1/2.7 * 0.5 - xSP)^2;
I.ST.crash_re =   m.ST.crash_re * (IP.UeH_v + IP.Radstand + IP.UeH_h * 0.5 - xSP)^2;

I.Sum.ST =  I.ST.frame + I.ST.crash_fr + I.ST.crash_re;

%%Chassis
I.CH.ax_re_ml =       m.CH.ax_re_ml * (IP.UeH_v - xSP)^2;
I.CH.susp_re_ml =     m.CH.susp_re_ml * (IP.UeH_v - xSP)^2;
I.CH.ax_fr_mcp =      m.CH.ax_fr_mcp * (IP.UeH_v + IP.Radstand - xSP)^2;
I.CH.susp_fr_mcp =    m.CH.susp_fr_mcp * (IP.UeH_v + IP.Radstand- xSP)^2;

I.CH.steer =              m.CH.steer * (IP.UeH_v * 1.1 - xSP)^2;    
I.CH.brake_total =        m.CH.brake_total * (0.6*(IP.UeH_v - xSP)^2+ 0.4 *(IP.UeH_v + IP.Radstand - xSP)^2);
I.CH.wheels_fr_normal =   m.CH.wheels_fr_normal * (IP.UeH_v - xSP)^2;
I.CH.wheels_re_normal =   m.CH.wheels_re_normal * (IP.UeH_v + IP.Radstand - xSP)^2;

I.Sum.CH =  I.CH.ax_re_ml + I.CH.susp_re_ml + I.CH.ax_fr_mcp + I.CH.susp_fr_mcp + I.CH.steer + I.CH.brake_total + ...
            I.CH.wheels_fr_normal + I.CH.wheels_re_normal;

%%Drivetrain
if IP.electric == 0
    if strcmp(IP.Mot_Einb, 'long') 
        I.DT.eng_comb =   m.DT.eng_comb * (IP.UeH_v * (1 - 7/18) - xSP)^2;
        I.DT.gearbox =    m.DT.gearbox * (IP.UeH_v * (1 + 7/18) - xSP)^2;
    elseif strcmp(IP.Mot_Einb, 'tran')
        I.DT.eng_comb =   m.DT.eng_comb * (IP.UeH_v * 0.5 - xSP)^2;
        I.DT.gearbox =    m.DT.gearbox * (IP.UeH_v * 0.5 - xSP)^2;
    end

    if strcmp(IP.Antr_Art, 'FWD') 
        I.DT.shaft =      m.DT.shaft * (IP.UeH_v - xSP)^2;
    elseif strcmp(IP.Antr_Art, 'AWD')
        I.DT.shaft =      m.DT.shaft * (IP.UeH_v + IP.Radstand * 0.5 - xSP)^2;
    end

    I.DT.clutch =     m.DT.clutch * (IP.UeH_v + 700 + 50 -xSP)^2;
    I.DT.exhaust =    m.DT.exhaust * (IP.UeH_v + (IP.Radstand + IP.UeH_h) * 0.5 - xSP)^2;
    I.DT.fuel =       m.DT.fuel * (IP.UeH_v + IP.Radstand + 450 -xSP)^2; %%!!!!

    I.Sum.DT =  I.DT.eng_comb + I.DT.gearbox + I.DT.shaft + I.DT.clutch + I.DT.exhaust + I.DT.fuel;
else
    I.DT.HVBatt =     1/12 * m.DT.HVBatt * (IP.Radstand^2 + (IP.Hoehe/10)^2);
    I.DT.eng_VA =     m.DT.eng_VA * (IP.UeH_v)^2; %Anpassen mit Daten von Frederik
    I.DT.eng_HA =     m.DT.eng_HA * (IP.UeH_v + IP.Radstand - xSP)^2; %Anpassen mit Daten von Frederik
    %I.DT.AW_VA =      m.DT.AW_VA * (IP.UeH_v - xSP)^2; %Anpassen mit Daten von Frederik
    %I.DT.AW_HA =      m.DT.AW_HA * (IP.UeH_v + IP.Radstand - xSP)^2; %Anpassen mit Daten von Frederik
    
    %I.DT.OD_VA =      m.DT.OD_VA * (IP.UeH_v - xSP)^2; %Anpassen mit Daten von Frederik
    %I.DT.OD_HA =      m.DT.OD_HA * (IP.UeH_v + IP.Radstand - xSP)^2; %Anpassen mit Daten von Frederik
    %I.DT.eTV_VA =     m.DT.eTV_VA * (IP.UeH_v - xSP)^2; %Anpassen mit Daten von Frederik
    %I.DT.eTV_HA =     m.DT.eTV_HA * (IP.UeH_v + IP.Radstand - xSP)^2; %Anpassen mit Daten von Frederik
    I.DT.GTR_VA =     m.DT.GTR_VA * (IP.UeH_v - xSP)^2; %Anpassen mit Daten von Frederik
    I.DT.GTR_HA =     m.DT.GTR_HA * (IP.UeH_v + IP.Radstand - xSP)^2; %Anpassen mit Daten von Frederik
    
    I.Sum.DT =      I.DT.HVBatt + I.DT.eng_VA + I.DT.eng_HA +  I.DT.GTR_VA + I.DT.GTR_HA;
    
                    %I.DT.AW_VA + I.DT.AW_HA + ...
                    %I.DT.OD_VA + I.DT.OD_HA + I.DT.eTV_VA + I.DT.eTV_HA +
end

%%EE
if IP.electric == 0
    I.EE.bat_12v =    m.EE.bat_12v * (IP.UeH_v + IP.Radstand + IP.UeH_h - 300 - xSP)^2;
    I.EE.nv_wiring =  m.EE.nv_wiring * (IP.UeH_v + (IP.Radstand + IP.UeH_h) * 0.25 -xSP)^2;
    I.EE.light_ext =  m.EE.light_ext * 0.5 * ((IP.UeH_v + IP.Radstand + IP.UeH_h) - xSP)^2 + (xSP)^2;

I.Sum.EE =  I.EE.bat_12v + I.EE.nv_wiring + I.EE.light_ext;

else
    I.EE.bat_12v =    m.EE.bat_12v * (IP.UeH_v + IP.Radstand + IP.UeH_h - 300 - xSP)^2;
    I.EE.nv_wiring =  m.EE.nv_wiring * (0.25 * NR.SpW_avg)^2;
    I.EE.light_ext =  m.EE.light_ext * (0.4 * NR.SpW_avg)^2;
    
    I.EE.dc_dc =        m.EE.dc_dc * (IP.UeH_v + (IP.Radstand + IP.UeH_h) * 0.25 -xSP)^2;
    I.EE.invert =       m.EE.invert * (IP.UeH_v + (IP.Radstand + IP.UeH_h) * 0.25 -xSP)^2;
    I.EE.hv_wiring =    m.EE.hv_wiring * (IP.UeH_v + (IP.Radstand + IP.UeH_h) * 0.25 -xSP)^2;
    I.EE.hv_steck =     m.EE.hv_steck * (IP.UeH_v + (IP.Radstand + IP.UeH_h) * 0.25 -xSP)^2;

    I.Sum.EE =  I.EE.nv_wiring + I.EE.light_ext + I.EE.dc_dc + I.EE.invert + I.EE.hv_wiring + I.EE.hv_steck;
end

%%Exterieur
I.EX.doors =      m.EX.doors * (IP.UeH_v + IP.Radstand * 5.0/8.65 -xSP)^2;
I.EX.hood =       m.EX.hood * (IP.UeH_v * 2.0/2.7 - xSP)^2;
I.EX.tg_hat =     m.EX.tg_hat * (IP.UeH_v + IP.Radstand + IP.UeH_h - 50 - xSP)^2; 
I.EX.fender =     m.EX.fender * ((IP.UeH_v + IP.Radstand + IP.UeH_h) * 0.5 - xSP)^2; %%!!!!
I.EX.bump_fr =    m.EX.bump_fr * (50 - xSP)^2;
I.EX.bump_re =    m.EX.bump_re * (IP.UeH_v + IP.Radstand + IP.UeH_h - 50 - xSP)^2;
I.EX.win_fr =     m.EX.win_fr * (IP.UeH_v * 4.1/2.7 + 1.3/5.2 * IP.Hoehe / tand(IP.WSSW) * 0.5 - xSP)^2;
I.EX.sidws =      (m.EX.sidws_fr + m.EX.sidws_re) * (IP.UeH_v + IP.Radstand * 5.0/8.65 - xSP)^2;
I.EX.win_re =     m.EX.win_re * (IP.UeH_v + IP.Radstand + IP.UeH_h - 300 -xSP)^2; %%!!!!

I.Sum.EX =  I.EX.doors + I.EX.hood + I.EX.tg_hat + I.EX.fender + I.EX.bump_fr + I.EX.bump_re + I.EX.win_fr + I.EX.sidws + I.EX.win_re;

%%Interieur
I.IN.seats_fr =       m.IN.seats_fr * (IP.UeH_v + 3.5/8.65 * IP.Radstand + IP.UeH_v * 1.25/2.7 - xSP)^2;
I.IN.seats_re =       m.IN.seats_re * (IP.UeH_v + 6.2/8.65 * IP.Radstand + IP.UeH_v * 1.25/2.7 - xSP) ^2;
I.IN.cover_side =     m.IN.cover_side * (IP.UeH_v + IP.Radstand * 0.5 - xSP)^2;
I.IN.cover_doors =    m.IN.cover_doors * (IP.UeH_v + IP.Radstand * 0.5 - xSP)^2;
I.IN.cover_rear =     m.IN.cover_rear * (IP.UeH_v + IP.Radstand + IP.UeH_h * 0.5 -xSP)^2;
I.IN.dashboard =      m.IN.dashboard * (IP.UeH_v + IP.Radstand * 2.5/8.65 - xSP)^2;
I.IN.centerconsole =  m.IN.centerconsole* (IP.UeH_v + IP.Radstand * 2.5/8.65 - xSP)^2;
I.IN.insul =          m.IN.insul * (IP.UeH_v + IP.Radstand * 0.5 - xSP)^2;

I.Sum.IN =  I.IN.seats_fr + I.IN.seats_re + I.IN.cover_side + I.IN.cover_doors + I.IN.cover_rear + I.IN.dashboard + I.IN.centerconsole +  I.IN.insul;

%%Calculation           
I.Sum.All = I.Sum.ST + I.Sum.CH + I.Sum.DT + I.Sum.EE + 1.3 * I.Sum.EX + 1.3 * I.Sum.IN;

par_VEH.Iy = 1.00 * I.Sum.All /(1000)^2;            

end

            
            
            
            
          
            
            
            
            
            

