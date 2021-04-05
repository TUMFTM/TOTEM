function [FY] = lateral_tire_force(FZ, KAPPA, ALPHA, GAMMA, VX, par_TIR, A)
%% Funktion zur Berechnung der Reifenseitenkraft

% Parameter vorbereiten
    IP = par_TIR(A).IP;
    FNOMIN = par_TIR(A).FNOMIN; UNLOADED_RADIUS = par_TIR(A).UNLOADED_RADIUS; LONGVL = par_TIR(A).LONGVL; LOADINDEX = par_TIR(A).LOADINDEX;...                              % TIRE DATA
    LFZO = par_TIR(A).LFZO; LCX = par_TIR(A).LCX; LMUX = par_TIR(A).LMUX; LEX = par_TIR(A).LEX; LKX = par_TIR(A).LKX; LHX = par_TIR(A).LHX; LVX = par_TIR(A).LVX; LGAX = par_TIR(A).LGAX; LCY = par_TIR(A).LCY;...                                  % SCALING FACTORS
    LMUY = par_TIR(A).LMUY; LEY = par_TIR(A).LEY; LKY = par_TIR(A).LKY; LHY = par_TIR(A).LHY; LVY = par_TIR(A).LVY; LGAY = par_TIR(A).LGAY; LTR = par_TIR(A).LTR; LRES = par_TIR(A).LRES; LGAZ = par_TIR(A).LGAZ; LXAL = par_TIR(A).LXAL; LYKA = par_TIR(A).LYKA; LVYKA = par_TIR(A).LVYKA; LS = par_TIR(A).LS;...              % SCALING FACTORS
    LMX = par_TIR(A).LMX; LVMX = par_TIR(A).LVMX; LMY = par_TIR(A).LMY;...                                                            % SCALING FACTORS
    PCX1 = par_TIR(A).PCX1; PDX1 = par_TIR(A).PDX1; PDX2 = par_TIR(A).PDX2; PDX3 = par_TIR(A).PDX3; PEX1 = par_TIR(A).PEX1; PEX2 = par_TIR(A).PEX2; PEX3 = par_TIR(A).PEX3; PEX4 = par_TIR(A).PEX4; PKX1 = par_TIR(A).PKX1; PKX2 = par_TIR(A).PKX2; PKX3 = par_TIR(A).PKX3; PHX1 = par_TIR(A).PHX1;...             % LONGITUDINAL COEFFICIENTS
    PHX2 = par_TIR(A).PHX2; PVX1 = par_TIR(A).PVX1; PVX2 = par_TIR(A).PVX2; RBX1 = par_TIR(A).RBX1; RBX2 = par_TIR(A).RBX2; RCX1 = par_TIR(A).RCX1; REX1 = par_TIR(A).REX1; REX2 = par_TIR(A).REX2; RHX1 = par_TIR(A).RHX1;...                            % LONGITUDINAL COEFFICIENTS
    QSX1 = par_TIR(A).QSX1; QSX2 = par_TIR(A).QSX2; QSX3 = par_TIR(A).QSX3;...                                                          % OVERTURNING COEFFICIENTS
    PCY1 = par_TIR(A).PCY1; PDY1 = par_TIR(A).PDY1; PDY2 = par_TIR(A).PDY2; PDY3 = par_TIR(A).PDY3; PEY1 = par_TIR(A).PEY1; PEY2 = par_TIR(A).PEY2; PEY3 = par_TIR(A).PEY3; PEY4 = par_TIR(A).PEY4; PKY1 = par_TIR(A).PKY1;...                            % LATERAL COEFFICIENTS
    PKY2 = par_TIR(A).PKY2; PKY3 = par_TIR(A).PKY3; PHY1 = par_TIR(A).PHY1; PHY2 = par_TIR(A).PHY2; PHY3 = par_TIR(A).PHY3; PVY1 = par_TIR(A).PVY1; PVY2 = par_TIR(A).PVY2; PVY3 = par_TIR(A).PVY3; PVY4 = par_TIR(A).PVY4; RBY1 = par_TIR(A).RBY1; RBY2 = par_TIR(A).RBY2; RBY3 = par_TIR(A).RBY3; RCY1 = par_TIR(A).RCY1; REY1 = par_TIR(A).REY1;...   % LATERAL COEFFICIENTS
    REY2 = par_TIR(A).REY2; RHY1 = par_TIR(A).RHY1; RHY2 = par_TIR(A).RHY2; RVY1 = par_TIR(A).RVY1; RVY2 = par_TIR(A).RVY2; RVY3 = par_TIR(A).RVY3; RVY4 = par_TIR(A).RVY4; RVY5 = par_TIR(A).RVY5; RVY6 = par_TIR(A).RVY6;...                            % LATERAL COEFFICIENTS
    QSY1 = par_TIR(A).QSY1; QSY2 = par_TIR(A).QSY2; QSY3 = par_TIR(A).QSY3; QSY4 = par_TIR(A).QSY4;...                                                     % ROLLING COEFFICIENTS
    QBZ1 = par_TIR(A).QBZ1; QBZ2 = par_TIR(A).QBZ2; QBZ3 = par_TIR(A).QBZ3; QBZ4 = par_TIR(A).QBZ4; QBZ5 = par_TIR(A).QBZ5; QBZ9 = par_TIR(A).QBZ9; QBZ10 = par_TIR(A).QBZ10; QCZ1 = par_TIR(A).QCZ1; QDZ1 = par_TIR(A).QDZ1;...                   % ALIGNING COEFFICIENTS
    QDZ2 = par_TIR(A).QDZ2; QDZ3 = par_TIR(A).QDZ3; QDZ4 = par_TIR(A).QDZ4; QDZ6 = par_TIR(A).QDZ6; QDZ7 = par_TIR(A).QDZ7; QDZ8 = par_TIR(A).QDZ8; QDZ9 = par_TIR(A).QDZ9; QEZ1 = par_TIR(A).QEZ1; QEZ2 = par_TIR(A).QEZ2; QEZ3 = par_TIR(A).QEZ3; QEZ4 = par_TIR(A).QEZ4; QEZ5 = par_TIR(A).QEZ5;...             % ALIGNING COEFFICIENTS
    QHZ1 = par_TIR(A).QHZ1; QHZ2 = par_TIR(A).QHZ2; QHZ3 = par_TIR(A).QHZ3; QHZ4 = par_TIR(A).QHZ4; SSZ1 = par_TIR(A).SSZ1; SSZ2 = par_TIR(A).SSZ2; SSZ3 = par_TIR(A).SSZ3; SSZ4 = par_TIR(A).SSZ4;...                                 % ALIGNING COEFFICIENTS
    PIO = par_TIR(A).PIO; PPX1 = par_TIR(A).PPX1; PPX2 = par_TIR(A).PPX2; PPX3 = par_TIR(A).PPX3; PPX4 = par_TIR(A).PPX4; PPY1 = par_TIR(A).PPY1; PPY2 = par_TIR(A).PPY2; PPY3 = par_TIR(A).PPY3; PPY4 = par_TIR(A).PPY4; QPZ1 = par_TIR(A).QPZ1;                  % PRESSURE COEFFICIENTS

