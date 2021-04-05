% Dieses Skript dient der Zuordnung der Design-Variablen zum struct
opt = varargin{3};
u = opt.lb;
u(opt.design_nummer)=x;

% Konfiguration
Konfig_VA                   = u(1);
Konfig_HA                   = u(2);
typ_EM_VA                   = u(3);
typ_EM_HA                   = u(4);
config.trans.n_gears_VA     = u(5);
config.trans.n_gears_HA     = u(6);
config.em.Mnenn_achs_VA     = u(7);
config.em.nmax_VA           = u(8);
config.etv.delta_M_max_VA   = u(9);
i_Gang1_VA                  = u(10);
Getriebespreizung_VA        = u(11);
config.em.Mnenn_achs_HA      = u(12);
config.em.nmax_HA           = u(13);
config.etv.delta_M_max_HA   = u(14);
i_Gang1_HA                  = u(15);
Getriebespreizung_HA        = u(16);

%% Ableiten der für die Simulation benötigten Eingangsvariablen
% Achskonfiguration
if(Konfig_VA == 1)      config.akt.rn_VA = 0; config.akt.az_VA = 0; config.akt.OD_VA = 0; config.akt.eTV_VA = 0; config.akt.TS_VA = 0;
elseif(Konfig_VA == 2)  config.akt.rn_VA = 1; config.akt.az_VA = 0; config.akt.OD_VA = 0; config.akt.eTV_VA = 0; config.akt.TS_VA = 0;
elseif(Konfig_VA == 3)  config.akt.rn_VA = 0; config.akt.az_VA = 1; config.akt.OD_VA = 1; config.akt.eTV_VA = 0; config.akt.TS_VA = 0;
elseif(Konfig_VA == 4)  config.akt.rn_VA = 0; config.akt.az_VA = 1; config.akt.OD_VA = 0; config.akt.eTV_VA = 1; config.akt.TS_VA = 0;
elseif(Konfig_VA == 5)  config.akt.rn_VA = 0; config.akt.az_VA = 1; config.akt.OD_VA = 0; config.akt.eTV_VA = 0; config.akt.TS_VA = 1;
end

if(Konfig_HA == 1)      config.akt.rn_HA = 0; config.akt.az_HA = 0; config.akt.OD_HA = 0; config.akt.eTV_HA = 0; config.akt.TS_HA = 0;
elseif(Konfig_HA == 2)  config.akt.rn_HA = 1; config.akt.az_HA = 0; config.akt.OD_HA = 0; config.akt.eTV_HA = 0; config.akt.TS_HA = 0;
elseif(Konfig_HA == 3)  config.akt.rn_HA = 0; config.akt.az_HA = 1; config.akt.OD_HA = 1; config.akt.eTV_HA = 0; config.akt.TS_HA = 0;
elseif(Konfig_HA == 4)  config.akt.rn_HA = 0; config.akt.az_HA = 1; config.akt.OD_HA = 0; config.akt.eTV_HA = 1; config.akt.TS_HA = 0;
elseif(Konfig_HA == 5)  config.akt.rn_HA = 0; config.akt.az_HA = 1; config.akt.OD_HA = 0; config.akt.eTV_HA = 0; config.akt.TS_HA = 1;
end

if isfield(Optimierung,'ML_GA')

    % Diskretisieren
    if typ_EM_VA < 1.5
        typ_EM_VA=1;
    else
        typ_EM_VA=2;
    end
    if typ_EM_HA < 1.5
        typ_EM_HA=1;
    else
        typ_EM_HA=2;
    end

    if config.trans.n_gears_VA < 1.5
        config.trans.n_gears_VA=1;
    else
        config.trans.n_gears_VA=2;
    end
    if config.trans.n_gears_HA < 1.5
        config.trans.n_gears_HA=1;
    else
        config.trans.n_gears_HA=2;
    end
end

% EM Vorderachse
if(typ_EM_VA == 1)              config.em.typ_EM_VA = 'ASM';
elseif(typ_EM_VA == 2)          config.em.typ_EM_VA = 'PSM';
end



% EM Hinterachse
if(typ_EM_HA == 1)              config.em.typ_EM_HA = 'ASM';
elseif(typ_EM_HA == 2)          config.em.typ_EM_HA = 'PSM';
end



% Getriebe Vorderachse
if(config.trans.n_gears_VA == 1)
    config.trans.i_gears_VA = i_Gang1_VA;
elseif(config.trans.n_gears_VA == 2)
    i_Gang2_VA = i_Gang1_VA/Getriebespreizung_VA;
    config.trans.i_gears_VA = [i_Gang1_VA i_Gang2_VA];
elseif(config.trans.n_gears_VA == 3)
    i_Gang3_VA = i_Gang1_VA/Getriebespreizung_VA;
    i_Gang2_VA = sqrt((i_Gang1_VA*i_Gang3_VA)/Progressionsfaktor_VA);
    config.trans.i_gears_VA = [i_Gang1_VA i_Gang2_VA i_Gang3_VA];
end

% Getriebe Hinterachse
if(config.trans.n_gears_HA == 1)
    config.trans.i_gears_HA = i_Gang1_HA;
elseif(config.trans.n_gears_HA == 2)
    i_Gang2_HA = i_Gang1_HA/Getriebespreizung_HA;
    config.trans.i_gears_HA = [i_Gang1_HA i_Gang2_HA];
elseif(config.trans.n_gears_HA == 3)
    i_Gang3_HA = i_Gang1_HA/Getriebespreizung_HA;
    i_Gang2_HA = sqrt((i_Gang1_VA*i_Gang3_HA)/Progressionsfaktor_HA);
    config.trans.i_gears_HA = [i_Gang1_HA i_Gang2_HA i_Gang3_HA];
end

assignin('base','config',config);