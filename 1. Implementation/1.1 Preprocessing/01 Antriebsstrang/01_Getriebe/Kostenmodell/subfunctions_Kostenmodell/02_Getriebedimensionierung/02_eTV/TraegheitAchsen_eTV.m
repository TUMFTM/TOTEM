function [Jx,Jy, Jz] = TraegheitAchsen_eTV(m_eTV,b_Rad, d_Rad)
%Vollzylinder mit Länge 4*b_Rad und Radius r2IV
%eigenes Koordinatensystem: y liegt parallel zur Achse/ist identisch mit der Achse und ist die
%Zylinderrotationsachse, x und z senkrecht dazu

%selbe Abschätzung wie in scaleeTVDiff
d_2IV = 0.8175*d_Rad;

Jy = (1/2)*m_eTV*(d_2IV/2)^2*1e-6; %[kg m^2]
Jx = (1/4)*m_eTV*(d_2IV/2)^2*1e-6 + (1/12)*m_eTV*(4*b_Rad)^2*1e-6;
Jz = Jx;

end