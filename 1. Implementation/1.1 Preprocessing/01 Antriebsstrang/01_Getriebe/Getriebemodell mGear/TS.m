function [d_a,A_l,M_s,la,z] = TS(d_verf,d_hw,M_in)
%Berechnung der Masse, Breite und Außenabmessung einer Kupplung des
%TV-Systems

%Dichten
c_st=7.8;        % Dichte Stahl in g/cm²
c_pa=2.15;       % Dichte Papierbelag in g/cm²

%Reibwerte
mue_stat_pa= 0.1 ;           % Reibungszahl statisch Papierbelag
mue_dyn_pa= 0.13  ;          % Reibungszahl dynamisch Papierbelag


lsp = 0.2;                   % Lüftspiel in mm entnommen aus Lamellendaten Ortlinghaus S.4

M_s = 1.2 * M_in;            % Sicherheitsfaktor gegen µ schwankungen von 1,2 gängige Praxis -> interview mit Borg Warner und . literatur

d_a = d_verf-(10*2);         % d_a ist der Außendurchmesser der Lamellen, er ergibt sich aus dem verfügbaren Durchmesser abzüglich der Verzahnungsbreite

vb=1.3;                      % Verhältnis d_a / d_i -> Ortlinghaus; auch 1,2 - 1,4 mgl.aus Lamellendaten Ortlinghaus S.4

d_i= d_a/vb  ;               % Innendurchmesser Lamelle


r_i = d_i/2;                 % Berechnung der Radien, der Lamellen
r_a = d_a/2;

rm = (2/3)*((r_a^3-r_i^3)/(r_a^2-r_i^2));       % Mittlerer Reibdurchmesser in mm
A_RF = (r_a^2-r_i^2)*pi()  ;                    % Reibfläche in mm² für einen Reibfläche
A_l = A_RF/1e+06;                               % Umrechnung auf m²
p_ist = 3.5;                                    % max. Flächenpressung auf den Belag in N/mm²
Fax =  A_RF * p_ist   ;                         % Anpresskraft in N
z_1= (M_s*100) /(Fax * mue_stat_pa * rm);       
z_2=ceil(z_1);                                  % z = Anzahl Reibflächen

if mod(z_2,2)==00
    i=z_2;
else 
    i=z_2+1;
end

z=i;                    % z = Anzahl Reibflächen
la=z/2;                 % z = Anzahl benötigter Reiblamellen


end
