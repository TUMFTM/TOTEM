%% Modifiziert nach Fuchs
function [m_diff, m_korb, r_diff_korb_aussen, r_diff_korb_innen, r_planet_ritz_2, r_sun_ritz_2,r_shaft_planet,l_diff_korb]= differential_calculation(M_Diff_max, differential_struct, r_Eingangswelle)
%% Achsdifferential als Kegelraddifferential

T_sun              =   M_Diff_max;

% Parameters
rho = 7800;     %kg/m^3

% input
r_sun                       = r_Eingangswelle;                   % aus Festigkeit, [m]
%n                           = gearbox_struct.engine_speed;     %unused

%% Innen
% Vorgaben Sonnenkegelrad
p_zul                       = differential_struct.sun.p_zul;                % maximal allowable stress
alpha                       = differential_struct.sun.alpha;                % pressure angle of bevel gear

d_1_sun                     = differential_struct.sun.f_d_1_sun * r_sun;        %Annahme thickness of sun bevel gear
r_sun_ritz_1                = differential_struct.sun.f_r_sun_ritz_1 * r_sun;   % Annahme radius 1 of sun bevel gear
r_sun_ritz_2                = differential_struct.sun.f_r_sun_ritz_2 * r_sun;   % Annahme radius 2 of sun bevel gear

% aus Umfangskraft in Schrägverzahnung

F_sun                       = T_sun / r_sun_ritz_2;                         % tangential force

% Berechnung Sonnenkegelrad - calculation of sun bevel gear 

[l_kontakt_sun,p_sun,d_2_sun,m_voll_sun,m_hohl_sun] = ...
    kegelrad(F_sun,p_zul,r_sun_ritz_1,r_sun_ritz_2,d_1_sun,alpha,7800);     % Berechnung Kegelrad

% Berechnung Ausgleichskegelrad - calculation of differential gear

d_1_planet                  = differential_struct.planet.d_1_planet;                    % Annahme thickness of planet bevel gear
r_planet_ritz_1             = differential_struct.planet.f_r_planet_ritz_1*r_sun;       % Annahme radius 1 of planet bevel gear
r_planet_ritz_2             = (r_sun_ritz_2-r_sun_ritz_1)+r_planet_ritz_1;              % radius 2 of planet bevel gear

[l_kontakt_planet,p_planet,d_t_planet,m_voll_planet,m_hohl_planet] = ...
    kegelrad(F_sun,p_zul,r_planet_ritz_1,r_planet_ritz_2,d_1_planet,90-alpha,7800);    % Berechnung Kegelrad

% Berechnung Ausgleichswelle - calculation of differential 
l_shaft_planet              = 2 * (r_sun_ritz_2 + d_1_planet);              % length of shaft between planets
r_shaft_planet              = r_planet_ritz_1;                              % radius of shaft between planets

% mass
m_shaft_planet              = r_shaft_planet ^ 2 * pi * l_shaft_planet * rho;   % Masse der Planetenwelle

% Berechnung Differentialkorb - calculation of differential cage
d_spalt_diff_korb           = differential_struct.cage.d_spalt_diff_korb;   % gap between cage and bevel gears
r_diff_korb_innen           = 0.5 * l_shaft_planet + d_spalt_diff_korb;     % inside radius of cage 
t_diff_korb                 = differential_struct.cage.t_diff_korb;         % Annahme : thickness of cage                   
l_diff_korb                 = 2 * (d_1_sun + d_2_sun + r_planet_ritz_1);    % length of cage
b_diff_korb                 = 2 * r_planet_ritz_2;                          % width of cage plate

r_diff_korb_aussen          = r_diff_korb_innen + t_diff_korb;              % outer radius of cage

% mass
m_platte_korb               = l_diff_korb * b_diff_korb * t_diff_korb * rho;                % mass of plate
m_radial_korb               = (r_diff_korb_aussen^2 - r_sun^2) * pi * t_diff_korb * rho;    % mass of radial plate 


% Berechnung crown wheel - calculation of crown wheel
d_spalt_crown_wheel         = differential_struct.crown_wheel.d_spalt_crown_wheel;          % gap between cage and crown wheel                         
l_crown_wheel               = differential_struct.crown_wheel.l_crown_wheel;                % length of crown wheel

r_ges                       = r_diff_korb_aussen + d_spalt_crown_wheel + l_crown_wheel;     % total radius

d_crown_wheel_ritz          = differential_struct.crown_wheel.d_crown_wheel_ritz;           % Annahme: thickness of crown wheel

% mass
m_crown_wheel_ritz          = (r_ges^2 - (r_ges - l_crown_wheel)^2) * pi * d_crown_wheel_ritz *rho;

% zylindrischer Teil des Differentialkorbes - cylindric part of cage

t_diff_korb_crown_wheel             = differential_struct.crown_wheel.t_diff_korb_crown_wheel;

V_diff_korb_crown_wheel             = (r_ges^2 - r_sun^2) * pi * t_diff_korb_crown_wheel ...
                                    + ((r_sun + t_diff_korb_crown_wheel)^2 - r_sun^2) * pi * 0.03;  % Korrektur notwendig!!

m_diff_korb_crown_wheel             = V_diff_korb_crown_wheel * rho;

% Lager - bearing - Korrektur notwendig!!

