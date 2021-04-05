function [m_ges,d_stange,abstand_A,roh_inn,d_geh,variante,gamma_1,gamma_2,gamma_3,gamma_1_B,gamma_2_B,d_1_g,d_2_g,d_4_g,gamma_3_B,...
    m_z1,m_z23,m_z4,m_korb,m_diff_stange,m_kegelraeder,m_geh,m_w1,m_w2,m_w4, m_Lagersitz] = ...    
    set_mass(m_A,m_B,m_C,m_D,m_E,m_F,d_1,d_2,d_3,d_4,b_1,b_3,spalt,d_kegel,b_kegel,d_sh_A,d_sh_B,d_sh_C,d_sh_D,d_sh_E,d_sh_F,d_sh_4,alpha,zeta,...
    b_korb,b_A,b_B,b_C,b_D,b_E,b_F,d_A_A,d_A_B,d_A_C,d_A_D,d_A_E,d_A_F,wert,fspalt,d_inn_1,d_inn_2,d_f2,d_f4,m_n,d_1_C,d_1_D,d_1_F,d_korb,t_ges,...
    Optimierung,roh_inn,differential,torque_vectoring,torque_splitter,m_torque,m_eTV,l_torque,t_links_rel,t_1_links,t_2_links,t_3_links,t_rechts_rel,t_1_rechts,t_2_rechts,t_3_rechts)
%% Programmbeginn
%Berechnet die Masse des Getriebes
%Gehäusematerial: AlSi9Cu3
roh_geh=2.75/1000000; %kg/mm^3
%Gehäusestärke
d_geh=5;
%Durchmesser der Stange um Differential:
d_stange=18;
%Abstand der Lager zum Gehäuse berechnen
abstand_B=(b_F+b_3)-(spalt+b_B);
abstand_C=(b_E+b_korb)-(b_C+spalt+b_1);
abstand_D=b_F-b_D;

n=length(m_A);

%% Innere Masse: Wellen,Lager,Zahnräder
%erste Welle:______________________________________________________________
V_rad_1=((((d_1./2).^2)-((d_inn_1./2).^2))*pi).*b_1;

%Abstand zur Gehäusewand:
abstand_A=(b_E+b_korb+b_3)-(b_A+spalt+b_1+b_3);
if(differential==1)
    V_welle_1=((spalt+b_A+(abstand_C-abstand_A)+d_geh).*(((d_sh_A./2).^2)-((d_inn_1./2).^2))*pi)+((b_B+spalt).*(((d_sh_B./2).^2)-((d_inn_1./2).^2))*pi);
elseif(torque_splitter==1)
    V_welle_1=((t_1_links-b_1+d_geh).*(((d_sh_A./2).^2)-((d_inn_1./2).^2))*pi)+((b_B+spalt).*(((d_sh_B./2).^2)-((d_inn_1./2).^2))*pi);
else
    V_welle_1=((t_1_links-b_1+d_geh).*(((d_sh_A./2).^2)-((d_inn_1./2).^2))*pi)+((b_B+spalt).*(((d_sh_B./2).^2)-((d_inn_1./2).^2))*pi);
end

m_z1=V_rad_1.*roh_inn;
m_w1=V_welle_1.*roh_inn;
m_1= m_z1+m_w1+m_A+m_B;

%zweite Welle:_____________________________________________________________
V_rad_23=zeros(1,n);
for k=1:n
    if(((d_f2(k)-(6*m_n))-(d_1_C(k)))>40)
        V_rad_23(k)=(((((d_2(k)/2)^2)-((d_inn_2(k)/2)^2))*pi).*b_1(k))+(((((d_3(k)/2)^2)-((d_inn_2(k)/2)^2))*pi).*b_3(k))-((b_1(k)*0.3)*pi*((((d_f2(k)-(6*m_n))/2)^2)-(((d_1_C(k))/2)^2)))-((b_1(k)*0.3)*pi*((((d_f2(k)-(6*m_n))/2)^2)-(((d_1_D(k))/2)^2)));
    else
        
        V_rad_23(k)=(((((d_2(k)/2)^2)-((d_inn_2(k)/2)^2))*pi).*b_1(k))+(((((d_3(k)/2)^2)-((d_inn_2(k)/2)^2))*pi).*b_3(k));
    end
