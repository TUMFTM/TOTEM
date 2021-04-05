function [ neig,Fehlerbit,Fehlercode] = calc_neig_two_speed( d_motor,Optimierung,d_1_1,d_1_2,d_2_1,d_2_2,d_3,d_4,d_sh_4,Fehlerbit,Fehlercode,d_A_A,d_A_B,m_A,m_B,m_C,m_D,m_E,m_F,b_1_1,b_1_2,b_3,spalt,d_kegel,b_kegel,d_sh_A,d_sh_B,d_sh_C,d_sh_D,d_sh_E,d_sh_F,b_A,b_B,b_C,b_D,b_E,b_F,d_A_C,d_A_D,d_A_E,d_A_F,fspalt,d_inn_1,d_inn_2,d_f2_1,d_f2_2,d_f4,m_n_1,m_n_3,d_1_C,d_1_D,d_1_F,d_korb,neig_uebergabe,roh_inn,roh_geh,d_geh,t_1_links,t_2_links,t_3_links,t_1_rechts,t_2_rechts,t_3_rechts,t_ges_inn,differential,torque_vectoring, torque_splitter,m_torque,m_eTV)
%Berechnung des optimalen Neigungswinkels für das Zweigang-Getriebe
[w,u]=size(d_1_1);
neig=zeros(1,u);

%Länge ohne Neigunswinkel bestimmen um Motor-Getriebekombination zu prüfen.
l_eva=(d_1_1./2)+(d_2_1./2)+(d_3./2)+(d_4./2)-(d_sh_4./2);
for k=1:u
    
    %Kompatibilität prüfen
    if(l_eva(k)<(d_motor(k)/2))
        Fehlerbit(k)=1;
        Fehlercode(1,k)={'Motor mit Getriebe nicht kompatibel, Abmessungen des Motor sind zu groß. Die Wellen wurden in einer Achse angeordnet'};
        neig(k)=0;
        
        break;
    end
    if (strcmp(Optimierung(k), 'Länge')==1 || strcmp(Optimierung(k),'Manual')==1)
        %minimale Länge des Getriebes wird ermittelt
        while 1
            alpha=neig(k)*pi/180;
            x=(d_1_1(k)/2)+(d_2_1(k)/2);
            y=(d_4(k)/2)+(d_3(k)/2);
            zeta=asin((x/y)*sin(alpha));
            z_1=(x*cos(alpha))+(y*cos(zeta));
            z=(x*cos(alpha))+(y*cos(zeta))-(d_sh_4(k)/2);
            val=(x*cos(alpha))+(d_1_1(k)/2);
            if(z >(d_motor(k)/2) && val>(d_2_1(k)/2) && z_1>((d_4(k)/2)+(d_2_1(k)/2)))
                neig(k)=neig(k)+1;
            else 
                break;
            end
        end
        if strcmp(Optimierung(k), 'Manual')
            if(neig(k)<neig_uebergabe(k))
                Fehlercode(1,k)={'Der eingegebene Winkel führt zu einer unzulässigen Anordnung. Er wurde entsprechend Korrigiert.'};
            else
                neig(k)=neig_uebergabe(k);
            end
        end
        
        
    elseif strcmp(Optimierung(k), 'Höhe')
        %minimale Höhe des Getriebes wird ermittelt
        neig(k)=0;
        
    elseif strcmp(Optimierung(k), 'Masse')
        %minimale Querschnittsfläche wird ermittelt
        winkel=zeros(1,1);
        i=1;
        while 1
            alpha=winkel(i)*pi/180;
            x=(d_1_1(k)/2)+(d_2_1(k)/2);
            y=(d_4(k)/2)+(d_3(k)/2);
            zeta=asin((x/y)*sin(alpha));
            z=(x*cos(alpha))+(y*cos(zeta))-(d_sh_4(k)/2);
            z_1=(x*cos(alpha))+(y*cos(zeta));
            val=(x*cos(alpha))+(d_1_1(k)/2);
            if(z>(d_motor(k)/2) && val>(d_2_1(k)/2) && z_1>((d_4(k)/2)+(d_2_1(k)/2)))
                i=i+1;
                winkel(i)=winkel(i-1)+1;
            else
                
                break;
            end
        end
        %Flächen berechnen
        alpha=zeros(1,i);
        zeta=zeros(1,i);
        m_er=zeros(1,i);
        for t=1:i
            alpha(t)=winkel(t)*pi/180;
            zeta(t)=asin((x/y)*sin(alpha(t)));
            [ m_ges,d_stange,abstand_A,abstand_B,abstand_C,abstand_D,abstand_E,abstand_F,roh_inn,d_geh,variante,gamma_1,gamma_2,gamma_3,gamma_1_B,gamma_2_B,d_1_g,d_2_g,d_4_g,gamma_3_B,m_z1_1,m_z1_2,m_z2_1,m_z2_2,m_z3,m_z4,m_w1,m_w2,m_korb,m_w4,m_kegelraeder,m_diff_stange,m_geh, m_Lagersitz] = set_mass_two_speed_gear(m_A(k),m_B(k),m_C(k),m_D(k),m_E(k),m_F(k),d_1_1(k),d_1_2(k),d_2_1(k),d_2_2(k),d_3(k),d_4(k),b_1_1(k),b_1_2(k),b_3(k),spalt,d_kegel(k),b_kegel(k),d_sh_A(k),d_sh_B(k),d_sh_C(k),d_sh_D(k),d_sh_E(k),d_sh_F(k),d_sh_4(k),alpha(k),zeta(k),b_A(k),b_B(k),b_C(k),b_D(k),b_E(k),b_F(k),d_A_A(k),d_A_B(k),d_A_C(k),d_A_D(k),d_A_E(k),d_A_F(k),fspalt,d_inn_1(k),d_inn_2(k),d_f2_1(k),d_f2_2(k),d_f4(k),m_n_1,m_n_3,d_1_C(k),d_1_D(k),d_1_F(k),d_korb(k),Optimierung(k),roh_inn,roh_geh,d_geh,t_ges_inn(k),t_1_links(k),t_2_links(k),t_3_links(k),t_1_rechts(k),t_2_rechts(k),t_3_rechts(k),differential(k),torque_vectoring(k),torque_splitter(k),m_torque(k), m_eTV);
            m_er(t)=m_ges;
            
        end
        m_min=min(m_er);
        %Minimum suchen
        for t=1:i
            if(m_er(1,t)==m_min)
                neig(k)=winkel(t);
            end
        end
        
        
    end
          
end

end

