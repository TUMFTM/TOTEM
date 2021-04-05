function [par_TIR] = read_parameters(import_file, import_path)

%% Import Dimensions from File Name

index = strfind(import_file,'_');

par_TIR.WIDTH = str2double(import_file(1 : index(1) - 1));                  % [mm]
par_TIR.ASPECT_RATIO = str2double(import_file(index(1)+1 : index(2) - 1));  % [%]
par_TIR.RIM = str2double(import_file(index(2)+2 : index(3) - 1));           % [inch]
par_TIR.IP = str2double(import_file(index(3)+2 : index(4) - 1));            % [bar]

% unit conversion
par_TIR.IP = par_TIR.IP * 10;                                               % [kPa]
par_TIR.DIAMETER = par_TIR.WIDTH * par_TIR.ASPECT_RATIO / 50 + par_TIR.RIM * 25.4; % [mm]
par_TIR.VERTICAL_STIFFNESS_CALC = (0.00028 * par_TIR.IP * sqrt((-0.004 * par_TIR.ASPECT_RATIO + 1.03) * par_TIR.WIDTH * par_TIR.DIAMETER) + 3.45) * 9.81; % [N/mm]
par_TIR.WIDTH = par_TIR.WIDTH / 1000;                                       % [m]
par_TIR.ASPECT_RATIO = par_TIR.ASPECT_RATIO / 100;                          % []
par_TIR.DIAMETER = par_TIR.DIAMETER / 1000;                                 % [m]
par_TIR.VERTICAL_STIFFNESS_CALC = par_TIR.VERTICAL_STIFFNESS_CALC * 1000;   % [N/m]

%% Import

fid = fopen([import_path, import_file], 'r');

% Alle relevanten Zeilen auslesen und in Cell Array "content" speichern
content = {};