end
V_welle_2=((b_C+spalt).*(((d_sh_C./2).^2)-((d_inn_2./2).^2))*pi)+((spalt+b_D).*(((d_sh_D./2).^2)-((d_inn_2./2).^2))*pi);


m_z23=V_rad_23.*roh_inn;
m_w2=V_welle_2.*roh_inn;
m_2=m_z23+m_w2+m_C+m_D;

%Differentialwelle:________________________________________________________
V_rad_4=zeros(1,n);
for k=1:n
    if((d_f4(k)-(6*m_n))-(d_kegel(k)+20)>40)
        V_rad_4(k)=((((d_4(k)/2)^2)*pi)*b_3(k))-((((d_sh_4(k)/2)^2)*pi).*b_3(k))-((b_3(k)*0.3)*pi*((((d_f4(k)-(6*m_n))/2)^2)-(((d_kegel(k)+20)/2)^2)))-((b_3(k)*0.3)*pi*((((d_f4(k)-(6*m_n))/2)^2)-(((d_1_F(k))/2)^2)));
    else
        V_rad_4(k)=((((d_4(k)/2)^2)*pi)*b_3(k))-((((d_sh_4(k)/2)^2)*pi)*b_3(k));
    end
end

m_z4=V_rad_4.*roh_inn; % Masse Differentialrad

if(differential==1)
    V_stange=(((d_stange/2)^2)*pi)*(20+d_kegel-(2*b_kegel));
    r=0.5*d_kegel-(b_kegel.*tan(45*pi/180));
    R=0.5*d_kegel;
    V_kegelrad=((b_kegel*pi)./3).*((R.^2)+(R.*r)+(r.^2));
    V_korb=(((d_korb).^2)*10)-((((d_sh_4./2).^2).*pi).*10)+(((2*(d_korb)*10)+(2*(d_korb-20)*10)).*d_kegel)-((2*pi*10*((d_stange/2)^2)));
    V_abtrieb=(((0.5*d_sh_4).^2).*pi).*(d_geh+b_E+10+b_3+spalt+b_F+d_geh);
    V_Lagersitz=(((((d_sh_E./2).^2)-((d_sh_4./2).^2))*pi).*b_E)+(((((d_sh_F./2).^2)-((d_sh_4./2).^2))*pi).*b_F);

    m_w4=V_abtrieb.*roh_inn;                %Masse Abtriebswelle
    m_korb=V_korb.*roh_inn;                 %Masse Differentialkorp
    m_Lagersitz=V_Lagersitz.*roh_inn;       %Masse Lagersitz
    m_diff_stange=V_stange.*roh_inn;        %Masse Planetenachse (Stange)
    m_kegelraeder=(4*V_kegelrad).*roh_inn;  %Masse der Kegelräder
    m_torque=0;                             %Masse der Torque-Vectoring-Einheit
    m_eTV = 0; 
    
elseif(torque_splitter==1)
    V_Lagersitz=(((((d_sh_E./2).^2)-((d_sh_4./2).^2))*pi).*b_E)+(((((d_sh_F./2).^2)-((d_sh_4./2).^2))*pi).*b_F);
    m_w4=t_ges.*(((0.5*d_sh_4).^2).*pi)*roh_inn;
    m_korb=0;
    m_Lagersitz=V_Lagersitz.*roh_inn;
    m_diff_stange=0;
    m_kegelraeder=0;
    m_eTV = 0;
