function vmax=calc_vmax(par_MDT, par_VEH, par_TIR, Automatisierter_Aufruf)


initialize_vehicle_Tesla_aus_initialisierung_fuer_Optimierung; 
% initialize_vehicle_Tesla_aus_initialisierung_testfunktion;
% initialize_vehicle_Tesla_aus_initialisierung_fuer_Validierung
load('backwards_tire_model.mat')

schrittweite=200; %Anzahl der Drehzahl- und Geschwindigkeitschritte
    
Fz_v=  (0.5*mass*(g*lh)/l).*ones(1,schrittweite);
[r_rad_stat_v, r_rad_dyn_v]=   calc_radradius_stat(Fz_v, c_z_reifen, r_rad_0);    
Fz_h=  (0.5*(mass*g-Fz_v)).*ones(1,schrittweite);
[r_rad_stat_h, r_rad_dyn_h]=   calc_radradius_stat(Fz_h, c_z_reifen, r_rad_0);

if ist_Antrieb_VA==1 % wenn Antrieb an der Vorderachse
    if par_MDT.VA.akt.az==1
        w_mot_VA     = par_MDT.VA.em.E_Motorobject.MaxTrqLine.x_radps;
        M_mot_VA     = par_MDT.VA.em.E_Motorobject.MaxTrqLine.y_Nm;
    else
        w_mot_VA     = par_MDT.VA.em.E_Motorobject.MaxTrqLine.x_radps;
        M_mot_VA     = 2.*par_MDT.VA.em.E_Motorobject.MaxTrqLine.y_Nm;
    end

    if length(i_Getriebe_VA)==1
        w_rad_VA_base    = w_mot_VA./i_Getriebe_VA;
        M_rad_VA    = M_mot_VA.*eta_Getriebe_VA*i_Getriebe_VA;
        w_rad_max_VA=max(w_rad_VA_base);
        w_rad_VA=linspace(1,w_rad_max_VA, schrittweite);
        M_rad_VA=interpn(w_rad_VA_base, M_rad_VA, w_rad_VA);
    elseif length(i_Getriebe_VA)==2
        w_rad_VA_g1    = w_mot_VA./i_Getriebe_VA(1);
        M_rad_VA_g1    = M_mot_VA.*eta_Getriebe_VA(1)*i_Getriebe_VA(1);
        w_rad_VA_g2    = w_mot_VA./i_Getriebe_VA(2);
        M_rad_VA_g2    = M_mot_VA.*eta_Getriebe_VA(2)*i_Getriebe_VA(2);
        w_rad_max_VA=max(max(w_rad_VA_g1), max(w_rad_VA_g2));
        w_rad_VA=linspace(1,w_rad_max_VA, schrittweite);
        M_rad_VA=max(   interpn(w_rad_VA_g1, M_rad_VA_g1, w_rad_VA), interpn(w_rad_VA_g2, M_rad_VA_g2, w_rad_VA));
    end
    

    F_antr_v=M_rad_VA./r_rad_stat_v;
    kappa_v=       sign(F_antr_v).* kappa_metamodel(Fz_v, abs(F_antr_v));
    I=find(isnan(kappa_v));
    kappa_v(I)=0.1;
    V_Fahrzeug_v=w_rad_VA./(1.+kappa_v).*r_rad_dyn_v;
