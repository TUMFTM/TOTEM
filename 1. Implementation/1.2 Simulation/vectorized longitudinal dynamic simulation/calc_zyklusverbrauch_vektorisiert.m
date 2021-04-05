function consumption =calc_zyklusverbrauch_vektorisiert(par_MDT, par_VEH, par_TIR, Automatisierter_Aufruf, samplerate, Optimierung)
% vectorized consumption-calculation 
% for Matlab 2018b
% authored by Christian Angerer in 2018
% Institute for Automotive Technology 
% Technical University of Munich


Kennfeldbasiert=0;  % Auswahl ob die berechnung auf einem a-v-verbrauchskennfeld 
                    % basieren soll oder der Zyklus normal berechnet werden soll

task=4;             %1 WLTP
                    %2 NEFZ
                    %3 Validierungszyklus Tesla (Hinfahrt05)
                    
if Automatisierter_Aufruf == 1
    task=4;
end



        
switch task
    case 1
        load('WLTP_class_3_refined_incl_acc.mat')
        samplerate=0.1;
        dc_grob=Zeitschritt_zyklus_aendern(samplerate, dc);
        dc=dc_grob;
        initialize_vehicle_Tesla_aus_initialisierung_fuer_Zyklus;
%         initialize_vehicle_Tesla_aus_initialisierung_fuer_Zyklus_RWD;
        par_MDT.VA.em.E_Motorobject=E;
        par_MDT.HA.em.E_Motorobject=E;
    case 2
        load('maneuver/Zyklen/EUROPE_NEDC.mat')
        create_acc_vector;
        initialize_vehicle_Tesla_aus_initialisierung_fuer_Zyklus;
        par_MDT.VA.em.E_Motorobject=E;
        par_MDT.HA.em.E_Motorobject=E;
    case 3
%       load('Hinfahrt5_mit_Hoehe_und_acc.mat')
        samplerate=0.1;
%       dc_grob=Zeitschritt_zyklus_aendern(samplerate, dc);
%       dc=dc_grob;        
        load('maneuver/Zyklen/Hinfahrt5_mit_Hoehe_inclination_und_acc_10Hz.mat')
        inclination=dc.inclination;
        initialize_vehicle_Tesla_aus_initialisierung_fuer_Validierung;
        par_MDT.VA.em.E_Motorobject=E;
        par_MDT.HA.em.E_Motorobject=E;
    case 4 % Optimierung
        initialize_vehicle_Tesla_aus_initialisierung_fuer_Optimierung; 
        if Optimierung.linux_paths == 1
            if samplerate==1
                load('./../1.2 Simulation/simulation tasks and cycles/driving cycles/WLTP_Schrittweite_1Hz.mat')
            elseif samplerate==0.1
                load('./../1.2 Simulation/simulation tasks and cycles/driving cycles/WLTP_Schrittweite_10Hz.mat')
%                 load('./../maneuver/Zyklen/120kmh_konstantfahrt_10Hz.mat') %aktivieren um 120 km/h Konstantfahrt zu simulieren
            end
        else 
            if samplerate==1
                load('1.2 Simulation/simulation tasks and cycles/driving cycles/WLTP_Schrittweite_1Hz.mat')
            elseif samplerate==0.1
                load('1.2 Simulation/simulation tasks and cycles/driving cycles/WLTP_Schrittweite_10Hz.mat')
%                 load('maneuver/Zyklen/120kmh_konstantfahrt_10Hz.mat') %aktivieren um 120 km/h Konstantfahrt zu simulieren
            end
        end
        dc=Zeitschritt_zyklus_aendern(samplerate, dc);
     
end    

load('backwards_tire_model.mat') 
% Backward Tire Modell
% Metamodel representing the longitudinal slip in dependence on
% normal and longitudinal force (assuming lateral force is zero)
% Meta-Model is based on the tiremodel: 245_45_R19_b32__Tesla_Regression

