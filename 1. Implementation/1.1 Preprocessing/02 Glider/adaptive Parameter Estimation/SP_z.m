function [par_VEH, cog] = SP_z(par_VEH, m, IP, NR, par_MDT)
%%Schwerpunktsberechnung z-Richtung
% Der Schwerpunkt wird relativ vom tiefsten Punkt der Karosserie berechnet.
% Am Ende muss noch die Bodenfreiheit addiert werden, damit die
% tatsächliche Schwerpunktshöhe berechnet wird.
r_wheel = 0.5 * 1000 * NR.d_wheel;

%%Structure
cog.ST.frame =      ((0.3 * NR.CH)*(0.6 * NR.CH * NR.Laenge) + (0.8 * NR.CH)*(0.4 * NR.CH * (IP.Radstand + IP.UeH_h)))/...
                    ((0.6 * NR.CH * NR.Laenge) + (0.4 * NR.CH * (IP.Radstand + IP.UeH_h)));
cog.ST.crash_fr =   0.3 * NR.CH;
cog.ST.crash_re =   0.3 * NR.CH;

cog.Sum.ST_m =  m.ST.frame + m.ST.crash_fr + m.ST.crash_re;
cog.Sum.ST =    (cog.ST.frame * m.ST.frame + cog.ST.crash_fr * m.ST.crash_fr + cog.ST.crash_re * m.ST.crash_re) / cog.Sum.ST_m;

%%Chassis
cog.CH.ax_re_ml =       r_wheel - NR.GC;
cog.CH.susp_re_ml =     (cog.CH.ax_re_ml + 0.6 * NR.CH)/2;
cog.CH.ax_fr_mcp =      r_wheel - NR.GC;
cog.CH.susp_fr_mcp =    (cog.CH.ax_fr_mcp + 0.6 * NR.CH)/2;

cog.CH.steer =              (r_wheel - NR.GC) * 1.3; %%%!!!!      
cog.CH.brake_total =        r_wheel - NR.GC;
cog.CH.wheels_fr_normal =   r_wheel - NR.GC;
cog.CH.wheels_re_normal =   r_wheel - NR.GC;

cog.Sum.CH_m =  m.CH.ax_re_ml + m.CH.susp_re_ml + m.CH.ax_fr_mcp + m.CH.susp_fr_mcp + m.CH.steer + m.CH.brake_total + ...
                m.CH.wheels_fr_normal + m.CH.wheels_re_normal;
cog.Sum.CH =    (m.CH.ax_re_ml * cog.CH.ax_re_ml + m.CH.susp_re_ml * cog.CH.susp_re_ml + m.CH.ax_fr_mcp * cog.CH.ax_fr_mcp + ...
                m.CH.susp_fr_mcp * cog.CH.susp_fr_mcp + m.CH.steer * cog.CH.steer + m.CH.brake_total * cog.CH.brake_total + ...
                m.CH.wheels_fr_normal * cog.CH.wheels_fr_normal + m.CH.wheels_re_normal * cog.CH.wheels_re_normal) / cog.Sum.CH_m;
            
%%Drivetrain
if IP.electric == 0
cog.DT.eng_comb =   0.2 * NR.CH;
cog.DT.gearbox =    0.2 * NR.CH;
cog.DT.shaft =      r_wheel - NR.GC;
cog.DT.clutch =     0.2 * NR.CH;
cog.DT.exhaust =    r_wheel - NR.GC;
cog.DT.fuel =       2 * r_wheel - NR.GC;
    
    cog.Sum.DT_m =  m.DT.eng_comb + m.DT.gearbox + m.DT.shaft + m.DT.clutch + m.DT.exhaust + m.DT.fuel;
    cog.Sum.DT =    (m.DT.eng_comb * cog.DT.eng_comb + m.DT.gearbox * cog.DT.gearbox + m.DT.shaft * cog.DT.shaft + m.DT.clutch * cog.DT.clutch + ...
                m.DT.exhaust * cog.DT.exhaust + m.DT.fuel * cog.DT.fuel) / cog.Sum.DT_m;
            
