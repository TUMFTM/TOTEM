% TOTEM - Result analysis Script
% ------------
% Created on 21 May 2019
% ------------
% For version: Matlab2018b
% ------------
% PURPOSE OF THIS SCRIPT
% This skript allows for an analysis of optimization result from TOTEM. 
% The skript is focused on results for optimizations with the 3 Objectives
% (Costs, Consumption and Driving Behaviour) as shown in:
%     C. Angerer, “Antriebskonzept-Optimierung für batterieelektrische 
%     Allradfahrzeuge,” Dissertation, Institute for Automotive Technology, 
%     Technical University of Munich, Munich, 2019.
% ------------
% Thanks to Guillaume Lestoille and Joshua Bügel who contributed a lot to this
% skript and the functions behind! 


%% Initialization
close all; clc; clear all

% general plot properties
w_fig=26;       %breite der figure in cm
h_fig=14.5;     %höhe der figure in cm
TUM_CI_colors   %load TUM CI colors

% ask for saving created pictures 
speichern = questdlg('Sollen die Grafiken abgespeichert werden?', ...
	'Abspeichern der Grafiken', ...
	'Ja','Nein', 'Nein');
% Prosa-Formulation of all design variables
Designvariablen=[   {'Motor VA'}, {'Motor HA'}, {'Ganganzahl VA'}, {'Ganganzahl HA'}, ...
                    {'Nennmoment VA in Nm'},  {'Maximaldrehzahl VA in 1/min'}, ...
                    {'Differenzmoment VA'}, {'Übersetzung 1. Gang VA'}, ...
                    {'Spreizung VA'}, ...
                    {'Nennmoment HA in Nm'},  {'Maximaldrehzahl HA in 1/min'}, ...
                    {'Differenzmoment HA'}, {'Übersetzung 1. Gang HA'}, ...
                    {'Spreizung HA'}];

currentFolder = pwd;
addpath(genpath(currentFolder))

% choose files to be analyzed
namen = uigetfile('*.mat*', 'Wähle die zu analysierenden Optimierungsergebnisse',[currentFolder,'\1.4 Optimization\Results'],'MultiSelect','on');

if iscell(namen)
    Anzahl_der_Topologien = size(namen,2);
    Konfig_list = cell(1,size(namen,2));
else
    Anzahl_der_Topologien = 1;
    Konfig_list = cell(1,1);
end


%% Main Analysis
% 1. parsing the result-file
% 2. identifiying the pareto-optimal solutions and 
% 3. plot 2D pareto-frontiers

    Pareto =    cell(1,1);
    Pareto_01 = cell(1,1);
    Pareto_01_all = cell(1,1);
    
