function [  l_1,s_1,d_sh_A,d_sh_B,a,alpha_wt,m_A,m_B,d_A_A,d_A_B,b_A,b_B,d_1_A,d_1_B,d_inn_1,Fehlerbit,Fehlercode,ID_A,ID_B] = set_bearings_welle_1_vec( T_nenn,T_max, n_eck, d_1, d_2, b_1, beta,alpha_t,m_n,z_1,z_2,values, spalt,b_park,Fehlerbit,Fehlercode,ueberlast)
%Lagerauslegung für die Erste Stufe für ein zweistufiges Strinradgetriebe
%Lagerabstand und Lager-Ritzelabsstand muss festgelegt werden, falls keine
%symmetrische Lagerung vorliegt.

%Anwendungsfaktor für statischen Lagernachweis
K_a=1.5;

%Der Betriebswingriffwinkel wird benötigt
%Achsabstand
a=0.5*(d_1+d_2);
%Betriebsengriffwinkel
alpha_wt=acos((((z_1+z_2)*m_n)./(2*a)).*(cos(alpha_t)/cos(beta)));

%__________________________________________________________________________
%WELLE 1:

%Es wird auf die Excel-Tabelle alle_stufen_2_stufig_stirn.xlxs zugegegriffen
% Es handelt sich um eine unsymmetrische Lagerung mit Rillenkugellager.
%        _
%---A---|_|--B---
%        
%Für die Symmetrische Lagerung ist s=0;
% Lagerabstand wird anhand der Lagerbreiten und er Verzahnungsbreite
% ermittelt
[w,u]=size(b_1);
s_1_vec=zeros(1,u);
l_1_vec=2*b_1 + b_park;

n_eck_vec=n_eck;
d_1_vec=d_1;
d_sh_1_vec=zeros(1,u);
b_1_vec=b_1;

%wirkende Kräfte
F_u_1_vec=2000*T_nenn./d_1;
F_ax_1_vec=F_u_1_vec*tan(beta);
F_rad_1_vec=F_u_1_vec.*tan(alpha_wt);

