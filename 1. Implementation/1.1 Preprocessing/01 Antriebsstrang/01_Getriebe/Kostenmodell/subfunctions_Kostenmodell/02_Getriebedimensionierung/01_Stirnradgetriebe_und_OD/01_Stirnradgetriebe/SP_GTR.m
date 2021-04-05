function [ x_GTR, y_GTR, z_GTR ] = SP_GTR(l_EM,l_GTR,b_GTR,akt_az)
%Schwerpunktabsch‰tzung
if akt_az == 1
    x_GTR = 0.3*l_GTR; %positiv heiﬂt hinter der Achse
    y_GTR = 0.1*b_GTR; %positiv heiﬂt n‰her am rechten Rad
    z_GTR = 0;
else %rn muss links/rechts unterschieden werden: x,y,z = [xyz_links  xyz_rechts], y_Achse zeigt zum rechten Rad, x nach hinten
    x_GTR = [0.3*l_GTR 0.3*l_GTR];
    y_GTR = [-(0.5*l_EM+0.5*b_GTR)  +(0.5*l_EM+0.5*b_GTR)];
    z_GTR = [0 0];
end

end