for n = 1:Anzahl_der_Topologien %iterate all result files

    if iscell(namen)
        name=namen{n};
    else
        name=namen;
    end
    
    disp(name) 
    load(name); %load results
    Ergebnisse = result; %assign result to variable Ergebnisse
    
    % extract the no. of Generations and the population size 
    q = size(Ergebnisse.pops);
    n_Generationen{n} = max([result.states.currentGen]); % no. of Generations
    n_Individuen = q(2);                                 % Population size
    
    if n==1 %distinguish between analysis of a single result file or the comparative analysis of multiple result files
        Anzahl_der_Ziele =              size(result.pops(1,1).obj, 2);
        Anzahl_der_Designvariablen =    size(result.pops(1,1).var, 2);
        Bewertungsnoten =               fieldnames(result.pops(n_Generationen{n}, n_Individuen).Bewertungsnoten);
        Bewertungsnoten_cell =          struct2cell(result.pops(n_Generationen{n}, n_Individuen).Bewertungsnoten);

        Anzahl_der_Bewertungsnoten=0;
        for i=1:length(Bewertungsnoten_cell)
            Anzahl_der_Bewertungsnoten = Anzahl_der_Bewertungsnoten + size(Bewertungsnoten_cell{i},2);
        end
        n_fig = Anzahl_der_Ziele;

        if Anzahl_der_Ziele==7 %if result contains an optimization of 7 objectives
            Ziele = [{'Verbrauch'}, {'Kosten'}, {'stat. QD'}, {'instat. QD'},{'LQD'},{'LD'},{'ORD'}];
            Label = [{'Verbrauch'}, {'Kosten in k€'}, {'QDS in %'}, {'QDI in %'},{'LQD in %'},{'LD in %'},{'ORD in %'}];
            n_row = 2;                                           % Anzahl an Zeile auf einer Figure
            n_col = 3;                                           % Anzahl an Spalte auf einer Figure
            n_sub = n_row*n_col;                                 % Anzahl von subplot pro Figure
            n_fig = 7;
            w_fig=26; %breite der figure in cm
            h_fig=14.5;  %höhe der figure in cm
            margin_hor = 0.07;
            margin_vert = 0.12;
            h = 1/n_row-margin_vert; %height
            w = 1/n_col-margin_hor;  %width
            x = 0.08; 
            y = 1/2+0.05 ; 
        elseif Anzahl_der_Ziele ==3 %if result contains an optimization of 3 objectives
            mit_Fahrdynamik=Ergebnisse.pops(1, 1).obj(3)>1000; %check if driving behaviour (=Fahrdynamik) is considered
            if mit_Fahrdynamik==1
                Ziele = [{'Fahrverhalten'}, {'Verbrauch'}, {'Kosten'}];
                Label = [{'Fahrverhalten'}, {'Verbrauch in kWh/100km'}, {'Kosten in 1000 €'}];
            else %otherwise it is assumed that consumptions, costs and top speed are the objectives
                Ziele = [{'Verbrauch'}, {'Kosten'}, {'V_max'}];
                Label = [{'Verbrauch in kWh/100km'}, {'Kosten in 1000 €'}, {'V_max'}];
            end
            n_row = 2;                                           % Anzahl an Zeile auf einer Figure
            n_col = 1;                                           % Anzahl an Spalte auf einer Figure
            n_sub = n_row*n_col;                                 % Anzahl von subplot pro Figure
            n_fig = 3;
            w_fig=14.5; %breite der figure in cm
            h_fig=20;  %höhe der figure in cm
            margin_hor = 0.12;
            margin_vert = 0.12;
            h = 1/n_row-margin_vert; %height
            w = 1/n_col-margin_hor;  %width
            x = 0.10; 
            y = 1/2+0.05 ; 
        end
    end

    [VA, HA, Color, LineStyle, MarkerStyle] = set_plot_style(name); %assign different plot styles in dependence on the chosen configuration
    
    % creating figures for all plots
    if n == 1
        for f = 1:n_fig
            fig(f) = figure('units','centimeters','Position',[1 1 w_fig h_fig]);
        end
    end
    
    Konfig = [VA HA];
    Konfig_list{n} = Konfig;
        
    row = length(Ergebnisse);                            % Anzahl Optimierungskonfigurationen mit 40 Individuen
    j = length(Ergebnisse(1).pops(1,1).obj);             % Anzahl der Optimierungsziele           

    B{n} = zeros(n_Generationen{n}*n_Individuen,j+14); i=1; 
    P =         cell(1,2);

    for r=1:n_Generationen{n} % iterate through each generation
        for s=1:n_Individuen %iterate through each indiviual af a certain generation
            if Ergebnisse.pops(r,s).obj(:,1)~=1000 %exclude individuals that hurt the boundary condition
                % write objectives to B
                for spalte=1:Anzahl_der_Ziele
                    B{n}(i,spalte) = Ergebnisse.pops(r,s).obj(:,spalte);
                end
                % write designvariables to B 
                B{n}(i,Anzahl_der_Ziele+1:Anzahl_der_Ziele+Anzahl_der_Designvariablen) = result.pops(r,s).var;
                % write gradings (Bewertungsgrößen) to B
                ug_all=0;
                for note=1:length(Bewertungsnoten_cell)                   
                    if ~isfield(Ergebnisse.pops(r,s).Bewertungsnoten, Bewertungsnoten{note})
                        eval(['Ergebnisse.pops(r,s).Bewertungsnoten.',Bewertungsnoten{note}, '=-1.*ones(1,size(Bewertungsnoten_cell{note},2));']);
                    end
                    uebergroesse=size(Bewertungsnoten_cell{note},2)-1;
                    eval(['B{n}(i,Anzahl_der_Ziele+Anzahl_der_Designvariablen+note+ug_all:Anzahl_der_Ziele+Anzahl_der_Designvariablen+note+ug_all+uebergroesse) = Ergebnisse.pops(r,s).Bewertungsnoten.',Bewertungsnoten{note}, ';']);
                    ug_all=ug_all+uebergroesse;
                end
                i=i+1;
            end
        end 
    end
    
    B{n}(i:end,:)=[];
    i=1;
    
    % creating Pareto-Frontiers
    for i = 1:Anzahl_der_Ziele % iterate through x-axis objectives (=figures)
        row = 1;
        col = 1;
        for j = 1:Anzahl_der_Ziele % iterate through y-axis objectives (=axes)
            if i~=j %only plot if y- and x-axis contain different objectives
                set(0, 'currentfigure', fig(i));

                if n == 1
                    ax(i,j) = axes('Position',[x+0.95*(col-1)/n_col y-0.9*(row-1)/n_row w h],'Box','on');
                    grid on;
                    xlabel(Label{i})
                    ylabel(Label{j})
                end
                % Search Pareto-optimal Individuals
                startwert=n_Individuen+1;
                D1 = [B{n}(startwert:end,i),B{n}(startwert:end,j)]; 
                P{i,j}(:,[1,2]) = D1(find(double(paretoset(D1))),:); 
                P{i,j}(:,2+1:2+Anzahl_der_Designvariablen) = B{n}(startwert-1+find(double(paretoset(D1))),Anzahl_der_Ziele+1:Anzahl_der_Ziele+Anzahl_der_Designvariablen);
                P_ind{i,j} =    startwert-1+find(double(paretoset(D1)));
                P_ind_01{i,j} = [zeros(startwert-1,1); double(paretoset(D1))];
                
                P{i,j}(:,2+Anzahl_der_Designvariablen+1:2+Anzahl_der_Designvariablen+Anzahl_der_Bewertungsnoten) = B{n}(startwert-1+find(double(paretoset(D1))),Anzahl_der_Ziele+Anzahl_der_Designvariablen+1:Anzahl_der_Ziele+Anzahl_der_Designvariablen+Anzahl_der_Bewertungsnoten);
                axes(ax(i,j));
                hold on
                %sorting
                A = sortrows(P{i,j},1,'ascend'); A = sortrows(A,2,'descend'); 
                %plot the pareto-frontiers
                if strcmp(Ziele{i}, 'Kosten')
                    if strcmp(Ziele{j}, 'Verbrauch')
                        l1 = plot(A(:,1)./1000,A(:,2),'Color',Color,'LineStyle',LineStyle,'Marker', MarkerStyle,  'LineWidth',3);
                    else
                        l1 = plot(A(:,1)./1000,A(:,2),'Color',Color,'LineStyle',LineStyle,'LineWidth',3);
                    end
                elseif strcmp(Ziele{j}, 'Kosten')
                    if strcmp(Ziele{i}, 'Verbrauch')
                        l1 = plot(A(:,1),A(:,2)./1000,'Color',Color,'LineStyle',LineStyle,'Marker', MarkerStyle,  'LineWidth',3);
                    else
                        l1 = plot(A(:,1),A(:,2)./1000,'Color',Color,'LineStyle',LineStyle, 'LineWidth',3);
                    end
                else 
                    l1 = plot(A(:,1),A(:,2),'Color',Color,'LineStyle',LineStyle, 'LineWidth',3);
                end
                ax(i,j).FontSize = 9;
                col = col + 1;
                if col > n_col
                    col = 1;
                    row = row + 1;
                end
            end
        end
    end
    Pareto{n} =         P_ind;
    Pareto_01{n} =      P_ind_01;
    Pareto_01_all{n} =  double(or(or(Pareto_01{n}{1,2}==1, Pareto_01{n}{1,3}), Pareto_01{n}{2,3}));    
