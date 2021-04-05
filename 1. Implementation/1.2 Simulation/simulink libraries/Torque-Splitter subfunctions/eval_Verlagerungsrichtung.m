function [ ltr, rtl ] = eval_Verlagerungsrichtung( M_WunschRechts, M_WunschLinks, M_ein)
%EVAL_VERLAGERUNGSRICHTUNG Richtung, in die Moment verlagert werden soll
%M_RW, LW: Wunschmomente am linken sowie rechten Rad
%rtl = right-to-left
if M_ein > 0
    if abs(M_WunschRechts) < abs(M_WunschLinks)
        rtl = 1;
        ltr = 0;
    elseif abs(M_WunschRechts) > abs(M_WunschLinks)
        rtl = 0;
        ltr = 1;
    else
        ltr = 0;
        rtl = 0;
    end
elseif M_ein < 0
    if abs(M_WunschRechts) > abs(M_WunschLinks)
        rtl = 1;
        ltr = 0;
    elseif abs(M_WunschRechts) < abs(M_WunschLinks)
        rtl = 0;
        ltr = 1;
    else
        ltr = 0;
        rtl = 0;
    end
else                                                                        %Fall auf-der-Stelle-drehen
    if M_WunschRechts > M_WunschLinks
        rtl = 1;
        ltr = 0;
    elseif M_WunschRechts < M_WunschLinks
        rtl = 0;
        ltr = 1;
    else
        ltr = 0;
        rtl = 0;
    end
end

end