%% INITIALISIERUNG

% Referenzgeschwindigkeit auf diejenige aus dem Reifenfile festlegen
VREF = LONGVL;

% calculate normalized vertical load increment dFZ
FNOMIN_ = FNOMIN.*LFZO;
dFZ = (FZ-FNOMIN_)./FNOMIN_;

% calculate normalized change in inflation pressure dPI
dPI = (IP-PIO)./PIO;

%% LONGITUDINAL

% pure slip
GAMMAX = GAMMA.*LGAX;
SHX = (PHX1+PHX2.*dFZ).*LHX;
SVX = FZ.*(PVX1+PVX2.*dFZ).*LVX.*LMUX;
KAPPAX = KAPPA+SHX;
MUX = (PDX1+PDX2.*dFZ).*(1-PDX3.*GAMMAX.^2).*LMUX.*(1+PPX3.*dPI+PPX4.*dPI.^2);
CX = PCX1.*LCX;
DX = MUX.*FZ;
EX = (PEX1+PEX2.*dFZ+PEX3.*dFZ.^2).*(1-PEX4.*sign(KAPPAX)).*LEX;
EX(EX>1) = 1;
KX = FZ.*(PKX1+PKX2.*dFZ).*exp(PKX3.*dFZ).*LKX.*(1+PPX1.*dPI+PPX2.*dPI.^2);
BX = KX./(CX.*DX);
FX0 = DX.*sin(CX.*atan(BX.*KAPPAX-EX.*(BX.*KAPPAX-atan(BX.*KAPPAX))))+SVX;

