function Start_Optimization(varargin)
% TOTEM - Topology Optimization Tool for Electric Mobility 
% ------------
% Created on 21 May 2019
% ------------
% For version: Matlab2018b
% ------------
% GOAL:
% TOTEM is a tool that allows for a topological optimization of 
% electric powertrains for passenger vehicles. 
% ------------
% AFFILIATION:
% The tool has been developed at the Institute for Automotive Technology 
% (FTM) at Technical University of Munich. (www.ftm.mw.tum.de) 
% ------------
% AUTHORS:
% The tool is part of the dissertation project by Christian Angerer who 
% initiated the project and led the development. It includes the 
% contribution of third party code (NSGA2-Implementation by Song Lin, 
% Copyright (c) 2011) as well as the work of theses and dissertations 
% by other students and colleagues. 
% The exact contribution of the code lines cannot be reproduced. 
% Nevertheless the following list mentions the main persons, that kindly 
% contributed to the overall tool: 
%     Arend, Julio
%     Bertele, Josef
%     Bügel, Joshua
%     Buß, Alexander
%     Chang, Fengqi
%     di Caro, Lorenzo
%     Eroglu, Isaak
%     Felgenhauer, Matthias
%     Gabriele, Stefano
%     Hillebrand, Simon
%     Holjevac, Nikola
%     Holtz, Andreas
%     Huber, Alexander
%     Klass, Vladislav
%     Lestoille, Guillaume
%     Lohse, Benedikt
%     Lübbers, Tim
%     Lüst, Moritz
%     Mantovani, Luca
%     Mildner, Alexander
%     Mößner, Benedikt
%     Schultze, Andreas
%     Tripps, Alexander
%     Tschochner, Maximilian
%     Valiyev, Mahammad
%     Zähringer, Maximlian
%     Zuchtriegel, Tobias
%     Wassiliadis, Nikolaos
% ------------
% INPUT:
%           - Mailnotification (choose 0 if no notification is wanted)
%           - Configuration front axle (1-4)
%           - Configuration rear axle  (1-4)
%               1 = no propulsion
%               2 = wheel individual motors 
%               3 = central motor 
%               4 = central motor with torque vectoring)
% ------------
% EXAMPLE
% Start_Optimization(0,1,3)
% --> Optimizes Rear-Wheel-Drive-Configurations with central Motor
% ------------
% Options:
% to adjust the settings (Design Variables, Objectives, Parallelization
% open the file Optimierung_Optionen.m


%% analyze inputs
Mailbenachrichtigung = varargin{1};
number_of_input_args=nargin;

%% prepare parallel computing and add paths
poolobj = gcp('nocreate');
delete(poolobj);
for i=1:32
    tmpdir = 'temp';
    tmpdir = strcat(tmpdir, num2str(i));
    if exist(tmpdir,'dir')
        rmdir(tmpdir, 's')
    end
end

addpath(genpath(cd))
warning('off','all')

%% Configure Optimization-Task and -Properties
Optimierung_Optionen;
Optimierung.Modus=1;
Optimierung.Cluster=options.Cluster_Mode;



%% Start Optimization
result = nsga2(options,Optimierung,ziele,opt,conf);            % begin the optimization!

%% finish Clusterlogging 
if options.Cluster_Mode ==1
    parallel_logging_cluster_closer
end

%% Mail-Notification it totalTime is higher than one hour
% if result.states(end).totalTime >3600 && Mailbenachrichtigung==1
%     recipients  =["angerer@ftm.mw.tum.de"];
%     subject='Optimization finished';
%     text='Die Optimierung ist fertiggestellt';
%     sendmail_from_totem(recipients, subject, text);
% end