if Kennfeldbasiert
    velocitystep=1;
    accstep=0.25;
    velocity_vec=transpose(0:velocitystep:50);
    acceleration_vec=-9:accstep:9;
    v=velocity_vec*ones(size(acceleration_vec));
    a=ones(size(velocity_vec))*acceleration_vec;
    vel_lin=reshape(v, numel(v),1);
    acc_lin=reshape(a, numel(a),1);
else
    acc_lin=dc.acc;
    vel_lin=dc.speed;
    t=dc.time;
end
 


%% Berechnung
if ~Automatisierter_Aufruf
tic
end


if kein_Antrieb_VA | kein_Antrieb_HA        % Topologien mit einer angetriebenen Achse
    if  kein_Antrieb_VA                     % Heckantrieb
        torquesplit=0;  
        i_Getriebe_VA=10;
        eta_Getriebe_VA=1;
    elseif kein_Antrieb_HA                  % Frontantrieb
        torquesplit=1;        
        i_Getriebe_HA=10;
        eta_Getriebe_HA=1;
    end
else                                        % Topologien mit zwei Angetriebenen Achsen
    torquesplit=[0:0.01:1];
end

    
F_inertia=acc_lin.*m_red;
F_aero=0.5*cw*rho*A*vel_lin.^2;

if task==3
    F_Steigung=mass.*g.*inclination.*sign(abs(vel_lin));
    F_Rollreibung=mass*g*c_RR*sign(abs(vel_lin)).*(1-dc.inclination);
else
    F_Steigung=0*F_aero;
    F_Rollreibung=mass*g*c_RR*sign(abs(vel_lin));
end
F_antr=F_inertia+F_aero+F_Rollreibung+F_Steigung;

F_antr_v=F_antr*torquesplit;
F_antr_h=F_antr*(1-torquesplit);
[vec_line, vec_col]=size(F_antr_v);
Fz_v=  (0.5*mass*(g*lh-acc_lin*z_SP)/l)*ones(1,size(F_antr_v,2));
Fz_h=  ((0.5*mass*g-Fz_v));

kappa_v=       sign(F_antr_v).* kappa_metamodel(Fz_v, abs(F_antr_v));
kappa_h=       sign(F_antr_h).* kappa_metamodel(Fz_h, abs(F_antr_h));

[r_rad_stat_v, r_rad_dyn_v]=   calc_radradius_stat(Fz_v, c_z_reifen, r_rad_0);
[r_rad_stat_h, r_rad_dyn_h]=   calc_radradius_stat(Fz_h, c_z_reifen, r_rad_0);

w_rad_v=((vel_lin*ones(1, vec_col))./r_rad_dyn_v).*(1+kappa_v);
w_rad_h=((vel_lin*ones(1, vec_col))./r_rad_dyn_h).*(1+kappa_h);