elseif(torque_vectoring==1)
    V_Lagersitz=(((((d_sh_E./2).^2)-((d_sh_4./2).^2))*pi).*b_E)+(((((d_sh_F./2).^2)-((d_sh_4./2).^2))*pi).*b_F);
    m_z4 = 0;%t_ges.*(((0.5*d_sh_4).^2).*pi)*roh_inn;
    m_w4=t_ges.*(((0.5*d_sh_4).^2).*pi)*roh_inn;
    m_korb=0;
    m_Lagersitz=V_Lagersitz.*roh_inn;
    m_diff_stange=0;
    m_kegelraeder=0;
else
    V_Lagersitz=(((((d_sh_E./2).^2)-((d_sh_4./2).^2))*pi).*b_E)+(((((d_sh_F./2).^2)-((d_sh_4./2).^2))*pi).*b_F);
    m_w4=(t_links_rel+b_3+spalt+b_F).*(((0.5*d_sh_4).^2).*pi)*roh_inn;
    m_korb=0;
    m_Lagersitz=V_Lagersitz.*roh_inn;    
    m_diff_stange=0;
    m_kegelraeder=0;
    m_torque=0;
    m_eTV = 0;

end

m_3=m_z4+m_w4+m_korb+m_Lagersitz+(2*m_torque)+m_eTV+m_diff_stange+m_kegelraeder+m_E+m_F;


