function par_VEH = Reifen(par_VEH, m, IP, Segment)

if Segment == 'A'
    par_VEH.r_stat0 = 0.340758; 
elseif Segment == 'B'
    par_VEH.r_stat0 = 0.337961;
elseif Segment == 'C'
    par_VEH.r_stat0 = 0.337961;  
elseif Segment == 'T'
    par_VEH.r_stat0 = 0.350560675;
end

par_VEH.IRad_f = 0.5 * m.CH.wheels_fr_normal * par_VEH.r_stat0^2;
par_VEH.IRad_r = 0.5 * m.CH.wheels_re_normal * par_VEH.r_stat0^2;
     
end

   
            
            
            
            
            
            
          
            
            
            
            
            

