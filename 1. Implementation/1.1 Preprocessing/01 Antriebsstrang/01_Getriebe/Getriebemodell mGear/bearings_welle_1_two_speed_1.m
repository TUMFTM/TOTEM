function [l_1,s_1_1,s_1_2,d_sh_A,d_sh_B,a_12,alpha_wt,m_A,m_B,d_A_A,d_A_B,b_A,b_B,d_1_A,d_1_B,d_inn_1,Fehlerbit,Fehlercode,ID_A,ID_B,f0_A,f0_B,C0r_A,C0r_B,C_stat_A,C_stat_B,C_dyn_A,C_dyn_B,Lager_A_angepasst,Lager_B_angepasst] = bearings_welle_1_two_speed_1(T_nenn,T_max, n_eck, d_1_1,d_1_2, d_2_1,d_2_2, b_1_1,b_1_2, beta,alpha_t,m_n,z_1_1,z_2_1,values, spalt,b_park,Fehlerbit,Fehlercode,ueberlast,Lager_A_beibehalten,Lager_B_beibehalten,gear,wunschbauraum,f0_A,f0_B,C0r_A,C0r_B,C_stat_A,C_dyn_A,C_stat_B,C_dyn_B,b_3,d_sh_A,d_sh_B,b_A,b_B,m_A,m_B,d_1_A,d_1_B,ID_A,ID_B,d_A_A,d_A_B,Lager_A_angepasst,Lager_B_angepasst)
%Lagerauswahl für erste Welle 2-Gang-Getriebe
%Anwendungsfaktor für statischen Lagernachweis
K_a=1.5;

%Der Betriebswingriffwinkel wird benötigt
%Achsabstand
a_12=0.5*(d_1_1+d_2_1);
%Betriebsengriffwinkel
alpha_wt=acos((((z_1_1+z_2_1)*m_n)./(2*a_12)).*(cos(alpha_t)/cos(beta)));

%__________________________________________________________________________
%WELLE 1:

% Es handelt sich um eine unsymmetrische Lagerung mit Rillenkugellager.
%      _
%---A-|_|--B---
%        
%Für die Symmetrische Lagerung ist s=0;
% Lagerabstand wird anhand der Lagerbreiten und er Verzahnungsbreite
% ermittelt

[w,u]=size(b_1_1);
s_1_1=b_1_1;
s_1_2=b_1_1;
l_1=4*b_1_1 + b_park + wunschbauraum;

d_sh_1=zeros(1,u);


%wirkende Kräfte
F_u_1=zeros(1,u);
F_ax_1=zeros(1,u);
F_rad_1=zeros(1,u);

%Initialisierung eines Vektors für Lagerdaten
%Nur neue Größen setzen wenn Lager neu bestimmt werden müssen
if(Lager_A_beibehalten==0)
    d_sh_A=zeros(1,u);
    m_A=zeros(1,u);
    d_A_A=zeros(1,u);
    b_A=zeros(1,u);
    d_1_A=zeros(1,u);
    f0_A=zeros(1,u);
    C0r_A=zeros(1,u);
    ID_A=cell(1,u);
    C_dyn_A=zeros(1,u);
    C_stat_A=zeros(1,u);
end
if(Lager_B_beibehalten==0)
    d_sh_B=zeros(1,u);
    m_B=zeros(1,u);
    d_A_B=zeros(1,u);
    b_B=zeros(1,u);
    d_1_B=zeros(1,u);
    f0_B=zeros(1,u);
    C0r_B=zeros(1,u);
    ID_B=cell(1,u);
    C_dyn_B=zeros(1,u);
    C_stat_B=zeros(1,u);
end

d_inn_1=zeros(1,u);


