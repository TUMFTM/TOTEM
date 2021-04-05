function [ b_diff,d_diff,m_E,m_F,d_A_E,d_A_F,d_sh_E,d_sh_F,d_korb,b_korb,b_E,b_F,d_kegel,b_kegel,d_sh_4,l_3,d_1_E,d_1_F,Fehlerbit,Fehlercode,ID_E,ID_F] = set_diff(m_n,T_max,F_u_3,F_ax_3,F_rad_3,n_eck,d_4,b_3,i_12,i_34,values_B,Fehlerbit,Fehlercode,ueberlast,spalt,values_C,d_korb,b_korb,d_kegel,b_kegel)
%Legt die Abmesungen der Differentialeinheit fest

%Abmessungen festlegen
[ d_korb,b_korb,l_3,s_3,d_kegel,b_kegel] = calculate_data_diff_vec( T_max,i_12,i_34,b_3,d_korb,b_korb,d_kegel,b_kegel);

%Lager festlegen
[ l_3,m_E,m_F,b_E,b_F,d_A_E,d_A_F,d_sh_E,d_sh_F,d_sh_4,d_1_E,d_1_F,Fehlerbit,Fehlercode,ID_E,ID_F] = ...
    set_bearings_diff_vec( F_u_3,F_ax_3,F_rad_3,l_3,s_3,d_kegel,i_12,i_34,b_3,d_4,n_eck,m_n,b_korb,values_B,Fehlerbit,Fehlercode,ueberlast,spalt,values_C);

%Hauptabmessungen berechnen
b_diff=b_E+b_korb+b_3+b_F;
d_diff=d_4;

end

