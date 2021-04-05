function [ x_EM, y_EM, z_EM ] = SP_EM( l_EM,l_GTR,b_GTR,akt_az)
%Schwerpunktabsch?tzung (nur Betr?ge, Zuweisung VA/HA in par_MDT)
if akt_az == 1
    x_EM = -0.4*l_GTR;
    y_EM = -(0.5*b_GTR + 0.5*l_EM); %positiv hei?t n?her am rechten Rad
    z_EM = 0;
else %rn muss links/rechts unterschieden werden: x,y,z = [xyz_links  xyz_rechts], y_Achse zeigt zum rechten Rad, x nach hinten
    x_EM = [-0.4*l_GTR -0.4*l_GTR];
    y_EM = [-0.5*l_EM  +0.5*l_EM]; 
    z_EM = [0 0];
end

end