% combined slip
SHXA = RHX1;
ALPHAS = ALPHA+SHXA;
BXA = RBX1.*cos(atan(RBX2.*KAPPA)).*LXAL;
CXA = RCX1;
EXA = REX1+REX2.*dFZ;
GXA0 = cos(CXA.*atan(BXA.*SHXA-EXA.*(BXA.*SHXA-atan(BXA.*SHXA))));
GXA = cos(CXA.*atan(BXA.*ALPHAS-EXA.*(BXA.*ALPHAS-atan(BXA.*ALPHAS))))./GXA0;
FX = GXA.*FX0;

%% LATERAL

% pure slip
GAMMAY = GAMMA.*LGAY;
SHY = (PHY1+PHY2.*dFZ).*LHY+PHY3.*GAMMAY;
ALPHAY = ALPHA+SHY;
MUY = (PDY1+PDY2.*dFZ).*(1-PDY3.*GAMMAY.^2).*LMUY.*(1+PPY3.*dPI+PPY4.*dPI.^2);
SVY = FZ.*((PVY1+PVY2.*dFZ).*LVY+(PVY3+PVY4.*dFZ).*GAMMAY).*LMUY;
DY = MUY.*FZ;
CY = PCY1.*LCY;
EY = (PEY1+PEY2.*dFZ).*(1-(PEY3+PEY4.*GAMMAY).*sign(ALPHAY)).*LEY;
EY(EY>1) = 1;
KY = PKY1.*FNOMIN.*sin(2.*atan(FZ./(PKY2.*FNOMIN.*LFZO.*(1+PPY2.*dPI)))).*(1-PKY3.*abs(GAMMAY)).*LFZO.*LKY.*(1+PPY1.*dPI);
BY = KY./(CY.*DY);
FY0 = DY.*sin(CY.*atan(BY.*ALPHAY-EY.*(BY.*ALPHAY-atan(BY.*ALPHAY))))+SVY;

%combined slip
SHYK = RHY1+RHY2.*dFZ;
KAPPAS = KAPPA+SHYK;
BYK = RBY1.*cos(atan(RBY2.*(ALPHA-RBY3))).*LYKA;
CYK = RCY1;
EYK = REY1+REY2.*dFZ;
DVYK = MUY.*FZ.*(RVY1+RVY2.*dFZ+RVY3.*GAMMA).*cos(atan(RVY4.*ALPHA));
SVYK = DVYK.*sin(RVY5.*atan(RVY6.*KAPPA)).*LVYKA;
GYK0 = cos(CYK.*atan(BYK.*SHYK-EYK.*(BYK.*SHYK-atan(BYK.*SHYK))));
GYK = cos(CYK.*atan(BYK.*KAPPAS-EYK.*(BYK.*KAPPAS-atan(BYK.*KAPPAS))))./GYK0;
FY = GYK.*FY0+SVYK;


end

