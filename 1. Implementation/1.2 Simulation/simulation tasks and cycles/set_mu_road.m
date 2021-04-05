function [ par_TIR, mu_road_LF, mu_road_LR, mu_road_RF, mu_road_RR ] = set_mu_road( par_TIR,select_mu )
%% Funktion die die Reibwerte der Fahrbahn und die Scaling-faktoren des Reifenmodells festlegt

switch select_mu 
     case 1
        mu_road_RF = 1.0;
        mu_road_LF = 1.0;
        mu_road_RR = 1.0;
        mu_road_LR = 1.0;
    case 2
        mu_road_RF = 0.2;
        mu_road_LF = 0.2;
        mu_road_RR = 0.2;
        mu_road_LR = 0.2;
    case 3
        mu_road_RF = 1.0;
        mu_road_LF = 0.2;
        mu_road_RR = 1.0;
        mu_road_LR = 0.2;
    case 4
        mu_road_RF = 0.2;
        mu_road_LF = 0.2;
        mu_road_RR = 1.0;
        mu_road_LR = 1.0;
    case 5
        mu_road_RF = 1.0;
        mu_road_LF = 1.0;
        mu_road_RR = 0.2;
        mu_road_LR = 0.2;
    case 6
        mu_road_RF = 0.458;
        mu_road_LF = 0.458;
        mu_road_RR = 0.458;
        mu_road_LR = 0.458;
        
        par_TIR(1).LMUY = 0.573;
        par_TIR(2).LMUY = 0.573;
        par_TIR(1).LKY = 0.69;
        par_TIR(2).LKY = 0.69;
    case 7
        mu_road_RF = 0.392;
        mu_road_LF = 0.392;
        mu_road_RR = 0.392;
        mu_road_LR = 0.392;
        
        par_TIR(1).LMUY= 0.490;
        par_TIR(2).LMUY = 0.490;
        par_TIR(1).LKY(:) = 0.602;
        par_TIR(2).LKY(:) = 0.602;

end