end

    
if ist_Antrieb_HA==1 % wenn antrieb an der Hinterachse
    if par_MDT.HA.akt.az==1
        w_mot_HA     = par_MDT.HA.em.E_Motorobject.MaxTrqLine.x_radps;
        M_mot_HA     = par_MDT.HA.em.E_Motorobject.MaxTrqLine.y_Nm;
    else
        w_mot_HA     = par_MDT.HA.em.E_Motorobject.MaxTrqLine.x_radps;
        M_mot_HA     = 2.*par_MDT.HA.em.E_Motorobject.MaxTrqLine.y_Nm;
    end    

    if length(i_Getriebe_HA)==1
        w_rad_HA_base    = w_mot_HA./i_Getriebe_HA;
        M_rad_HA    = M_mot_HA.*eta_Getriebe_HA*i_Getriebe_HA;
        w_rad_max_HA=max(w_rad_HA_base);
        w_rad_HA=linspace(1,w_rad_max_HA, schrittweite);
        M_rad_HA=interpn(w_rad_HA_base, M_rad_HA, w_rad_HA);
    elseif length(i_Getriebe_HA)==2
        w_rad_HA_g1    = w_mot_HA./i_Getriebe_HA(1);
        M_rad_HA_g1    = M_mot_HA.*eta_Getriebe_HA(1)*i_Getriebe_HA(1);
        w_rad_HA_g2    = w_mot_HA./i_Getriebe_HA(2);
        M_rad_HA_g2    = M_mot_HA.*eta_Getriebe_HA(2)*i_Getriebe_HA(2);
        w_rad_max_HA=max(max(w_rad_HA_g1), max(w_rad_HA_g2));
        w_rad_HA=linspace(1,w_rad_max_HA, schrittweite);
        M_rad_HA=max(   interpn(w_rad_HA_g1, M_rad_HA_g1, w_rad_HA), interpn(w_rad_HA_g2, M_rad_HA_g2, w_rad_HA));
    end


    F_antr_h=M_rad_HA./r_rad_stat_h;
    kappa_h=       sign(F_antr_h).* kappa_metamodel(Fz_h, abs(F_antr_h));
    I=find(isnan(kappa_h));
    kappa_h(I)=0.1;
    V_Fahrzeug_h=w_rad_HA./(1.+kappa_h).*r_rad_dyn_h;

end

if ist_Antrieb_VA==1 &&ist_Antrieb_HA==1
    V_Fahrzeug_max=min(max(V_Fahrzeug_v), max(V_Fahrzeug_h));
    V_Fahrzeug=linspace(0, V_Fahrzeug_max, 200);
    F_antr_max=max(   interpn(V_Fahrzeug_v, F_antr_v, V_Fahrzeug), interpn(V_Fahrzeug_h, F_antr_h, V_Fahrzeug));
elseif ist_Antrieb_VA==1
    V_Fahrzeug=V_Fahrzeug_v;
    F_antr_max=F_antr_v;
elseif ist_Antrieb_HA==1
    V_Fahrzeug=V_Fahrzeug_h;
    F_antr_max=F_antr_h;
end
    

F_inertia=0;
F_aero=0.5*cw*rho*A*V_Fahrzeug.^2;
F_Steigung=0;
F_Rollreibung=mass*g*c_RR*sign(abs(V_Fahrzeug));
F_Fahrwiderstand=F_inertia+F_aero+F_Rollreibung+F_Steigung;

[~,i_vmax]=min(abs(F_antr_max-F_Fahrwiderstand));
vmax=V_Fahrzeug(i_vmax);
% disp(num2str(vmax*3,6))

%% plots
    if not(Automatisierter_Aufruf==1)
        figure(83)
        subplot(2,1,1)
        cla
        hold on 
        grid on
        try
            plot(w_rad_VA, M_rad_VA)
        end
        try
            plot(w_rad_VA_g1, M_rad_VA_g1)
            plot(w_rad_VA_g2, M_rad_VA_g2)
        end

        try
            plot(w_rad_HA, M_rad_HA)
        end
        try
            plot(w_rad_HA_g1, M_rad_HA_g1)
            plot(w_rad_HA_g2, M_rad_HA_g2)
        end

        % 
        subplot(2,1,2)
        cla
        hold on 
        grid on
        try
            plot(V_Fahrzeug.*3.6, F_antr_v)
        end
        try
            plot(V_Fahrzeug.*3.6, F_antr_h)
        end
        plot(V_Fahrzeug.*3.6, F_antr_max)
        plot(V_Fahrzeug.*3.6, F_Fahrwiderstand)
        plot(V_Fahrzeug.*3.6, F_antr_max-F_Fahrwiderstand)
    end
    
    

