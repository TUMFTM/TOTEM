function m_EM = Masse_SteuerEM(M_nenn, n_nenn)

%nach Matz
P_nenn = M_nenn*n_nenn*(2*pi/60);%[W]
LD = 1800; %[W/kg] Gravimetrische Nennleistungsdichte aus Matz
m_EM = P_nenn/LD;

end