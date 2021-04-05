function [ J_ges_antr_gang_1,J_ges_antr_gang_2,J_ges_abtr_gang_1,J_ges_abtr_gang_2 ] = calc_J_two_speed( spalt,abstand_A,abstand_E,abstand_F,d_geh,roh_inn,d_sh_4,d_stange,d_kegel,b_kegel,b_A,d_sh_A,d_1_A,b_B,d_sh_B,d_1_B,b_C,d_sh_C,d_1_C,b_D,d_sh_D,d_1_D,b_E,d_sh_E,d_1_E,b_F,d_sh_F,d_1_F,i_12_1,i_12_2,i_34,d_1_1,d_1_2,d_2_1,d_2_2,d_3,d_4,b_1_1,b_1_2,b_3,d_inn_1,d_inn_2,m_n_1,m_n_3,d_f2_1,d_f2_2,d_f4,d_korb,differential,torque_splitter,J_torque,l_torque)
%Berechnet die Trägheitsmomente für das Zweigang-Getriebe
n=length(abstand_A);
%Welle 1:
l_1=(d_geh+abstand_A+b_A+spalt+spalt);
l_2=b_B+spalt;
J_1_1=((((d_sh_A/2).^2)+((d_inn_1/2).^2))./2).*(((((0.5*d_sh_A).^2)-((0.5*d_inn_1).^2))*pi).*l_1)*roh_inn;
J_1_2=((((d_1_1/2).^2)+((d_inn_1/2).^2))./2).*(((((0.5*d_1_1).^2)-((d_inn_1/2).^2))*pi).*b_1_1)*roh_inn;
J_1_3=((((d_sh_B/2).^2)+((d_inn_1/2).^2))./2).*(((((0.5*d_sh_B).^2)-((d_inn_1/2).^2))*pi).*l_2)*roh_inn;
J_1_4=((((d_1_2/2).^2)+((d_inn_1/2).^2))./2).*(((((0.5*d_1_2).^2)-((d_inn_1/2).^2))*pi).*b_1_2)*roh_inn;
J_1=J_1_1+J_1_2+J_1_3+J_1_4;

%Welle 2:
d_2a_1=d_f2_1-(6*m_n_1);
d_2a_2=d_f2_2-(6*m_n_3);
l_3=(spalt+b_C)+spalt;
l_4=spalt+b_D+spalt;
J_2_1=((((d_sh_C/2).^2)+((d_inn_2/2).^2))./2).*(((((0.5*d_sh_C).^2)-((d_inn_2/2).^2))*pi).*l_3)*roh_inn;
J_2_2=((((d_2_1/2).^2)+((d_inn_2/2).^2))./2).*(((((0.5*d_2_1).^2)-((d_inn_2/2).^2))*pi).*b_1_1)*roh_inn;
J_2_2_2=zeros(1,n);
for k=1:n
    if(((d_f2_1(k)-(6*m_n_1))-(d_1_C(k)))>40)
        J_2_2_2(k)=((((d_2a_1(k)/2).^2)+((d_1_C(k)/2).^2))./2).*(((((0.5*d_2a_1(k)).^2)-((d_1_C(k)/2).^2))*pi).*(0.6*b_1_1(k)))*roh_inn;
    else
        J_2_2_2(k)=0;
    end
end
J_2_5=((((d_2_2/2).^2)+((d_inn_2/2).^2))./2).*(((((0.5*d_2_2).^2)-((d_inn_2/2).^2))*pi).*b_1_2)*roh_inn;
J_2_2_3=zeros(1,n);
for k=1:n
    if(((d_f2_2(k)-(6*m_n_1))-(d_1_D(k)))>40)
        J_2_2_3(k)=((((d_2a_2(k)/2).^2)+((d_1_D(k)/2).^2))./2).*(((((0.5*d_2a_2(k)).^2)-((d_1_D(k)/2).^2))*pi).*(0.6*b_1_2(k)))*roh_inn;
    else
        J_2_2_3(k)=0;
    end
end
J_2_3=((((d_3/2).^2)+((d_inn_2/2).^2))./2).*(((((0.5*d_3).^2)-((d_inn_2/2).^2))*pi).*b_3)*roh_inn;
J_2_4=((((d_sh_D/2).^2)+((d_inn_2/2).^2))./2).*(((((0.5*d_sh_D).^2)-((d_inn_2/2).^2))*pi).*l_4)*roh_inn;

J_2=J_2_1+(J_2_2-J_2_2_2)+J_2_3+J_2_4+(J_2_5-J_2_2_3);

