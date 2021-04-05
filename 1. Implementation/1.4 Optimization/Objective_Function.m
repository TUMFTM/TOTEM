function [y, cons, extra] = Objective_Function(x, gen, ind, varargin)
% Objective function : Test problem 'CONSTR'.
%*************************************************************************

% Erzeugen benötigter Variablen
% In der Variable 'y' werden die Zielfunktionswerte abgespeichert.
ziele = varargin{2};
opt = varargin{3};
y = zeros(1,length(ziele));
% In der Variable 'cons' werden etwaige Nebenbedingungsverletzungen
% abgespeichert.
cons = [0];

% Variablen so mit Werten belegen, dass Optimierung ablaufen kann. Dies ist
% nötig, da das Gesamtfahrzeumodell auch mit der Eingabemaske gestartet
% werden kann.
Neues_Fahrzeug = 0;
Neues_Fahrzeug_Speichern = 0;
Vorhandene_Konfiguration = 0;
Optimierung = varargin{1};

% Im Skript 'Umbenennung_Design_Variablen' werden den vom Optimierer
% erstellten Design-Variablen im Vektor 'x' die Namen der Design-Variabelen
% des Gesamtfahrzeugmodells zugeordnet. Außerdem werden dort beispielsweise
% auch die Übersetzungen der Gänge 2 und 3 mit Hilfe der Getriebespreizung
% und des Progressionsfaktors berechnet.
Rename_Design_Variables;

% Überprüfung der Eingangvariablen

case_Konfiguration = (Konfig_VA==1)&(Konfig_HA==1);
% ... für weitere zukünftige Bedingungen
% ...
do_Simulieren = not(case_Konfiguration);

try
    if do_Simulieren
        
        % Berechnen der Antriebsstrangkosten
        % rmpath(genpath('.\Initialisierung\Antriebsstrang\Kostenmodell'));
        % addpath(genpath('.\Initialisierung\Antriebsstrang\Kostenmodell'));
        % Kosten_Topologie = fcn_Gesamtkostenmodell(config);
        % rmpath(genpath('.\Initialisierung\Antriebsstrang\Kostenmodell'));
        consumption = [];
        Bewertung = [];
        Werte_Bewertung = [];
        % Initialisierung und Simulation
        Init_Veh;
        
        Init_Sim;
        
        Init_Driv_Env;
        
        % Berechnung der Eigenschaftserfüllungsgrade
        GEEG = 100;
        QDEGS = 100;
        QDEGI = 100;
        LQDEG = 100;
        LDEG = 100;
        OREG = 100;
        VMEG = 100;
        if opt.test_vektor_opt(1)
            Gesamteigenschaftserfuellungsgrad;
            Querdynamikerfuellungsgrad_stat;
            Querdynamikerfuellungsgrad_instat;
            Laengs_querdynamikerfuellungsgrad;
            Laengsdynamikerfuellungsgrad;
            Offroaderfuellungsgrad;
        else
            if opt.test_vektor_opt(4)
                Querdynamikerfuellungsgrad_stat;
            end
            if opt.test_vektor_opt(5)
                Querdynamikerfuellungsgrad_instat;
            end
            if opt.test_vektor_opt(6)
                Laengs_querdynamikerfuellungsgrad;
            end
            if opt.test_vektor_opt(7)
                Laengsdynamikerfuellungsgrad;
            end
            if opt.test_vektor_opt(8)
                Offroaderfuellungsgrad;
            end
            if opt.test_vektor_opt(9)
                vmax_erfuellungsgrad
            end
        end
        
        % Abspeichern der zusätzlichen Werte
        extra = {consumption,Werte_Bewertung,Bewertung};
        
        % Abspeichern der berechneten Optimierungsziele im Vektor 'y'
        y_ = zeros(1,8);
        y_(1) = GEEG;       % Fahrdynamik
        y_(2) = consumption;         % Energieverbrauch
        y_(3) = par_MDT.AUS.Gesamtkosten_Topologie;    % Antriebsstrangkosten
        y_(4) = QDEGS;
        y_(5) = QDEGI;
        y_(6) = LQDEG;
        y_(7) = LDEG;
        y_(8) = OREG;
        y_(9) = VMEG;
        
        y = y_(ziele);
        
    else
        % unannehmbarer Fall
        y = ones(size(y))*1e30;
        extra = cell(1,3);
        
    end
catch err
    file = which('Error_log.txt');
    fid = fopen(file,'a+');
    Cur_ind = sprintf('Generation: %d,Individual: %d', gen,ind);
    Design_var = sprintf('%d; ',x);
    errorFile = fileread('Error_Log.txt');
    idx = all(ismember(err.getReport('extended', 'hyperlinks','off'),errorFile));
    text = ['----------------------------------------------' newline...
        '----------------ERROR-------------------------' newline...
        '----------------------------------------------' newline...
        'Zeit: ' char(datetime('now')) newline...
        Cur_ind newline...
        'Designvariablen: ' Design_var newline newline ...
        err.getReport('extended', 'hyperlinks','off') newline...
        '----------------------------------------------' newline];
    disp(text)
   if idx==0 %Fehler noch nicht per Mail gesendet
        % Fehlerbenachrichtigung per Mail 
        try
            if opt.Mailbenachrichtigung.enabled==1
                recipients  = opt.Mailbenachrichtigung.recipients;
                subject='Optimization_Error';
                sendmail_from_totem(recipients, subject, text);
                disp('Fehlerbericht per Mail versendet')
            end
        catch
        end
   end
   fprintf(fid,'%s',text);
   fclose(fid);
   y = y+1e30;
   consumption=1000;
   extra = cell(1,3);
end

c=100-consumption;
if c<0
    cons(1)=abs(c);
end

end

