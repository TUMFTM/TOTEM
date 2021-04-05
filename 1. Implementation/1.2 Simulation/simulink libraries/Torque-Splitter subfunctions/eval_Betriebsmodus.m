function [ mot_ein, mot_Steuer, mot_rechts, mot_links, gen_ein, gen_Steuer, gen_rechts, gen_links ] = eval_Betriebsmodus( M_ein, M_Steuer, M_rechts, M_links, n_ein, n_Steuer, n_rechts, n_links)
%EVAL_BETRIEBSMODUS Evaluiert, ob generatorischer oder motorischer Betrieb
%vorliegt

if sign(M_Steuer*n_Steuer) == -1
    mot_Steuer = 0;
    gen_Steuer = 1;
else
    mot_Steuer = 1;
    gen_Steuer = 0;
end

if sign(M_ein*n_ein) == -1
    mot_ein = 0;
    gen_ein = 1;
else
    mot_ein = 1;
    gen_ein = 0;
end

if sign(M_rechts*n_rechts) == -1
    mot_rechts = 0;
    gen_rechts = 1;
else
    mot_rechts = 1;
    gen_rechts = 0;
end

if sign(M_links*n_links) == -1
    mot_links = 0;
    gen_links = 1;
else
    mot_links = 1;
    gen_links = 0;
end

end

%% ALT
% %nri: Ist-Drehzahl rechtes Rad
% %nli: Ist-Drehzahl linkes Rad
% 
% if ltr == 1
%     if nli>nri
%         mot = 0;
%         gen = 1;
%     elseif nli<nri
%         mot = 1;
%         gen = 0;
%     else
%         mot = 0;
%         gen = 0; 
%     end
% elseif rtl == 1
%     if nli>nri
%         mot = 1;
%         gen = 0;
%     elseif nli<nri
%             mot = 0;
%             gen = 1;
%     else
%         mot = 0;
%         gen = 0;
%     end
% else
%     mot = 0;
%     gen = 0;   
% end
% 
% end