%% Gehäuseberechnung:________________________________________________________
%Fläche berechnen:
d_1_g=zeros(1,n);
d_2_g=zeros(1,n);
d_4_g=zeros(1,n);
A_1=zeros(1,n);D_1=zeros(1,n);
A_2=zeros(1,n);D_2=zeros(1,n);
A_3=zeros(1,n);D_3=zeros(1,n);
A_4=zeros(1,n);
A_5=zeros(1,n);D_5=zeros(1,n);
A_6=zeros(1,n);D_6=zeros(1,n);
A_7=zeros(1,n);D_7=zeros(1,n);
A_ges=zeros(1,n);D_ges=zeros(1,n);
A_1_B=zeros(1,n);D_1_B=zeros(1,n);
A_2_B=zeros(1,n);D_2_B=zeros(1,n);
A_3_B=zeros(1,n);D_3_B=zeros(1,n);
gamma_1=zeros(1,n);
gamma_2=zeros(1,n);
gamma_3=zeros(1,n);
gamma_1_B=zeros(1,n);
gamma_2_B=zeros(1,n);
gamma_3_B=zeros(1,n);
variante=zeros(1,n);
for k=1:n
    if(wert(k)==d_1(k))
        d_1_g(k)=d_1(k)+(2*fspalt);
    else
        d_1_g(k)=wert(k)+20;
    end
    d_2_g(k)=d_2(k)+(2*fspalt);
    a_1=(d_1(k)+d_2(k))/2;
    a_2=(d_3(k)+d_4(k))/2;
    a_3=(a_1*cos(alpha(k)))+(a_2*cos(zeta(k)));
    d_4_g(k)=d_4(k)+(2*fspalt);
    s_3=(0.5*d_1_g(k))*sqrt((a_3^2)-(((d_4_g(k)/2)-(d_1_g(k)/2))^2))/((d_4_g(k)/2)-(d_1_g(k)/2));
    gamma_3(k)=atan((d_1_g(k)/2)/s_3);
    %Für Entscheidung der Gehäuseform notwendig
    val=(a_1*sin(alpha(k)))+((s_3+(a_1*cos(alpha(k))))*tan(gamma_3(k)))-(d_2_g(k)/2);
    if(val>0 &&(strcmp(Optimierung(1,k),'Höhe')==0) && alpha(k)>0)
        variante(k)=1;
        %Fläche 1:

        s_1=(0.5*d_1_g(k))*sqrt((a_1^2)-(((d_2_g(k)/2)-(d_1_g(k)/2))^2))/((d_2_g(k)/2)-(d_1_g(k)/2));
        x_1=sqrt((a_1^2)-(((d_2_g(k)/2)-(d_1_g(k)/2))^2));
        gamma_1(k)=atan((d_1_g(k)/2)/s_1);
        A_1_1=((pi+gamma_1(k))/(2*pi))*pi*((d_2_g(k)/2)^2);
        A_1_2=((pi-gamma_1(k))/(2*pi))*pi*((d_1_g(k)/2)^2);
        A_1_3=0.5*x_1*((d_1_g(k)/2)+(d_2_g(k)/2));
        A_1(k)=A_1_1+A_1_2+A_1_3;
        D_1_1=((pi+gamma_1(k))/(2*pi))*pi*((((0.5*d_2_g(k))+d_geh)^2)-((d_2_g(k)/2)^2));
        D_1_2=((pi-gamma_1(k))/(2*pi))*pi*((((0.5*d_1_g(k))+d_geh)^2)-((d_1_g(k)/2)^2));
        D_1_3=x_1*d_geh;
        D_1(k)=D_1_1+D_1_2+D_1_3;
        
        %Fläche 2:

        if(d_2_g(k)<d_4_g(k))
            s_2=(0.5*d_2_g(k))*sqrt((a_2^2)-(((d_4_g(k)/2)-(d_2_g(k)/2))^2))/((d_4_g(k)/2)-(d_2_g(k)/2));
            x_2=sqrt((a_2^2)-(((d_4_g(k)/2)-(d_2_g(k)/2))^2));
            gamma_2(k)=atan((d_2_g(k)/2)/s_2);
            A_2_1=((pi-gamma_2(k))/(2*pi))*pi*((d_2_g(k)/2)^2);
            A_2_2=((pi+gamma_2(k))/(2*pi))*pi*((d_4_g(k)/2)^2);
            A_2_3=0.5*x_2*((d_2_g(k)/2)+(d_4_g(k)/2));
            D_2_1=((pi-gamma_2(k))/(2*pi))*pi*((((0.5*d_2_g(k))+d_geh)^2)-((d_2_g(k)/2)^2));
            D_2_2=((pi+gamma_2(k))/(2*pi))*pi*((((0.5*d_4_g(k))+d_geh)^2)-((d_4_g(k)/2)^2));
            D_2_3=x_2*d_geh;
            D_2(k)=D_2_1+D_2_2+D_2_3;
        else
            s_2=(0.5*d_4_g(k))*sqrt((a_2^2)-(((d_2_g(k)/2)-(d_4_g(k)/2))^2))/((d_2_g(k)/2)-(d_4_g(k)/2));
            x_2=sqrt((a_2^2)-(((d_2_g(k)/2)-(d_4_g(k)/2))^2));
            gamma_2(k)=atan((d_4_g(k)/2)/s_2);
            A_2_1=((pi-gamma_2(k))/(2*pi))*pi*((d_4_g(k)/2)^2);
            A_2_2=((pi+gamma_2(k))/(2*pi))*pi*((d_2_g(k)/2)^2);
            A_2_3=0.5*x_2*((d_2_g(k)/2)+(d_4_g(k)/2));
            D_2_1=((pi-gamma_2(k))/(2*pi))*pi*((((0.5*d_4_g(k))+d_geh)^2)-((d_4_g(k)/2)^2));
            D_2_2=((pi+gamma_2(k))/(2*pi))*pi*((((0.5*d_2_g(k))+d_geh)^2)-((d_2_g(k)/2)^2));
            D_2_3=x_2*d_geh;
            D_2(k)=D_2_1+D_2_2+D_2_3;
        end
        A_2(k)=A_2_1+A_2_3+A_2_2;
        
        %Fläche 3:
        
        s_3=(0.5*d_1_g(k))*sqrt((a_3^2)-(((d_4_g(k)/2)-(d_1_g(k)/2))^2))/((d_4_g(k)/2)-(d_1_g(k)/2));
        x_3=sqrt((a_3^2)-(((d_4_g(k)/2)-(d_1_g(k)/2))^2));
        gamma_3(k)=atan((d_1_g(k)/2)/s_3);
        A_3_1=((pi+gamma_3(k))/(2*pi))*pi*((d_4_g(k)/2)^2);
        A_3_2=((pi-gamma_3(k))/(2*pi))*pi*((d_1_g(k)/2)^2);
        A_3_3=0.5*x_3*((d_1_g(k)/2)+(d_4_g(k)/2));
        A_3(k)=A_3_1+A_3_2+A_3_3;
        D_3_1=((pi+gamma_2(k))/(2*pi))*pi*((((0.5*d_4_g(k))+d_geh)^2)-((d_4_g(k)/2)^2));
        D_3_2=((pi-gamma_2(k))/(2*pi))*pi*((((0.5*d_1_g(k))+d_geh)^2)-((d_1_g(k)/2)^2));
        D_3_3=x_3*d_geh;
        D_3(k)=D_3_1+D_3_2+D_3_3;
        
        %Fläche 4:
        c=(a_1+a_2+a_3)/2;
        %Satz von Heron
        A_4(k)=sqrt(c*(c-a_1)*(c-a_2)*(c-a_3));
        
        %Doppelte Flächen entfernen
        A_5(k)=((((pi/2)-alpha(k))+((pi/2)+zeta(k)))/(2*pi))*pi*((d_2_g(k)/2)^2);
        A_6(k)=(alpha(k)/(2*pi))*pi*((d_1_g(k)/2)^2);
        A_7(k)=(zeta(k)/(2*pi))*pi*((d_4_g(k)/2)^2);
        D_5(k)=((((pi/2)-alpha(k))+((pi/2)+zeta(k)))/(2*pi))*pi*((((0.5*d_2_g(k))+d_geh)^2)-((d_2_g(k)/2)^2));
        D_6(k)=(alpha(k)/(2*pi))*pi*((((0.5*d_1_g(k))+d_geh)^2)-((d_1_g(k)/2)^2));
        D_7(k)=(zeta(k)/(2*pi))*pi*((((0.5*d_4_g(k))+d_geh)^2)-((d_4_g(k)/2)^2));
        
        A_ges(k)=A_1(k)+A_2(k)+A_3(k)+A_4(k)-A_5(k)-A_6(k)-A_7(k);
        D_ges(k)=D_1(k)+D_2(k)+D_3(k)-D_5(k)-D_6(k)-D_7(k);
        
    else
        variante(k)=0;
        %Fläche 1
        d_4_g(k)=d_4(k)+(2*fspalt);
        a_1=(d_1(k)+d_2(k))/2;
        x_1=sqrt((a_1^2)-(((d_2_g(k)/2)-(d_1_g(k)/2))^2));
        s_1=(0.5*d_1_g(k))*sqrt((a_1^2)-(((d_2_g(k)/2)-(d_1_g(k)/2))^2))/((d_2_g(k)/2)-(d_1_g(k)/2));
        gamma_1_B(k)=atan((d_1_g(k)/2)/s_1);
        A_1_1=((pi+gamma_1_B(k))/(2*pi))*pi*((d_2_g(k)/2)^2);
        A_1_2=((pi-gamma_1_B(k))/(2*pi))*pi*((d_1_g(k)/2)^2);
        A_1_3=0.5*x_1*((d_1_g(k)/2)+(d_2_g(k)/2));
        A_1_B(k)=A_1_1+A_1_2+A_1_3;
        D_1_1=((pi+gamma_1_B(k))/(2*pi))*pi*((((0.5*d_2_g(k))+d_geh)^2)-((d_2_g(k)/2)^2));
        D_1_2=((pi-gamma_1_B(k))/(2*pi))*pi*((((0.5*d_1_g(k))+d_geh)^2)-((d_1_g(k)/2)^2));
        D_1_3=x_1*d_geh;
        D_1_B(k)=D_1_1+D_1_2+D_1_3;
        %Fläche 2
        a_2=(d_3(k)+d_4(k))/2;
        if(d_2_g(k)<d_4_g(k))
            x_2=sqrt((a_2^2)-(((d_4_g(k)/2)-(d_2_g(k)/2))^2));
            s_2=(0.5*d_2_g(k))*sqrt((a_2^2)-(((d_4_g(k)/2)-(d_2_g(k)/2))^2))/((d_4_g(k)/2)-(d_2_g(k)/2));
            gamma_2_B(k)=atan((d_2_g(k)/2)/s_2);
            A_2_1=((pi+gamma_2_B(k))/(2*pi))*pi*((d_4_g(k)/2)^2);
            A_2_2=((pi-gamma_2_B(k))/(2*pi))*pi*((d_2_g(k)/2)^2);
            A_2_3=0.5*x_2*((d_2_g(k)/2)+(d_4_g(k)/2));
            A_2_B(k)=A_2_1+A_2_2+A_2_3;
            D_2_1=((pi+gamma_2_B(k))/(2*pi))*pi*((((0.5*d_4_g(k))+d_geh)^2)-((d_4_g(k)/2)^2));
            D_2_2=((pi-gamma_2_B(k))/(2*pi))*pi*((((0.5*d_2_g(k))+d_geh)^2)-((d_2_g(k)/2)^2));
            D_2_3=x_2*d_geh;
            D_2_B(k)=D_2_1+D_2_2+D_2_3;
        else
            x_2=sqrt((a_2^2)-(((d_2_g(k)/2)-(d_4_g(k)/2))^2));
            s_2=(0.5*d_4_g(k))*sqrt((a_2^2)-(((d_2_g(k)/2)-(d_4_g(k)/2))^2))/((d_2_g(k)/2)-(d_4_g(k)/2));
            gamma_2_B(k)=atan((d_4_g(k)/2)/s_2);
            A_2_1=((pi+gamma_2_B(k))/(2*pi))*pi*((d_2_g(k)/2)^2);
            A_2_2=((pi-gamma_2_B(k))/(2*pi))*pi*((d_4_g(k)/2)^2);
            A_2_3=0.5*x_2*((d_2_g(k)/2)+(d_4_g(k)/2));
            A_2_B(k)=A_2_1+A_2_2+A_2_3;
            D_2_1=((pi+gamma_2_B(k))/(2*pi))*pi*((((0.5*d_2_g(k))+d_geh)^2)-((d_2_g(k)/2)^2));
            D_2_2=((pi-gamma_2_B(k))/(2*pi))*pi*((((0.5*d_4_g(k))+d_geh)^2)-((d_4_g(k)/2)^2));
            D_2_3=x_2*d_geh;
            D_2_B(k)=D_2_1+D_2_2+D_2_3;
        end
        

        %Fläche, die abgezogen werden muss
        A_3_B(k)=pi*((d_2_g(k)/2)^2);
        D_3_B(k)=pi*((((0.5*d_2_g(k))+d_geh)^2)-((d_2_g(k)/2)^2));
        
        A_ges(k)=(2*A_1_B(k))+(2*A_2_B(k))-A_3_B(k);
        D_ges(k)=(2*D_1_B(k))+(2*D_2_B(k))-D_3_B(k);
        
        if(gamma_2_B(k)>gamma_1_B(k))
            a_3=a_1+a_2;
            x_3=sqrt((a_3^2)-(((d_4_g(k)/2)-(d_1_g(k)/2))^2));
            s_3=(0.5*d_1_g(k))*sqrt((a_2^2)-(((d_4_g(k)/2)-(d_1_g(k)/2))^2))/((d_4_g(k)/2)-(d_1_g(k)/2));
            gamma_3_B(k)=atan((d_1_g(k)/2)/s_3);
            A_3_1=((pi+gamma_3_B(k))/(2*pi))*pi*((d_4_g(k)/2)^2);
            A_3_2=((pi-gamma_3_B(k))/(2*pi))*pi*((d_1_g(k)/2)^2);
            A_3_3=0.5*x_3*((d_1_g(k)/2)+(d_4_g(k)/2));
            A_3_B(k)=A_3_1+A_3_2+A_3_3;
            A_ges(k)=2*A_3_B(k);
            D_3_1=((pi+gamma_3_B(k))/(2*pi))*pi*((((0.5*d_4_g(k))+d_geh)^2)-((d_4_g(k)/2)^2));
            D_3_2=((pi-gamma_3_B(k))/(2*pi))*pi*((((0.5*d_1_g(k))+d_geh)^2)-((d_1_g(k)/2)^2));
            D_3_3=x_3*d_geh;
            D_3_B(k)=D_3_1+D_3_2+D_3_3;
            D_ges(k)=2*D_3_B(k);
            
        end
        
    end
    
    
    
    