while ~feof(fid)
    line = fgetl(fid);
    if ~isempty(line)
        if strcmp(line(1), '!') == 0 && strcmp(line(1), '$') == 0 && strcmp(line(1), '[') == 0 && strcmp(line(1), '{') == 0 && strcmp(line(1), '''') == 0
            content = [content; line];
        end
    end
end

fclose(fid);

%% Bearbeitung: Struct erstellen und befuellen

% Alle Leerzeichen aus den einzelnen Zellen entfernen
for i = 1 : length(content)
    content{i} = strrep(content{i}, ' ', '');       % Leerzeichen loeschen
    content{i} = regexprep(content{i}, '\t', '');   % Tabs loeschen
end

% [UNITS]
ANGLE_temp                      = read_parameters_sub(content,'ANGLE',import_file);

switch lower(ANGLE_temp)
    case ('degrees')
        par_TIR.ANGLE = 180 / pi;                   % unit conversion [rad] -> [degree]
    case ('radians')
        par_TIR.ANGLE = 1;
    otherwise
        error('Winkeleinheit konnte nicht bestimmt werden!');
end

% [MODEL]
TYRESIDE_temp                    = read_parameters_sub(content,'TYRESIDE',import_file);

switch lower(TYRESIDE_temp)
    case ('left')
        par_TIR.TYRESIDE = 1;
    case ('right')
        par_TIR.TYRESIDE = -1;
    case ('symmetric')
        par_TIR.TYRESIDE = 0;
    otherwise
        error('Tyreside konnte nicht bestimmt werden!');
end

par_TIR.USE_MODE                 = read_parameters_sub(content,'USE_MODE',import_file);
par_TIR.LONGVL                   = read_parameters_sub(content,'LONGVL',import_file);

% [DIMENSION]
par_TIR.UNLOADED_RADIUS          = read_parameters_sub(content,'UNLOADED_RADIUS',import_file);
% par_TIR.WIDTH                    = read_parameters_sub(content,'WIDTH',import_file);
% par_TIR.ASPECT_RATIO             = read_parameters_sub(content,'ASPECT_RATIO',import_file);
par_TIR.RIM_RADIUS               = read_parameters_sub(content,'RIM_RADIUS',import_file);
par_TIR.RIM_WIDTH                = read_parameters_sub(content,'RIM_WIDTH',import_file);

% [VERTICAL]
par_TIR.VERTICAL_STIFFNESS       = read_parameters_sub(content,'VERTICAL_STIFFNESS',import_file);
par_TIR.VERTICAL_DAMPING         = read_parameters_sub(content,'VERTICAL_DAMPING',import_file);
par_TIR.BREFF                    = read_parameters_sub(content,'BREFF',import_file);
par_TIR.DREFF                    = read_parameters_sub(content,'DREFF',import_file);
par_TIR.FREFF                    = read_parameters_sub(content,'FREFF',import_file);
par_TIR.FNOMIN                   = read_parameters_sub(content,'FNOMIN',import_file);

% [LONG SLIP RANGE]
par_TIR.KPUMIN                   = read_parameters_sub(content,'KPUMIN',import_file);
par_TIR.KPUMAX                   = read_parameters_sub(content,'KPUMAX',import_file);

% [SLIP ANGLE RANGE]
par_TIR.ALPMIN                   = read_parameters_sub(content,'ALPMIN',import_file);
par_TIR.ALPMAX                   = read_parameters_sub(content,'ALPMAX',import_file);

% [INCLINATION ANGLE RANGE]
par_TIR.CAMMIN                   = read_parameters_sub(content,'CAMMIN',import_file);
par_TIR.CAMMAX                   = read_parameters_sub(content,'CAMMAX',import_file);

% [VERTICAL FORCE RANGE]
par_TIR.FZMIN                    = read_parameters_sub(content,'FZMIN',import_file);
par_TIR.FZMAX                    = read_parameters_sub(content,'FZMAX',import_file);

% [SCALING_COEFFICIENTS]
par_TIR.LFZO                     = read_parameters_sub(content,'LFZO',import_file);
par_TIR.LCX                      = read_parameters_sub(content,'LCX',import_file);
par_TIR.LMUX                     = read_parameters_sub(content,'LMUX',import_file);
par_TIR.LEX                      = read_parameters_sub(content,'LEX',import_file);
par_TIR.LKX                      = read_parameters_sub(content,'LKX',import_file);
par_TIR.LHX                      = read_parameters_sub(content,'LHX',import_file);
par_TIR.LVX                      = read_parameters_sub(content,'LVX',import_file);
par_TIR.LGAX                     = read_parameters_sub(content,'LGAX',import_file);
par_TIR.LCY                      = read_parameters_sub(content,'LCY',import_file);
par_TIR.LMUY                     = read_parameters_sub(content,'LMUY',import_file);
par_TIR.LEY                      = read_parameters_sub(content,'LEY',import_file);
par_TIR.LKY                      = read_parameters_sub(content,'LKY',import_file);
par_TIR.LHY                      = read_parameters_sub(content,'LHY',import_file);
par_TIR.LVY                      = read_parameters_sub(content,'LVY',import_file);
par_TIR.LGAY                     = read_parameters_sub(content,'LGAY',import_file);
par_TIR.LTR                      = read_parameters_sub(content,'LTR',import_file);
par_TIR.LRES                     = read_parameters_sub(content,'LRES',import_file);
par_TIR.LGAZ                     = read_parameters_sub(content,'LGAZ',import_file);
par_TIR.LXAL                     = read_parameters_sub(content,'LXAL',import_file);
par_TIR.LYKA                     = read_parameters_sub(content,'LYKA',import_file);
par_TIR.LVYKA                    = read_parameters_sub(content,'LVYKA',import_file);
par_TIR.LS                       = read_parameters_sub(content,'LS',import_file);
par_TIR.LSGKP                    = read_parameters_sub(content,'LSGKP',import_file);
par_TIR.LSGAL                    = read_parameters_sub(content,'LSGAL',import_file);
par_TIR.LGYR                     = read_parameters_sub(content,'LGYR',import_file);
par_TIR.LMX                      = read_parameters_sub(content,'LMX',import_file);
par_TIR.LVMX                     = read_parameters_sub(content,'LVMX',import_file);
par_TIR.LMY                      = read_parameters_sub(content,'LMY',import_file);

% [LONGITUDINAL_COEFFICIENTS]
par_TIR.PCX1                     = read_parameters_sub(content,'PCX1',import_file);
par_TIR.PDX1                     = read_parameters_sub(content,'PDX1',import_file);
par_TIR.PDX2                     = read_parameters_sub(content,'PDX2',import_file);
par_TIR.PDX3                     = read_parameters_sub(content,'PDX3',import_file);
par_TIR.PEX1                     = read_parameters_sub(content,'PEX1',import_file);
par_TIR.PEX2                     = read_parameters_sub(content,'PEX2',import_file);
par_TIR.PEX3                     = read_parameters_sub(content,'PEX3',import_file);
par_TIR.PEX4                     = read_parameters_sub(content,'PEX4',import_file);
par_TIR.PKX1                     = read_parameters_sub(content,'PKX1',import_file);
par_TIR.PKX2                     = read_parameters_sub(content,'PKX2',import_file);
par_TIR.PKX3                     = read_parameters_sub(content,'PKX3',import_file);
par_TIR.PHX1                     = read_parameters_sub(content,'PHX1',import_file);
par_TIR.PHX2                     = read_parameters_sub(content,'PHX2',import_file);
par_TIR.PVX1                     = read_parameters_sub(content,'PVX1',import_file);
par_TIR.PVX2                     = read_parameters_sub(content,'PVX2',import_file);
par_TIR.RBX1                     = read_parameters_sub(content,'RBX1',import_file);
par_TIR.RBX2                     = read_parameters_sub(content,'RBX2',import_file);
par_TIR.RCX1                     = read_parameters_sub(content,'RCX1',import_file);
par_TIR.REX1                     = read_parameters_sub(content,'REX1',import_file);
par_TIR.REX2                     = read_parameters_sub(content,'REX2',import_file);
par_TIR.RHX1                     = read_parameters_sub(content,'RHX1',import_file);
par_TIR.PTX1                     = read_parameters_sub(content,'PTX1',import_file);
par_TIR.PTX2                     = read_parameters_sub(content,'PTX2',import_file);
par_TIR.PTX3                     = read_parameters_sub(content,'PTX3',import_file);

% [OVERTURNING_COEFFICIENTS]
par_TIR.QSX1                     = read_parameters_sub(content,'QSX1',import_file);
par_TIR.QSX2                     = read_parameters_sub(content,'QSX2',import_file);
par_TIR.QSX3                     = read_parameters_sub(content,'QSX3',import_file);

% [LATERAL_COEFFICIENTS]
par_TIR.PCY1                     = read_parameters_sub(content,'PCY1',import_file);
par_TIR.PDY1                     = read_parameters_sub(content,'PDY1',import_file);
par_TIR.PDY2                     = read_parameters_sub(content,'PDY2',import_file);
par_TIR.PDY3                     = read_parameters_sub(content,'PDY3',import_file);
par_TIR.PEY1                     = read_parameters_sub(content,'PEY1',import_file);
par_TIR.PEY2                     = read_parameters_sub(content,'PEY2',import_file);
par_TIR.PEY3                     = read_parameters_sub(content,'PEY3',import_file);
par_TIR.PEY4                     = read_parameters_sub(content,'PEY4',import_file);
par_TIR.PKY1                     = read_parameters_sub(content,'PKY1',import_file);
par_TIR.PKY2                     = read_parameters_sub(content,'PKY2',import_file);
par_TIR.PKY3                     = read_parameters_sub(content,'PKY3',import_file);
par_TIR.PHY1                     = read_parameters_sub(content,'PHY1',import_file);
par_TIR.PHY2                     = read_parameters_sub(content,'PHY2',import_file);
par_TIR.PHY3                     = read_parameters_sub(content,'PHY3',import_file);
par_TIR.PVY1                     = read_parameters_sub(content,'PVY1',import_file);
par_TIR.PVY2                     = read_parameters_sub(content,'PVY2',import_file);
par_TIR.PVY3                     = read_parameters_sub(content,'PVY3',import_file);
par_TIR.PVY4                     = read_parameters_sub(content,'PVY4',import_file);
par_TIR.RBY1                     = read_parameters_sub(content,'RBY1',import_file);
par_TIR.RBY2                     = read_parameters_sub(content,'RBY2',import_file);
par_TIR.RBY3                     = read_parameters_sub(content,'RBY3',import_file);
par_TIR.RCY1                     = read_parameters_sub(content,'RCY1',import_file);
par_TIR.REY1                     = read_parameters_sub(content,'REY1',import_file);
par_TIR.REY2                     = read_parameters_sub(content,'REY2',import_file);
par_TIR.RHY1                     = read_parameters_sub(content,'RHY1',import_file);
par_TIR.RHY2                     = read_parameters_sub(content,'RHY2',import_file);
par_TIR.RVY1                     = read_parameters_sub(content,'RVY1',import_file);
par_TIR.RVY2                     = read_parameters_sub(content,'RVY2',import_file);
par_TIR.RVY3                     = read_parameters_sub(content,'RVY3',import_file);
par_TIR.RVY4                     = read_parameters_sub(content,'RVY4',import_file);
par_TIR.RVY5                     = read_parameters_sub(content,'RVY5',import_file);
par_TIR.RVY6                     = read_parameters_sub(content,'RVY6',import_file);
par_TIR.PTY1                     = read_parameters_sub(content,'PTY1',import_file);
par_TIR.PTY2                     = read_parameters_sub(content,'PTY2',import_file);

% [ROLLING_COEFFICIENTS]
par_TIR.QSY1                     = read_parameters_sub(content,'QSY1',import_file);
par_TIR.QSY2                     = read_parameters_sub(content,'QSY2',import_file);
par_TIR.QSY3                     = read_parameters_sub(content,'QSY3',import_file);
par_TIR.QSY4                     = read_parameters_sub(content,'QSY4',import_file);

% [ALIGNING_COEFFICIENTS]
par_TIR.QBZ1                     = read_parameters_sub(content,'QBZ1',import_file);
par_TIR.QBZ2                     = read_parameters_sub(content,'QBZ2',import_file);
par_TIR.QBZ3                     = read_parameters_sub(content,'QBZ3',import_file);
par_TIR.QBZ4                     = read_parameters_sub(content,'QBZ4',import_file);
par_TIR.QBZ5                     = read_parameters_sub(content,'QBZ5',import_file);
par_TIR.QBZ9                     = read_parameters_sub(content,'QBZ9',import_file);
par_TIR.QBZ10                    = read_parameters_sub(content,'QBZ10',import_file);
par_TIR.QCZ1                     = read_parameters_sub(content,'QCZ1',import_file);
par_TIR.QDZ1                     = read_parameters_sub(content,'QDZ1',import_file);
par_TIR.QDZ2                     = read_parameters_sub(content,'QDZ2',import_file);
par_TIR.QDZ3                     = read_parameters_sub(content,'QDZ3',import_file);
par_TIR.QDZ4                     = read_parameters_sub(content,'QDZ4',import_file);
par_TIR.QDZ6                     = read_parameters_sub(content,'QDZ6',import_file);
par_TIR.QDZ7                     = read_parameters_sub(content,'QDZ7',import_file);
par_TIR.QDZ8                     = read_parameters_sub(content,'QDZ8',import_file);
par_TIR.QDZ9                     = read_parameters_sub(content,'QDZ9',import_file);
par_TIR.QEZ1                     = read_parameters_sub(content,'QEZ1',import_file);
par_TIR.QEZ2                     = read_parameters_sub(content,'QEZ2',import_file);
par_TIR.QEZ3                     = read_parameters_sub(content,'QEZ3',import_file);
par_TIR.QEZ4                     = read_parameters_sub(content,'QEZ4',import_file);
par_TIR.QEZ5                     = read_parameters_sub(content,'QEZ5',import_file);
par_TIR.QHZ1                     = read_parameters_sub(content,'QHZ1',import_file);
par_TIR.QHZ2                     = read_parameters_sub(content,'QHZ2',import_file);
par_TIR.QHZ3                     = read_parameters_sub(content,'QHZ3',import_file);
par_TIR.QHZ4                     = read_parameters_sub(content,'QHZ4',import_file);
par_TIR.SSZ1                     = read_parameters_sub(content,'SSZ1',import_file);
par_TIR.SSZ2                     = read_parameters_sub(content,'SSZ2',import_file);
par_TIR.SSZ3                     = read_parameters_sub(content,'SSZ3',import_file);
par_TIR.SSZ4                     = read_parameters_sub(content,'SSZ4',import_file);
par_TIR.QTZ1                     = read_parameters_sub(content,'QTZ1',import_file);
par_TIR.MBELT                    = read_parameters_sub(content,'MBELT',import_file);
end