M_rad_v=F_antr_v.*r_rad_stat_v;
M_rad_h=F_antr_h.*r_rad_stat_h;

    if  length(i_Getriebe_VA)==1 && length(i_Getriebe_HA)==1
        M_mot_v=(M_rad_v/i_Getriebe_VA)./eta_Getriebe_VA.^sign(M_rad_v);
        w_mot_v=w_rad_v*i_Getriebe_VA;

        M_mot_h=(M_rad_h/i_Getriebe_HA)./eta_Getriebe_HA.^sign(M_rad_h);
        w_mot_h=w_rad_h*i_Getriebe_HA;

        P_mot_el_v = lookup_em_consumption(par_MDT.VA.em.E_Motorobject, w_mot_v, M_mot_v, par_MDT.VA.akt.az).*not(kein_Antrieb_VA);
        P_mot_el_h = lookup_em_consumption(par_MDT.HA.em.E_Motorobject, w_mot_h, M_mot_h, par_MDT.HA.akt.az).*not(kein_Antrieb_HA);

        P_el_mot=P_mot_el_v+P_mot_el_h;
        [P_el_mot_min,I]=nanmin(P_el_mot,[],2);


    elseif length(i_Getriebe_VA)==2 && length(i_Getriebe_HA)==1
        M_mot_v_g1=(M_rad_v/i_Getriebe_VA(1))./eta_Getriebe_VA(1).^sign(M_rad_v);
        w_mot_v_g1=w_rad_v*i_Getriebe_VA(1);
        M_mot_v_g2=(M_rad_v/i_Getriebe_VA(2))./eta_Getriebe_VA(2).^sign(M_rad_v);
        w_mot_v_g2=w_rad_v*i_Getriebe_VA(2);
        M_mot_v=[M_mot_v_g1, M_mot_v_g2];
        w_mot_v=[w_mot_v_g1, w_mot_v_g2];

        M_mot_h=(M_rad_h/i_Getriebe_HA)./eta_Getriebe_HA.^sign(M_rad_h);
        w_mot_h=w_rad_h*i_Getriebe_HA;

        P_mot_el_v = lookup_em_consumption(par_MDT.VA.em.E_Motorobject, w_mot_v, M_mot_v, par_MDT.VA.akt.az).*not(kein_Antrieb_VA);
        P_mot_el_h = lookup_em_consumption(par_MDT.HA.em.E_Motorobject, w_mot_h, M_mot_h, par_MDT.HA.akt.az).*not(kein_Antrieb_HA);


        P_mot_el_h=[P_mot_el_h, P_mot_el_h];

        P_el_mot=P_mot_el_v+P_mot_el_h;
        [P_el_mot_min,I]=nanmin(P_el_mot,[],2);

    elseif length(i_Getriebe_VA)==1 && length(i_Getriebe_HA)==2
        M_mot_v=(M_rad_v/i_Getriebe_VA)./eta_Getriebe_VA.^sign(M_rad_v);
        w_mot_v=w_rad_v*i_Getriebe_VA;

        M_mot_h_g1=(M_rad_h/i_Getriebe_HA(1))./eta_Getriebe_HA(1).^sign(M_rad_h);
        w_mot_h_g1=w_rad_h*i_Getriebe_HA(1);
        M_mot_h_g2=(M_rad_h/i_Getriebe_HA(2))./eta_Getriebe_HA(2).^sign(M_rad_h);
        w_mot_h_g2=w_rad_h*i_Getriebe_HA(2);
        M_mot_h=[M_mot_h_g1, M_mot_h_g2];
        w_mot_h=[w_mot_h_g1, w_mot_h_g2];

        P_mot_el_v = lookup_em_consumption(par_MDT.VA.em.E_Motorobject, w_mot_v, M_mot_v, par_MDT.VA.akt.az).*not(kein_Antrieb_VA);
        P_mot_el_h = lookup_em_consumption(par_MDT.HA.em.E_Motorobject, w_mot_h, M_mot_h, par_MDT.HA.akt.az).*not(kein_Antrieb_HA);

        P_mot_el_v=[P_mot_el_v, P_mot_el_v];

        P_el_mot=P_mot_el_v+P_mot_el_h;
        [P_el_mot_min,I]=nanmin(P_el_mot,[],2);

    elseif length(i_Getriebe_VA)==2 && length(i_Getriebe_HA)==2
        M_mot_v_g1=(M_rad_v/i_Getriebe_VA(1))./eta_Getriebe_VA(1).^sign(M_rad_v);
        w_mot_v_g1=w_rad_v*i_Getriebe_VA(1);
        M_mot_v_g2=(M_rad_v/i_Getriebe_VA(2))./eta_Getriebe_VA(2).^sign(M_rad_v);
        w_mot_v_g2=w_rad_v*i_Getriebe_VA(2);
        M_mot_v=[M_mot_v_g1, M_mot_v_g2, M_mot_v_g1, M_mot_v_g2];
        w_mot_v=[w_mot_v_g1, w_mot_v_g2, w_mot_v_g1, w_mot_v_g2];

        M_mot_h_g1=(M_rad_h/i_Getriebe_HA(1))./eta_Getriebe_HA(1).^sign(M_rad_h);
        w_mot_h_g1=w_rad_h*i_Getriebe_HA(1);
        M_mot_h_g2=(M_rad_h/i_Getriebe_HA(2))./eta_Getriebe_HA(2).^sign(M_rad_h);
        w_mot_h_g2=w_rad_h*i_Getriebe_HA(2);
        M_mot_h=[M_mot_h_g1, M_mot_h_g2, M_mot_h_g2, M_mot_h_g1];
        w_mot_h=[w_mot_h_g1, w_mot_h_g2, w_mot_h_g2, w_mot_h_g1];

        P_mot_el_v = lookup_em_consumption(par_MDT.VA.em.E_Motorobject, w_mot_v, M_mot_v, par_MDT.VA.akt.az).*not(kein_Antrieb_VA);
        P_mot_el_h = lookup_em_consumption(par_MDT.HA.em.E_Motorobject, w_mot_h, M_mot_h, par_MDT.HA.akt.az).*not(kein_Antrieb_HA);


        P_el_mot=P_mot_el_v+P_mot_el_h;
        [P_el_mot_min,I]=nanmin(P_el_mot,[],2);

    end



