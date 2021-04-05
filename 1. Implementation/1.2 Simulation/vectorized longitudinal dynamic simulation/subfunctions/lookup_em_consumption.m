function P_mot_el = lookup_em_consumption(E, w_mot, M_mot, az)

if az==1
    P_mot_el = sign(w_mot).* interpn(E.ConGrid.xgs_radps, E.ConGrid.ygs_Nm , E.ConGrid.zgs_W, abs(w_mot), M_mot);
elseif az==0
    P_mot_el = 2*sign(w_mot).* interpn(E.ConGrid.xgs_radps, E.ConGrid.ygs_Nm , E.ConGrid.zgs_W, abs(w_mot), M_mot./2);
end
