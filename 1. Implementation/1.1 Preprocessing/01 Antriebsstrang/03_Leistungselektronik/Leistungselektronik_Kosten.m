function [Kosten_LE] = Leistungselektronik_Kosten(n_nenn,M_nenn,Stkzahl)
% calculating costs for inverter

P_nenn=2*pi*n_nenn*M_nenn/60;  % Nennleistung in W (Nenndrehzahl (Geschwindigkeit) in U/min (rpm); Nennmoment des Motors in Nm)
P_nenn_LE=P_nenn/10^3;              %Umwandlung in kW

%% Costmodell from 
% I. Eroglu, “Fertigungstechnische Beurteilung, Kostenmodellierung und 
% Analyse der Topologie elektrischer Antriebsstrangsysteme unter 
% Berücksichtigung fahrdynamischer Eigenschaften,” Masterarbeit, 
% Lehrstuhl für Fahrzeugtechnik, Technische Universität München, 
% München, 2017.
% S. 82
% 
% Data come from:
% G. Domingues-Olavarria, P. Fyhr, A. Reinap, M. Andersson, und M. Alakula,
% “From Chip to Converter: A Complete Cost Model for Power Electronics 
% Converters,” IEEE Trans. Power Electron, Bd. 32, Rn. 11, S. 8681–8692, 
% 2017. DOI: 10.1109/TPEL.2017.2651407.

%%

if Stkzahl<=5000
    Kosten_LE=800+8*P_nenn_LE;
elseif Stkzahl>5000 && Stkzahl<=20000
    Kosten_LE=400+7.5*P_nenn_LE;
elseif Stkzahl>20000 && Stkzahl<=100000
    Kosten_LE=145+7.5*P_nenn_LE;
elseif Stkzahl>100000 && Stkzahl<=250000
    Kosten_LE=100+7*P_nenn_LE;
elseif Stkzahl>250000
    Kosten_LE=90+6.5*P_nenn_LE;
end
end

