function [ d_korb,b_korb,l_3,s_3,d_kegel,b_kegel ] = calculate_data_diff_vec( T_max,i_12,i_34,b_3,d_korb,b_korb,d_kegel,b_kegel)
%Berechent die für die Lagerauslegung erforderlichen Abmessungen

%Korbabmessungen aus empirischen Daten
%d_korb=((0.0043*T_max.*i_12).*i_34)+70.9945+20;
%b_korb=d_korb;

%Kegelraddurchmesser empirisch ermittelt
%d_kegel=((0.0039*T_max.*i_12).*i_34)+54.6484;

%Breite des Kegelrads:
%b_kegel=((0.0014*T_max.*i_12).*i_34)+17.3580;

%Lagerabstand und Lagerparameter kalkulieren
l_3=(b_3./2)+b_korb+b_3+(b_3./2);
s_3=(l_3./2)-b_3;

end

