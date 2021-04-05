function [r_rad_stat, r_rad_dyn]=   calc_radradius_stat(Fz, c_z_reifen, r_rad_0)
    
r_rad_stat=r_rad_0-(Fz/c_z_reifen);
r_rad_dyn=1/3*r_rad_stat+2/3*r_rad_0; %Schramm, Fahrdyn. Modellbildung, S. 152
