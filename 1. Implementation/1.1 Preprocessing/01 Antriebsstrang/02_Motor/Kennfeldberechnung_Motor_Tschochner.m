function [M_max_mot, MaxMotorTrqCurve_w, MaxMotorTrqCurve_M, MaxGeneratorTrqCurve_w, MaxGeneratorTrqCurve_M, MotorEffMap3D_w, MotorEffMap3D_M, MotorEffMap3D, GeneratorEffMap3D_w, GeneratorEffMap3D_M, GeneratorEffMap3D, n_nenn_rpm, E]...
    =Kennfeldberechnung_Motor_Tschochner(Mnenn_mot, nmax_rpm, typ_EM)
% loading and scaling efficiency maps and maximum torque curves 
% for the  electric motor

%Regressions for overload factors origin from Dissertation by Matthias
%Felgenhauer: "Automated Development of Modular Systems for Passenger Cars 
%within the Vehicle Front", Insititute for Automotive Technology, 
%Technical University of Munich, 2019
if strcmp(typ_EM, 'PSM')
    f_ueberlast=1.72; % from Dissertation Felgenhauer
elseif strcmp(typ_EM, 'ASM')
    f_ueberlast=2.65; % from Dissertation Felgenhauer
end


E = MotorScaling_PSMASM(typ_EM); %Motorobjekt initialisieren und laden

PeakSpeed_radps=nmax_rpm/60*2*pi; %Nennmoment in rad/s
n_nenn_radps=PeakSpeed_radps/2.062411;
n_nenn_rpm=n_nenn_radps/2/pi*60;
PeakPower_kW=Mnenn_mot*f_ueberlast*n_nenn_radps/1000; %Peakpower


E = Scale(E, PeakPower_kW, PeakSpeed_radps);
calc_Consumption(E);


%% Übergabe der Variablen 

M_max_mot =         max(E.MaxTrqLine.y_Nm);

MaxMotorTrqCurve_w= E.MaxTrqLine.x_radps; 
MaxMotorTrqCurve_M= E.MaxTrqLine.y_Nm;

MotorEffMap3D_w= transpose(E.EffGrid.xgs_radps(:,1));
MotorEffMap3D_M= E.EffGrid.ygs_Nm(1,   (size(E.EffGrid.ygs_Nm,2)/2+1):end);
MotorEffMap3D=   E.EffGrid.zgs_eff(:,  (size(E.EffGrid.ygs_Nm,2)/2+1):end);

MaxGeneratorTrqCurve_w= E.MinTrqLine.x_radps;
MaxGeneratorTrqCurve_M= -E.MinTrqLine.y_Nm;

GeneratorEffMap3D_w= transpose(E.EffGrid.xgs_radps(:,1));
GeneratorEffMap3D_M= E.EffGrid.ygs_Nm(1, 1:(size(E.EffGrid.ygs_Nm,2)/2));
GeneratorEffMap3D=1./E.EffGrid.zgs_eff(:, 1:(size(E.EffGrid.ygs_Nm,2)/2));