if(differential==1) %Falls Differentialmodul verwendet wird
    %Differentialgehäuse
    J_3_1_1=(1/12)*(((d_korb).^2)+((d_korb).^2)).*(((d_korb).^2)*10*roh_inn);
    J_3_1_2=(((0.5*d_sh_4).^2)./2).*((((0.5*d_sh_4).^2)*pi)*10)*roh_inn;
    J_3_1=J_3_1_1-J_3_1_2;
    J_3_2_1=(1/12)*(((d_korb).^2)+((d_korb).^2)).*(((d_korb).^2).*d_kegel)*roh_inn;
    J_3_2_2=(1/12)*(((d_korb-20).^2)+((d_korb-20).^2)).*(((d_korb-20).^2).*(d_korb-20))*roh_inn;
    J_3_2_3=((((0.5*d_stange)^2)/2)*(roh_inn*10*pi*((0.5*d_stange)^2)))+((1/12)*(10^2)*roh_inn*10*pi*((0.5*d_stange)^2))+(((0.5*d_kegel+5).^2)*roh_inn*10*pi*((0.5*d_stange)^2));
    J_3_2=J_3_2_1-J_3_2_2-(2*J_3_2_3);
    J_3=J_3_1+J_3_2;

    %Lagersitze Differential:
    J_Lagersitz_E=0.5*(((0.5*d_sh_4).^2)+((0.5*d_sh_E).^2)).*(roh_inn*pi*b_E.*(((0.5*d_sh_E).^2)-((0.5*d_sh_4).^2)));
    J_Lagersitz_F=0.5*(((0.5*d_sh_4).^2)+((0.5*d_sh_F).^2)).*(roh_inn*pi*b_F.*(((0.5*d_sh_F).^2)-((0.5*d_sh_4).^2)));


    %Trägheitsmoment Rad 4
    d_4a=d_f4-(6*m_n_3);
    J_4_1=(((0.5*d_4).^2)./2).*((((0.5*d_4).^2)*pi).*b_3)*roh_inn;
    J_4_2=(((0.5*d_sh_4).^2)./2).*((((0.5*d_sh_4).^2)*pi).*b_3)*roh_inn;
    J_4_3=zeros(1,n);
    for k=1:n
        if((d_f4(k)-(6*m_n_3))-(d_kegel(k)+20)>40)
            J_4_3(k)=((((d_4a(k)/2).^2)+(((d_kegel(k)+20)./2).^2))./2).*(((((0.5*d_4a(k)).^2)-(((d_kegel(k)+20)./2).^2))*pi).*(0.6*b_3(k)))*roh_inn;
        else
            J_4_3(k)=0;
        end
    end

    J_4=J_4_1-J_4_2-J_4_3;

    %Kegelräder Abtrieb
    J_5_1_1=(((0.5*d_sh_4).^2)./2).*((((0.5*d_sh_4).^2)*pi).*(b_E+10+d_geh+abstand_E)*roh_inn);
    J_5_1_2=(((0.5*d_sh_4).^2)./2).*((((0.5*d_sh_4).^2)*pi).*(b_F+d_geh+spalt+b_3+abstand_F)*roh_inn);
    R_kegel=d_kegel*0.5;
    r=R_kegel-b_kegel;
    V_kegel=((b_kegel*pi)./3).*((R_kegel.^2)+(r.*R_kegel)+(r.^2));
    J_5_1_3=(2/5)*(V_kegel.*roh_inn).*(((R_kegel.^5)-(r.^5))./((R_kegel.^3)-(r.^3)));
    J_5_1=J_5_1_1+J_5_1_3;
    J_5_2=J_5_1_2+J_5_1_3;

    %Differentialstange
    J_6_1=(((0.5*d_stange).^2)*0.25)*(((0.5*d_stange).^2).*(d_kegel+20))*pi*roh_inn;
    J_6_2=((((d_stange+20).^2))*(((0.5*d_stange).^2).*(d_kegel+20))*roh_inn*pi)./12;
    J_6=J_6_1+J_6_2;
    
    %Kegelräder im Differential als Zylinder approximiert
    %mittlerer Radius
    r_m=(R_kegel+r)./2;
    m_zyl=(pi*b_kegel*roh_inn).*(r_m.^2);
    J_7_1=((m_zyl./2).*(r_m.^2))+((m_zyl./2).*b_kegel)+(((0.5*(d_kegel+b_kegel)).^2).*m_zyl);
    J_7_2=J_7_1;
    
