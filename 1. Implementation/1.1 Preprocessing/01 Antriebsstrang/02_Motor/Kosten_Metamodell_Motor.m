function Kosten_Motor=Kosten_Metamodell_Motor(n_nenn_rpm, M_nenn_Nm, typ_EM)
% calculation the costs of the electric motor

% Metamodel for Motor-Costs is based on the following publication:
% C. Angerer, M. Felgenhauer, I. Eroglu, M. Zähringer, S. Kalt, und 
% M. Lienkamp, “Scalable Dimension-, Weight- and Cost-Modeling for 
% Components of Electric Vehicle Powertrains,” in International 
% Conference on Electrical Machines and Systems, Seoul, Korea, 2018.


P_nenn_kw=n_nenn_rpm/60*2*pi * M_nenn_Nm/1000;

if strcmp(typ_EM, 'PSM')
       a =       382.1;%  (244.3, 519.9)
       b =    -0.06657;%  (-0.08025, -0.0529)
       c =   0.0001982;%  (0.000138, 0.0002583)
       d =       9.355;%  (7.627, 11.08)
       e =    -0.01406;%  (-0.02205, -0.006064)
       f =      -2.292;%  (-8.257, 3.673)


elseif strcmp(typ_EM, 'ASM')
    
       a =         243;%  (190.4, 295.7)
       b =    -0.05144;%  (-0.05899, -0.0439)
       c =   0.0001645;%  (0.000131, 0.000198)
       d =       7.515;%  (6.756, 8.274)
       e =    -0.01249;%  (-0.01608, -0.008907)
       f =        2.75;%  (-0.1803, 5.68)
end

x=P_nenn_kw;

y=n_nenn_rpm/M_nenn_Nm;
spezifische_Kosten = a/(x-f) + b*y + c*y^2+d+e*x+f/y;

Kosten_Motor=spezifische_Kosten*P_nenn_kw;