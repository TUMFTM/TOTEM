
function [  l_2,s_2,d_sh_C,d_sh_D,a,alpha_wt,m_C,m_D,d_A_C,d_A_D,b_C,b_D,F_u_3_vec,F_ax_3_vec,F_rad_3_vec,d_1_C,d_1_D,d_inn_2,Fehlerbit,Fehlercode,ID_C,ID_D] = set_bearings_welle_2_vec( T_nenn,T_max, n_eck, d_3,d_4,b_1, b_3, beta,alpha_t,m_n,z_3,z_4,i_12,d_1,d_2,values ,spalt,Fehlerbit,Fehlercode,ueberlast)
%Setzt die Lager für die zweite Welle.

%Anwendungsfaktor für statischen Nachweis
K_a=1.5;

%Der Betriebswingriffwinkel wird benötigt
%Achsabstand
a=0.5*(d_3+d_4);
%Betriebsengriffwinkel
alpha_wt=acos((((z_3+z_4)*m_n)./(2*a))*(cos(alpha_t)/cos(beta)));

%WELLE 2:
%Es wird eine Fest-Los-Lagerung verwendet. Auch hier müssen der
%Lagerabstand und Ritzelabstand festgelegt werden
%Es wird auf die Excel-Tabelle alle_stufen_2_stufig_strin.xlxs zugegegriffen
%Es handelt sich um eine nicht symmetrische Lagerung mit Rillenkugellager.
%        _ 
%       | |  _ 
%---C---|2|-|3|---D--
%       |_|  
%
% Lagerabstand und Lager-Ritzelabstand wird anhand der Lagerbreiten und der
%Verzahnungsbreite ermittelt
[w,u]=size(b_1);
s_2_vec=0.5*((b_1/2)+(b_3/2));
l_2_vec=(1.5*b_1)+(1.5*b_3)+(2*spalt);

%wirkende Kräfte
F_u_3_vec=2000*(i_12.*T_nenn)./d_3;
F_ax_3_vec=F_u_3_vec*tan(beta);
F_rad_3_vec=F_u_3_vec.*tan(alpha_wt);
F_u_1_vec=2000*T_nenn./d_1;
F_ax_1_vec=F_u_1_vec.*tan(beta);
F_rad_1_vec=F_u_1_vec.*tan(alpha_wt);
F_u_2_vec=F_u_1_vec;
F_rad_2_vec=F_rad_1_vec;
F_ax_2_vec=F_ax_1_vec;

%Initialisierung eines Vektors für Lagerdaten
d_sh_C_vec=zeros(1,u);
d_sh_D_vec=zeros(1,u);
m_C_vec=zeros(1,u);
m_D_vec=zeros(1,u);
d_A_C_vec=zeros(1,u);
d_A_D_vec=zeros(1,u);
b_C_vec=zeros(1,u);
b_D_vec=zeros(1,u);
d_1_C=zeros(1,u);
d_1_D=zeros(1,u);
d_inn_2=zeros(1,u);
ID_C=cell(1,u);
ID_D=cell(1,u);

d_2_vec=d_2;
d_3_vec=d_3;
n_eck_vec=n_eck;
d_sh_2_vec=zeros(1,u);
i_12_vec=i_12;
b_1_vec=b_1;
b_3_vec=b_3;

