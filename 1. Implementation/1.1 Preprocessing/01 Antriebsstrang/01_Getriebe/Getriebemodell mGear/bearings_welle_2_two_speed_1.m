function [l_3_1,d_sh_C,d_sh_D,a,alpha_wt,m_C,m_D,d_A_C,d_A_D,b_C,b_D,F_u_3,F_ax_3,F_rad_3,d_1_C,d_1_D,d_inn_2,Fehlerbit,Fehlercode,ID_C,ID_D,C_dyn_C,C_dyn_D,C_stat_C,C_stat_D,f0_C,f0_D,C0r_C,C0r_D,Lager_C_angepasst,Lager_D_angepasst] = bearings_welle_2_two_speed_1( T_nenn,T_max, n_eck, d_3,d_4,b_1_1,b_1_2, b_3, beta,alpha_t,m_n,z_3,z_4,i_12_1,i_12_2,d_1_1,d_1_2,d_2_1,d_2_2,values ,spalt,Fehlerbit,Fehlercode,ueberlast,Lager_C_beibehalten,Lager_D_beibehalten,gear,wunschbauraum,b_C,b_D,m_C,m_D,d_sh_D,d_sh_C,d_1_C,d_1_D,C_dyn_C,C_dyn_D,C_stat_C,C_stat_D,f0_C,f0_D,C0r_C,C0r_D,ID_C,ID_D,Lager_C_angepasst,Lager_D_angepasst,d_A_C,d_A_D)
%Wälzlagerauslegung für 2.Welle 

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
%

%
% Lagerabstand und Lager-Ritzelabstand wird anhand der Lagerbreiten und der
%Verzahnungsbreite ermittelt
[w,u]=size(b_1_1);
%Lagerabstände Gang 1
l_3_1=4*(b_1_1)+wunschbauraum;
l_2_1=2*(b_1_1);
l_1_1=b_1_1;
%Lagerabstände Gang 2
l_3_2=4*(b_1_1)+wunschbauraum;
l_2_2=2*(b_1_1)+wunschbauraum;
l_1_2=b_1_1;

%wirkende Kräfte
F_u_3=zeros(1,u);
F_ax_3=zeros(1,u);
F_rad_3=zeros(1,u);
F_u_1=zeros(1,u);
F_ax_1=zeros(1,u);
F_rad_1=zeros(1,u);
F_u_2=zeros(1,u);
F_rad_2=zeros(1,u);
F_ax_2=zeros(1,u);

%Variabel
int=0;

%Initialisierung eines Vektors für Lagerdaten
%Nur neue Größen defineren, wenn kein Lager beibehalten werden soll
if (Lager_C_beibehalten==0)
    d_sh_C=zeros(1,u);
    m_C=zeros(1,u);
    d_A_C=zeros(1,u);
    b_C=zeros(1,u);
    d_1_C=zeros(1,u);
    ID_C=cell(1,u);
    f0_C=zeros(1,u);
    C0r_C=zeros(1,u);
    C_stat_C=zeros(1,u);
    C_dyn_C=zeros(1,u);
end

if (Lager_D_beibehalten==0)
    d_sh_D=zeros(1,u);
    m_D=zeros(1,u);
    d_A_D=zeros(1,u);
    b_D=zeros(1,u);
    d_1_D=zeros(1,u);
    ID_D=cell(1,u);
    f0_D=zeros(1,u);
    C0r_D=zeros(1,u);
    C_stat_D=zeros(1,u);
    C_dyn_D=zeros(1,u);
end


d_inn_2=zeros(1,u);
d_sh_2=zeros(1,u);