%Für vektorielle Berechnung ist  hier eine for-Schleife erforderlich:
for k=1:u
    %definiere eine dynamische Tragzahl von C_dyn=0 sodass if Abfrage auch beim
    %ersten Durchlauf funktioniert. C_dyn wird später überschrieben
    C_dyn_erf_A=0;
    C_dyn_erf_B=0;
    C_stat_erf_B=0;
    C_stat_erf_A=0;
   
    %Hier müsste die Schleife für die Optimierung des Lagerabstandes l und
    %Ritzelabstandes s beginnen.
    while 1
        while 1
            if(gear==1)
                %Lagerreaktionskräfte für Gang 1
                F_u_1(k)=2000*T_nenn(k)./d_1_1;
                F_ax_1(k)=F_u_1(k)*tan(beta);
                F_rad_1(k)=F_u_1(k).*tan(alpha_wt(k));
                F_Ay=((F_ax_1(k)*0.5*d_1_1(k))+(F_rad_1(k)*((0.5*l_1(k))+s_1_1(k))))/l_1(k);
                F_By=F_rad_1(k)-F_Ay;

                F_Az=(F_u_1(k)*((l_1(k)/2)+s_1_1(k)))/l_1(k);
                F_Bz=F_u_1(k)-F_Az;

                %radiale Belastung
                F_radA=sqrt((F_Az^2)+(F_Ay^2));
                F_radB=sqrt((F_Bz^2)+(F_By^2));

                %axiale Last verteilen
                if(F_radA>=F_radB)
                    F_axA=0;
                    F_axB=F_ax_1(k);
                else
                    F_axA=F_ax_1(k);
                    F_axB=0;
                end
                
            elseif(gear==2)
                %Lagerreaktionskräfte für 2.Gang
                F_u_1(k)=2000*T_nenn(k)./d_1_2;
                F_ax_1(k)=F_u_1(k)*tan(beta);
                F_rad_1(k)=F_u_1(k).*tan(alpha_wt(k));
                F_Ay=((F_ax_1(k)*0.5*d_1_2(k))+(F_rad_1(k)*((0.5*l_1(k))-s_1_2(k))))/l_1(k);
                F_By=F_rad_1(k)-F_Ay;

                F_Az=(F_u_1(k)*((l_1(k)/2)-s_1_2(k)))/l_1(k);
                F_Bz=F_u_1(k)-F_Az;
                
                %radiale Belastung
                F_radA=sqrt((F_Az^2)+(F_Ay^2));
                F_radB=sqrt((F_Bz^2)+(F_By^2));

                %axiale Last verteilen
                if(F_radA>=F_radB)
                    F_axA=0;
                    F_axB=F_ax_1(k);
                else
                    F_axA=F_ax_1(k);
                    F_axB=0;
                end
                
            end

            %Lager A:
            %Bestimmung des Radialfaktors X und Axialfaktors Y nach Tabelle 47 (ME FS)
            %Auswahl eines passenden Lagers anand des Wellenduchmessers
            %Tabelle: A:Innendurchmesser B:Außendurchmesser C:Lagerbreite D: dyn.
            %Tragzahl E:Masse F: fo G: stat Tragzahl
            [m,n]=size(values);
            %Lager nur neu auswählen, wenn es nicht bebehalten werden soll
            if (Lager_A_beibehalten==0)
                
                for i=1:1:m
                    if(values(i,1)>= d_sh_1(k) && values(i,4)>=C_dyn_erf_A && values(i,7)>=C_stat_erf_A)
                        var=i;
                        break;
                    end
                end
                %Abspeichern der Lagerbreite und des Wellendurchmessers
                d_sh_A(k)=values(var,1);
                b_A(k)=values(var,3);
                m_A(k)=values(var,5)/1000;
                d_A_A(k)=values(var,2);
                d_1_A(k)=values(var,8);
                ID_A{1,k}=num2str(values(var,9));
                f0_A(k)=values(var,6);
                C0r_A(k)=values(var,7);
                C_stat_A(k)=values(var,7);
                C_dyn_A(k)=values(var,4);
            end
            %e definieren
            %zunächst muss das Verhlätnis f0*Fax/C0r bebildet werden
            val=f0_A(k)*F_axA/C0r_A(k);
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
            

            %______________________________________________________________
            %dynamischer Nachweis:
            %dynamische äquivalente Belastung berechnen
            P_next_A=(X*F_radA)+(Y*F_axA);

            %Berechnen der erforderlichen dynamische Tragzahl: Wir gehen von
            %2000h Betrieb bei maximalen Moment aus
            %Betreib aus
            if(gear==1)
                lifetime=600;
            else
                lifetime=800;
            end
            L_10=lifetime*60*n_eck(k)/(10^6);
            C_dyn_erf_A=(L_10^(1/3))*P_next_A;
            

            %Lager B:
            %Bestimmung des Radialfaktors X und Axialfaktors Y nach Tabelle 47 (ME FS)
            %Auswahl eines passenden Lagers anand des Wellenduchmessers
            %Tabelle: A:Innendurchmesser B:Außendurchmesser C:Lagerbreite D: dyn.
            %Tragzahl E:Neigungswinkel der Kegel
            %Lager nur neu auslesen, falls es nicht beibehalten werden soll
            if (Lager_B_beibehalten==0)
                for i=1:1:m
                    if(values(i,1)>= d_sh_1 && values(i,4)>=C_dyn_erf_B && values(i,7)>=C_stat_erf_B)
                        var=i;
                        break;
                    end
                end
                %Abspeichern der Lagerbreite und des Wellendurchmessers
                d_sh_B(k)=values(var,1);
                b_B(k)=values(var,3);
                m_B(k)=values(var,5)/1000;
                d_A_B(k)=values(var,2);
                d_1_B(k)=values(var,8);
                ID_B{1,k}=num2str(values(var,9));
                f0_B(k)=values(var,6);
                C0r_B(k)=values(var,7);
                C_stat_B(k)=values(var,7);
                C_dyn_B(k)=values(var,4);
            end
            %e muss bestimmt werden
            %zunächst muss das Verhlätnis f0*Fax/C0r bebildet werden
            val=f0_B(k)*F_axB/C0r_B(k);
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

            %______________________________________________________________
            %Dynamischer Festigkeitsnachweis
            %dynamische äquivalente Belastung berechnen:
            P_next_B=(X*F_radB)+(Y*F_axB);

            %Berechnen der erforderlichen dynamische Tragzahl: Wir gehen von 2000h
            %Betrieb aus bei maximalen Moment
            if(gear==1)
                lifetime=600;
            else
                lifetime=800;
            end
            L_10=lifetime*60*n_eck(k)/(10^6);
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
            [d_inn_1,d_sh_rel,int,Fehlerbit(k),Fehlercode(1,k)] = calc_d_sh(T_max(k),d_sh_A(k),d_sh_B(k),Fehlerbit(k),Fehlercode(1,k));
            
            if(C_dyn_A(k)>C_dyn_erf_A && C_dyn_B(k)>C_dyn_erf_B && int==1 && C_stat_A(k)>C_stat_erf_A && C_stat_B(k)>C_stat_erf_B)
                d_inn_1(k)=d_inn_1;
                Lager_A_beibehalten=1;
                Lager_B_beibehalten=1;
                
                break;
            else
                if(int==0)
                    d_sh_1(k)=d_sh_rel+5;
                end
                if(C_dyn_A(k)<C_dyn_erf_A || C_stat_A(k)<C_stat_erf_A)
                    Lager_A_beibehalten=0;
                    Lager_A_angepasst=1;
                end
                if(C_dyn_B(k)<C_dyn_erf_B || C_stat_B(k)<C_stat_erf_B)
                    Lager_B_beibehalten=0;
                    Lager_B_angepasst=1;
                end
            end
             
            
        end
        %In der äußeren Schleife müssen noch Lagerabstand angepasst werden
        %Es müssen hier endgültige Werte für l,s,m, d_sh festgelegt werden
        %Es ist noch festzulegendes Spaltmaß zu addieren
        l_1_r=(b_A(k)/2)+(b_B(k)/2)+b_1_1(k)+b_park+(4*spalt)+b_3(k)+b_1_2(k)+wunschbauraum(k);
        s_1_r1=(l_1_r(k)/2)-((b_A(k)/2)+b_park+spalt+(b_1_1(k)/2));
        s_1_r2=(l_1_r(k)/2)-((b_B(k)/2)+spalt+(b_1_2(k)/2));

        %Abfrage ob der Lagerabstand passt
        if(gear==1)
            if(l_1_r==l_1(k) && s_1_r1==s_1_1(k))
                s_1_1(k)=s_1_r1;
                l_1(k)=l_1_r;
                break;
            else
                l_1(k)=l_1_r;
                s_1_1(k)=s_1_r1;
            end
        elseif(gear==2)
          if(l_1_r==l_1(k)&& s_1_r2==s_1_2(k))
                s_1_2(k)=s_1_r2;
                l_1(k)=l_1_r;
                break;
            else
                l_1(k)=l_1_r;
                s_1_2(k)=s_1_r2;
          end
        end


    end

end



end

