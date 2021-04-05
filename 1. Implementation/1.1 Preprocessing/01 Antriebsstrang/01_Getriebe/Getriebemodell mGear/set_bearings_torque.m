function [ l_3,m_E,m_F,b_E,b_F,d_A_E,d_A_F,d_sh_E,d_sh_F,d_sh_4,d_1_E,d_1_F,Fehlerbit,Fehlercode,ID_E,ID_F] = set_bearings_torque( F_u_3,F_ax_3,F_rad_3,i_12,i_34,b_3,d_4,n_eck,values_B,Fehlerbit,Fehlercode,ueberlast,values_C,d_sh_4,l_torque)
%Legt die Lager des Differentials fest, es wird eine angestellte Lagerung
%mit Kegelrollenlager verwendet.

%Anwendungsfaktor für statischen Lagernachweis
K_a=1.5;

%Lagerinnendruchmesser:
d_sh_Lager=d_sh_4+20; %10mm Wandstärke des Diff-Korbes


%WELLE 3:
%Es wird eine angestellte Lagerung verwendet
%Es handelt sich um eine symmetrische Lagerung mit Kegelrollenlager.
%        _ 
%      _| |_  
%---E-|_|4|_|-F--
%       |_| 
%
% Lagerabstand und wird anhand der Lagerbreiten, der
%Verzahnungsbreite und der Breite eines Torque-Vectoring-Moduls ermittelt
l_3=(2*l_torque)+b_3;

[w,u]=size(b_3);

%wirkende Kräfte werden übergeben
F_u_3_vec=F_u_3;
F_ax_3_vec=F_ax_3;
F_rad_3_vec=F_rad_3;
%Initialisierung eines Vektors für Lagerdaten
d_sh_E_vec=zeros(1,u);
d_sh_F_vec=zeros(1,u);
m_E_vec=zeros(1,u);
m_F_vec=zeros(1,u);
d_A_E_vec=zeros(1,u);
d_A_F_vec=zeros(1,u);
b_E_vec=zeros(1,u);
b_F_vec=zeros(1,u);
e_E_vec=zeros(1,u);
e_F_vec=zeros(1,u);
Y_E_vec=zeros(1,u);
Y_F_vec=zeros(1,u);
d_1_E=zeros(1,u);
d_1_F=zeros(1,u);
ID_E=cell(1,u);
ID_F=cell(1,u);

d_4_vec=d_4;
n_eck_vec=n_eck;
l_3_vec=l_3;

i_12_vec=i_12;
i_34_vec=i_34;
b_3_vec=b_3;
d_sh_Lager_vec=d_sh_Lager;