end
%%  create the Legends
for i=1:Anzahl_der_Ziele
    for j=1:Anzahl_der_Ziele
        if i~=j
            if j==1 || (j==2 && i==1) 
                axes(ax(i,j));
                legend(Konfig_list);
            elseif j==2 && i==3
                axes(ax(i,j));
                legend(Konfig_list, 'Location', 'northwest');
            end
        end
    end
    if strcmp(speichern, 'Ja')
        set(fig(i), 'Renderer', 'painters');
        speichername=['Paretofronten_ueber_', Ziele{i}];
        print(fig(i), speichername,'-dmeta')
    end
end

%% Plot 3D-pareto frontier and video 
% create the video writer with 1 fps
VideoObj = VideoWriter('konvergenz_video.avi');
VideoObj.FrameRate = 5;  % set the seconds per image
open(VideoObj); % open the video writer
fig(47) = figure('Units','pixels','Position',[1 1 1280 720]);

%create the 3D-plot
if Anzahl_der_Ziele == 3
    for r=1:n_Generationen{n} % go through all generations
        start_individuum=n_Individuen*(r-1)+1;
        end_endividuum=n_Individuen*r;

        az =  -75;
        el =   24.0000;
        view(az, el);
        if n==1
            cla
        end
        hold off
        grid on
        title(['Generation ', num2str(r)])
        hold on

        Rechengroessen_berechnen;        
        calc_Teilziele;
        
        if Anzahl_der_Topologien==1 %in case of one result file
            xmin=min(B{n}(n_Individuen*3+1:end,1));
            xmax=max(B{n}(n_Individuen*3+1:end,1));
            ymin=min(B{n}(n_Individuen*3+1:end,2));
            ymax=max(B{n}(n_Individuen*3+1:end,2));
            zmin=min(B{n}(n_Individuen*3+1:end,3));
            zmax=max(B{n}(n_Individuen*3+1:end,3));
            
            xlim([xmin, xmax]);
            ylim([ymin, 17]);
            zlim([zmin./1000, 18000./1000]);
            
            if strcmp('1', name(2)) %Frontantrieb
                scatter3(B{n}(1:end_endividuum,1), B{n}(1:end_endividuum,2), B{n}(1:end_endividuum,3)./1000, 5+Pareto_01_all{n}(1:end_endividuum).*30, Leistung_VA(1:end_endividuum), 'filled')
                hold on
