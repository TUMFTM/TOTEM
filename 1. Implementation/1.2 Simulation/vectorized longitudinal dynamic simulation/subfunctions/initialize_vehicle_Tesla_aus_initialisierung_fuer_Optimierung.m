% Fahrzeug
kein_Antrieb_VA=and((par_MDT.AUS.akt.az_VA==0), (par_MDT.AUS.akt.rn_VA==0));
kein_Antrieb_HA=and((par_MDT.AUS.akt.az_HA==0), (par_MDT.AUS.akt.rn_HA==0));
ist_Antrieb_VA=not(kein_Antrieb_VA);
ist_Antrieb_HA=not(kein_Antrieb_HA);


cw=         par_VEH.cx;
A=          par_VEH.Afront;
rho=        par_VEH.rhoair;
mass=       par_VEH.m; %Quelle Masterarbeit Holtz, par_VEH.m;
m_red=      mass*1.1; %nach SA Mößner
lv=         par_VEH.lF;
lh=         par_VEH.lR;
l=          lv+lh;
z_SP=       par_VEH.zSP_r;
g=          par_VEH.g;

P_auxiliaries=250; %Nebenverbraucherleistung

%Reifen
c_z_reifen= par_TIR(1).VERTICAL_STIFFNESS; %Vertikalsteifigkeit des Reifens
r_rad_0=    par_TIR(1).UNLOADED_RADIUS;         %Fertigungsdurchmesser




% Getriebe
i_Getriebe_VA=      par_MDT.VA.trans.i_gears;
eta_Getriebe_VA=    par_MDT.VA.trans.wkg;

i_Getriebe_HA=      par_MDT.HA.trans.i_gears;
eta_Getriebe_HA=    par_MDT.HA.trans.wkg;

eta_batt=           0.95^2; %Quelle Tschochner
c_RR=               0.008;


% % Motor
% E_VA                = MotorScaling(); %Motorobjekt initialisieren und laden
% M_max_NM_VA         = par_MDT.VA.em.M_max_mot; %Maximalmoment in Nm
% n_max_rpm_VA        = par_MDT.VA.em.nmax;
% n_max_radps_VA      = n_max_rpm_VA/60*2*pi; %Nennmoment in rad/s
% PeakPower_kW_VA     = M_max_NM_VA*n_max_radps_VA/2/1000; %Peakpower
% if kein_Antrieb_VA
%     PeakPower_kW_VA=20000;
%     n_max_radps_VA=100000;
% end
% E_VA                = Scale(E_VA, PeakPower_kW_VA, n_max_radps_VA);
% calc_Consumption(E_VA);
% 
% 
% E_HA                = MotorScaling(); %Motorobjekt initialisieren und laden
% M_max_NM_HA         = par_MDT.HA.em.M_max_mot; %Maximalmoment in Nm
% n_max_rpm_HA        = par_MDT.HA.em.nmax;
% n_max_radps_HA      = n_max_rpm_HA/60*2*pi; %Nennmoment in rad/s
% PeakPower_kW_HA     = M_max_NM_HA*n_max_radps_HA/2/1000; %Peakpower
% if kein_Antrieb_HA
%     PeakPower_kW_HA=20000;
%     n_max_radps_HA=100000;
% end
% E_HA                = Scale(E_HA, PeakPower_kW_HA, n_max_radps_HA);
% calc_Consumption(E_HA);