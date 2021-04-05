function [ l ] = Laenge_EM( typ_EM, M_EM_nenn, n_EM_nenn, Optimierung)

if Optimierung.linux_paths == 1
    load('./../1.1 Preprocessing/01 Antriebsstrang/02_Motor/Laengenkoeffizienten_EM.mat');
else 
    load('./1.1 Preprocessing/01 Antriebsstrang/02_Motor/Laengenkoeffizienten_EM.mat');
end
%disp(Optimierung)
% load('./mat-Files/Regressionen/Laengenkoeffizienten_EM.mat');
if(strcmp('PSM',typ_EM)==1)
    l = p_PSM(1)*M_EM_nenn^(3/6)*n_EM_nenn^(11/6) + p_PSM(2);%[mm]
else
    l = 216;
end
end