%                 scatter3(B{n}(start_individuum:end_endividuum,1), B{n}(start_individuum:end_endividuum,2), B{n}(start_individuum:end_endividuum,3)./1000, 5, Leistung_VA(start_individuum:end_endividuum), 'filled')
            elseif strcmp('1', name(1)) %Heckantrieb
                scatter3(B{n}(1:end_endividuum,1), B{n}(1:end_endividuum,2), B{n}(1:end_endividuum,3)./1000, 5+Pareto_01_all{n}(1:end_endividuum).*30, Leistung_HA(1:end_endividuum), 'filled')
                hold on
%                 scatter3(B{n}(start_individuum:end_endividuum,1), B{n}(start_individuum:end_endividuum,2), B{n}(start_individuum:end_endividuum,3)./1000, 5, Leistung_HA(start_individuum:end_endividuum), 'filled')
            else
                scatter3(B{n}(1:end_endividuum,1), B{n}(1:end_endividuum,2), B{n}(1:end_endividuum,3)./1000, 5+Pareto_01_all{n}(1:end_endividuum).*30, Gesamtleistung(1:end_endividuum), 'filled')
                hold on
                scatter3(B{n}(start_individuum:end_endividuum,1), B{n}(start_individuum:end_endividuum,2), B{n}(start_individuum:end_endividuum,3)./1000, 30, Gesamtleistung(start_individuum:end_endividuum), 'filled')
            end
            
            xlim([xmin, xmax]);
            ylim([ymin, 17]);
            zlim([zmin./1000, 18000./1000]);

            xlabel(Label{1}, 'FontSize', 14)
            ylabel(Label{2}, 'FontSize', 14)
            zlabel(Label{3}, 'FontSize', 14)
            set(gca,'FontSize',14)
            colormap(TUM_CI_colormap_2c)        
