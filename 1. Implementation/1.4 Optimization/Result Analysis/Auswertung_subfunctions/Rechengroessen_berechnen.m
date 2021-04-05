        % Werte berechnen
        Fahrverhalten   = B{n}(:,1);
        Verbrauch       = B{n}(:,2);
        Kosten          = B{n}(:,3);
        Motor_VA        = B{n}(:,4);
        Motor_HA        = B{n}(:,5);
        gang_VA         = B{n}(:,6);
        gang_HA         = B{n}(:,7);
        M_VA            = B{n}(:,8);
        n_VA            = B{n}(:,9);
        i1_VA           = B{n}(:,11);
        spreizung_VA    = B{n}(:,12);
        M_HA            = B{n}(:,13);
        n_HA            = B{n}(:,14);
        i1_HA           = B{n}(:,16);
        spreizung_HA    = B{n}(:,17);
        
        Leistung_VA     = M_VA.*n_VA/2/60*2*pi/1000;
        Leistung_HA     = M_HA.*n_HA/2/60*2*pi/1000;
        Gesamtleistung  = Leistung_VA+Leistung_HA; 
        Anteil_HA       = Leistung_HA./(Leistung_VA+Leistung_HA)*100; 
        
        M_n_verh_VA     = M_VA./n_VA*1000;
        M_n_verh_HA     = M_HA./n_HA*1000;

        gang_mittel=(gang_VA+gang_HA)/2;
        Motor_mittel=(Motor_VA+Motor_HA)/2;
        i_min_VA=i1_VA./(spreizung_VA.^(gang_VA-1));
        i_min_HA=i1_HA./(spreizung_HA.^(gang_HA-1));
        r_reifen=0.35;
        v_rad_max_VA = n_VA/60*2*pi./i_min_VA.*r_reifen*3.6;
        v_rad_max_HA = n_HA/60*2*pi./i_min_HA.*r_reifen*3.6;
        v_rad_max_VAHA =v_rad_max_VA./v_rad_max_HA;
        
        % Fahrverhalten
        LWG_14 =    B{n}(:, 19);
        LWG_67 =    B{n}(:, 20);
        a_y_max =   B{n}(:, 21);
        v_char =    B{n}(:, 22);
        
        % Überlast
        f_UEL_PSM       = 1.72;
        f_UEL_ASM       = 2.65;
        Maximalmoment_VA= M_VA.* (f_UEL_PSM.*(Motor_VA-1) + f_UEL_ASM.*(2-Motor_VA));
        Maximalmoment_HA= M_HA.* (f_UEL_PSM.*(Motor_HA-1) + f_UEL_ASM.*(2-Motor_HA));