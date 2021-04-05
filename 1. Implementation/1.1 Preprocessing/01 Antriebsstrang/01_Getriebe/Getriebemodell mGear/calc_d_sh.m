function [d_inn,d_sh_rel,var,Fehlerbit,Fehlercode] = calc_d_sh(T_rel,d_sh_A,d_sh_B,Fehlerbit,Fehlercode)
%Festigkeitsnachweis für die Wellen 
d_inn=0;
    while 1
        d_inn_u=d_inn;
    %minimaler Druchmesser für Festigkeit entschiedend
    d_sh_rel=min(d_sh_A,d_sh_B);
    %Streckgrenze für 16MnCr5
    R_mn=900;
    %Werkstoff-Wechselfestigkeit für Normabmessungen
    tau_wsn=0.58*0.4*R_mn;
    %Wechselfestigekti im Bauteil:
    K_dm=(1-(0.7686*0.5*log10(d_sh_rel/7.5)))/(1-(0.7686*0.5*log10(11/7.5)));
    tau_ws=tau_wsn*K_dm;
    %Es werden eine Kerben betrachetet, es handelt sich um eine wechslende
    %Beanspruchung
    tau_ak=tau_ws;
    
    %Wandstärke der Hohlwellen prüfen
    if(d_sh_rel-d_inn<5)
        if(Fehlerbit==0) %andere Fehler beibehalten, Warnung ausgeben   
            Fehlerbit=0;        
            Fehlercode={'Die Wandstärke der Hohlwelle ist auf minimal 2.5mm festgesetzt. Dies wurde erreicht. Die Festigkeit ist weiterhin gegeben.'};
        end
        var=1;
        break;
    end
    
    %auftretende Spannung:
    wt=pi*((d_sh_rel^4)-(d_inn_u^4))/(16*d_sh_rel); %Hohlwellen
    tau_auft=T_rel*1000/wt;
    
    S_dt=tau_ak/tau_auft;
    
    if(S_dt>2 && S_dt<3.0)
        var=1;
        break;
    elseif (S_dt<=2)
        var=0;
        break;
    else
        d_inn=d_inn+0.25;
    end
    end


end