%             c2=colorbar;
%             caxis([50 200]);
%             title(c2,'Nennleistung in kW')
        else % in case of multiple result files
            cla
            hold on
            if r==1
                xmin=min(B{n}(n_Individuen*3+1:end,1));
                xmax=max(B{n}(n_Individuen*3+1:end,1));
                ymin=min(B{n}(n_Individuen*3+1:end,2));
                ymax=max(B{n}(n_Individuen*3+1:end,2));
                zmin=min(B{n}(n_Individuen*3+1:end,3));
                zmax=max(B{n}(n_Individuen*3+1:end,3));
            end
            
            for topo=1:Anzahl_der_Topologien
                xmin=min(xmin, min(B{topo}(n_Individuen*3+1:end,1)));
                xmax=max(xmax, max(B{topo}(n_Individuen*3+1:end,1)));
                ymin=min(ymin, min(B{topo}(n_Individuen*3+1:end,2)));
                ymax=max(ymax, max(B{topo}(n_Individuen*3+1:end,2)));
                zmin=min(zmin, min(B{topo}(n_Individuen*3+1:end,3)));
                zmax=min(zmax, max(B{topo}(n_Individuen*3+1:end,3)));

                [VA, HA, Color, LineStyle, MarkerType] = set_plot_style(namen{topo});
                
                if r<=n_Generationen{topo}
                    start_individuum=n_Individuen*(r-1)+1;
                    end_endividuum=n_Individuen*r;
                    
                    scatter3(B{topo}(start_individuum:end_endividuum,1), B{topo}(start_individuum:end_endividuum,2), B{topo}(start_individuum:end_endividuum,3)./1000, [], Color, MarkerType)
                    scatter3(B{topo}(1:start_individuum,1), B{topo}(1:start_individuum,2), B{topo}(1:start_individuum,3)./1000, 5, Color, MarkerType)

                else
                    start_individuum=n_Individuen*(n_Generationen{topo}-1)+1;
                    end_endividuum=n_Individuen*n_Generationen{topo};
    
                    scatter3(B{topo}(start_individuum:end_endividuum,1), B{topo}(start_individuum:end_endividuum,2), B{topo}(start_individuum:end_endividuum,3)./1000, [], Color, MarkerType)
                    scatter3(B{topo}(1:start_individuum,1), B{topo}(1:start_individuum,2), B{topo}(1:start_individuum,3)./1000, 5, Color, MarkerType)
                end
                
                xlabel(Label{1}, 'FontSize', 9)
                ylabel(Label{2}, 'FontSize', 9)
                zlabel(Label{3}, 'FontSize', 9)
                xlim([xmin, xmax])
                ylim([ymin, ymax])
                zlim([zmin./1000, zmax./1000])
            
            end
        end
        view(az, el);
        drawnow
        frame = getframe(gcf);
        writeVideo(VideoObj, frame);       
%         pause(1)
    end

    set(gca,'FontSize',9)
    % close the video object
    close(VideoObj);

    % save plot as emf-file
    w_fig = 14.5;
    h_fig = 10;
    set(fig(47),'units','centimeters','Position',[1 1 w_fig h_fig]);
    if strcmp(speichern, 'Ja')
        title([''])
        set(gcf, 'Renderer', 'painters');
        speichername=['3D-Paretoplot_aus_Video', name(1:2)];
        print(gcf, speichername,'-dmeta')
    end
end


%% SOM (Self-Organizing-Maps)
% see thesis by Joshua Bügel:
% J. Bügel, “Optimierung elektrischer Antriebsstrangtopologien und Analyse der Pareto Fronten mit Hilfe verschiedener Visualisierungsmethoden,” Bachelorarbeit, Lehrstuhl für Fahrzeugtechnik, Technische Universität München, München, 2018.