end

%Deckel
V_deckel=A_ges*d_geh;
m_deckel=V_deckel*roh_geh;

%Boden
m_boden=V_deckel*roh_geh;

%Seitenwände:
%Auf einer Seite einheitliche Ebene, auf Motorseite zwei Ebenen falls
%Differential
if(differential==1)
    V_wand_1=(D_ges.*(t_ges-abstand_C));

    V_wand_2=pi*(d_4_g.*abstand_C);
    V_wand=V_wand_1+V_wand_2;
    m_wand=V_wand*roh_geh;
elseif(torque_splitter==1)
    %Bei Torque-Vectoring einheitlichen Gehäuseebene links und rechts:
    m_wand=(D_ges.*t_ges)*roh_geh;
else
    %achsnahe Getriebe verwenden auch einheitlich Gehäuseebene:
    m_wand=(D_ges.*t_ges)*roh_geh;
end

%Lagereinschalungen:
%Die Lager werden in einem Rohr mit einer Wandstärke von 5mm
%eingefasst.Das Rohr ist bis zur Gehäusewand hohl.

%Bei Differential:
if(differential==1)
    %Lager A
    V_LA=(((abstand_C-abstand_A)+b_A)*pi).*((((d_A_A+10)*0.5).^2)-((d_A_A*0.5).^2));
    %Lager B
    V_LB=((abstand_B+b_B)*pi).*((((d_A_B+10)*0.5).^2)-((d_A_B*0.5).^2));
    %Lager C
    V_LC=((b_C)*pi).*((((d_A_C+10)*0.5).^2)-((d_A_C*0.5).^2));
    %Lager D
    V_LD=((abstand_D+b_D)*pi).*((((d_A_D+10)*0.5).^2)-((d_A_D*0.5).^2));
    %Lager E
    V_LE=((b_E)*pi).*((((d_A_E+10)*0.5).^2)-((d_A_E*0.5).^2));
    %Lager F
    V_LF=((b_F)*pi).*((((d_A_F+10)*0.5).^2)-((d_A_F*0.5).^2));
