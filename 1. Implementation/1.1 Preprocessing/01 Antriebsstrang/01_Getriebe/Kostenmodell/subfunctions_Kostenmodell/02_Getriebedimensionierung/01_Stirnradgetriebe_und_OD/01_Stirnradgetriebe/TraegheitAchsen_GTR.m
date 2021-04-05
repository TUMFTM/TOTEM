function [Jx,Jy,Jz] = TraegheitAchsen_GTR(m_GTR,l_GTR, b_GTR, h_GTR)
%Quader mit homogener Massenverteilung
%x parallel l
%y parallel b
%z parallel h

Jx = (1/12)*m_GTR*(b_GTR^2+h_GTR^2)*1e-6; %[kg m^2]
Jy = (1/12)*m_GTR*(l_GTR^2+h_GTR^2)*1e-6;
Jz = (1/12)*m_GTR*(l_GTR^2+b_GTR^2)*1e-6;

end