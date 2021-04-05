% Berechnet Geometrie-und Wirkungsgraddaten
function [z1_I, z2_II, z1_III, z2_III, z2_IV, zP_I_II, zP_III_IV, zVTV_1, zVTV_2, zVTV_3, zVTV_4, i12_I, i12_II, i12_III, i12_IV, iVTV_1, iVTV_2, eta12_I, eta12_II, eta12_III, eta12_IV, etaVTV_12, etaVTV_34] = GeometrieWKG_eTV(delta_M_max, M_Steuer, d_Rad, vzkonst)

mu = vzkonst.mu;
%% Variation der TV-Einheit laden
%Das maximale Differenzmoment ist delta_M_max = M_Steuer_max*i_tot.
%Die Variationen definieren sich über i_tot, also Rückrechnung:
i_tot_Wunsch = delta_M_max/M_Steuer;

% alte eTV Auslegung:
% if i_tot_Wunsch >= 48
%     x = 1;
% elseif i_tot_Wunsch >= 91
%     x = 2;
% elseif i_tot_Wunsch >= 126
%     x = 3;
% elseif i_tot_Wunsch >= 175
%     x = 4;              %Var7 (in create_Variations auskommentiert) wäre hier die Alternative mit kleinerer Vorstufe
% elseif i_tot_Wunsch >= 214
%     x = 5;
% elseif i_tot_Wunsch >= 246
%     x = 6;
% else
%     x = 0;
% end

% Übersetzung i_eTV wurde mit Metamodell fest auf 48.5 gesetzt, fällt also unter Fall 1; analog visio.m
x = 1; 
eval(['load Var' num2str(x) '.mat;']); 


%% Differential skalieren
[z2_IV, z1_III, z2_III, zP_III_IV] = scaleeTVDiff(d_Rad, vzkonst);
%% Berechnung der Standübersetzungen
i12_I = z2_II/z1_I;
i12_II = z2_II/z1_I;
i12_III = -z2_III/z1_III;
i12_IV = -z2_IV/z1_III;
iVTV_1 = zVTV_2/zVTV_1;
iVTV_2 = zVTV_4/zVTV_3;

%% Berechnen der Hv
%Vorstufe
Hv_VTV_12 = calchv(iVTV_1,zVTV_1,vzkonst);
Hv_VTV_34 = calchv(iVTV_2,zVTV_2,vzkonst);

% TV-Stufe
%Planet-Hohlrad (3x2x)
iPH_I_II = z2_II/zP_I_II;
Hv_PH_I_II = calchv(iPH_I_II,zP_I_II,vzkonst);
%Planet-Sonne(3x2x)
iPS_I_II = z1_I/zP_I_II;
z_Ritzel = min(z1_I,zP_I_II);
Hv_PS_I_II = calchv(iPS_I_II,z_Ritzel,vzkonst);

% Differentialstufe
%Planet-Abtriebssonne (3x) 
iPAS_III = z1_III/zP_III_IV;
z_Ritzel = min(z1_III,zP_III_IV);
Hv_PAS_III = calchv(iPAS_III,z_Ritzel,vzkonst);
%Planet-Planet (3x)
iPP = 1;
Hv_PP = calchv(iPP,zP_III_IV,vzkonst);
%Planet-Steuersonne (3x)
iPSS = z2_III/zP_III_IV;
z_Ritzel = min(z2_III, zP_III_IV);
Hv_PSS = calchv(iPSS,z_Ritzel,vzkonst);
%Planet-Hohlrad (3x)
iPH_III_IV = z2_IV/zP_III_IV;
Hv_PH_III_IV = calchv(iPH_III_IV,zP_III_IV,vzkonst);

%% Berechnen der einzelnen Verzahnungswirkungsgrade
etaVTV_12 = 1-mu*Hv_VTV_12;
etaVTV_34 = 1-mu*Hv_VTV_34;
wkg_vz_PH_I_II = 1-mu*Hv_PH_I_II;
wkg_vz_PS_I_II = 1-mu*Hv_PS_I_II;
wkg_vz_PAS_III = 1-mu*Hv_PAS_III;
wkg_vz_PP = 1-mu*Hv_PP;
wkg_vz_PSS = 1-mu*Hv_PSS;
wkg_vz_PH_III_IV = 1-mu*Hv_PH_III_IV;

%% Berechnen der Standwirkungsgrade aus den einzelnen Verzahnungswirkungsgraden
% TV-Stufe
eta12_I = wkg_vz_PS_I_II*wkg_vz_PH_I_II;
eta12_II = eta12_I;
% Differentialstufe
eta12_III = wkg_vz_PAS_III*wkg_vz_PP*wkg_vz_PSS*wkg_vz_PH_III_IV;
eta12_IV = eta12_III;

%% Ergebnisse gruppieren (Handhabbarkeit)
% z.z1_I = z1_I;
% z.z2_II = z2_II;
% z.z1_III = z1_III;
% z.z2_III = z2_III;
% z.z2_IV = z2_IV;
% z.zP_I_II = zP_I_II;
% z.zP_III_IV = zP_III_IV;
% z.zVTV_1 = zVTV_1;
% z.zVTV_2 = zVTV_2;
% z.zVTV_3 = zVTV_3;
% z.zVTV_4 = zVTV_4;
% 
% i.i12_I = i12_I;
% i.i12_II = i12_II;
% i.i12_III = i12_III;
% i.i12_IV = i12_IV;
% i.iVTV_1 = iVTV_1;
% i.iVTV_2 = iVTV_2;
% 
% eta.eta12_I = eta12_I;
% eta.eta12_II = eta12_II;
% eta.eta12_III = eta12_III;
% eta.eta12_IV = eta12_IV;
% eta.etaVTV_12 = etaVTV_12;
% eta.etaVTV_34 = etaVTV_34;

end