elseif(torque_splitter==1)
    % Bei Torque-Vectoring Abstände bis zur Gehäusinnenseite neu bestimmen
    if(t_links_rel==t_1_links)
        abstand_A=b_A;
        abstand_C=t_2_links-b_1-spalt;
        abstand_E=t_3_links-(l_torque-(b_3./2));
    elseif(t_links_rel==t_2_links)
        abstand_A=t_1_links-b_1-spalt;
        abstand_C=b_C;
        abstand_E=t_3_links-(l_torque-(b_3./2));
    else
        abstand_A=t_1_links-b_1-spalt;
        abstand_C=t_2_links-b_1-spalt;
        abstand_E=b_E;
    end
    if(t_rechts_rel==t_1_rechts)
        abstand_B=b_B;
        abstand_D=t_2_rechts-b_3-spalt;
        abstand_F=t_3_rechts-(l_torque-(b_3./2))-b_3;
    elseif(t_rechts_rel==t_2_rechts)
        abstand_B=t_1_rechts-b_3-spalt;
        abstand_D=b_D;
        abstand_F=t_3_rechts-(l_torque-(b_3./2))-b_3;
    else
        abstand_B=t_1_rechts-b_3-spalt;
        abstand_D=t_2_rechts-b_3-spalt;
        abstand_F=b_F;
    end
    %Lager A
    V_LA=((abstand_A)*pi).*((((d_A_A+10)*0.5).^2)-((d_A_A*0.5).^2));
    %Lager B
    V_LB=((abstand_B)*pi).*((((d_A_B+10)*0.5).^2)-((d_A_B*0.5).^2));
    %Lager C
    V_LC=((abstand_C)*pi).*((((d_A_C+10)*0.5).^2)-((d_A_C*0.5).^2));
    %Lager D
    V_LD=((abstand_D)*pi).*((((d_A_D+10)*0.5).^2)-((d_A_D*0.5).^2));
    %Lager E
    V_LE=((abstand_E)*pi).*((((d_A_E+10)*0.5).^2)-((d_A_E*0.5).^2));
    %Lager F
    V_LF=((abstand_F)*pi).*((((d_A_F+10)*0.5).^2)-((d_A_F*0.5).^2));
