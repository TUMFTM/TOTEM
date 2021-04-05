function [Masse_LE] = Leistungseletronik_Masse(Mmax, az, nnenn)
% calculating mass of inverter
Masse_LE=Mmax*(2-az)*2*pi*nnenn/(60*1000)*8.7900E-02+6.2423E+00/2; %Masse Inverter [kg]  nach Dissertation Stephan Fuchs angepasst von Andreas Holtz am 12.02.18

end

% S. Fuchs, “Verfahren zur parameterbasierten Gewichtsabschätzung neuer Fahrzeugkonzepte,” Dissertation, Lehrstuhl für Fahrzeugtechnik, Technische Universität München, München, 2014.
% 
% A. Holtz, “Fahrversuchsbasierte Validierung und Optimierung eines modularen Gesamtfahrzeugmodells mit adaptiver Parametrierung,” Masterarbeit, Lehrstuhl für Fahrzeugtechnik, Technische Universität München, München, 2017.