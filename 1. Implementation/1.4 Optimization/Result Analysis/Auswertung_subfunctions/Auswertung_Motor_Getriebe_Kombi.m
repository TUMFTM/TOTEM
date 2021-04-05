% n_betr_gens=5;
% start_i=length(gang_VA)-n_betr_gens*n_Individuen;
% G1_PSM = start_i+find(and(gang_HA(end-n_Individuen*n_betr_gens+1:end)==1 ,  Motor_HA(end-n_Individuen*n_betr_gens+1:end)==2));
% G2_PSM = start_i+find(and(gang_HA(end-n_Individuen*n_betr_gens+1:end)==2 ,  Motor_HA(end-n_Individuen*n_betr_gens+1:end)==2));
% G1_ASM = start_i+find(and(gang_HA(end-n_Individuen*n_betr_gens+1:end)==1 ,  Motor_HA(end-n_Individuen*n_betr_gens+1:end)==1));
% G2_ASM = start_i+find(and(gang_HA(end-n_Individuen*n_betr_gens+1:end)==2 ,  Motor_HA(end-n_Individuen*n_betr_gens+1:end)==1));

G1_PSM = find(and(Verbrauch<16, and(Pareto_01_all{1}, and(gang_VA==1 ,  Motor_HA==2))));
G2_PSM = find(and(Verbrauch<16, and(Pareto_01_all{1}, and(gang_VA==2 ,  Motor_HA==2))));
G1_ASM = find(and(Verbrauch<16, and(Pareto_01_all{1}, and(gang_VA==1 ,  Motor_HA==1))));
G2_ASM = find(and(Verbrauch<16, and(Pareto_01_all{1}, and(gang_VA==2 ,  Motor_HA==1))));


%% a

figure(39)
cla 
hold on
grid on

scatter(v_rad_max_VA(G1_PSM), v_rad_max_HA(G1_PSM),[], Verbrauch(G1_PSM), '+')
scatter(v_rad_max_VA(G2_PSM), v_rad_max_HA(G2_PSM),[], Verbrauch(G2_PSM),  '*')
scatter(v_rad_max_VA(G1_ASM), v_rad_max_HA(G1_ASM),[], Verbrauch(G1_ASM),  'd')
scatter(v_rad_max_VA(G2_ASM), v_rad_max_HA(G2_ASM),[], Verbrauch(G2_ASM),  's')
colormap(TUM_CI_colormap_2c)        
colorbar
legend('PSM G1', 'PSM G2', 'ASM G1', 'ASM G2')
xlabel('Maximale Geschwindigkeit VA in km/h')
ylabel('Maximale Geschwindigkeit HA in km/h')
xlim([100 300])
xline=0:1000;
yline=xline;
plot(xline, yline, '--')

txt = 'HA limitiert vmax';
text(240, 230, txt)
txt = 'VA limitiert vmax';
text(240, 310,txt)

%% n zu M verhältnis
    w_fig = 14.5;
    h_fig = 10;
fig(407) = figure('Units','centimeters','Position',[1 1 w_fig h_fig]);
cla 
hold on
grid on

scatter(M_VA(G1_PSM)./n_VA(G1_PSM)*1000, M_HA(G1_PSM)./n_HA(G1_PSM)*1000, [], Verbrauch(G1_PSM), '+')
scatter(M_VA(G2_PSM)./n_VA(G2_PSM)*1000, M_HA(G2_PSM)./n_HA(G2_PSM)*1000, [], Verbrauch(G2_PSM), '*')
scatter(M_VA(G1_ASM)./n_VA(G1_ASM)*1000, M_HA(G1_ASM)./n_HA(G1_ASM)*1000, [], Verbrauch(G1_ASM), 'd')
scatter(M_VA(G2_ASM)./n_VA(G2_ASM)*1000, M_HA(G2_ASM)./n_HA(G2_ASM)*1000, [], Verbrauch(G2_ASM), 's')

colormap(TUM_CI_colormap_2c)        
c5=colorbar
legend('HA PSM G1', 'HA PSM G2', 'HA ASM G1', 'HA ASM G2', 'FontSize', 9)
xlabel('M/n-Verhältnis an der Vorderachse in Nm/1000min-1', 'FontSize', 9)
ylabel('M/n-Verhältnis an der Hinterachse in Nm/1000min-1', 'FontSize', 9)
% xlim([2 5])
xline=0:10;
yline=xline;
plot(xline, yline, '--')
legend('HA PSM VA 1 Gang', 'HA PSM VA 2 Gänge', 'HA ASM VA 1 Gang', 'HA ASM VA 2 Gang',  'FontSize', 9, 'location', 'northwest')
title(c5,'Verbrauch in kWh/100km', 'FontSize', 9)

    if strcmp(speichern, 'Ja')
        set(gcf, 'Renderer', 'painters');
        speichername=['M_zu_n_Verhältnis_motoren', name(1:2)];
        print(gcf, speichername,'-dmeta')
    end

% 
% txt = 'HA limitiert vmax';
% text(270, 230, txt)
% txt = 'VA limitiert vmax';
% text(270, 310,txt)

%% übersetzung HA

figure(40)
cla 
hold on
grid on

% scatter(i1_HA(G2_PSM), i1_HA(G2_PSM)./spreizung_HA(G2_PSM),[], n_HA(G2_PSM),  'filled')
scatter(i1_HA(G2_ASM), i1_HA(G2_ASM)./spreizung_HA(G2_ASM),[], Verbrauch(G2_ASM),  'filled')
colormap(TUM_CI_colormap_2c)
c3=colorbar
% caxis([14000 20000])
title(c3,'Verbrauch in kWh/100km')
xlabel('Übersetzung 1. Gang')
ylabel('Übersetzung 2. Gang')