%Für vektorielle Bearbeitung for-Schleife notwendig
for k=1:u
    %definiere eine dynamische Tragzahl von C_dyn=0 sodass if Abfrage auch beim
    %ersten Durchlauf funktioniert. C_dyn wird später überschrieben
    C_dyn_erf_C=0;
    C_dyn_erf_D=0;
    C_stat_erf_C=0;
    C_stat_erf_D=0;
    
    
    %Hier müsste die Schleife für die Optimierung des Lagerabstandes l und
    %Ritzelabstandes s beginnen.
    while 1
        while 1
            if (gear==1)
                %Lagerreaktionskräfte für 1.Gang
                F_u_3(k)=2000*(i_12_1(k).*T_nenn(k))./d_3(k);
                F_ax_3(k)=F_u_3(k)*tan(beta);
                F_rad_3(k)=F_u_3(k).*tan(alpha_wt(k));
                F_u_1(k)=2000*T_nenn(k)./d_1_1(k);
                F_ax_1(k)=F_u_1(k).*tan(beta);
                F_rad_1(k)=F_u_1(k).*tan(alpha_wt(k));
                F_u_2(k)=F_u_1(k);
                F_rad_2(k)=F_rad_1(k);
                F_ax_2(k)=F_ax_1(k);
                
                F_Cz=(1/l_3_1(k))*((F_u_2(k)*(l_3_1(k)-l_1_1(k)))-(F_u_3(k)*((l_3_1(k)-l_2_1(k)))));
                F_Dz=F_u_2(k)-F_u_3(k)-F_Cz;

                F_Cy=(1/l_3_1(k))*((F_ax_2(k)*0.5*d_2_1(k))+(F_rad_2(k)*(l_3_1(k)-l_1_1(k)))-(F_rad_3(k)*(l_3_1(k)-l_2_1(k)))+(F_ax_3(k)*0.5*d_3(k)));
                F_Dy=F_rad_2(k)+F_rad_3(k)-F_Cy;

                %radiale Belastung
                F_radC=sqrt((F_Cz^2)+(F_Cy^2));
                F_radD=sqrt((F_Dz^2)+(F_Dy^2));

                %Auswahl welches Lager die Axialkraft aufnimmt
                if(F_radC>F_radD)
                    F_Dx=abs(F_ax_2(k)-F_ax_3(k));
                    F_Cx=0;
                else
                    F_Cx=abs(F_ax_2(k)-F_ax_3(k));
                    F_Dx=0;
                end
                
            elseif(gear==2)
                %Lagerreaktionskräfte für Gang 2
                F_u_3(k)=2000*(i_12_2(k).*T_nenn(k))./d_3(k);
                F_ax_3(k)=F_u_3(k)*tan(beta);
                F_rad_3(k)=F_u_3(k).*tan(alpha_wt(k));
                F_u_1(k)=2000*T_nenn(k)./d_1_2(k);
                F_ax_1(k)=F_u_1(k).*tan(beta);
                F_rad_1(k)=F_u_1(k).*tan(alpha_wt(k));
                F_u_2(k)=F_u_1(k);
                F_rad_2(k)=F_rad_1(k);
                F_ax_2(k)=F_ax_1(k);
                
                F_Cz=(1/l_3_2(k))*((F_u_2(k)*l_1_2(k))-(F_u_3(k)*l_2_2(k)));
                F_Dz=F_u_2(k)-F_u_3(k)-F_Cz;

                F_Cy=(1/l_3_2(k))*((F_ax_3(k)*0.5*d_3(k))-(F_rad_3(k)*l_2_2(k))+(F_rad_2(k)*l_1_2(k))+(F_ax_2(k)*0.5*d_2_2(k)));
                F_Dy=F_rad_2(k)-F_rad_3(k)-F_Cy;

                %radiale Belastung
                F_radC=sqrt((F_Cz^2)+(F_Cy^2));
                F_radD=sqrt((F_Dz^2)+(F_Dy^2));

                %Auswahl welches Lager die Axialkraft aufnimmt
                if(F_radC>F_radD)
                    F_Dx=abs(F_ax_3(k)-F_ax_2(k));
                    F_Cx=0;
                else
                    F_Cx=abs(F_ax_3(k)-F_ax_2(k));
                    F_Dx=0;
                end
            end

            %Lager C:____________
            %Bestimmung des Radialfaktors X und Axialfaktors Y nach Tabelle 47 (ME FS)
            %Auswahl eines passenden Lagers anand des Wellenduchmessers
            %Tabelle: A:Innendurchmesser B:Außendurchmesser C:Lagerbreite D: dyn.
            %Tragzahl 
            [m,n]=size(values);
            %Nur neues Lager auswählen, wenn keines beibehalten werden soll
            if (Lager_C_beibehalten==0)
                
                for i=1:1:m
                    if(values(i,1)>=d_sh_2(k) && values(i,4)>=C_dyn_erf_C && values(i,7)>C_stat_erf_C)
                        var=i;
                        break;
                    end
                end
                %Auslesen der Lagerbreite und des Wellendurchmessers
                b_C(k)=values(var,3);
                d_sh_C(k)=values(var,1);
                d_A_C(k)=values(var,2);
                m_C(k)=values(var,5)/1000;
                d_1_C(k)=values(var,8);
                ID_C{1,k}=num2str(values(var,9));
                f0_C(k)=values(var,6);
                C0r_C(k)=values(var,7);
                C_stat_C(k)=values(var,7);
                C_dyn_C(k)=values(var,4);
            end
          
            %e bestimmen
            %zunächst muss das Verhlätnis f0*Fax/C0r bebildet werden
            val=f0_C(k)*F_Cx/C0r_C(k);
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

            %______________________________________________________________
            %dynamischer Nachweis
            %dynamische äquivalente Belastung berechnen
            P_next_C=(X*F_radC)+(Y*F_Cx);

            %Berechnen der erforderlichen dynamische Tragzahl: Wir gehen von 2000h
            %Betreib aus bei maximalen Moment
            if(gear==1)
                i_12=i_12_1(k);
            else
                i_12=i_12_2(k);
            end
            L_10=1000*60*(n_eck(k)/i_12)/(10^6);
            C_dyn_erf_C=(L_10^(1/3))*P_next_C;


            %Lager D:___________
            %Bestimmung des Radialfaktors X und Axialfaktors Y nach Tabelle 47 (ME FS)
            %Auswahl eines passenden Lagers anand des Wellenduchmessers
            %Tabelle: A:Innendurchmesser B:Außendurchmesser C:Lagerbreite D: dyn.
            %Tragzahl
            %Nur neues Lager auswählen, wenn keines beibehalten werden soll
            if (Lager_D_beibehalten==0)
                
                for i=1:1:m
                    if(values(i,1)>=d_sh_2(k) && values(i,4)>=C_dyn_erf_D && values(i,7)> C_stat_erf_D)
                        var=i;
                        break;
                    end
                end
                %Auslesen der Lagerbreite und des Wellendurchmessers
                b_D(k)=values(var,3);
                d_sh_D(k)=values(var,1);
                d_A_D(k)=values(var,2);
                m_D(k)=values(var,5)/1000;
                d_1_D(k)=values(var,8);
                ID_D{1,k}=num2str(values(var,9));
                f0_D(k)=values(var,6);
                C0r_D(k)=values(var,7);
                C_stat_D(k)=values(var,7);
                C_dyn_D(k)=values(var,4);
            end

            %e muss bestimmt werden, hängt vom Lager ab.
            %zunächst muss das Verhlätnis f0*Fax/C0r bebildet werden
            val=f0_D(k)*F_Dx/C0r_D(k);
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

            %______________________________________________________________
            %Dynamischer Nachweis
            %dynamische äquivalente Belastung berechnen
            P_next_D=(X*F_radD)+(Y*F_Dx);

            %Berechnen der erforderlichen dynamische Tragzahl: Wir gehen von 2000h
            %Betreib aus bei maximalen Moment
            if(gear==1)
                i_12=i_12_1(k);
                lifetime=600;
            else
                i_12=i_12_2(k);
                lifetime=800;
            end
            L_10=lifetime*60*(n_eck(k)/i_12)/(10^6);
            C_dyn_erf_D=(L_10^(1/3))*P_next_D;

            %Überprüfen der dynamischen erforderlichen Tragzahl
            if(C_dyn_erf_C>120000 || C_dyn_erf_D>120000)
                Fehlerbit(k)=1;
                Fehlercode(1,k)={'Fehler bei Welle 2: Die erforderliche dynamische Tragzahl ist zu hoch. Der Lagerkatalog muss erweitert werden.'};
                C_dyn_erf_C=20000;
                C_dyn_erf_D=20000;
                int=1;
            end
            %Überprüfen der stat. erforderlichen Tragzahl
            if(C_stat_erf_C>80000 || C_stat_erf_D>80000)
                Fehlerbit(k)=1;
                Fehlercode(1,k)={'Fehler bei Welle 2: Die erforderliche stat. Tragzahl ist zu hoch. Der Lagerkatalog muss erweitert werden.'};
                C_stat_erf_C=20000;
                C_stat_erf_D=20000;
                int=1;
            end
            

            %Abfrage ob die geforderte Lebensdauer erreicht wird. Beim zweiten
            %Druchlauf müsste dies der Fall sein
            %Festigkeitsnachweis der Welle
            T_rel=T_max.*i_12;
            if(int==0)
                [d_inn,d_sh_rel,int,Fehlerbit(k),Fehlercode(1,k)] = calc_d_sh(T_rel(k),d_sh_C(k),d_sh_D(k),Fehlerbit(k),Fehlercode(1,k));
            else
                d_inn=0;
            end
            if(C_dyn_C(k)>C_dyn_erf_C && C_dyn_D(k)>C_dyn_erf_D && int==1 && C_stat_C(k)>C_stat_erf_C && C_stat_D(k)>C_stat_erf_D)
                d_inn_2(k)=d_inn;
                Lager_C_beibehalten=1;
                Lager_D_beibehalten=1;
               
                break;
            else
                if(int==0)
                    d_sh_2(k)=d_sh_rel+5;
                    Lager_C_beibehalten=0;
                    Lager_D_beibehalten=0;
                    Lager_C_angepasst=1;
                    Lager_D_angepasst=1;
                end
                if(C_dyn_C(k)<C_dyn_erf_C || C_stat_C(k)<C_stat_erf_C)
                    Lager_C_beibehalten=0;
                    Lager_C_angepasst=1;
                end
                if(C_dyn_D(k)<C_dyn_erf_D || C_stat_D(k)<C_stat_erf_D)
                    Lager_D_beibehalten=0;
                    Lager_D_angepasst=1;
                end
            end
        end
        %In der äußeren Schleife müssen noch Lagerabstand angepasst werden
        %Es müssen hier endgültige Werte für l,s,m, d_sh festgelegt werden
        %Es ist noch festzulegendes Spaltmaß zu addieren
        %Lagerabstände Gang 1
            l_3_1_r=(b_C(k)/2)+spalt+b_1_1(k)+spalt+b_3(k)+wunschbauraum+spalt+b_1_2(k)+spalt+(b_D(k)/2);
            l_1_1_r=(b_C(k)/2)+spalt+(b_1_1(k)/2);
            l_2_1_r=(b_C(k)/2)+spalt+b_1_1(k)+spalt+(b_3(k)/2)+wunschbauraum(k);
            %Lagerabstände Gang 2
            l_3_2_r=(b_C(k)/2)+spalt+b_1_1(k)+spalt+b_3(k)+wunschbauraum+spalt+b_1_2(k)+spalt+(b_D(k)/2);
            l_2_2_r=(b_D(k)/2)+spalt+b_1_2(k)+spalt+(b_3(k)/2);
            l_1_2_r=(b_D(k)/2)+spalt+(b_1_2(k)/2);

        %Abfrage ob der Lagerabstand passt
        if (gear==1)
            if(l_3_1(k)==l_3_1_r && l_2_1(k)==l_2_1_r && l_1_1(k)==l_1_1_r)
                l_3_1(k)=l_3_1_r;
                l_2_1(k)=l_2_1_r;
                l_1_1(k)=l_1_1_r;
                break;
            else
                l_3_1(k)=l_3_1_r;
                l_2_1(k)=l_2_1_r;
                l_1_1(k)=l_1_1_r;
            end
        elseif (gear==2)
            if(l_3_2(k)==l_3_2_r && l_2_2(k)==l_2_2_r && l_1_2(k)==l_1_2_r)
                l_3_2(k)=l_3_2_r;
                l_2_2(k)=l_2_2_r;
                l_1_2(k)=l_1_2_r;
                break;
            else
                l_3_2(k)=l_3_2_r;
                l_2_2(k)=l_2_2_r;
                l_1_2(k)=l_1_2_r;
            end
        end

    end

end


end