%Initialisierung eines Vektors für Lagerdaten
d_sh_A_vec=zeros(1,u);
d_sh_B_vec=zeros(1,u);
m_A_vec=zeros(1,u);
m_B_vec=zeros(1,u);
d_A_A_vec=zeros(1,u);
d_A_B_vec=zeros(1,u);
b_A_vec=zeros(1,u);
b_B_vec=zeros(1,u);
d_1_A=zeros(1,u);
d_1_B=zeros(1,u);
d_inn_1_vec=zeros(1,u);
ID_A=cell(1,u);
ID_B=cell(1,u);
%Für vektorielle Berechnung ist  hier eine for-Schleife erforderlich:
for k=1:u
    s_1=s_1_vec(k);
    l_1=l_1_vec(k);
    F_u_1=F_u_1_vec(k);
    F_ax_1=F_ax_1_vec(k);
    F_rad_1=F_rad_1_vec(k);
    n_eck=n_eck_vec(k);
    d_1=d_1_vec(k);
    d_sh_1=d_sh_1_vec(k);
    b_1=b_1_vec(k);
    %definiere eine dynamische Tragzahl von C_dyn=0 sodass if Abfrage auch beim
    %ersten Durchlauf funktioniert. C_dyn wird später überschrieben
    C_dyn_erf_A=0;
    C_dyn_erf_B=0;
    C_stat_erf_B=0;
    C_stat_erf_A=0;
    %Lager kann beim ersten Durchlauf nicht beibehalten werden
    beibehalten=0;
    %Hier müsste die Schleife für die Optimierung des Lagerabstandes l und
    %Ritzelabstandes s beginnen.
    while 1
        while 1
            %Lagerreaktionskräfte
            F_Ay=((F_ax_1*0.5*d_1)+(F_rad_1*((0.5*l_1)+s_1)))/l_1;
            F_By=F_rad_1-F_Ay;

            F_Az=(F_u_1*((l_1/2)+s_1))/l_1;
            F_Bz=F_u_1-F_Az;

            %radiale Belastung
            F_radA=sqrt((F_Az^2)+(F_Ay^2));
            F_radB=sqrt((F_Bz^2)+(F_By^2));
            
            %axiale Last verteilen
            if(F_radA>=F_radB)
                F_axA=0;
                F_axB=F_ax_1;
            else
                F_axA=F_ax_1;
                F_axB=0;
            end

            %Lager A:
            %Bestimmung des Radialfaktors X und Axialfaktors Y nach Tabelle 47 (ME FS)
            %Auswahl eines passenden Lagers anand des Wellenduchmessers
            %Tabelle: A:Innendurchmesser B:Außendurchmesser C:Lagerbreite D: dyn.
            %Tragzahl E:Masse F: fo G: stat Tragzahl
            [m,n]=size(values);
            %Lager nur neu auswählen, wenn es nicht bebehalten werden soll
            if (beibehalten==0)
                
                for i=1:1:m
                    if(values(i,1)>= d_sh_1 && values(i,4)>=C_dyn_erf_A && values(i,7)>=C_stat_erf_A)
                        var=i;
                        break;
                    end
                end
                %Abspeichern der Lagerbreite und des Wellendurchmessers
                d_sh_A_vec(k)=values(var,1);
                b_A_vec(k)=values(var,3);
                m_A_vec(k)=values(var,5)/1000;
                d_A_A_vec(k)=values(var,2);
                d_1_A(k)=values(var,8);
                ID_A{1,k}=num2str(values(var,9));
                f0_A=values(var,6);
                C0r_A=values(var,7);
            end
            %e definieren
            %zunächst muss das Verhlätnis f0*Fax/C0r bebildet werden
            val=f0_A*F_axA/C0r_A;
            if(val<0.5)
                e=0.22;
            elseif(val>=0.5 && val<0.9)
                e=0.24;
            elseif(val>=0.9 && val<1.6)
                e=0.28;
            elseif(val>=1.6 && val<3.0)
                e=0.32;
            elseif(val>=3.0 && val<6.0)
                e=0.36;
            else
                e=0.43;
            end
            par=F_axA/F_radA;

            if(par<=e)
                X=1;
                Y=0;
            else
                X=0.56;
                %Y festlegen in Abhängigkeit von e
                if(e==0.22)
                    Y=2.0;
                elseif(e==0.24)
                    Y=1.8;
                elseif(e==0.28)
                    Y=1.6;
                elseif(e==0.32)
                    Y=1.4;
                elseif(e==0.36)
                    Y=1.2;
                else
                    Y=1;
                end
            end
            %statischer Nachweis:__________________________________________
            %stat. Tragzahl berechnen:
            P_stat_A=(0.6*F_radA)+(0.5*F_axA)*ueberlast(k)*K_a;
            %Es wird eine Sicherhheit von größer 2 gefordert. Wähle 2.1!
            C_stat_erf_A=2.1*P_stat_A;
            %Auslesen der stat. Tragzahl:
            C_stat_A=values(var,7);
            

            %______________________________________________________________
            %dynamischer Nachweis:
            %dynamische äquivalente Belastung berechnen
            P_next_A=(X*F_radA)+(Y*F_axA);

            %Auslesen der Dynamsichen Tragzahl des Lagers
            C_dyn_A=values(var,4);
            %Berechnen der erforderlichen dynamische Tragzahl: Wir gehen von
            %2000h Betrieb bei maximalen Moment aus
            %Betreib aus
            L_10=2000*60*n_eck/(10^6);
            C_dyn_erf_A=(L_10^(1/3))*P_next_A;
            

            %Lager B:
            %Bestimmung des Radialfaktors X und Axialfaktors Y nach Tabelle 47 (ME FS)
            %Auswahl eines passenden Lagers anand des Wellenduchmessers
            %Tabelle: A:Innendurchmesser B:Außendurchmesser C:Lagerbreite D: dyn.
            %Tragzahl E:Neigungswinkel der Kegel
            %Lager nur neu auslesen, falls es nicht beibehalten werden soll
            if (beibehalten==0)
                for i=1:1:m
                    if(values(i,1)>= d_sh_1 && values(i,4)>=C_dyn_erf_B && values(i,7)>=C_stat_erf_B)
                        var=i;
                        break;
                    end
                end
                %Abspeichern der Lagerbreite und des Wellendurchmessers
                d_sh_B_vec(k)=values(var,1);
                b_B_vec(k)=values(var,3);
                m_B_vec(k)=values(var,5)/1000;
                d_A_B_vec(k)=values(var,2);
                d_1_B(k)=values(var,8);
                ID_B{1,k}=num2str(values(var,9));
                f0_B=values(var,6);
                C0r_B=values(var,7);
            end
            %e muss bestimmt werden
            %zunächst muss das Verhlätnis f0*Fax/C0r bebildet werden
            val=f0_B*F_axB/C0r_B;
            if(val<0.5)
                e=0.22;
            elseif(val>=0.5 && val<0.9)
                e=0.24;
            elseif(val>=0.9 && val<1.6)
                e=0.28;
            elseif(val>=1.6 && val<3.0)
                e=0.32;
            elseif(val>=3.0 && val<6.0)
                e=0.36;
            else
                e=0.43;
            end

            par=F_axB/F_radB;

            if(par<=e)
                X=1;
                Y=0;
            else
                X=0.56;
                %Y festlegen in Abhängigkeit von e
                if(e==0.22)
                    Y=2.0;
                elseif(e==0.24)
                    Y=1.8;
                elseif(e==0.28)
                    Y=1.6;
                elseif(e==0.32)
                    Y=1.4;
                elseif(e==0.36)
                    Y=1.2;
                else
                    Y=1;
                end
            end
            
            %Statischer Festigkeitsnachweis________________________________
            %Für Rillenkugellager wird eine stat. Sicherheit von >2
            %gefordert. Wähle 2.1!
            P_stat_B=(0.6*F_radB)+(0.5*F_axB)*ueberlast(k)*K_a;
            C_stat_erf_B=2.1*P_stat_B;
            %Auslesen der stat. Tragzahl:
            C_stat_B=values(var,7);
            %______________________________________________________________
            %Dynamischer Festigkeitsnachweis
            %dynamische äquivalente Belastung berechnen:
            P_next_B=(X*F_radB)+(Y*F_axB);

            %Auslesen der Dynamsichen Tragzahl des Lagers
            C_dyn_B=values(var,4);
            %Berechnen der erforderlichen dynamische Tragzahl: Wir gehen von 2000h
            %Betrieb aus bei maximalen Moment
            L_10=2000*60*n_eck/(10^6);
            C_dyn_erf_B=(L_10^(1/3))*P_next_B;
            
            %Abgleichen ob dyn. erforderliche Tragzahl zu groß
            if(C_dyn_erf_A>120000 || C_dyn_erf_B>120000)
                Fehlerbit(k)=1;
                Fehlercode(1,k)={'Fehler bei Welle 1: Die erforderliche dynamische Tragzahl ist zu hoch. Der Lagerkatalog muss erweitert werden.'};
                C_dyn_erf_A=20000;
                C_dyn_erf_B=20000;
            end
            %Abgleichen ob stat. erf. Tragzahl zu groß
            if(C_stat_erf_A>85000 || C_stat_erf_B>85000)
                Fehlerbit(k)=1;
                Fehlercode(1,k)={'Fehler bei Welle 1: Die erforderliche statische Tragzahl ist zu hoch. Der Lagerkatalog muss erweitert werden.'};
                C_stat_erf_A=20000;
                C_stat_erf_B=20000;
            end

            %Abfrage ob die geforderte Lebensdauer erreicht wird. Beim zweiten
            %Druchlauf müsste dies der Fall sein
            
            %Festigkeitsnachweis der Welle_________________________________
            [d_inn_1,d_sh_rel,int,Fehlerbit(k),Fehlercode(1,k)] = calc_d_sh(T_max(k),d_sh_A_vec(k),d_sh_B_vec(k),Fehlerbit(k),Fehlercode(1,k));
            
            if(C_dyn_A>C_dyn_erf_A && C_dyn_B>C_dyn_erf_B && int==1 && C_stat_A>C_stat_erf_A && C_stat_B>C_stat_erf_B)
                d_inn_1_vec(k)=d_inn_1;
                beibehalten=1;
                break;
            else
                if(int==0)
                    d_sh_1(k)=d_sh_rel+5;
                end
                beibehalten=0;
            end
             
            
        end
        %In der äußeren Schleife müssen noch Lagerabstand angepasst werden
        %Es müssen hier endgültige Werte für l,s,m, d_sh festgelegt werden
        %Es ist noch festzulegendes Spaltmaß zu addieren
        l_1_1=(b_A_vec(k)/2)+(b_B_vec(k)/2)+b_1+b_park+(3*spalt);
        s_1_1=(l_1_1/2)-(b_1/2)-(b_A_vec(k)/2)-spalt; 

        %Abfrage ob der Lagerabstand passt
        if(l_1_1==l_1 && s_1_1==s_1)
            s_1_vec(k)=s_1_1;
            l_1_vec(k)=l_1_1;
            break;
        else
            l_1=l_1_1;
            s_1=s_1_1;
        end


    end

end
%Ursprüngliche Benamung beibehalten
s_1=s_1_vec;
l_1=l_1_vec;
d_sh_A=d_sh_A_vec;
d_sh_B=d_sh_B_vec;
m_A=m_A_vec;
m_B=m_B_vec;
d_A_A=d_A_A_vec;
d_A_B=d_A_B_vec;
b_A=b_A_vec;
b_B=b_B_vec;
d_inn_1=d_inn_1_vec;

end

