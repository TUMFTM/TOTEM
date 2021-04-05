function [par_VEH] = I_x(par_VEH, m, IP, NR, par_MDT)
%%Berechnung des Trägheitsmoment um die x-Achse

xSP = par_VEH.xSP * 1000 + IP.UeH_v;
height_avg = IP.Hoehe * (0.5 * IP.UeH_v + 1.0 * IP.Radstand + 0.75 * IP.UeH_h)/(NR.Laenge);
%%Structure
I.ST.frame =      1.7/12 *  m.ST.frame * ((height_avg)^2 + (IP.Breite)^2);
I.ST.crash_fr =   m.ST.crash_fr * (0.4 * IP.Breite)^2;
I.ST.crash_re =   m.ST.crash_re * (0.4 * IP.Breite)^2;

I.Sum.ST =  I.ST.frame + I.ST.crash_fr + I.ST.crash_re;

%%Chassis
I.CH.ax_re_ml =       1/12 * m.CH.ax_re_ml * ((IP.Hoehe/10)^2 + (NR.SpW_avg)^2) ;
I.CH.susp_re_ml =     m.CH.susp_re_ml * (0.45 * NR.SpW_avg)^2;
I.CH.ax_fr_mcp =      1/12 * m.CH.ax_fr_mcp * ((IP.Hoehe/10)^2 + (NR.SpW_avg)^2);
I.CH.susp_fr_mcp =    m.CH.susp_fr_mcp * (0.45 * NR.SpW_avg)^2;

I.CH.steer =              1/12 * m.CH.steer * ((IP.Hoehe/20)^2 + (NR.SpW_avg)^2);
I.CH.brake_total =        m.CH.brake_total * (0.5 * NR.SpW_avg)^2;
I.CH.wheels_fr_normal =   m.CH.wheels_fr_normal * (0.5 * NR.SpW_avg)^2;
I.CH.wheels_re_normal =   m.CH.wheels_re_normal * (0.5 * NR.SpW_avg)^2;

I.Sum.CH =  I.CH.ax_re_ml + I.CH.susp_re_ml + I.CH.ax_fr_mcp + I.CH.susp_fr_mcp + I.CH.steer + I.CH.brake_total + ...
            I.CH.wheels_fr_normal + I.CH.wheels_re_normal;

%%Drivetrain
if IP.electric == 0
    if strcmp(IP.Mot_Einb, 'long') 
        I.DT.eng_comb =   1/12 * m.DT.eng_comb * ((300)^2 + (350)^2); 
        I.DT.gearbox =    1/12 * m.DT.gearbox * ((380)^2 + (710)^2); 
    elseif strcmp(IP.Mot_Einb, 'tran')
        I.DT.eng_comb =   1/12 * m.DT.eng_comb * ((400)^2 + (350)^2); 
        I.DT.gearbox =    1/12 * m.DT.gearbox * ((955)^2 + (380)^2); 
    end
    I.DT.shaft =      1/12 * m.DT.shaft * ((IP.Hoehe/20)^2 + (NR.SpW_avg)^2);
    I.DT.clutch =     2/12 * m.DT.clutch * (375)^2;
    I.DT.exhaust =    2/12 * m.DT.exhaust * (300)^2;
    I.DT.fuel =       1/12 * m.DT.fuel * ((0.8 * IP.Breite)^2 + (0.3 * IP.Hoehe)^2); %%!!!!
    
    I.Sum.DT =  I.DT.eng_comb + I.DT.gearbox + I.DT.shaft + I.DT.clutch + I.DT.exhaust + I.DT.fuel;
else
    I.DT.HVBatt =     1/12 * m.DT.HVBatt * (IP.Breite^2 + (IP.Hoehe/10)^2);
    I.DT.eng_VA =     m.DT.eng_VA * (NR.SpW_avg/2)^2; %Anpassen mit Daten von Frederik
    I.DT.eng_HA =     m.DT.eng_HA * (NR.SpW_avg/2)^2; %Anpassen mit Daten von Frederik
    %I.DT.AW_VA =      m.DT.AW_VA * (NR.SpW_avg/2)^2; %Anpassen mit Daten von Frederik
    %I.DT.AW_HA =      m.DT.AW_HA * (NR.SpW_avg/2)^2; %Anpassen mit Daten von Frederik
    
    %I.DT.OD_VA =      m.DT.OD_VA * (NR.SpW_avg/2)^2; %Anpassen mit Daten von Frederik
    %I.DT.OD_HA =      m.DT.OD_HA * (NR.SpW_avg/2)^2; %Anpassen mit Daten von Frederik
    %I.DT.eTV_VA =     m.DT.eTV_VA * (NR.SpW_avg/2)^2; %Anpassen mit Daten von Frederik
    %I.DT.eTV_HA =     m.DT.eTV_HA * (NR.SpW_avg/2)^2; %Anpassen mit Daten von Frederik
    I.DT.GTR_VA =     m.DT.GTR_VA * (NR.SpW_avg/2)^2; %Anpassen mit Daten von Frederik
    I.DT.GTR_HA =     m.DT.GTR_HA * (NR.SpW_avg/2)^2; %Anpassen mit Daten von Frederik
    
    I.Sum.DT =      I.DT.HVBatt + I.DT.eng_VA + I.DT.eng_HA + I.DT.GTR_VA + I.DT.GTR_HA;
    
                    %I.DT.AW_VA + I.DT.AW_HA + ...
                    %I.DT.OD_VA + I.DT.OD_HA + I.DT.eTV_VA + I.DT.eTV_HA + 
