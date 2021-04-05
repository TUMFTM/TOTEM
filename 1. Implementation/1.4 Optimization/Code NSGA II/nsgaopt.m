function defaultopt = nsgaopt()
% Function: defaultopt = nsgaopt()
% Description: Create NSGA-II default options structure.
% Syntax:  opt = nsgaopt()
%         LSSSSWC, NWPU
%   Revision: 1.3  Data: 2011-07-13
%*************************************************************************


defaultopt = struct(...
... % Optimization model
... % Populationsgröße
    'popsize', 50,...    % population size
... % Anzahl maximaler Generationen
    'maxGen', 30,...     % maximum generation
... % Anzahl der Design-Variablen
    'numVar', 26,...     % number of design variables
... % Anzahl der Optimierungsziele
    'numObj', 3,...      % number of objectives
... % Anzahl der Nebenbedingungen
    'numCons', 0,...     % number of constraints
... % Untere Intervallgrenzen aller Design-Variablen (Die Anordnung der
... % Design-Variablen kann dem pdf "00_Informationen_und_Hinweise" im Ordner
... % "Optimierung" entnommen werden)
    'lb', [1 1 1 1 1 1 40 10000 2000 0 5 1.25 0.81 40 10000 2000 0 5 1.25 0.81],...       % lower bound of design variables [1:numVar]
... % Obere Intervallgrenzen aller Design-Variablen (Die Anordnung der
... % Design-Variablen kann dem pdf "00_Informationen_und_Hinweise" im Ordner
... % "Optimierung" entnommen werden)
    'ub', [3 3 2 2 3 3 300 16000 7000 2250 15 5 1.19 300 16000 7000 2250 15 5 1.19],... % upper bound of design variables [1:numVar]
... % Mit 'vartype' wird festgelegt, ob eine Design-Variable diskret oder
... % kontinuierlich vorliegt. (2: diskret; 1: kontinuierlich)
    'vartype', [2 2 2 2 2 2 1 1 1 1 1 1 1 1 1 1 1 1 1 1],...           % variable data type [1:numVar]£¬1=real, 2=integer
... % Zugrunde liegendes Simulationsmodell, das die Zielfunktionswerte berechnet
    'objfun', @Optimierung_Zweispurmodell,...       % objective function
... % Optimization model components' name
    'nameObj',{{}},...
    'nameVar',{{}},...
    'nameCons',{{}},...
... % Initialization and output
    'initfun', {{@initpop}},...         % population initialization function (use random number as default)
    'outputfuns',{{@output2file}},...   % output function
    'outputfile', 'populations.txt',... % output file name
    'outputInterval', 1,...             % interval of output
    'plotInterval', 5,...               % interval between two call of "plotnsga".
... % Genetic algorithm operators
... % Festlegen des Crossoverfaktors (nur 'intermediate crossover' möglich)
    'crossover', {{'intermediate', 0.75}},...   % crossover operator
... % Festlegen des Skalierungsfaktors der initialen Generation (erster
... % Wert) und der Schrumpfung (zweiter Wert)
    'mutation', {{'gaussian',1.0, 1.0}},...     % mutation operator
... % Crossoverwahrscheinlichkeit (Bei der Default-Einstellung 'auto'
... % beträgt die Crossoverwahrscheinlichkeit 2/numVar.)
    'crossoverFraction', 0.9, ...               % crossover fraction of variables of an individual
... % Mutationswahrscheinlichkeit (Bei der Default-Einstellung 'auto'
... % beträgt die Mutationswahrscheinlichkeit 2/numVar.)
    'mutationFraction', 'auto',...              % mutation fraction of variables of an individual
... % Algorithm parameters (Einstellungen zur Parallelisierung der Optimierung)
    'useParallel', 'no',...                     % compute objective function of a population in parallel. {'yes','no'}
    'poolsize', 1,...                           % number of workers use by parallel computation, 0 = auto select.
... % R-NSGA-II parameters
    'refPoints', [],...                         % Reference point(s) used to specify preference. Each row is a reference point.
    'refWeight', [],...                         % weight factor used in the calculation of Euclidean distance
    'refUseNormDistance', 'front',...           % use normalized Euclidean distance by maximum and minumum objectives possiable. {'front','ever','no'}
    'refEpsilon', 0.001 ...                     % parameter used in epsilon-based selection strategy
);