for topo=1:Anzahl_der_Topologien
    disp(['plotte SOM ', num2str(topo), ' von ', num2str(Anzahl_der_Topologien)])
    if iscell(namen)
        [VA, HA, Color, LineStyle, ~] = set_plot_style(namen{topo});
        name=namen{topo};
    else
        [VA, HA, Color, LineStyle, ~] = set_plot_style(namen);
        name=namen;
    end
    
    x=[];
    B_pareto = B{topo}((end-(64*5)):end,:);
    groessen={};
    x = [x, B_pareto(:, 1:Anzahl_der_Ziele)];  
        groessen={groessen{:}, Ziele{:}};
    x = [x, (B_pareto(:, Anzahl_der_Ziele+5).*B_pareto(:, Anzahl_der_Ziele+6)+ ...
        B_pareto(:, Anzahl_der_Ziele+10).*B_pareto(:, Anzahl_der_Ziele+11)) ...
        /60*2*pi/1000]; %Gesamtleistung
        groessen = {groessen{:}, 'Gesamtleistung in kW'};
    x = [x, (B_pareto(:, Anzahl_der_Ziele+10).*B_pareto(:, Anzahl_der_Ziele+11)).*100./ ...
        (B_pareto(:, Anzahl_der_Ziele+5).*B_pareto(:, Anzahl_der_Ziele+6)+ ...
        B_pareto(:, Anzahl_der_Ziele+10).*B_pareto(:, Anzahl_der_Ziele+11))]; 
        groessen={groessen{:}, 'Anteil HA in %'};
    x = [x, (B_pareto(:, Anzahl_der_Ziele+1)+B_pareto(:, Anzahl_der_Ziele+2))/2]; 
        groessen={groessen{:}, sprintf('Maschinentyp\n(1=ASM, 2=PSM)')};                         
    x = [x, (B_pareto(:, Anzahl_der_Ziele+3)+B_pareto(:, Anzahl_der_Ziele+4))/2]; 
        groessen={groessen{:}, 'mittlere Ganganzahl'}; 
    x = [x, (B_pareto(:, Anzahl_der_Ziele+4))]; 
        groessen={groessen{:}, 'Ganganzahl HA'}; 
    x = [x, (B_pareto(:, Anzahl_der_Ziele+4))]; 
        groessen={groessen{:}, 'Ganganzahl HA'}; 
    
    create_SOM( x, groessen, topo, ...
            [VA, HA], ...
            w_fig, h_fig);
        
    if strcmp(speichern, 'Ja')
        set(gcf, 'Renderer', 'painters');
        speichername=['SOM_', name(1:2)];
        print(gcf, speichername,'-dmeta')
    end
end

%% SOM (alternative Implementation)

for topo=1:Anzahl_der_Topologien
    disp(['plotte SOM ', num2str(topo), ' von ', num2str(Anzahl_der_Topologien)])
    if iscell(namen)
        [VA, HA, Color, LineStyle, ~] = set_plot_style(namen{topo});
        name=namen{topo};
    else
        [VA, HA, Color, LineStyle, ~] = set_plot_style(namen);
        name=namen;
    end
    
    plot_individuen=(length(B{topo})-20*n_Individuen):length(B{topo});
    
    x=[];
    groessen={};

    x = [x, FV(plot_individuen)];  
        groessen={groessen{:}, Ziele{1}};
    x = [x, Verbrauch(plot_individuen)];  
        groessen={groessen{:}, Ziele{2}};
    x = [x, Kosten(plot_individuen)];  
        groessen={groessen{:}, Ziele{3}};
%     x = [x, Gesamtleistung(plot_individuen)]; %Gesamtleistung
%         groessen = {groessen{:}, 'Gesamtnennleistung in kW'};
%     x = [x, Anteil_HA(plot_individuen)]; 
%         groessen={groessen{:}, 'Anteil HA in %'};
%     x = [x, Motor_mittel(plot_individuen)]; 
%         groessen={groessen{:}, sprintf('Maschinentyp\n(1=ASM, 2=PSM)')};                         
%     x = [x, gang_mittel(plot_individuen)]; 
%         groessen={groessen{:}, 'mittlere Ganganzahl'}; 
%     x = [x, gang_VA(plot_individuen)]; 
%         groessen={groessen{:}, 'Ganganzahl VA'}; 
%     x = [x, gang_HA(plot_individuen)]; 
%         groessen={groessen{:}, 'Ganganzahl HA'}; 
%     x = [x, i_min_VA(plot_individuen)]; 
%         groessen={groessen{:}, 'kleinste Übersetzung VA'}; 
    x = [x, i1_HA(plot_individuen)]; 
        groessen={groessen{:}, 'erster Gang HA'}; 
            x = [x, i_min_HA(plot_individuen)]; 
        groessen={groessen{:}, 'zweiter Gang HA'}; 