end

%%EE
if IP.electric == 0
    I.EE.nv_wiring =  m.EE.nv_wiring * (0.25 * NR.SpW_avg)^2;
    I.EE.light_ext =  m.EE.light_ext * (0.4 * NR.SpW_avg)^2;
    
    I.Sum.EE =  I.EE.nv_wiring + I.EE.light_ext;
else
    I.EE.nv_wiring =  m.EE.nv_wiring * (0.25 * NR.SpW_avg)^2;
    I.EE.light_ext =  m.EE.light_ext * (0.4 * NR.SpW_avg)^2;
    
    I.EE.dc_dc =        m.EE.dc_dc * (0.25 * NR.SpW_avg)^2;
    I.EE.invert =       m.EE.invert * (0.25 * NR.SpW_avg)^2;
    I.EE.hv_wiring =    m.EE.hv_wiring * (0.25 * NR.SpW_avg)^2;
    I.EE.hv_steck =     m.EE.hv_steck * (0.25 * NR.SpW_avg)^2;

    I.Sum.EE =  I.EE.nv_wiring + I.EE.light_ext + I.EE.dc_dc + I.EE.invert + I.EE.hv_wiring + I.EE.hv_steck;
end

%%Exterieur
I.EX.doors =      m.EX.doors * (0.5 * IP.Breite)^2;
I.EX.hood =       m.EX.hood * (0.3 * IP.Breite)^2;
I.EX.tg_hat =     m.EX.tg_hat * (0.3 * IP.Breite)^2; 
I.EX.fender =     m.EX.fender * (0.3 * IP.Breite)^2; 
I.EX.bump_fr =    m.EX.bump_fr * (0.3 * IP.Breite)^2;
I.EX.bump_re =    m.EX.bump_re * (0.3 * IP.Breite)^2;
I.EX.win_fr =     m.EX.win_fr * (0.3 * IP.Breite)^2;
I.EX.sidws =      (m.EX.sidws_fr + m.EX.sidws_re) * (0.5 * IP.Breite)^2;
I.EX.win_re =     m.EX.win_re * (0.3 * IP.Breite)^2; 

I.Sum.EX =  I.EX.doors + I.EX.hood + I.EX.tg_hat + I.EX.fender + I.EX.bump_fr + I.EX.bump_re + I.EX.win_fr + I.EX.sidws + I.EX.win_re;

%%Interieur
I.IN.seats_fr =       m.IN.seats_fr * (0.3 * IP.Breite)^2;
I.IN.seats_re =       m.IN.seats_re * (0.3 * IP.Breite)^2;
I.IN.cover_side =     m.IN.cover_side * (0.5 * IP.Breite)^2;
I.IN.cover_doors =    m.IN.cover_doors * (0.5 * IP.Breite)^2;
I.IN.cover_rear =     m.IN.cover_rear * (0.3 * IP.Breite)^2;
I.IN.dashboard =      m.IN.dashboard * (0.3 * IP.Breite)^2;
I.IN.centerconsole =  m.IN.centerconsole* (0.3 * IP.Breite)^2;
I.IN.insul =          m.IN.insul * (0.3 * IP.Breite)^2;

I.Sum.IN =  I.IN.seats_fr + I.IN.seats_re + I.IN.cover_side + I.IN.cover_doors + I.IN.cover_rear + I.IN.dashboard + I.IN.centerconsole +  I.IN.insul;

%%Calculation          
I.Sum.All = I.Sum.ST + I.Sum.CH + I.Sum.DT + I.Sum.EE + I.Sum.EX + I.Sum.IN;

par_VEH.Ix = I.Sum.All / (1000)^2;            
            
end

            
            
            
            
          
            
            
            
            
            

