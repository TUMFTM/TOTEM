 function Hv_Stufe = calchv(i_Stufe, z_Ritzel, vzkonst)

beta_b = vzkonst.beta_b*180/pi;
eps_alpha = vzkonst.eps_alpha;
eps_1 = vzkonst.eps_1;
eps_2 = vzkonst.eps_2;

Hv_Stufe = (pi.*(i_Stufe+1)./(z_Ritzel.*i_Stufe.*cos(beta_b)))...
    .*(1-eps_alpha+eps_1^2+eps_2^2);

end