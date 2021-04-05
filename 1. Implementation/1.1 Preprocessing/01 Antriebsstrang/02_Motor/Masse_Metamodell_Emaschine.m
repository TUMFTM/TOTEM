function m_mot_gesamt=Masse_Metamodell_Emaschine(M_nenn_Nm, typ_EM)
% calculation the mass of the electric motor
    
%Regressions for Motor Mass origin from Dissertation by Matthias
%Felgenhauer: "Automated Development of Modular Systems for Passenger Cars 
%within the Vehicle Front", Insititute for Automotive Technology, 
%Technical University of Munich, 2019
if strcmp(typ_EM, 'PSM')
    m_mot_gesamt=18.136+0.177.*M_nenn_Nm;
elseif strcmp(typ_EM, 'ASM')
    m_mot_gesamt=11.229+18.136+(0.177+0.128).*M_nenn_Nm;
end

    