else
    cog.DT.HVBatt =     r_wheel - NR.GC;;
    cog.DT.eng_VA =     r_wheel - NR.GC; %Anpassen mit Daten von Frederik
    cog.DT.eng_HA =     r_wheel - NR.GC; %Anpassen mit Daten von Frederik
    %cog.DT.AW_VA =      r_wheel - NR.GC; %Anpassen mit Daten von Frederik
    %cog.DT.AW_HA =      r_wheel - NR.GC; %Anpassen mit Daten von Frederik
    
    %cog.DT.OD_VA =      r_wheel - NR.GC; %Anpassen mit Daten von Frederik
    %cog.DT.OD_HA =      r_wheel - NR.GC; %Anpassen mit Daten von Frederik
    %cog.DT.eTV_VA =     r_wheel - NR.GC; %Anpassen mit Daten von Frederik
    %cog.DT.eTV_HA =     r_wheel - NR.GC; %Anpassen mit Daten von Frederik
    cog.DT.GTR_VA =     r_wheel - NR.GC; %Anpassen mit Daten von Frederik
    cog.DT.GTR_HA =     r_wheel - NR.GC; %Anpassen mit Daten von Frederik
    cog.DT.steuer_VA =     r_wheel - NR.GC; %Anpassen mit Daten von Frederik
    cog.DT.steuer_HA =     r_wheel - NR.GC; %Anpassen mit Daten von Frederik
    
    cog.Sum.DT_m =   m.DT.HVBatt +  m.DT.eng_VA + m.DT.eng_HA + m.DT.GTR_VA + m.DT.GTR_HA + m.DT.steuer_VA + m.DT.steuer_HA;
                     %+ m.DT.AW_VA + m.DT.AW_HA + m.DT.OD_VA + m.DT.OD_HA + ...
                     %+ m.DT.eTV_VA + m.DT.eTV_HA ;
    cog.Sum.DT =    (m.DT.HVBatt * cog.DT.HVBatt +  m.DT.eng_VA * cog.DT.eng_VA +...
                     m.DT.eng_HA * cog.DT.eng_HA +m.DT.GTR_VA * cog.DT.GTR_VA + m.DT.GTR_HA * cog.DT.GTR_HA + m.DT.steuer_VA * cog.DT.steuer_VA + m.DT.steuer_HA * cog.DT.steuer_HA) /  cog.Sum.DT_m;
                     %m.DT.AW_VA * cog.DT.AW_VA + m.DT.AW_HA * cog.DT.AW_HA + m.DT.OD_VA * cog.DT.OD_VA + ...
                     %m.DT.OD_HA * cog.DT.OD_HA + m.DT.eTV_VA * cog.DT.eTV_VA + m.DT.eTV_HA * cog.DT.eTV_HA + ...
end



%%EE
if IP.electric == 0
    cog.EE.bat_12v =    r_wheel - NR.GC;
    cog.EE.nv_wiring =  0.4 * NR.CH;
    cog.EE.light_ext =  0.4 * NR.CH;

    cog.Sum.EE_m =  m.EE.bat_12v + m.EE.nv_wiring + m.EE.light_ext;
    cog.Sum.EE =    (m.EE.bat_12v * cog.EE.bat_12v + m.EE.nv_wiring * cog.EE.nv_wiring + m.EE.light_ext * cog.EE.light_ext) / cog.Sum.EE_m;
else
    cog.EE.bat_12v =    r_wheel - NR.GC;
    cog.EE.nv_wiring =  0.4 * NR.CH;
    cog.EE.light_ext =  0.4 * NR.CH;
    cog.EE.dc_dc =        r_wheel - NR.GC;
    cog.EE.invert =       r_wheel - NR.GC;
    cog.EE.hv_wiring =    r_wheel - NR.GC;
    cog.EE.hv_steck =     r_wheel - NR.GC;
    
    cog.Sum.EE_m =  m.EE.bat_12v + m.EE.nv_wiring + m.EE.light_ext + m.EE.dc_dc + m.EE.invert + m.EE.hv_wiring + m.EE.hv_steck;
    cog.Sum.EE =    (m.EE.bat_12v * cog.EE.bat_12v + m.EE.nv_wiring * cog.EE.nv_wiring + m.EE.light_ext * cog.EE.light_ext +...
                    m.EE.dc_dc * cog.EE.dc_dc + m.EE.invert * cog.EE.invert + m.EE.hv_wiring * cog.EE.hv_wiring + ...
                    m.EE.hv_steck * cog.EE.hv_steck) / cog.Sum.EE_m;
