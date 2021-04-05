%% Nach Fuchs

%% Initialisierung Differential
function [differential_struct] = differential_calculation_init()

differential_struct.main.i_null                         = -1;               % Standübersetzung
% n_1 - i_null * n_2 - (1 - i_null) * n_s = 0
% n_1 + n_2 = 2*n_s

% Parameters
differential_struct.material_parameters.rho             = 7800;             % Dichte Stahl [kg / m^3]
differential_struct.material_parameters.R_mN            = 900;              % Zugfestigkeit des Werkstoffs [MPa]
differential_struct.material_parameters.f_W             = 0.40;             % Berechnungsfaktor
differential_struct.material_parameters.r_tau           = 0.58;             % Schubfaktor hinterfragen ob sinnvoll !!!!!
differential_struct.material_parameters.E               = 210000E+6;        % E-Modul [Pa]
differential_struct.material_parameters.v_poisson       = 0.3;              % Poisson Ratio
differential_struct.material_parameters.S               = 5;                % Sicherheit Welle 1

%% Innen
% Vorgaben Sonnenkegelrad
differential_struct.sun.p_zul                   = 60;                       % maximal allowable stress
differential_struct.sun.alpha                   = 45;                       % pressure angle of bevel gear
differential_struct.sun.f_d_1_sun               = 0.25;                     % thickness of sun bevel gear to total r_sun
differential_struct.sun.f_r_sun_ritz_1          = 1.4;                      % radius 1 of sun bevel gear to r_sun
differential_struct.sun.f_r_sun_ritz_2          = 2.5;                      % radius 2 of sun bevel gear to r_sun

% Berechnung Ausgleichskegelrad - calculation of differential gear
differential_struct.planet.d_1_planet               = 0.003;                % Annahme: thickness of planet bevel gear
differential_struct.planet.f_r_planet_ritz_1        = 0.4;                  % radius 1 of planet bevel gear to r_sun

% Berechnung Differentialkorb - calculation of differential cage
differential_struct.cage.d_spalt_diff_korb          = 0.002;                % gap between cage and bevel gears
differential_struct.cage.t_diff_korb                = 0.004;                % Annahme : thickness of cage                   

% Berechnung crown wheel - claculation of crown wheel
differential_struct.crown_wheel.d_spalt_crown_wheel         = 0.015;        % gap between cage and crown wheel                         
differential_struct.crown_wheel.l_crown_wheel               = 0.022;        % length of crown wheel
differential_struct.crown_wheel.d_crown_wheel_ritz          = 0.005;        % Annahme: thickness of crown wheel
differential_struct.crown_wheel.t_diff_korb_crown_wheel     = 0.005;        % thickness of crown_wheel only teeth

%% Gehäuse - box
differential_struct.box.t_geh                               = 0.006;        % thickness of box

% kegelförmiger Teil des Gehäuses - conic part of box
differential_struct.box.beta_geh_keg_aw                     = 30;           % angle of conic part of box zur Antriebswelle
differential_struct.box.beta_geh_keg_sw                     = 30;           % angle of conic part of box zu den Seitenwellen
differential_struct.f_fudge                                 = 1.07;         % fudge factor

% assignin('base','differential_struct',differential_struct)