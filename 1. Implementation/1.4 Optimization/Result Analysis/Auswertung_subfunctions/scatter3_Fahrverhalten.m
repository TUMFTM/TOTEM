if Anzahl_der_Topologien==1
    figure(398)
    [VA, HA, Color, LineStyle, MarkerType] = set_plot_style(namen);
    
    iende=n_Generationen{n}*n_Individuen;
    istart=iende-5*n_Individuen;
    scatter3(LD(istart:iende), QD(istart:iende), OD(istart:iende), 5, Verbrauch(istart:iende), MarkerType)
    colormap(TUM_CI_colormap)
    colorbar

    xlim([0 100])
    ylim([10 25])
    zlim([20 50])
    
    
else
    figure(398)
    cla
    hold on
    grid on
    az =  -75;
    el =   24.0000;
    view(az, el);

    for topo = 1:Anzahl_der_Topologien
        n=topo;
        Rechengroessen_berechnen;        
        calc_Teilziele;
        [VA, HA, Color, LineStyle, MarkerType] = set_plot_style(namen{topo});


        figure(398)
        
        iende=n_Generationen{n}*n_Individuen;
        istart=iende-1*n_Individuen;
        
        
        scatter3(LD(istart:iende), QD(istart:iende), OD(istart:iende), [], gang_HA(istart:iende),  MarkerType)
        
       
        
        colormap(TUM_CI_colormap)
        colorbar
        
        xlabel('Längsdynamik')
        ylabel('Querdynamik')
        zlabel('Geländeeigenschaften')
        
        xlim([0 100])
        ylim([10 35])
        zlim([20 50])
        

    end
    legend((namen))
end


%% unterschiede in FV
figure(456)
cla 
hold on
grid on

scatter3(LD(G1_PSM), QD(G1_PSM), OD(G1_PSM), [], Gesamtleistung(G1_PSM), '+')
scatter3(LD(G2_PSM), QD(G2_PSM), OD(G2_PSM), [], Gesamtleistung(G2_PSM), '*')
scatter3(LD(G1_ASM), QD(G1_ASM), OD(G1_ASM), [], Gesamtleistung(G1_ASM), 'd')
scatter3(LD(G2_ASM), QD(G2_ASM), OD(G2_ASM), [], Gesamtleistung(G2_ASM), 's')
colormap(TUM_CI_colormap)        
colorbar
legend('PSM G1', 'PSM G2', 'ASM G1', 'ASM G2')
xlabel('LD')
ylabel('QD')
% xlim([100 300])
% xline=0:1000;
% yline=xline;
% plot(xline, yline, '--')

% txt = 'HA limitiert vmax';
% text(270, 230, txt)
% txt = 'VA limitiert vmax';
% text(270, 310,txt)

%%
figure(457)
cla 
hold on
grid on

scatter3(QD_stat(G1_PSM), QD_inst(G1_PSM), QD_komb(G1_PSM), [], Gesamtleistung(G1_PSM), '+')
scatter3(QD_stat(G2_PSM), QD_inst(G2_PSM), QD_komb(G2_PSM), [], Gesamtleistung(G2_PSM), '*')
scatter3(QD_stat(G1_ASM), QD_inst(G1_ASM), QD_komb(G1_ASM), [], Gesamtleistung(G1_ASM), 'd')
scatter3(QD_stat(G2_ASM), QD_inst(G2_ASM), QD_komb(G2_ASM), [], Gesamtleistung(G2_ASM), 's')
colormap(TUM_CI_colormap)        
colorbar
legend('PSM G1', 'PSM G2', 'ASM G1', 'ASM G2')
xlabel('stat')
ylabel('inst')
% xlim([100 300])
% xline=0:1000;
% yline=xline;
% plot(xline, yline, '--')

% txt = 'HA limitiert vmax';
% text(270, 230, txt)
% txt = 'VA limitiert vmax';
% text(270, 310,txt)


%%
figure(458)
cla 
hold on
grid on

scatter3(LWG_14(G1_PSM), LWG_67(G1_PSM), a_y_max(G1_PSM), [], Gesamtleistung(G1_PSM), '+')
scatter3(LWG_14(G2_PSM), LWG_67(G2_PSM), a_y_max(G2_PSM), [], Gesamtleistung(G2_PSM), '*')
scatter3(LWG_14(G1_ASM), LWG_67(G1_ASM), a_y_max(G1_ASM), [], Gesamtleistung(G1_ASM), 'd')
scatter3(LWG_14(G2_ASM), LWG_67(G2_ASM), a_y_max(G2_ASM), [], Gesamtleistung(G2_ASM), 's')
colormap(TUM_CI_colormap)        
colorbar
legend('PSM G1', 'PSM G2', 'ASM G1', 'ASM G2')
xlabel('LWG 1-4m/s^2')
ylabel('LWG 6-7m/s^2')
zlabel('ay max')

xlim([5 10])
ylim([5 10])
zlim([5 10])% xline=0:1000;
% yline=xline;
% plot(xline, yline, '--')

% txt = 'HA limitiert vmax';
% text(270, 230, txt)
% txt = 'VA limitiert vmax';
% text(270, 310,txt)




