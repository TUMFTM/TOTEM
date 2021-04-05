% Optimierung_Optionen configures all options that are available for the
% optimization:
% - environment / calculation method (local, cluster, parallelized, ...)
% - population and maximum number of generations 
% - considered design-variables and their upper and lower boundaries
% - objectives
% - boundary conditions
% - objective function
% see readme.md for more details


%% Options
% Bei nsgaopt() können die Algorithmuseinstellungen geändert werden

options = nsgaopt();

%% maximum number of Generations und Population-Size

options.popsize = 4; % population size
options.maxGen = 3; % max generation

%% Parallelization

options.useParallel = 'no'; % parallelisation(yes/no)
options.poolsize = 4; % number of pools

%% Cluster Configuration 
if strcmp(options.useParallel, 'yes')
    Optimierung.linux_paths=1;
else
    Optimierung.linux_paths=1;
end
options.Cluster_Mode = 0;
options.ClusterName='FTM'
if(options.Cluster_Mode == 1)
    switch options.ClusterName
        case char('FTM')
            Optimierung.linux_paths=1;
            options.c = parcluster('SlurmFlex32');
            disp(['Logs werden gespeichert unter ', options.c.JobStorageLocation])
        case char('LRZ')
            Optimierung.linux_paths=1;
            time_mins = ((ceil((options.popsize)/(options.poolsize)))) * options.maxGen * 5 + 60;
            hours = floor(time_mins/60);
            mins =  mod(time_mins, 60);
            if(hours < 10)
                hours_str = strcat('0', num2str(hours));
            else
                hours_str = num2str(hours);
            end
            if(mins < 10)
                mins_str = strcat('0', num2str(mins));
            else
                mins_str = num2str(mins);
            end
            wallTimeStr = strcat(strcat(strcat(hours_str, ':'), mins_str), ':00')
            configCluster;
            options.c = parcluster('coolmuc local R2018b');
            disp(['Logs werden gespeichert unter ', options.c.JobStorageLocation])
            options.c.AdditionalProperties.WallTime = wallTimeStr;
            options.c.AdditionalProperties.ProcsPerNode = 8;
    end
end
%% Mail-Notification
% in case of computationally expensive optimization runs the
% Mail-Notification can update you about an error or tells you when the run
% is finished.
opt.Mailbenachrichtigung.enabled=Mailbenachrichtigung;
opt.Mailbenachrichtigung.recipients=[ "test@google.com"];
if(options.Cluster_Mode == 1) % Outbox-Server is locked on the developpers' Cluster
    opt.Mailbenachrichtigung.enabled=0;
end

%% Start logging of parallel calculation processes 
if(options.Cluster_Mode == 0) % am Cluster kann nicht ohne weiteres geloggt werden laut Matlabaussage
    parallel_logging
elseif options.Cluster_Mode ==1
    parallel_logging_cluster_opener
end

%% Designvariables with lower and upper boundaries

% 1: Configuration Front axle 
%   1 no Propulstion
%   2 wheel-individueal propulstion
%   3 centered propulsion with open differential 
%   4 centered propulsion with torque-vectoring differentail
VA = 1; switch VA
    case 0; lb_VA = 3; ub_VA = 3; 
        if number_of_input_args==3
            lb_VA=varargin{2};
            ub_VA=varargin{2};       
        end
        opt.name_1 = num2str(lb_VA); conf = 1;   % bei 0 muss Konfiguration eingestellt werden!!!
    case 1; lb_VA = 1; ub_VA = 4; conf = 0;   end
   
% 1: Configuration rear axle (values are the same as for front axle)
HA = 1; switch HA
    case 0; lb_HA = 4; ub_HA = 4; 
        if number_of_input_args==3
            lb_HA=varargin{3};
            ub_HA=varargin{3};       
        end
        opt.name_2 = num2str(lb_HA); conf = 1;  % bei 0 muss Konfiguration eingestellt werden!!!
    case 1; lb_HA = 1; ub_HA = 4; conf = 0;   end
    
% 3: Motor-type front axle
E_Maschine_VA = 1; switch E_Maschine_VA
    case 0; lb_E_Maschine_VA = 2; ub_E_Maschine_VA = 2;  % bei 0 muss Konfiguration eingestellt werden!!!
    case 1; lb_E_Maschine_VA = 1; ub_E_Maschine_VA = 2; end
