function [ d_1,d_a1, d_f1, d_b1, z_1,d_2,d_a2, d_f2, d_b2, z_2 ,i_12, alpha_t,beta,Fehlerbit,Fehlercode] = calculate_wheel_data_vec(d_1,i_12,m_n,beta,Fehlerbit,Fehlercode)
%Bestimmung der erforderlichen Zahnradrößen
i=length(i_12);
%Definition des Kopfspiels
c=0.25*m_n;
%Definition des Normaleingriffwinkels
alpha_n=20*pi/180;
%Eingriffswinkel im Strinschnitt
alpha_t=atan(tan(alpha_n)/cos(beta));

%Zähnezahl bestimmen und auf ganze Zahl runden
z_1=d_1*cos(beta)/m_n;
z_1=round(z_1);
d_2=i_12.*d_1;
z_2=d_2*cos(beta)/m_n;
%minimale Zähnezahl für Ritzel festlegen
for k=1:i
    if(z_1(k)<17)
       z_1(k)=17;
    end
    if(z_2(k)> 130)
        if(Fehlerbit(1,k)==0)
            Fehlercode(1,k)={'Warnung: Eine Zähnezahl von über 130 wird in diesem Getriebe verwendet.'};
        end
    end
    if(z_2(k)>145)
        Fehlerbit(1,k)=1;
        Fehlercode(1,k)={'Die Zähnezahl eines Rades ist größer 145. Aus Geräuschentwicklungsgründen wird dieses Getriebe nicht verwendet.'};
    end
end
d_1=z_1.*m_n/cos(beta);
d_2=i_12.*d_1;
z_2=d_2*cos(beta)/m_n;
z_2=round(z_2);



% Zähezahl so festlegen, dass Übersetzung nahe an der gefoderten liegt
i_12_1=z_2./z_1;
i_12_2=(z_2+1)./z_1;
i_12_3=z_2./(z_1+1);
err_1=abs(i_12-i_12_1);
err_2=abs(i_12-i_12_2);
err_3=abs(i_12-i_12_3);
a_err=[err_1; err_2; err_3];
[m,n]=size(a_err);
for i=1:n
    
    opt=min(a_err(:,i));
    if(opt==err_1(i))
        i_12(i)=i_12_1(i);
        
    elseif(opt==err_2(i))
        i_12(i)=i_12_2(i);
        z_2(i)=z_2(i)+1;
    else
        i_12(i)=i_12_3(i);
        z_1(i)=z_1(i)+1;
    end
end



%neuen Teilkreisdurchmesser aus Zänezahl und Modul
d_1=z_1*m_n/cos(beta);
d_2=z_2*m_n/cos(beta);
%Kopfkreisdurchmesser
d_a1=d_1+(2*m_n);
d_a2=d_2+(2*m_n);
%Fußkreisdurchmesser
d_f1=d_1-(2*(m_n+c));
d_f2=d_2-(2*(m_n+c));
%Grundkreisdurchmesser
d_b1=d_1*cos(alpha_t);
d_b2=d_2*cos(alpha_t);



end