%     x = [x, Leistung_VA(plot_individuen)]; 
%         groessen={groessen{:}, 'Nennleistung VA'}; 
%     x = [x, Leistung_HA(plot_individuen)]; 
%         groessen={groessen{:}, 'Nennleistung HA'};     
%     x = [x, M_n_verh_VA(plot_individuen)]; 
%         groessen={groessen{:}, 'M zu n Verhältnis VA'}; 
%     x = [x, M_n_verh_HA(plot_individuen)]; 
%         groessen={groessen{:}, 'M zu n Verhältnis HA'}; 
    %Teilziele
%     x = [x, QD(plot_individuen)]; 
%         groessen={groessen{:}, 'Querdynamik'}; 
%     x = [x, LD(plot_individuen)]; 
%         groessen={groessen{:}, 'Längsdynamik'}; 
%     x = [x, OD(plot_individuen)]; 
%         groessen={groessen{:}, 'Geländefähigkeit'}; 
    x = [x, Motor_HA(plot_individuen)]; 
        groessen={groessen{:}, 'Motortyp HA'}; 
    
    create_SOM( x, groessen, topo, ...
            [VA, HA], ...
            w_fig, h_fig);
        
    if strcmp(speichern, 'Ja')
        set(gcf, 'Renderer', 'painters');
        speichername=['SOM_neu', name(1:2)];
        print(gcf, speichername,'-dmeta')
    end
end

%% Konvergency plot 2D
if Anzahl_der_Topologien==1
    topo=1;
    h_fig=5;
    w_fig=14.5;
    fig(29) = figure('units','centimeters','Position',[1 1 w_fig h_fig]);

    for i=1:n_Generationen{n}
        for j=1:Anzahl_der_Ziele
            indizes=find(B{topo}((1+n_Individuen*(i-1):n_Individuen*i),2)<100);
            Mean(i,j) = mean(B{topo}((n_Individuen*(i-1))+indizes,j));
            Min(i,j) = min(B{topo}  ((n_Individuen*(i-1))+indizes,j));
            Max(i,j) = max(B{topo}  ((n_Individuen*(i-1))+indizes,j));
        end
    end
    
    x = 1:n_Generationen{n};
    
    for Ziel=1:Anzahl_der_Ziele
        s29(Ziel)=subplot(1,Anzahl_der_Ziele,Ziel)
        cla
%         y = Mean(:,Ziel);
%         yneg = Mean(:,Ziel)-Min(:,Ziel);
%         ypos = Max(:,Ziel)-Mean(:,Ziel);
%         errorbar(x,y,yneg,ypos)
        if strcmp(Ziele{Ziel}, 'Kosten')
            plot(x, Min(:, Ziel)./1000, 'Color', dunkelblau)
            ylim( [min(Min(:,Ziel)*0.98/1000), max(Min(:,Ziel)*1.02)/1000])
        else
            plot(x, Min(:, Ziel), 'Color', dunkelblau)        
            ylim( [min(Min(:,Ziel)*0.98), max(Min(:,Ziel)*1.02)])

        end
        ylabel(Label(Ziel), 'FontSize', 9)
        xlabel('Generation', 'FontSize', 9)
        grid on
    end
    set(s29(:), 'FontSize', 9)
    
    if strcmp(speichern, 'Ja')
        set(gcf, 'Renderer', 'painters');
        speichername=['Konvergenz_der_Ziele', name(1:2)];
        print(gcf, speichername,'-dmeta')
    end
    
