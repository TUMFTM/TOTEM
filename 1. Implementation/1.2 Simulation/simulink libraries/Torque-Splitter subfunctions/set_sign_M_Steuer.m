%set_sign_M_Steuer nach Logbuch S.138
function [sign_M_Steuer] = set_sign_M_Steuer(M_ein, M_LW, M_RW, nli, nri, delta_M_krit)

%Unterscheidung Antrieb oder Rekuperation
if M_ein >=0                                %Antriebsfall
    %Unterscheidung Kurvenrichtung
    if nli == nri                           %Geradeausfahrt
        if abs(M_LW)<abs(M_RW)
            sign_M_Steuer = -1;
        elseif abs(M_LW)>abs(M_RW)
            sign_M_Steuer = +1;
        else
            sign_M_Steuer = 0;
        end
    elseif nli > nri                        %Rechtskurve
        if abs(M_LW)<abs(M_RW)              %WV nach rechts (Grenze höher!)
            if abs(M_LW-M_RW)<abs(delta_M_krit)     %unterhalb der Nullstelle
                sign_M_Steuer = +1;
            else                            %oberhalb oder auf der Nullstelle
                sign_M_Steuer = -1;
            end
        elseif abs(M_LW)>abs(M_RW)          %WV nach links (Grenze niedriger!)
            sign_M_Steuer = +1;
        else                                %keine Wunschverlagerung: Gegensteuern nach links notwendig, sonst Selbstverlagerung nach rechts
            sign_M_Steuer = +1;
        end
    else                                    %Linkskurve
        if abs(M_LW)<abs(M_RW)              %WV nach rechts (Grenze niedriger!)
            sign_M_Steuer = -1;
        elseif abs(M_LW)>abs(M_RW)          %WV nach links (Grenze höher!)
            if abs(M_LW-M_RW)<abs(delta_M_krit)     %unterhalb der Nullstelle
                sign_M_Steuer = -1;
            else                            %oberhalb oder auf der Nullstelle
                sign_M_Steuer = +1;
            end
        else                                 %keine Wunschverlagerung: Gegensteuern nach rechts notwendig, sonst Selbstverlagerung nach links
            sign_M_Steuer = -1;
        end
    end
    
else                                        %Generatorfall
    
%Unterscheidung Kurvenrichtung
    if nli == nri                           %Geradeausfahrt: hier alles andersrum
        if abs(M_LW)<abs(M_RW)
            sign_M_Steuer = +1;
        elseif abs(M_LW)>abs(M_RW)
            sign_M_Steuer = -1;
        else
            sign_M_Steuer = 0;
        end
    elseif nli > nri                        %Rechtskurve: hier manches gleich
        if abs(M_LW)<abs(M_RW)              %WV nach rechts (Grenze niedriger!)
                sign_M_Steuer = +1;           
        elseif abs(M_LW)>abs(M_RW)          %WV nach links (Grenze höher!)
            if (M_LW-M_RW)<delta_M_krit     %unterhalb der Nullstelle
                sign_M_Steuer = +1;
            else                            %oberhalb oder auf der Nullstelle
                sign_M_Steuer = -1;
            end
        else                                %keine Wunschverlagerung: Gegensteuern nach links notwendig, sonst Selbstverlagerung nach rechts
            sign_M_Steuer = +1;
        end
    else                                    %Linkskurve: hier manches gleich
        if abs(M_LW)<abs(M_RW)              %WV nach rechts (Grenze höher!)
            if (M_LW-M_RW)<delta_M_krit     %unterhalb der Nullstelle
                sign_M_Steuer = -1;
            else                            %oberhalb oder auf der Nullstelle
                sign_M_Steuer = +1;
            end
        elseif abs(M_LW)>abs(M_RW)          %WV nach links (Grenze niedriger!)
                sign_M_Steuer = -1;           
        else                                 %keine Wunschverlagerung: Gegensteuern nach rechts notwendig, sonst Selbstverlagerung nach links
            sign_M_Steuer = -1;
        end
    end
end

%Kurvenfahrt ohne Verlagerung nicht ausregeln (gängige Praxis)
if M_LW == M_RW
    sign_M_Steuer = 0;
end

end
            

