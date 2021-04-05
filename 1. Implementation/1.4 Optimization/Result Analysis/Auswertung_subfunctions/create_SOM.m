function create_SOM(x, groessen, figure_no, ...
                    Bezeichnung_der_Topologie, ...
                    w_fig, h_fig)
                
% figure('Name','SOM40_3')
TUM_CI_colors %Lade TUM CI farben

%% beliebige Kombinationen
figure(59+figure_no)
% set(gcf, 'units','centimeters');
% set(gcf, 'outerposition',[1 1 w_fig h_fig]);
% B_pareto = B(find(double(paretoset(B(:,1:Anzahl_der_Ziele)))),:);
  

no_of_elements = 5*sqrt(size(x,2))+2; %% SA Bügel, Joshua, 2018, S. 20
mapsize=floor(sqrt(no_of_elements));
net = selforgmap([mapsize mapsize]); %defaultwert ist 15
net.trainParam.epochs=1000;
net.trainParam.showWindow = false;
net = train(net,x');
plot_planes = plotsomplanes_TUM_CI_colormap(net); hold on;
weigths = net.IW;

% plot
plotcols = 3;%ceil(sqrt(size(x,2)));
plotrows = ceil(size(x,2)/plotcols);


for i=1:size(x,2)
    weigths_max(i) = round(max(weigths{1,1}(:,i)),3, 'significant');
    weigths_min(i) = round(min(weigths{1,1}(:,i)),3, 'significant');
    c1=colorbar(subplot(plotrows,plotcols,i),'Ticks',[0,1],'TickLabels',{num2str(weigths_min(i)),num2str(weigths_max(i))}, 'FontSize', 9, 'FontWeight', 'normal');
    xticks('');yticks('');
end

colormap(TUM_CI_colormap_2c);

for i=1:size(x,2)
    title(subplot(plotrows,plotcols,i),groessen{i}, 'FontSize', 9, 'FontWeight', 'normal')
end

set(gcf, 'units','centimeters');
set(gcf, 'position',[1 1 w_fig h_fig]);

%% Ziele
% figure(58)
% % train
% x = all_objectives(find(double(paretoset(all_objectives(:,[1:3])))),[1:3])';
% net = selforgmap([15 15]);
% net.trainParam.epochs=1000;
% net.trainParam.showWindow = false;
% net = train(net,x);
% plot_planes = plotsomplanes_TUM_CI_colormap(net); hold on;
% weigths = net.IW;
% 
% % plot
% for i=1:3
%     weigths_max(i) = max(weigths{1,1}(:,i));
%     weigths_min(i) = min(weigths{1,1}(:,i));
%     c1=colorbar(subplot(2,2,i),'Ticks',[0,1],'TickLabels',{num2str(weigths_min(i)),num2str(weigths_max(i))});
%     xticks('');yticks('');
% end
% colormap(TUM_CI_colormap);
% title(subplot(2,2,1),'Fahrdynamik in %');
% title(subplot(2,2,2),'Verbrauch in kWh/100km');title(subplot(2,2,3),'Kosten in €')
% 
% s2=subplot(2,2,4);
% title('Verteilung')
% figure('Name','help')
% plot_hits = plotsomhits(net,x);
% ax_hits=gca;
% fig_hits=get(ax_hits,'children');
% copyobj(fig_hits,s2);
% close(plot_hits)
% axis off
% suptitle(['Self-organizing Maps für 3 Optimierungsziele; Gewichte für ',Bezeichnung_der_Topologie])       

%% Designvariablen
% figure(59)
% % train
% x = all_designvariables(find(double(paretoset(all_objectives))),:)';
% net = selforgmap([15 15]);
% net.trainParam.epochs=1000;
% net.trainParam.showWindow = false;
% net = train(net,x);
% plot_planes = plotsomplanes_TUM_CI_colormap(net); hold on;
% weigths = net.IW;
% 
% % plot
%     plotcols = ceil(sqrt(Anzahl_der_Designvariablen));
%     plotrows = ceil(Anzahl_der_Designvariablen/plotcols);
% for i=1:Anzahl_der_Designvariablen
%     weigths_max(i) = max(weigths{1,1}(:,i));
%     weigths_min(i) = min(weigths{1,1}(:,i));
%     c1=colorbar(subplot(plotcols,plotrows,i),'Ticks',[0,1],'TickLabels',{num2str(weigths_min(i)),num2str(weigths_max(i))});
%     xticks('');yticks('');
% end
% colormap(TUM_CI_colormap);
% for i=1:Anzahl_der_Designvariablen
%     title(subplot(plotcols,plotrows,i),Designvariablen{i})
% end
% 
% 
% s2=subplot(plotcols,plotrows,i+1);
% title('Verteilung')
% figure('Name','help')
% plot_hits = plotsomhits(net,x);
% ax_hits=gca;
% fig_hits=get(ax_hits,'children');
% copyobj(fig_hits,s2);
% close(plot_hits)
% axis off
% suptitle(['Self-organizing Maps für 3 Optimierungsziele; Gewichte für ',Bezeichnung_der_Topologie])       
