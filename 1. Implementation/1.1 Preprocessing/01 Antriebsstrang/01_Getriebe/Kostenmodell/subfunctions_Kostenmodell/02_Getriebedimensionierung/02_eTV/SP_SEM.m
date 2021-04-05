function [x_SEM, y_SEM, z_SEM] = SP_SEM(b_Rad, dVTV2, dVTV4, l_SEM)

x_SEM = 0;
y_SEM = b_Rad*3 + 0.5*l_SEM; %etwas näher am rechten Rad
z_SEM = dVTV2 + dVTV4;

end