function [b_k,m_ges,m_torque_cost,I_ges] = TS_Gewicht(z,d_torque_ver,d_sh_4)
%Berechnet das Gewicht,die Breite und Trägheit einer Torque Splitter Einheit (ein
%Lamellenpaket)


%% Konstanten

c_st=7.8;        % Dichte Stahl in g/cm²
c_pa=2.0;        % Dichte Papierbelag in g/cm²


lsp=0.2;    % Lüftspiel in mm
modul=3;    % Modul der Mitnehmerverzahnung außen
d_a = d_torque_ver-((modul*2)+10);   % d_a ist Außendurchmesser der Lamelle;Verfügbarer Durchmesser abzüglich der Verzahnungshöhe und der Wandstärke (5mm)eines Rohres in dem der TorqueSplitter steckt 
vb=1.3;                      % Verhältnis d_a / d_i 
d_i= d_a/vb  ;               % Innendurchmesser Lamelle
r_i = d_i/2;                 % Radius Innen der Lamelle
r_a = d_a/2;                 % Radius Außen der Lamelle
A_RF = (r_a^2-r_i^2)*pi()  ; % Reibfläche in mm²
la=z/2;                      % Berechnung wie viele Lamellen -> z ist neue Reibflächenanzahl nach der thermischen Auslegung

%% Gewichtsberechnung

%Dicke der Belag-Lamellen abhängig von der Größe
if d_a < 120 % aus Interviews mit MIBA und Hörbiger Antriebstechnik, Näherungswerte,da normal speziell für eine Anwendung angepasst wird
    b_b=1.7;
    c_b=0.8;
    f_b=0.45;
else
    b_b=1.9;
    c_b=1;
    f_b=0.45;
end

%Dicke Stahllamelle abhängig von der Größe
if d_a < 120 % aus Lamellendaten Ortlinghaus S.9
    b_st=1.5;
  
elseif d_a <140
    b_st=2;
    
elseif d_a < 195
    b_st=2.3;
    
else
    b_st=2.3;
end



%Stahllamellen
m_l_st=A_RF*b_st*(c_st/1000)/1000;

%Belaglamelle
m_l_b=(A_RF*c_b*(c_st/1000)+2*A_RF*f_b*(c_pa/1000))/1000;

%Gesamtmasse Lamellen
m_lamellen_ges=la*m_l_b+(la+1)*m_l_st;


% Berechnung der Masse des Lagers
m_lager = (1.1305 * d_a - 31.179 )/ 1000; % Regression der Masse eines Schäffler-Axial-Nadelkranzlagers abhängig vom Durchmesser der Lamelle


%Berechnung der Masse eines Aktuierungskolbens mit 3mm Wandstärke aus Stahl
m_seitenteile=A_RF*3*(c_st/1000)/1000;

m_aussenring= (r_a^2-(r_a-3)^2) *pi()* 24 *(c_st/1000)/1000; %Breite des Kolbens sind 30mm
m_innenring= ((r_i+3)^2-r_i^2) *pi()* 24 *(c_st/1000)/1000;  %Breite des Kolbens sind 30mm

m_kolben= 2* m_seitenteile + m_aussenring +m_innenring ;




%% b=Breite des lamellenpaketes(berechnen aus Lamllenbreiten und Lüftspiel + Aktuierung ( Kolben und Lager))

breite_max_ges=(la+1)*b_st+la*b_b + lsp * z + + b_st + 40;

breite_ohneakt=(la+1)*b_st+la*b_b + lsp * z;


%% Berecbnung der masse des Verbindungsstück zwischen Hohlwelle und großen Lamellen 

if d_i > d_sh_4
    m_verbindung=breite_ohneakt*(c_st/1000)/1000 * pi()* (((d_i/2)^2)-((d_sh_4/2)^2));
else
    m_verbindung=0;
end

%% Massen der Teile und Breiten

b_korb =breite_ohneakt + b_st    ;                              % Breite von Stahlträgerscheibe und Reibbelag + 1 stahlbreite extra 
m_korb = (c_st/1000) * b_korb * pi()/1000 * ((d_torque_ver/2)^2 -((d_torque_ver-10)/2)^2 )  ; % Berechnung der Masse des Mitnehmerkorbes der Lamellen
m_verzahnung = 0.5 *(c_st/1000) * b_korb * pi()/1000 * (((d_torque_ver-10)/2)^2-((d_a/2)^2));
m_korb_mitverzahnung=m_korb + m_verzahnung   ;                  % Masse des Rohres mit Außenverzahnung

m_ges = m_lamellen_ges+m_korb_mitverzahnung+m_kolben+m_lager+m_verbindung;
m_ges_cost = 2* (m_korb_mitverzahnung + m_kolben + m_verbindung);               %Zweimal die Masse, da die Funktion nur eine Kupplungsseite berechnet

%% Trägheitsberechnung

%Trägheit einer Stahllamelle
I_l_st = 0.5 * m_l_st * (r_i^2+r_a^2)/1000000;

%Trägheit einer Belaglamelle
I_l_b = 0.5 * m_l_b * (r_i^2+r_a^2)/1000000;

%Trägheit des Kupplungskorbes

I_k_korb =0.5* m_korb_mitverzahnung*((d_torque_ver/2)^2+r_a^2)/1000000;

%Trägheit des Verbindungsstückes
if d_i > d_sh_4
    I_verbindung = 0.5 * m_verbindung * ((d_sh_4/2)^2+(d_i/2)^2)/1000000;
else
    I_verbindung=0;
end

%Gesamtträgheit
I_ges= I_k_korb + I_verbindung + I_l_st*(la+1) + I_l_b*la;

%% 
m_ges  ;                     % in kg
m_torque_cost=m_ges_cost;    % in kg
b_k=breite_max_ges;          % in mm
I_ges       ;                % in kg*m^2

end

