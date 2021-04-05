function par_VEH = spring_damper(par_VEH)
%%Feder- Dämpfer-Auslegung
% Source:
% C. Angerer, B. Mößner, M. Lüst, A. Holtz, F. Sträußl, und M. Lienkamp, 
% “Parameter-Adaption for a Vehicle Dynamics Model for the Evaluation 
% of Powertrain Concept Designs,” in International Conference on 
% New Energy Vehicle and Vehicle Engineering (NEVVE), Seoul, Korea, 2018.

%%Feder
%%Berechnung Achslast VA/HA
R_VA = 1 - (par_VEH.xSP / par_VEH.l);
R_HA = par_VEH.xSP / par_VEH.l;

%Berechnung Eigenfrequenzen Achsen
f_A = 1.4;

f_VA = (f_A^2/(R_VA + 1.3225 * R_HA))^(1/2);
f_HA = (f_A^2/(1/1.3225 * R_VA + R_HA))^(1/2);

omega_A  = 2*pi*f_A;
omega_VA = 2*pi*f_VA;
omega_HA = 2*pi*f_HA;

omega_VA = (omega_A^2/(R_VA + 1.3225 * R_HA))^(1/2);
omega_HA = (omega_A^2/(1/1.3225 * R_VA + R_HA))^(1/2);

%Berechnung Federsteifigkeit
par_VEH.csF = (omega_VA)^2 * R_VA * par_VEH.mss/2;
par_VEH.csR = (omega_HA)^2 * R_HA * par_VEH.mss/2;

%%Dämpfer
%Berechnung Dämpfungsmaße Achsen
D_A = 0.3;

D_VA =  (D_A * (par_VEH.csF*2 + par_VEH.csR*2)^(1/2))/...
        ((par_VEH.csF*2 * R_VA)^(1/2)+ 1.6 * (par_VEH.csR*2 * R_HA)^(1/2));
D_HA =  (D_A * (par_VEH.csF*2 + par_VEH.csR*2)^(1/2))/...
        (0.625 * (par_VEH.csF*2 * R_VA)^(1/2)+ (par_VEH.csR*2 * R_HA)^(1/2));

%Berechnung Dämpfungskonstanten Achsen
d_VA = 2 * D_VA * (par_VEH.csF*2 * R_VA * par_VEH.mss)^(1/2);
d_HA = 2 * D_HA * (par_VEH.csR*2 * R_HA * par_VEH.mss)^(1/2);    
    
%%Ausgabe Kompression Rebound
par_VEH.ddF_comp=  4/7*[-d_VA 0]/2;     %Dämpferrate vorn rebound in Ns/m
par_VEH.ddF_reb = 10/7*[-d_VA 0]/2;     %Dämpferrate vorn compression in Ns/m
par_VEH.ddR_comp=  4/7*[-d_HA 0]/2;     %Dämpferrate hinten compression in Ns/m
par_VEH.ddR_reb=  10/7*[-d_HA 0]/2;     %Dämpferrate hinten rebound in Ns/m
end

   
            
            
            
            
            
            
          
            
            
            
            
            