P_el_batt=P_el_mot./eta_batt.^(sign(P_el_mot))+ones(size(P_el_mot)).*P_auxiliaries;
[P_el_batt_min,I]=nanmin(P_el_batt,[],2);

if Kennfeldbasiert
    toc
    tic
    Verbrauchskennfeld=reshape(P_el_batt_min, [length(velocity_vec), length(acceleration_vec)]);
    P_el_batt_min=interpn(v, a, Verbrauchskennfeld, abs(dc.speed), dc.acc);
end

if ~Automatisierter_Aufruf
    toc
end

P_Fahr=F_antr.*vel_lin;

% calculate consumption 
weg=sum(dc.speed)*samplerate;
E_el_Batt=sum(P_el_batt_min)*samplerate;
consumption=E_el_Batt/1000/3600/(weg/1000/100);



%% plot
if Automatisierter_Aufruf~=1
    
    

    
switch task
    case 1
        disp(['---- Ergebnisse WLTP-Zyklus:  ----'])
    case 2
        disp(['---- Ergebnisse NEFZ-Zyklus:  ----'])
    case 3
        disp(['---- Ergebnisse Validierungs-Zyklus:  ----'])
    case 4
        disp(['---- Ergebnisse WLTP-Zyklus:  ----'])
end 

disp(['Gefahrene Strecke:    ', num2str(weg/1000), ' km'])
disp(['Verbrauchte Energie:  ', num2str(E_el_Batt/1000/3600), ' kWh'])
disp(['durchschn. Verbrauch: ', num2str(consumption), ' kWh/100km'])


    


    figure(29)

    ax1=subplot(3,2,1);
    plot(t,vel_lin.*3.6)
    grid on
    ylabel('geschw in kmh')

    ax2=subplot(3,2,2);
    cla
    plot(t,acc_lin)
    grid on
    ylabel('beschleunigung in m/s^2')

    ax3=subplot(3,2,3);
    cla
    hold on

    plot(t,P_Fahr./1000, 'r')
    plot(t,P_el_mot_min./1000, 'b')
    plot(t,P_el_batt_min./1000, 'k')
    P_mech_mot=(w_mot_v.* M_mot_v)+(w_mot_h.* M_mot_h);
    for i=1:size(P_mech_mot,2)
    plot(t,P_mech_mot(:,i)./1000)
    end

    legend('Fahrleistung', 'el. Motorleistung', 'Batterieleistung', 'mech. Motorleistung')
    grid on


    ax4=subplot(3,2,4);
    cla
    hold on
    plot(t,I)
    ylabel('powersplitfaktor')
    grid on

    ax5=subplot(3,2,5);
    cla
    hold on
    plot(t,F_antr_v,'r')
    plot(t,F_antr_h,'k')
    grid on
    ylabel('F antrieb v und h in N')

    ax6=subplot(3,2,6);
    cla
    hold on
    for i=1:size(P_el_mot,2)
    plot(t,P_el_mot(:,i)./1000)
    plot(t,P_el_batt(:,i)./1000)
    end

    grid on
    ylabel('P el,mot')

    linkaxes([ax1, ax2, ax3, ax4, ax5, ax6], 'x')

end



