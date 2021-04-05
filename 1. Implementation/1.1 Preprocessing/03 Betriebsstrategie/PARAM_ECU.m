function [par_VEH] = PARAM_ECU(par_MDT, par_VEH)

%% Erstellt Vektor für alle möglichen Schaltkombinationen

    i_all = 1;
    n_Schaltkombinationen = par_MDT.VA.trans.n_gears * par_MDT.HA.trans.n_gears;
    Vektorabstufung = 0.01;
    Vektorlaenge = 1/Vektorabstufung + 1;
    Vektor = ones(1, Vektorlaenge);

    for i=1:par_MDT.VA.trans.n_gears
        for j=1:par_MDT.HA.trans.n_gears

            Gang_VA (i_all, 1) = i;
            Gang_HA (i_all, 1) = j;
            
            Uebersetzungen_VA (i_all, 1) = par_MDT.VA.trans.i_gears (i);
            Uebersetzungen_HA (i_all, 1) = par_MDT.HA.trans.i_gears (j);
            
            Wirkungsgrade_VA (i_all, 1) = par_MDT.VA.trans.wkg (i);
            Wirkungsgrade_HA (i_all, 1) = par_MDT.HA.trans.wkg (j);
            
            Gang_VA_Vektor (i_all, :) = Gang_VA(i_all) .* Vektor;
            Gang_HA_Vektor (i_all, :) = Gang_HA(i_all) .* Vektor;
            
            Uebersetzungen_VA_Vektor (i_all, :) = Uebersetzungen_VA (i_all) .* Vektor;
            Uebersetzungen_HA_Vektor (i_all, :) = Uebersetzungen_HA (i_all) .* Vektor;
            
            Wirkungsgrade_VA_Vektor (i_all, :) = Wirkungsgrade_VA (i_all) .* Vektor;
            Wirkungsgrade_HA_Vektor (i_all, :) = Wirkungsgrade_HA (i_all) .* Vektor;
            
            i_all = i_all + 1;

        end
    end
    

    % Abspeichern 
    par_VEH.dt.ecu.n_Schaltkombinationen = n_Schaltkombinationen;
    par_VEH.dt.ecu.Vektorabstufung = Vektorabstufung;
    par_VEH.dt.ecu.Vektorlaenge = Vektorlaenge;
    par_VEH.dt.ecu.Schaltkombinationen_VA = Gang_VA_Vektor;
    par_VEH.dt.ecu.Schaltkombinationen_HA = Gang_HA_Vektor;
    par_VEH.dt.ecu.Uebersetzungen_VA = Uebersetzungen_VA_Vektor;
    par_VEH.dt.ecu.Uebersetzungen_HA = Uebersetzungen_HA_Vektor;
    par_VEH.dt.ecu.Wirkungsgrade_VA = Wirkungsgrade_VA_Vektor;
    par_VEH.dt.ecu.Wirkungsgrade_HA = Wirkungsgrade_HA_Vektor;

end