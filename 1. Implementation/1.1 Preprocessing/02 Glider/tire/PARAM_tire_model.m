function [par_TIR, par_ASR] = PARAM_tire_model_SUV(tire_file_path, Segment, IP)
% load parameters from tire-files

% read tire parameters
% if changed, change Values in Input_Paramters and Reifen
if Segment == 'A'
    tire_file_front = '225_55_R17_b23__Goodyear_Excellence__MF52.tir';
    tire_file_rear =  '225_55_R17_b23__Goodyear_Excellence__MF52.tir';
    load('225_55_R17_b23__Goodyear_Excellence__MF52.mat');
    par_ASR.Schlupf = par_ASR.Schlupf./100;
elseif Segment == 'B'
    tire_file_front = '245_45_R18_b24__Dunlop_SP_Sport_3D_MuS__MF52.tir';
    tire_file_rear =  '245_45_R18_b24__Dunlop_SP_Sport_3D_MuS__MF52.tir';
    load('245_45_R18_b24__Dunlop_SP_Sport_3D_MuS__MF52.mat');
    par_ASR.Schlupf = par_ASR.Schlupf./100;
elseif Segment == 'C'
    tire_file_front = '245_45_R18_b24__Dunlop_SP_Sport_3D_MuS__MF52.tir';
    tire_file_rear =  '245_45_R18_b24__Dunlop_SP_Sport_3D_MuS__MF52.tir';
    load('245_45_R18_b24__Dunlop_SP_Sport_3D_MuS__MF52.mat');
    par_ASR.Schlupf = par_ASR.Schlupf./100;
elseif Segment == 'T'
    tire_file_front = '245_45_R19_b32__Tesla_Regression.tir';
    tire_file_rear  = '245_45_R19_b32__Tesla_Regression.tir';
    load('245_45_R19_b32__Tesla_Regression.mat');
    par_ASR.Schlupf = par_ASR.Schlupf./100;
end

par_TIR(1) = read_parameters(tire_file_front, tire_file_path);
par_TIR(2) = read_parameters(tire_file_rear, tire_file_path);

% save tire load index (needed for Michelin rolling resistance model)
par_TIR(1).LOADINDEX = 94;
par_TIR(2).LOADINDEX = 86;

% create needed coefficients for pressure model
for i = 1 : 2
    par_TIR(i).PIO = par_TIR(i).IP;                                         % [kPa] reference pressure
    par_TIR(i).PPX1 = -0.7333;
    par_TIR(i).PPX2 = 0;
    par_TIR(i).PPX3 = 0.0525;
    par_TIR(i).PPX4 = 0;
    par_TIR(i).PPY1 = 0.5101;
    par_TIR(i).PPY2 = 1.5804;
    par_TIR(i).PPY3 = -0.1092;
    par_TIR(i).PPY4 = 0;
    par_TIR(i).QPZ1 = 0.5213;
end

% set modified flag
par_TIR(1).MODIFIED = 0;
par_TIR(2).MODIFIED = 0;

end