else
   %Lagerhalter für Achsnahe Getriebe 
   if(t_links_rel==t_1_links)
        abstand_A=b_A;
        abstand_C=t_2_links-b_1-spalt;
        abstand_E=t_3_links-spalt;
    elseif(t_links_rel==t_2_links)
        abstand_A=t_1_links-spalt-b_1;
        abstand_C=b_C;
        abstand_E=t_3_links-spalt;
    else
        abstand_A=t_1_links-spalt-b_1;
        abstand_C=t_2_links-b_1-spalt;
        abstand_E=b_E;
    end
    if(t_rechts_rel==t_1_rechts)
        abstand_B=b_B;
        abstand_D=t_2_rechts-b_3-spalt;
        abstand_F=t_3_rechts-b_3-spalt;
    elseif(t_rechts_rel==t_2_rechts)
        abstand_B=t_1_rechts-spalt;
        abstand_D=b_D;
        abstand_F=t_3_rechts-spalt-b_3;
    else
        abstand_B=t_1_rechts-spalt;
        abstand_D=t_2_rechts-b_3-spalt;
        abstand_F=b_F;
    end
    %Lager A
    V_LA=((abstand_A)*pi).*((((d_A_A+10)*0.5).^2)-((d_A_A*0.5).^2));
    %Lager B
    V_LB=((abstand_B)*pi).*((((d_A_B+10)*0.5).^2)-((d_A_B*0.5).^2));
    %Lager C
    V_LC=((abstand_C)*pi).*((((d_A_C+10)*0.5).^2)-((d_A_C*0.5).^2));
    %Lager D
    V_LD=((abstand_D)*pi).*((((d_A_D+10)*0.5).^2)-((d_A_D*0.5).^2));
    %Lager E
    V_LE=((abstand_E)*pi).*((((d_A_E+10)*0.5).^2)-((d_A_E*0.5).^2));
    %Lager F
    V_LF=((abstand_F)*pi).*((((d_A_F+10)*0.5).^2)-((d_A_F*0.5).^2));
   
   
end
  
if(torque_splitter==1)
    m_aktuierung = 2.950 ; %  Für die Aktuierungseinheit(Hydraulik) des Torque Splitters wird zusätzlich eine Masse veranschlagt -> siehe SA Tripps      

else
     m_aktuierung = 0 ;
end
                    
m_lager_halter=(V_LA+V_LB+V_LC+V_LD+V_LE+V_LF)*roh_geh;
m_LA=V_LA*roh_geh;
m_LB=V_LB*roh_geh;
m_LC=V_LC*roh_geh;
m_LD=V_LD*roh_geh;
m_LE=V_LE*roh_geh;
m_LF=V_LF*roh_geh;

m_geh=m_deckel+m_boden+m_wand+m_lager_halter;

%% Gesamtmasse:
m_ges=m_1+m_2+m_3+m_deckel+m_boden+m_wand+m_lager_halter+m_aktuierung;



end