%Für vektorielle Bearbeitung for-Schleife notwendig
for k=1:u
    %definiere eine dynamische Tragzahl von C_dyn=0 sodass if Abfrage auch beim
    %ersten Durchlauf funktioniert. C_dyn wird später überschrieben
    C_dyn_erf_C=0;
    C_dyn_erf_D=0;
    C_stat_erf_C=0;
    C_stat_erf_D=0;
    
    F_u_3=F_u_3_vec(k);
    F_u_2=F_u_2_vec(k);
    F_ax_3=F_ax_3_vec(k);
    F_ax_2=F_ax_2_vec(k);
    F_rad_3=F_rad_3_vec(k);
    F_rad_2=F_rad_2_vec(k);
    s_2=s_2_vec(k);
    l_2=l_2_vec(k);
    d_2=d_2_vec(k);
    d_3=d_3_vec(k);
    d_sh_2=d_sh_2_vec(k);
    i_12=i_12_vec(k);
    b_1=b_1_vec(k);
    b_3=b_3_vec(k);
    n_eck=n_eck_vec(k);
    %Beim ertsen Durchlauf kein Lager beibehalten
    beibehalten=0;
    
    %Hier müsste die Schleife für die Optimierung des Lagerabstandes l und
    %Ritzelabstandes s beginnen.
    while 1
        while 1
            %Lagerreaktionskräfte
            F_Cz=(1/l_2)*((F_u_3*((l_2/2)-s_2))-(F_u_2*((l_2/2)+s_2)));
            F_Dz=F_u_3-F_u_2-F_Cz;

            F_Cy=(1/l_2)*((F_rad_3*((l_2/2)-s_2))-(F_rad_2*((l_2/2)+s_2))+(F_ax_2*0.5*d_2)+(F_ax_3*0.5*d_3));
            F_Dy=F_rad_3-F_rad_2-F_Cy;

            %radiale Belastung
            F_radC=sqrt((F_Cz^2)+(F_Cy^2));
            F_radD=sqrt((F_Dz^2)+(F_Dy^2));

            %Auswahl welches Lager die Axialkraft aufnimmt
            if(F_radC>F_radD)
                F_Dx=F_ax_3-F_ax_2;
                F_Cx=0;
            else
                F_Cx=F_ax_3-F_ax_2;
                F_Dx=0;
            end

            %Lager C:____________
            %Bestimmung des Radialfaktors X und Axialfaktors Y nach Tabelle 47 (ME FS)
            %Auswahl eines passenden Lagers anand des Wellenduchmessers
            %Tabelle: A:Innendurchmesser B:Außendurchmesser C:Lagerbreite D: dyn.
            %Tragzahl 
            [m,n]=size(values);
            %Nur neues Lager auswählen, wenn keines beibehalten werden soll
            if (beibehalten==0)
                
                for i=1:1:m
                    if(values(i,1)>=d_sh_2 && values(i,4)>=C_dyn_erf_C && values(i,7)>C_stat_erf_C)
                        var=i;
                        break;
                    end
                end
                %Auslesen der Lagerbreite und des Wellendurchmessers
                b_C_vec(k)=values(var,3);
                d_sh_C_vec(k)=values(var,1);
                d_A_C_vec(k)=values(var,2);
                m_C_vec(k)=values(var,5)/1000;
                d_1_C(k)=values(var,8);
                ID_C{1,k}=num2str(values(var,9));
                f0_C=values(var,6);
                C0r_C=values(var,7);
            end
          
            %e bestimmen
            %zunächst muss das Verhlätnis f0*Fax/C0r bebildet werden
            val=f0_C*F_Cx/C0r_C;
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

            par=F_Cx/F_radC;

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
            %statischer Nachweis___________________________________________
            %Berechnen der stat. Tragzahl
            P_stat_C=(0.6*F_radC)+(0.5*F_Cx)*ueberlast(k)*K_a;
            %Es wird eine Sicherheit von 2.1 gefordert.
            C_stat_erf_C=2.1*P_stat_C;
            %Auslesen der stat. Tragzahl
            C_stat_C=values(var,7);

            %______________________________________________________________
            %dynamischer Nachweis
            %dynamische äquivalente Belastung berechnen
            P_next_C=(X*F_radC)+(Y*F_Cx);

            %Auslesen der Dynamsichen Tragzahl des Lagers
            C_dyn_C=values(var,4);
            %Berechnen der erforderlichen dynamische Tragzahl: Wir gehen von 2000h
            %Betreib aus bei maximalen Moment
            L_10=2000*60*(n_eck/i_12)/(10^6);
            C_dyn_erf_C=(L_10^(1/3))*P_next_C;


            %Lager D:___________
            %Bestimmung des Radialfaktors X und Axialfaktors Y nach Tabelle 47 (ME FS)
            %Auswahl eines passenden Lagers anand des Wellenduchmessers
            %Tabelle: A:Innendurchmesser B:Außendurchmesser C:Lagerbreite D: dyn.
            %Tragzahl
            %Nur neues Lager auswählen, wenn keines beibehalten werden soll
            if (beibehalten==0)
                
                for i=1:1:m
                    if(values(i,1)>=d_sh_2 && values(i,4)>=C_dyn_erf_D && values(i,7)> C_stat_erf_D)
                        var=i;
                        break;
                    end
                end
                %Auslesen der Lagerbreite und des Wellendurchmessers
                b_D_vec(k)=values(var,3);
                d_sh_D_vec(k)=values(var,1);
                d_A_D_vec(k)=values(var,2);
                m_D_vec(k)=values(var,5)/1000;
                d_1_D(k)=values(var,8);
                ID_D{1,k}=num2str(values(var,9));
                f0_D=values(var,6);
                C0r_D=values(var,7);
            end

            %e muss bestimmt werden, hängt vom Lager ab.
            %zunächst muss das Verhlätnis f0*Fax/C0r bebildet werden
            val=f0_D*F_Dx/C0r_D;
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

            par=F_Dx/F_radD;

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
            %Berechnenen der stat. Tragzahl
            P_stat_D=(0.6*F_radD)+(0.5*F_Dx)*ueberlast(k)*K_a;
            %Es wird eine Sicherheit von 2.1 gefordert
            C_stat_erf_D=2.1*P_stat_D;
            %Auslesen der dynamischen Tragzahl
            C_stat_D=values(var,7);

            %______________________________________________________________
            %Dynamischer Nachweis
            %dynamische äquivalente Belastung berechnen
            P_next_D=(X*F_radD)+(Y*F_Dx);

            %Auslesen der Dynamsichen Tragzahl des Lagers
            C_dyn_D=values(var,4);
            %Berechnen der erforderlichen dynamische Tragzahl: Wir gehen von 2000h
            %Betreib aus bei maximalen Moment
            L_10=2000*60*(n_eck/i_12)/(10^6);
            C_dyn_erf_D=(L_10^(1/3))*P_next_D;

            %Überprüfen der dynamischen erforderlichen Tragzahl
            if(C_dyn_erf_C>120000 || C_dyn_erf_D>120000)
                Fehlerbit(k)=1;
                Fehlercode(1,k)={'Fehler bei Welle 2: Die erforderliche dynamische Tragzahl ist zu hoch. Der Lagerkatalog muss erweitert werden.'};
                C_dyn_erf_C=20000;
                C_dyn_erf_D=20000;
            end
            %Überprüfen der stat. erforderlichen Tragzahl
            if(C_stat_erf_C>80000 || C_stat_erf_D>80000)
                Fehlerbit(k)=1;
                Fehlercode(1,k)={'Fehler bei Welle 2: Die erforderliche stat. Tragzahl ist zu hoch. Der Lagerkatalog muss erweitert werden.'};
                C_stat_erf_C=20000;
                C_stat_erf_D=20000;
            end
            

            %Abfrage ob die geforderte Lebensdauer erreicht wird. Beim zweiten
            %Druchlauf müsste dies der Fall sein
            %Festigkeitsnachweis der Welle
            T_rel=T_max.*i_12;
            [d_inn,d_sh_rel,int,Fehlerbit(k),Fehlercode(1,k)] = calc_d_sh(T_rel(k),d_sh_C_vec(k),d_sh_D_vec(k),Fehlerbit(k),Fehlercode(1,k));
            
            if(C_dyn_C>C_dyn_erf_C && C_dyn_D>C_dyn_erf_D && int==1 && C_stat_C>C_stat_erf_C && C_stat_D>C_stat_erf_D)
                d_inn_2(k)=d_inn;
                beibehalten=1;
                break;
            else
                if(int==0)
                    d_sh_2(k)=d_sh_rel+5;
                end
                beibehalten=0;
            end
        end
        %In der äußeren Schleife müssen noch Lagerabstand angepasst werden
        %Es müssen hier endgültige Werte für l,s,m, d_sh festgelegt werden
        %Es ist noch festzulegendes Spaltmaß zu addieren
        l_2_2=(b_C_vec(k)/2)+spalt+b_1+b_3+spalt+(b_D_vec(k)/2);
        s_2_2=(l_2_2/2)-(b_C_vec(k)/2)-spalt-(b_1/2);

        %Abfrage ob der Lagerabstand passt
        if(l_2_2==l_2 && s_2_2==s_2)
            s_2_vec(k)=s_2_2;
            l_2_vec(k)=l_2_2;
            break;
        else
            l_2=l_2_2;
            s_2=s_2_2;
        end

    end

end
%Ursprünliche Benamung beibehalten
s_2=s_2_vec;
l_2=l_2_vec;
m_C=m_C_vec;
m_D=m_D_vec;
d_A_C=d_A_C_vec;
d_A_D=d_A_D_vec;
b_C=b_C_vec;
b_D=b_D_vec;
d_sh_C=d_sh_C_vec;
d_sh_D=d_sh_D_vec;
end

