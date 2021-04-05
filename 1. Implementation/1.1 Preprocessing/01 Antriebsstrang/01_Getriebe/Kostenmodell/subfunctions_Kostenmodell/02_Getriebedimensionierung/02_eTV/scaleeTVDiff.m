function [z2_IV, z1_III, z2_III, zP_III_IV] = scaleeTVDiff(d_Rad,vzkonst)
%Auf Grundlage des Durchmessers des letzten Abtriebszahnrades des Getriebes
%wird die Skalierung des eTV abgeschätzt.
mod_Diff = vzkonst.mod_eTV_DiffE;
%Hohlrad 2IV
d2_IV = -0.8175*d_Rad; %Faktor auf Basis Visio.M
z2_IV = 2*(floor(d2_IV/mod_Diff*2));  %auf nächste ganze gerade Zahl abrunden
%Sonne III (=Sonne IV): für Differentialfunktion muss das Verhältnis 2 sein
z1_III = -0.5*z2_IV;
%Zweite Sonne III: Abgeschätzt aus dem Verhältnis im Visio.M
z2_III = 2*(ceil((39/36)*z1_III*0.5)); %auf nächste gerade Zahl aufrunden -> Planet tendenziell kleiner
%Jetzt sind die Planeten fest (geometrische Bedingung ohne
%Profilverschiebung)
zP_III_IV = 0.5*(-z2_IV-z1_III);
end  