elseif(torque_splitter==1) %Falls Torque-Vectoring-Modul verwendet wird
    J_3=2*J_torque; %Trägheitsmoment der Module
    J_Lagersitz_E=0.5*(((0.5*d_sh_4).^2)+((0.5*d_sh_E).^2)).*(roh_inn*pi*b_E.*(((0.5*d_sh_E).^2)-((0.5*d_sh_4).^2)));
    J_Lagersitz_F=0.5*(((0.5*d_sh_4).^2)+((0.5*d_sh_F).^2)).*(roh_inn*pi*b_F.*(((0.5*d_sh_F).^2)-((0.5*d_sh_4).^2)));
    J_4=(((0.5*d_sh_4).^2)./2).*((((0.5*d_sh_4).^2)*pi).*(abstand_E+b_E+l_torque+l_torque+b_F+(2*d_geh))*roh_inn);
    J_5_1=0;
    J_5_2=0;
    J_6=0;
    J_7_1=0;
    J_7_2=0;
else %Achsnaher Antrieb
    J_3=0;
    J_Lagersitz_E=0.5*(((0.5*d_sh_4).^2)+((0.5*d_sh_E).^2)).*(roh_inn*pi*b_E.*(((0.5*d_sh_E).^2)-((0.5*d_sh_4).^2)));
    J_Lagersitz_F=0.5*(((0.5*d_sh_4).^2)+((0.5*d_sh_F).^2)).*(roh_inn*pi*b_F.*(((0.5*d_sh_F).^2)-((0.5*d_sh_4).^2)));
    J_4=(((0.5*d_sh_4).^2)./2).*((((0.5*d_sh_4).^2)*pi).*(d_geh+abstand_E+b_E+spalt+b_3+spalt+b_F)*roh_inn);
    J_5_1=0;
    J_5_2=0;
    J_6=0;
    J_7_1=0;
    J_7_2=0;
    
end


%Trägheitsmoment der Wälzlager:
%Approximiert als drehender Innenring:
%Lager A:
m_anA=((((0.5*d_1_A).^2)-((0.5*d_sh_A).^2)).*b_A)*pi*roh_inn;
J_A=((((0.5*d_1_A).^2)+((0.5*d_sh_A).^2)).*m_anA)*0.5;
%Lager B:
m_anB=((((0.5*d_1_B).^2)-((0.5*d_sh_B).^2)).*b_B)*pi*roh_inn;
J_B=((((0.5*d_1_B).^2)+((0.5*d_sh_B).^2)).*m_anB)*0.5;
%Lager C:
m_anC=((((0.5*d_1_C).^2)-((0.5*d_sh_C).^2)).*b_C)*pi*roh_inn;
J_C=((((0.5*d_1_C).^2)+((0.5*d_sh_C).^2)).*m_anC)*0.5;
%Lager D:
m_anD=((((0.5*d_1_D).^2)-((0.5*d_sh_D).^2)).*b_D)*pi*roh_inn;
J_D=((((0.5*d_1_D).^2)+((0.5*d_sh_D).^2)).*m_anD)*0.5;


    %Lager E:
    m_anE=((((0.5*d_1_E).^2)-((0.5*d_sh_E).^2)).*b_E)*pi*roh_inn;
    J_E=((((0.5*d_1_E).^2)+((0.5*d_sh_E).^2)).*m_anE)*0.5;
    %Lager F:
    m_anF=((((0.5*d_1_F).^2)-((0.5*d_sh_F).^2)).*b_F)*pi*roh_inn;
    J_F=((((0.5*d_1_F).^2)+((0.5*d_sh_F).^2)).*m_anF)*0.5;
    

%Gesamtes reduziertes Trägheitsmoment bezogen auf die Motorwellendrehzahl
J_ges_antr_gang_1=(J_1+J_A+J_B)+((J_2+J_C+J_D)./(i_12_1.^2))+((J_E+J_F+J_3+J_4+J_5_1+J_5_2+J_6+J_7_1+J_7_2+J_Lagersitz_E+J_Lagersitz_F)./(i_12_1.^2)./(i_34.^2));
J_ges_antr_gang_2=(J_1+J_A+J_B)+((J_2+J_C+J_D)./(i_12_2.^2))+((J_E+J_F+J_3+J_4+J_5_1+J_5_2+J_6+J_7_1+J_7_2+J_Lagersitz_E+J_Lagersitz_F)./(i_12_2.^2)./(i_34.^2));
%Gesamtes reduziertes Trägheitsmoment bezogen auf die Raddrehzahlen
J_ges_abtr_gang_1=((J_1+J_A+J_B).*(i_12_1.^2).*(i_34.^2))+((J_2+J_C+J_D).*(i_34.^2))+(J_E+J_F+J_3+J_4+J_5_1+J_5_2+J_6+J_7_1+J_7_2+J_Lagersitz_E+J_Lagersitz_F);
J_ges_abtr_gang_2=((J_1+J_A+J_B).*(i_12_2.^2).*(i_34.^2))+((J_2+J_C+J_D).*(i_34.^2))+(J_E+J_F+J_3+J_4+J_5_1+J_5_2+J_6+J_7_1+J_7_2+J_Lagersitz_E+J_Lagersitz_F);

end

