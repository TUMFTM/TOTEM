function [ J ] = Traegheit_EM( M_nenn, n_nenn, typ_EM, i )
% calculating the rotational intertia of the electric motor

% Source: T. Pesce, “Ein Werkzeug zur Spezifikation von effizienten 
% Antriebstopologien für Elektrofahrzeuge,” Dissertation, Lehrstuhl 
% für Fahrzeugtechnik, Technische Universität München, München, 2014.

%im radnahen Fall entsteht ein Vektor [J im ersten Gang    J im zweiten Gang]

%Regression
J_PSM = 0.0002*M_nenn-0.0029;   %[kg m^2] Pesce S.49, Datenbasis bis ca. 330Nm;

%J_ASM nach Pesce braucht deren Masse
m_PSM = Masse_EM(M_nenn,n_nenn,'PSM');%[kg]
m_ASM = Masse_EM(M_nenn,n_nenn,'ASM');

J_ASM = (1+(m_ASM - m_PSM)/(2*m_PSM))*J_PSM;%[kg m^2]

%Untergrenzen, Pesce S.49
if J_PSM < 0.001
    J_PSM = 0.001;
end
if J_ASM < 0.001
    J_ASM = 0.001;
end

tf = strcmp(typ_EM, 'PSM');
if tf == 1
    J = J_PSM*i.^2; %da i ein Vektor mit verschiedenen Gangübersetzungen ist, ist J das auch 
else
    J = J_ASM*i.^2;
end

end