%Für vektorielle Bearbeitung for-Schleife notwendig
for k=1:u
    %definiere eine dynamische Tragzahl von C_dyn=0 sodass if Abfrage auch beim
    %ersten Durchlauf funktioniert. C_dyn wird später überschrieben
    C_dyn_erf_E=0;
    C_dyn_erf_F=0;
    C_stat_erf_E=0;
    C_stat_erf_F=0;
    
    F_u_3=F_u_3_vec(k);
    F_ax_3=F_ax_3_vec(k);
    F_rad_3=F_rad_3_vec(k);
    l_3=l_3_vec(k);
    d_4=d_4_vec(k);
    i_12=i_12_vec(k);
    i_34=i_34_vec(k);
    b_3=b_3_vec(k);
    n_eck=n_eck_vec(k);
    
    %Im ersten Durchlauf kann kein Lager beibehalten werden 
    beibehalten=0;
    
    %Hier müsste die Schleife für die Optimierung des Lagerabstandes l und
    %Ritzelabstandes s beginnen.
    while 1
        while 1
            
            %Lagerreaktionskräfte
            F_Ez=(1/l_3)*(-F_u_3*((l_3/2)));
            F_Fz=-F_Ez-F_u_3;

            F_Ey=(1/l_3)*((F_ax_3*d_4/2)-(F_rad_3*((l_3/2))));
            F_Fy=-F_rad_3-F_Ey;

            %radiale Belastung
            F_radE=sqrt((F_Ez^2)+(F_Ey^2));
            F_radF=sqrt((F_Fz^2)+(F_Fy^2));

            %Auswahl welches Lager die Axialkraft aufnimmt
            

            %Lager E:____________
            %Auswahl eines passenden Lagers anand des Wellenduchmessers
            %Tabelle: A:Innendurchmesser B:Außendurchmesser C:Lagerbreite D: dyn.
            %Tragzahl 
            %Neues Lager nur auswählen, falls kein Lager beibehalten werden
            %soll
            
            [m,v]=size(values_B);
            
            if (beibehalten==0)
                for i=1:1:m
                    if(values_B(i,1)>=d_sh_Lager_vec(k) && values_B(i,4)>=C_dyn_erf_E && values_B(i,9)>C_stat_erf_E)
                        var=i;
                        break;
                    end
                end
                %Auslesen der Lagerbreite und des Wellendurchmessers
                b_E_vec(k)=values_B(var,3);
                d_sh_E_vec(k)=values_B(var,1);
                d_A_E_vec(k)=values_B(var,2);
                m_E_vec(k)=values_B(var,5)/1000;
                e_E_vec(k)=values_B(var,6);
                Y_E_vec(k)=values_B(var,7);
                C_dyn_E=values_B(var,4);
                d_1_E(k)=values_B(var,8);
                C_stat_E=values_B(var,9);
                Y_0_E=values_B(var,10);
                ID_E{1,k}=values_C(var,1);
            end
            


            %Lager F:___________
            %Bestimmung des Radialfaktors X und Axialfaktors Y nach Tabelle 47 (ME FS)
            %Auswahl eines passenden Lagers anand des Wellenduchmessers
            %Tabelle: A:Innendurchmesser B:Außendurchmesser C:Lagerbreite D: dyn.
            %Tragzahl
            %Neues Lager nur auswählen, falls kein Lager beibehalten werden
            %soll
            if (beibehalten==0)
                for i=1:1:m
                    if(values_B(i,1)>=d_sh_Lager_vec(k) && values_B(i,4)>=C_dyn_erf_F && values_B(i,9)>=C_stat_erf_F)
                        var=i;
                        break;
                    end
                end
                %Auslesen der Lagerbreite und des Wellendurchmessers
                b_F_vec(k)=values_B(var,3);
                d_sh_F_vec(k)=values_B(var,1);
                d_A_F_vec(k)=values_B(var,2);
                m_F_vec(k)=values_B(var,5)/1000;
                e_F_vec(k)=values_B(var,6);
                Y_F_vec(k)=values_B(var,7);
                C_dyn_F=values_B(var,4);
                d_1_F(k)=values_B(var,8);
                C_stat_F=values_B(var,9);
                Y_0_F=values_B(var,10);
                ID_F{1,k}=values_C(var,1);
            end
            
            %Axiale Last auf Lagerberechnen:
            val_E=F_radE/Y_E_vec(k);
            val_F=F_radF/Y_F_vec(k);
            if(val_F<=val_E)
                F_axF=F_ax_3+(0.5*val_E);
                F_axE=0;
            else
                if(abs(F_ax_3)>abs(0.5*(val_F-val_E)))
                    F_axF=F_ax_3+(0.5*val_E);
                    F_axE=0;
                else
                    F_axF=0;
                    F_axE=(0.5*val_F)-F_ax_3;
                end
            end
            
            
            %Lager E_______________________________________________________
            %stat. Nachweis:
            %Berechnen der stat. Tragzahl
            P_stat_E=(0.5*F_radE)+(Y_0_E*F_axE)*ueberlast(k)*K_a;
            %Für Kegelrollenlager wird eine Sicherheit von >4 gefordert.
            C_stat_erf_E=4.1*P_stat_E;
           
            
            %dynamischer Nachweis:_________________________________________
            %dynamische äquivalente Belastung berechnen
            par_E=F_axE/F_radE;
            if(par_E<=e_E_vec(k))
                P_next_E=F_radE+(1.12*Y_E_vec(k)*F_axE);
            else
                P_next_E=(0.67*F_radE)+(1.68*Y_E_vec(k)*F_axE);
            end

            %Berechnen der erforderlichen dynamische Tragzahl: Wir gehen von 2000h
            %Betrieb aus bei maximalen Moment
            L_10=2000*60*(n_eck/(i_12*i_34))/(10^6);
            C_dyn_erf_E=(L_10^(1/3))*P_next_E;
            
            
            %Lager F_______________________________________________________
            %stat. Nachweis:
            %Berechnen der stat. Tragzahl
            P_stat_F=(0.5*F_radF)+(Y_0_F*F_axF)*ueberlast(k)*K_a;
            C_stat_erf_F=4.1*P_stat_F;
            
            %dynamischer Nachweis__________________________________________
            %dynamische äquivalente Belastung berechnen
            par_F=F_axF/F_radF;
            if(par_F<=e_F_vec(k))
                P_next_F=F_radF+(1.12*Y_F_vec(k)*F_axF);
            else
                P_next_F=(0.67*F_radF)+(1.68*Y_F_vec(k)*F_axF);
            end

            %Berechnen der erforderlichen dynamische Tragzahl: Wir gehen von 2000h
            %Betrieb aus bei maximalen Moment
            L_10=2000*60*(n_eck/(i_12*i_34))/(10^6);
            C_dyn_erf_F=(L_10^(1/3))*P_next_F;
            
            %Überprüfen der Dynamischen erforderlichen Tragzahl
            if(C_dyn_erf_E>400000 || C_dyn_erf_F>400000)
                Fehlerbit(k)=1;
                Fehlercode(1,k)={'Fehler bei Lagerung des Differentials: Die erforderliche dynamische Tragzahl ist zu hoch. Der Lagerkatalog muss erweitert werden.'};
                C_dyn_erf_E=100000;
                C_dyn_erf_F=100000;
            end
            %Überprüfen der statisch erforderlichen Tragzahl
            if(C_stat_erf_E>550000 || C_stat_erf_F>550000)
                Fehlerbit(k)=1;
                Fehlercode(1,k)={'Fehler bei Lagerung des Differentials: Die erforderliche statische Tragzahl ist zu hoch. Der Lagerkatalog muss erweitert werden.'};
                C_stat_erf_E=100000;
                C_stat_erf_F=100000;
            end

            %Abfrage ob die geforderte Lebensdauer erreicht wird. Beim zweiten
            %Druchlauf müsste dies der Fall sein
            if(C_dyn_E>C_dyn_erf_E && C_dyn_F>C_dyn_erf_F && C_stat_E>C_stat_erf_E && C_stat_F>C_stat_erf_F)
                %beibehalten=1;
                break;
            else
                beibehalten=0;
            end
        end
        %Der Lagerabtand muss hier kontrolliert werden
        %Es müssen hier endgültige Werte für l,s,m, d_sh festgelegt werden
        %Es ist noch festzulegendes Spaltmaß zu addieren
        l_3_3=(b_E_vec(k)/2)+l_torque(k)+l_torque+(b_F_vec(k)/2);
        

        %Abfrage ob der Lagerabstand passt
        if(l_3_3<=l_3)
            
            l_3_vec(k)=l_3_3;
            break;
        else
            l_3=l_3_3;
           
        end
    end

end
%Ursprünliche Benamung beibehalten
l_3=l_3_vec;
m_E=m_E_vec;
m_F=m_F_vec;
d_A_E=d_A_E_vec;
d_A_F=d_A_F_vec;
b_E=b_E_vec;
b_F=b_F_vec;
d_sh_E=d_sh_E_vec;
d_sh_F=d_sh_F_vec;
end