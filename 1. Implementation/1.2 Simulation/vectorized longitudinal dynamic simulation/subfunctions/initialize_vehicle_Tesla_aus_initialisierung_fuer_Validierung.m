load('codebasierte LD\Parameter model s 85d.mat')
kein_Antrieb_VA=0;
kein_Antrieb_HA=0;

cw=         par_VEH.cx;
A=          par_VEH.Afront;
rho=        par_VEH.rhoair;
mass=       2374; %Quelle Masterarbeit Holtz, par_VEH.m;
m_red=      mass*1.1;
lv=         par_VEH.lF;
lh=         par_VEH.lR;
l=          lv+lh;
z_SP=       par_VEH.zSP_r;
g=          par_VEH.g;

P_auxiliaries=545; %Nebenverbraucherleistung

%Reifen
c_z_reifen= par_TIR(1).VERTICAL_STIFFNESS; %Vertikalsteifigkeit des Reifens
r_rad_0=    par_TIR(1).UNLOADED_RADIUS;         %Fertigungsdurchmesser


par_VEH.r_stat0;

% Getriebe
i_Getriebe_VA=      par_MDT.VA.trans.i_gears;
eta_Getriebe_VA=    par_MDT.VA.trans.wkg;

i_Getriebe_HA=      par_MDT.HA.trans.i_gears;
eta_Getriebe_HA=    par_MDT.HA.trans.wkg; % 0.95 Quelle Tschochner

eta_batt=   0.95; %Quelle Tschochner
c_RR=       0.008;


typ_EM='ASM';

E = MotorScaling_PSMASM(typ_EM); %Motorobjekt initialisieren und laden
M_max_NM=305; %Maximalmoment in Nm
n_max_rpm=18000;
n_max_radps=n_max_rpm/60*2*pi; %Nennmoment in rad/s
PeakPower_kW=M_max_NM*n_max_radps/2/1000; %Peakpower
n_max_radps=n_max_radps*2;
E = Scale(E, PeakPower_kW, n_max_radps);
calc_Consumption(E);