%m_L_1                               = berechnung_lager(r_sun + t_diff_korb_crown_wheel,15,n,20,3);
%m_L_2                               = berechnung_lager(2*r_sun,15,n,20,2);

%m_lag                               = m_L_1 + m_L_2;

%% Gehäuse - box
% Aufbau besteht aus einem hohlzylindrischen Teil und 3 kegelförmigen
% Teilen

t_geh = differential_struct.box.t_geh;
l_geh_zyl = r_planet_ritz_2 + 2 * d_1_sun;

% zylindrischer Teil in dem sich Crown wheel befindet - cylindric part with
% crown wheel inside

% V_geh_zyl_platte                = 0.5 * (((r_ges + t_geh)^2 - (r_sun + t_diff_korb_crown_wheel)^2) * pi * t_geh)
V_geh_zyl_zyl                   = 0.5 * (((r_ges+t_geh)^2 - r_ges^2) * pi * l_geh_zyl);

% kegelförmiger Teil des Gehäuses zur Antriebswelle - conic part of box
beta_geh_keg_aw                     = differential_struct.box.beta_geh_keg_aw;
r_geh_keg_aw_mittel                = (l_geh_zyl + r_ges) / 2;
V_geh_keg_aw_aussen                = 1/3 * (r_geh_keg_aw_mittel + t_geh) * (tan((2*pi/360) * beta_geh_keg_aw)) * (r_geh_keg_aw_mittel + t_geh)^2 * pi;
V_geh_keg_aw_innen                 = 1/3 * (r_geh_keg_aw_mittel) * (tan((2*pi/360) * beta_geh_keg_aw)) * (r_geh_keg_aw_mittel)^2 * pi;
V_geh_aw_keg                       = V_geh_keg_aw_aussen - V_geh_keg_aw_innen;

% kegelförmiger Teil des Gehäuses zur Seitenwelle - conic part of box
beta_geh_keg_sw                     = differential_struct.box.beta_geh_keg_sw;
r_geh_keg_sw_mittel                = r_ges;
V_geh_keg_sw_aussen                = 1/3 * (r_geh_keg_sw_mittel + t_geh) * (tan((2*pi/360) * beta_geh_keg_sw)) * (r_geh_keg_sw_mittel + t_geh)^2 * pi;
V_geh_keg_sw_innen                 = 1/3 * (r_geh_keg_sw_mittel) * (tan((2*pi/360) * beta_geh_keg_sw)) * (r_geh_keg_sw_mittel)^2 * pi;
V_geh_sw_keg                       = V_geh_keg_sw_aussen - V_geh_keg_sw_innen;

m_geh                           = (V_geh_zyl_zyl + V_geh_aw_keg + 2 * V_geh_sw_keg) * rho;

m_int                           = m_crown_wheel_ritz    ...
                                + m_hohl_planet *2      ...
                                + m_hohl_sun *2         ...
                                + m_shaft_planet        ...
                                + m_platte_korb * 2     ...
                                + m_radial_korb * 2     ...
                                + m_diff_korb_crown_wheel;   ...
                                %+ m_lag;                 %...

%für die Trägheitsberechnung: m_korb ohne Sonnenkegelräder
m_korb                          = m_crown_wheel_ritz    ...
                                + m_hohl_planet *2      ...
                                + m_shaft_planet        ...
                                + m_platte_korb * 2     ...
                                + m_radial_korb * 2     ...
                                + m_diff_korb_crown_wheel;                          
                            
f_geh_int                       = m_geh/m_int;

f_fudge                         = differential_struct.f_fudge;

m_tot                           = f_fudge * (m_int + m_geh);

m_diff                          = m_tot;

b_diff                          = l_geh_zyl + (2*((r_geh_keg_sw_mittel + t_geh) * (tan((2*pi/360) * beta_geh_keg_sw))));

differential_struct.masses.m_diff       = m_tot;
differential_struct.main.b_diff         = b_diff;

%% WERTE FÜR DREHMASSENZUSCHLAGSFAKTOR

differential_struct.e_i.m_crown_wheel_ritz = m_crown_wheel_ritz;
differential_struct.e_i.r_aussen = r_ges;
differential_struct.e_i.r_innen = r_ges - l_crown_wheel;

differential_struct.e_i.m_hohl_sun = m_hohl_sun;
differential_struct.e_i.r_sun_ritz = (r_sun_ritz_1 + r_sun_ritz_2) / 2;

differential_struct.e_i.m_hohl_planet = m_hohl_planet;
differential_struct.e_i.r_planet_ritz = (r_planet_ritz_1 + r_planet_ritz_2) / 2;
differential_struct.e_i.d_1_planet = d_1_planet;

differential_struct.e_i.m_shaft_planet = m_shaft_planet;
differential_struct.e_i.l_shaft_planet = l_shaft_planet;
differential_struct.e_i.r_shaft_planet = r_shaft_planet;

differential_struct.e_i.m_platte_korb = m_platte_korb;
differential_struct.e_i.r_diff_korb_innen = r_diff_korb_innen;
differential_struct.e_i.t_diff_korb = t_diff_korb;
differential_struct.e_i.b_diff_korb = b_diff_korb;
differential_struct.e_i.m_radial_korb = m_radial_korb;
differential_struct.e_i.r_diff_korb_aussen = r_diff_korb_aussen;
differential_struct.e_i.r_sun = r_sun;

% assignin('base','differential_struct',differential_struct)