end



%%Exterieur
cog.EX.doors =      0.35 * NR.CH;
cog.EX.hood =       0.50 * NR.CH;
cog.EX.tg_hat =     0.5 * NR.CH; 
cog.EX.fender =     2 * r_wheel - NR.GC;
cog.EX.bump_fr =    0.15 * NR.CH;
cog.EX.bump_re =    0.15 * NR.CH;
cog.EX.win_fr =     0.75 * NR.CH;
cog.EX.sidws =      0.75 * NR.CH;
cog.EX.win_re =     0.75 * NR.CH;

cog.Sum.EX_m =  m.EX.doors + m.EX.hood + m.EX.tg_hat + m.EX.fender + m.EX.bump_fr + m.EX.bump_re + m.EX.win_fr + m.EX.sidws_fr + m.EX.sidws_re + m.EX.win_re;
cog.Sum.EX =    (m.EX.doors * cog.EX.doors + m.EX.hood * cog.EX.hood + m.EX.tg_hat * cog.EX.tg_hat + m.EX.fender * cog.EX.fender + ...
                m.EX.bump_fr * cog.EX.bump_fr + m.EX.bump_re * cog.EX.bump_re + m.EX.win_fr * cog.EX.win_fr + ...
                (m.EX.sidws_fr + m.EX.sidws_re) * cog.EX.sidws + m.EX.win_re * cog.EX.win_re) / cog.Sum.EX_m;

%%Interieur
cog.IN.seats_fr =       0.3 * NR.CH;
cog.IN.seats_re =       0.3 * NR.CH;
cog.IN.cover_side =     0.3 * NR.CH;
cog.IN.cover_doors =    0.3 * NR.CH;
cog.IN.cover_rear =     0.3 * NR.CH;
cog.IN.dashboard =      0.55 * NR.CH;
cog.IN.centerconsole =  0.55 * NR.CH;
cog.IN.insul =          0.5 * NR.CH;

cog.Sum.IN_m =  m.IN.seats_fr + m.IN.seats_re + m.IN.cover_side + m.IN.cover_doors + m.IN.cover_rear + m.IN.dashboard + m.IN.centerconsole +  m.IN.insul;
cog.Sum.IN =    (m.IN.seats_fr * cog.IN.seats_fr  + m.IN.seats_re * cog.IN.seats_re + m.IN.cover_side * cog.IN.cover_side + ... 
                m.IN.cover_doors * cog.IN.cover_doors + m.IN.cover_rear * cog.IN.cover_rear + m.IN.dashboard * cog.IN.dashboard + ...
                m.IN.centerconsole * cog.IN.centerconsole +  m.IN.insul * cog.IN.insul) / cog.Sum.IN_m;

            
%%Calculation
cog.Sum.masse = cog.Sum.ST_m + cog.Sum.CH_m + cog.Sum.DT_m + cog.Sum.EE_m + cog.Sum.EX_m + cog.Sum.IN_m;
cog.Sum.z =     (cog.Sum.ST_m * cog.Sum.ST + cog.Sum.CH_m * cog.Sum.CH + cog.Sum.DT_m * cog.Sum.DT + ...
                cog.Sum.EE_m * cog.Sum.EE + cog.Sum.EX_m * cog.Sum.EX + cog.Sum.IN_m * cog.Sum.IN) / cog.Sum.masse;

            
par_VEH.zSP_r = (cog.Sum.z + NR.GC)/1000;
par_VEH.zSP = (cog.Sum.z + NR.GC - r_wheel)/1000;       
            
end  
            
            
            
            
            
            
          
            
            
            
            
            