xline=7:16;
spreizungen=(2:5)';
yline=(1./spreizungen)*xline;
plot(xline, yline, '--')
% 
% txt = 'HA limitiert vmax';
% text(400, 700, txt)
% txt = 'VA limitiert vmax';
% text(500,300,txt)

%% Übersetzung beide Achsen
    w_fig = 14.5;
    h_fig = 10;
fig(564) = figure('Units','centimeters','Position',[1 1 w_fig h_fig]);
cla 
hold on
grid on

i12_HA_ASM = [i1_HA(G2_ASM), i1_HA(G2_ASM)];
i12_VA_ASM = [i1_VA(G2_ASM), i1_VA(G2_ASM)./spreizung_VA(G2_ASM)];
i12_HA_PSM = [i1_HA(G2_PSM), i1_HA(G2_PSM)];
i12_VA_PSM = [i1_VA(G2_PSM), i1_VA(G2_PSM)./spreizung_VA(G2_PSM)];

for i=1:length(i12_VA_ASM)
    plot(i12_VA_ASM(i,:), i12_HA_ASM(i,:), '--', 'Color', graustufe20.*0.9)
end
for i=1:length(i12_VA_PSM)
    plot(i12_VA_PSM(i,:), i12_HA_PSM(i,:), ':', 'Color', graustufe20.*0.9)
end

s1=scatter(i1_VA(G1_PSM), i1_HA(G1_PSM), [], Verbrauch(G1_PSM), '+')
s2=scatter(i1_VA(G1_ASM), i1_HA(G1_ASM), [], Verbrauch(G1_ASM), 'd')
s3=scatter(i1_VA(G2_PSM), i1_HA(G2_PSM), [], Verbrauch(G2_PSM), '*')
s4=scatter(i1_VA(G2_PSM)./spreizung_VA(G2_PSM), i1_HA(G2_PSM), [], Verbrauch(G2_PSM), '*')
s5=scatter(i1_VA(G2_ASM), i1_HA(G2_ASM), [], Verbrauch(G2_ASM), 's')
s6=scatter(i1_VA(G2_ASM)./spreizung_VA(G2_ASM), i1_HA(G2_ASM), [], Verbrauch(G2_ASM), 's')

legend([s1, s3, s2, s5], 'HA PSM 1 Gang', 'HA PSM 2 Gänge', 'HA ASM 1 Gang', 'HA ASM 2 Gänge',  'FontSize', 9, 'location', 'southeast')

colormap(TUM_CI_colormap_2c)        
c5=colorbar
xlabel('Übersetzungsverhältnis VA', 'FontSize', 9)
ylabel('Übersetzungsverhältnis HA', 'FontSize', 9)
title(c5,'Verbrauch in kWh/100km', 'FontSize', 9)
ylim([4 16])

    if strcmp(speichern, 'Ja')
        set(gcf, 'Renderer', 'painters');
        speichername=['Übersetzungsverhältnisse VA und HA', name(1:2)];
        print(gcf, speichername,'-dmeta')
    end
%% Leistungsaufteilung
    w_fig = 14.5;
    h_fig = 10;
fig(846) = figure('Units','centimeters','Position',[1 1 w_fig h_fig]);
cla 
hold on
grid on



% for i=1:length(i12_VA_ASM)
%     plot(i12_VA_ASM(i,:), i12_HA_ASM(i,:), '--', 'Color', graustufe20.*0.9)
% end
% for i=1:length(i12_VA_PSM)
%     plot(i12_VA_PSM(i,:), i12_HA_PSM(i,:), ':', 'Color', graustufe20.*0.9)
% end

s1=scatter(Gesamtleistung(G1_PSM), Anteil_HA(G1_PSM), [], Leistung_HA(G1_PSM), '+')
s2=scatter(Gesamtleistung(G1_ASM), Anteil_HA(G1_ASM), [], Leistung_HA(G1_ASM), 'd')
s3=scatter(Gesamtleistung(G2_PSM), Anteil_HA(G2_PSM), [], Leistung_HA(G2_PSM), '*')
% s4=scatter(i1_VA(G2_PSM)./spreizung_VA(G2_PSM), i1_HA(G2_PSM), [], Verbrauch(G2_PSM), '*')
s5=scatter(Gesamtleistung(G2_ASM), Anteil_HA(G2_ASM), [], Leistung_HA(G2_ASM), 's')
% s6=scatter(i1_VA(G2_ASM)./spreizung_VA(G2_ASM), i1_HA(G2_ASM), [], Verbrauch(G2_ASM), 's')

legend([s1, s3, s2, s5], 'HA PSM 1 Gang', 'HA PSM 2 Gänge', 'HA ASM 1 Gang', 'HA ASM 2 Gänge',  'FontSize', 9, 'location', 'southeast')
colormap(jet)
colormap(TUM_CI_colormap_2c)        
c5=colorbar
xlabel('installierte Nennleistung in kW', 'FontSize', 9)
ylabel('Anteil der HA an der installierten Nennleistung in %', 'FontSize', 9)
title(c5,'inst. Leistung HA', 'FontSize', 9)
caxis([40 180])

    if strcmp(speichern, 'Ja')
        set(gcf, 'Renderer', 'painters');
        speichername=['Leistungsaufteilung VA und HA', name(1:2)];
        print(gcf, speichername,'-dmeta')
    end