% 4: Motor-type rear axle
E_Maschine_HA = 1; switch E_Maschine_HA
    case 0; lb_E_Maschine_HA = 2; ub_E_Maschine_HA = 2;  % bei 0 muss Konfiguration eingestellt werden!!!
    case 1; lb_E_Maschine_HA = 1; ub_E_Maschine_HA = 2; end
% 5: Number of gear front axle
Gaenge_VA = 1; switch Gaenge_VA
    case 0; lb_Gange_VA = 1; ub_Gaenge_VA = 1;   % bei 0 muss Konfiguration eingestellt werden!!!
    case 1; lb_Gange_VA = 1; ub_Gaenge_VA = 2;  end
% 6: Number of gears rear axle
Gaenge_HA = 1; switch Gaenge_HA
    case 0; lb_Gange_HA = 1; ub_Gaenge_HA = 1;   % bei 0 muss Konfiguration eingestellt werden!!!
    case 1; lb_Gange_HA = 1; ub_Gaenge_HA = 2;  end
    
% 7: nom. torque of front axle motor
NennM_VA = 1; lb_NennM_VA = 40; ub_NennM_VA = 300;
% 8: max. speed of front axle motor
nmax_VA = 1; lb_nmax_VA = 10000; ub_nmax_VA = 16000;
% 9: torque-difference of torque-vectoring: 
% NOT USED IN OPTIMIZATION, NOT VALIDATED!
diffM_VA = 1; lb_diffM_VA = 576; ub_diffM_VA = 576; 
% 10: 1st gear transmission ratio front axle 
i_VA = 1; lb_i_VA = 7; ub_i_VA = 16;
% 11: ratio between 1st and 2nd gear ratio (dt. Spreizung) at front axle 
Spreizung_VA = 1; lb_Spreizung_VA = 1.25; ub_Spreizung_VA = 5;

% 12 nom. torque of rear axle motor
NennM_HA = 1; lb_NennM_HA = 40; ub_NennM_HA = 300;
% 13: max. speed of rear axle motor
nmax_HA = 1; lb_nmax_HA = 10000; ub_nmax_HA = 16000;
% 14: torque-difference of torque-vectoring: 
% NOT USED IN OPTIMIZATION, NOT VALIDATED!
diffM_HA = 1; lb_diffM_HA = 576; ub_diffM_HA = 576;
% 15: 1st gear transmission ratio rear axle 
i_HA = 1; lb_i_HA = 7; ub_i_HA = 16;
% 16: ratio between 1st and 2nd gear ratio (dt. Spreizung) at rear axle 
Spreizung_HA = 1; lb_Spreizung_HA = 1.25; ub_Spreizung_HA = 5;

opt.vektor_design = [VA, HA, E_Maschine_VA, E_Maschine_HA, Gaenge_VA, Gaenge_HA, NennM_VA, nmax_VA, diffM_VA, i_VA, Spreizung_VA, NennM_HA, nmax_HA,  ...
    diffM_HA, i_HA, Spreizung_HA];

% lower boundaries of all Design-Variables
opt.lb = [lb_VA, lb_HA, lb_E_Maschine_VA, lb_E_Maschine_HA, lb_Gange_VA, lb_Gange_HA, lb_NennM_VA, lb_nmax_VA, ...
    lb_diffM_VA, lb_i_VA, lb_Spreizung_VA, ...
    lb_NennM_HA, lb_nmax_HA, ...
    lb_diffM_HA, lb_i_HA, lb_Spreizung_HA];

% upper boundaries of all Design-Variables
opt.ub = [ub_VA, ub_HA, ub_E_Maschine_VA, ub_E_Maschine_HA, ub_Gaenge_VA, ub_Gaenge_HA, ub_NennM_VA, ub_nmax_VA, ...
    ub_diffM_VA, ub_i_VA, ub_Spreizung_VA, ...
    ub_NennM_HA, ub_nmax_HA, ...
    ub_diffM_HA, ub_i_HA, ub_Spreizung_HA]; 

lb_ =zeros(1,length(opt.vektor_design));
for i=1:length(opt.vektor_design)
    if opt.vektor_design(i) == 0
        lb_(i) = (opt.lb(i)+opt.ub(i))/2;
        opt.ub(i) = (opt.lb(i)+opt.ub(i))/2;
        opt.lb(i) = lb_(i);
    end
end

opt.design_nummer = find(opt.vektor_design);
options.lb = opt.lb(opt.design_nummer);
options.ub = opt.ub(opt.design_nummer);