end

    
%% Histograms
if Anzahl_der_Topologien==1
    %%%%%%%%%%%%%%%%%
    % Designvariables
    %%%%%%%%%%%%%%%%%
    plotcols = 2;
    plotrows = ceil(Anzahl_der_Designvariablen/plotcols);
    h_fig=14.5/4*plotrows;
    figure('Name',['Verteilung der Designvariablen'], 'units','centimeters','Position',[1 1 w_fig h_fig])

    durchlauf=1;
    if strcmp('1', name(2)) %Frontantrieb
        reihenfolgedergroessen=[1  3  5  6  8  9 ];
    elseif strcmp('1', name(1)) %Heckantrieb
        reihenfolgedergroessen=[ 2  4  10  11  13  14];
    else
        reihenfolgedergroessen=[1 2 3 4 5 10 6 11 8 13 9 14];
    end
    
    for desvar=reihenfolgedergroessen %1:Anzahl_der_Designvariablen
        subplot(plotrows,plotcols,durchlauf); 
        title(Designvariablen(desvar), 'FontSize', 9, 'FontWeight', 'normal')
        hold on
        grid on
        ylabel('Häufigkeit');
        if desvar==9 
            h(desvar) = histogram(B{topo}(find(and(Pareto_01_all{1}==1, gang_VA==2)),Anzahl_der_Ziele+desvar),'Normalization','probability', 'EdgeColor', [1 1 1], 'FaceColor', dunkeldunkelblau, 'FaceAlpha', 1);
        elseif desvar==14
            h(desvar) = histogram(B{topo}(find(and(Pareto_01_all{1}==1, gang_HA==2)),Anzahl_der_Ziele+desvar),'Normalization','probability', 'EdgeColor', [1 1 1], 'FaceColor', dunkeldunkelblau, 'FaceAlpha', 1);
        else
            h(desvar) = histogram(B{topo}(find(Pareto_01_all{1})                    ,Anzahl_der_Ziele+desvar),'Normalization','probability', 'EdgeColor', [1 1 1], 'FaceColor', dunkeldunkelblau, 'FaceAlpha', 1);
        end
        durchlauf=durchlauf+1;

        if desvar==1 || desvar==2
            Labels = {'ASM', 'PSM'};                   
            set(gca, 'XTick', 1:2, 'XTickLabel', Labels);
        end
        if desvar==3 || desvar==4
            Labels = {'1','2'};
            set(gca, 'XTick', 1:2, 'XTickLabel', Labels);
        end

    end
    if strcmp(speichern, 'Ja')
        set(gcf, 'Renderer', 'painters');
        speichername=['Verteilung_der_Designvars', name(1:2)];
        print(gcf, speichername,'-dmeta')
    end
    
    %%%%%%%%%%%%%%%%%
    % Objectives
    %%%%%%%%%%%%%%%%%
    plotcols = 2;
    plotrows = ceil(Anzahl_der_Ziele/plotcols);
    h_fig=14.5/4*plotrows;
    figure('Name',['Verteilung der Designvariablen'], 'units','centimeters','Position',[1 1 w_fig h_fig])

    for Ziel=1:Anzahl_der_Ziele
        subplot(plotrows,plotcols,Ziel); 
        title(Ziele(Ziel), 'FontSize', 9, 'FontWeight', 'normal')
        hold on
        grid on
        ylabel('Häufigkeit');
        h(Ziel) = histogram(B{topo}(n_Individuen*2+1:end,Ziel),'Normalization','probability', 'EdgeColor', [1 1 1], 'FaceColor', dunkeldunkelblau, 'FaceAlpha', 1);
    end
    if strcmp(speichern, 'Ja')
        set(gcf, 'Renderer', 'painters');
        speichername=['Verteilung_der_Ziele', name(1:2)];
        print(gcf, speichername,'-dmeta')
    end
end

%% Analyze combinations of motor and transmission designs
if Anzahl_der_Topologien==1
    if strcmp('1', name(2)) %Frontantrieb
%         Auswertung_Motor_Getriebe_Kombi_fuer_einachsantriebe
    elseif strcmp('1', name(1)) %Heckantrieb
%         Auswertung_Motor_Getriebe_Kombi_fuer_einachsantriebe
    else
%         Auswertung_Motor_Getriebe_Kombi
    end
end