% number of Design Variables
options.numVar = VA+HA+E_Maschine_VA+E_Maschine_HA+Gaenge_VA+Gaenge_HA+NennM_VA+NennM_HA+nmax_VA+nmax_HA ...
+diffM_VA+diffM_HA ...
+i_VA+i_HA+Spreizung_VA+Spreizung_HA;

%% Objectives

Optimierung_Fahrdynamik = 0;
Optimierung_Verbrauch   = 1;
Optimierung_Kosten      = 1;
Optimierung_Quer_stat   = 0;
Optimierung_Quer_instat = 0;
Optimierung_Laengs_Quer = 0;
Optimierung_Laengs      = 0;
Optimierung_Offroad     = 0;
Optimierung_vmax        = 0;

% Anzahl der Optimierungsziele
options.numObj = Optimierung_Fahrdynamik+Optimierung_Verbrauch+Optimierung_Kosten+Optimierung_Quer_stat+Optimierung_Quer_instat+Optimierung_Laengs_Quer+Optimierung_Laengs+Optimierung_Offroad+Optimierung_vmax;
ziele = 1:9;
opt.test_vektor_opt=[Optimierung_Fahrdynamik, Optimierung_Verbrauch, Optimierung_Kosten, Optimierung_Quer_stat, Optimierung_Quer_instat, Optimierung_Laengs_Quer, Optimierung_Laengs,  Optimierung_Offroad, Optimierung_vmax];
r_opt=find(opt.test_vektor_opt);
ziele=ziele(r_opt);
    
%% boundary conditions
% Anzahl der Nebenbedingungen
options.numCons = 1; % number of constraints

%% objective function

options.objfun = @Objective_Function; %objective function handle

%% initial Population
% use this if you want to start with a certain set of start-population
% instead of randomly generating your start population

% if lb_VA==3 && lb_HA==3 && options.numObj==3 
%     load('33_start_population.mat');
%     options.initfun = {@initpop, result};
% end

%% further properties
% Intervall (Generationen) zwischen 2 Aufrufen der integrierten Ergebnisplot-Funktion

options.plotInterval = 1; % interval between two calls of "plotnsga"

% distinguishing discrete and continuous design variables
vartype = [2 2 2 2 2 2 1 1 1 1 1 1 1 1 1 1 1 1 1 1];
vartype = vartype(opt.design_nummer);
options.vartype = vartype;

%% deletion of unneccessary variables

clear VA HA E_Maschine_VA E_Maschine_HA Gaenge_VA Gaenge_HA NennM_VA NennM_HA nmax_VA nmax_HA nnenn_VA ...
nnenn_HA NennSteuer_VA NennSteuer_HA nmax_Steuer_VA nmax_Steuer_HA nnenn_Steuer_VA nnenn_Steuer_HA diffM_VA diffM_HA ...
i_VA i_HA Spreizung_VA Spreizung_HA Progression_VA Progression_HA lb_VA lb_HA lb_E_Maschine_VA lb_E_Maschine_HA ... 
lb_Gange_VA lb_Gange_HA lb_NennM_VA lb_nmax_VA lb_nnenn_VA lb_NennSteuer_VA lb_nmax_Steuer_VA lb_nnenn_Steuer_VA ... 
lb_diffM_VA lb_i_VA lb_Spreizung_VA lb_Progression_VA lb_NennM_HA lb_nmax_HA lb_nnenn_HA lb_NennSteuer_HA ...
lb_nmax_Steuer_HA lb_nnenn_Steuer_HA lb_diffM_HA lb_i_HA lb_Spreizung_HA lb_Progression_HA ub_VA ub_HA ub_E_Maschine_VA ...
ub_E_Maschine_HA ub_Gaenge_VA ub_Gaenge_HA ub_NennM_VA ub_nmax_VA ub_nnenn_VA ub_NennSteuer_VA ub_nmax_Steuer_VA ...
ub_nnenn_Steuer_VA ub_diffM_VA ub_i_VA ub_Spreizung_VA ub_Progression_VA ub_NennM_HA ub_nmax_HA ub_nnenn_HA ub_NennSteuer_HA ...
ub_nmax_Steuer_HA ub_nnenn_Steuer_HA ub_diffM_HA ub_i_HA ub_Spreizung_HA ub_Progression_HA test_vektor_design r_design ...
test_vektor_opt r_opt lb_
