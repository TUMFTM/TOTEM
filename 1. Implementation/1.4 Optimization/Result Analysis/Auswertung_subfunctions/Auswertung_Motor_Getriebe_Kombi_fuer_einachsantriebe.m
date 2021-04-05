% n_betr_gens=5;
% start_i=length(gang_VA)-n_betr_gens*n_Individuen;
% G1_PSM = start_i+find(and(gang_HA(end-n_Individuen*n_betr_gens+1:end)==1 ,  Motor_HA(end-n_Individuen*n_betr_gens+1:end)==2));
% G2_PSM = start_i+find(and(gang_HA(end-n_Individuen*n_betr_gens+1:end)==2 ,  Motor_HA(end-n_Individuen*n_betr_gens+1:end)==2));
% G1_ASM = start_i+find(and(gang_HA(end-n_Individuen*n_betr_gens+1:end)==1 ,  Motor_HA(end-n_Individuen*n_betr_gens+1:end)==1));
% G2_ASM = start_i+find(and(gang_HA(end-n_Individuen*n_betr_gens+1:end)==2 ,  Motor_HA(end-n_Individuen*n_betr_gens+1:end)==1));
if strcmp('1', name(2)) %Frontantrieb
    G1_PSM = find(and(Verbrauch<16, and(Pareto_01_all{1}, and(gang_VA==1 ,  Motor_VA==2))));
    G2_PSM = find(and(Verbrauch<16, and(Pareto_01_all{1}, and(gang_VA==2 ,  Motor_VA==2))));
    G1_ASM = find(and(Verbrauch<16, and(Pareto_01_all{1}, and(gang_VA==1 ,  Motor_VA==1))));
    G2_ASM = find(and(Verbrauch<16, and(Pareto_01_all{1}, and(gang_VA==2 ,  Motor_VA==1))));
    n_mot=n_VA;
    M=M_VA;
    Leistung=Leistung_VA;
    i1=i1_VA;
    spreizung=spreizung_VA;
    
elseif strcmp('1', name(1)) %Heckantrieb
    G1_PSM = find(and(Verbrauch<16, and(Pareto_01_all{1}, and(gang_HA==1 ,  Motor_HA==2))));
    G2_PSM = find(and(Verbrauch<16, and(Pareto_01_all{1}, and(gang_HA==2 ,  Motor_HA==2))));
    G1_ASM = find(and(Verbrauch<16, and(Pareto_01_all{1}, and(gang_HA==1 ,  Motor_HA==1))));
    G2_ASM = find(and(Verbrauch<16, and(Pareto_01_all{1}, and(gang_HA==2 ,  Motor_HA==1))));
    n_mot=n_HA;
    M=M_HA;
    Leistung=Leistung_HA;
    i1=i1_HA;
    spreizung=spreizung_HA;
end





%% n zu M verhältnis
    w_fig = 14.5;
    h_fig = 10;
fig(407) = figure('Units','centimeters','Position',[1 1 w_fig h_fig]);
cla 
hold on
grid on

% scatter(n(G1_PSM), M(G1_PSM), 100, Leistung(G1_PSM), '+')
scatter(n_mot(G2_PSM)./1000, M(G2_PSM), 100, i1(G2_PSM), '.')
% scatter(n(G1_ASM), M(G1_ASM), 100, Leistung(G1_ASM), 'd')
% scatter(n(G2_ASM), M(G2_ASM), 100, Leistung(G2_ASM), 's')


colormap(TUM_CI_colormap_2c)        
c5=colorbar;
%             caxis([50 200]);
xlabel('Maximaldrehzahl in 1000 min^-^1', 'FontSize', 9)
ylabel('Nenndrehmoment in Nm', 'FontSize', 9)
ylim([50 300])
max_drehzahlen=10000:16000;
nenn_drehzahlen_rad=max_drehzahlen./2/60*2*pi;
leistungen=(50:25:250)'.*1000;
momente=leistungen./nenn_drehzahlen_rad;
plot(max_drehzahlen./1000, momente, '--', 'Color', graustufe50)

legend( 'Konfigurationen ', 'konst. Leistung', 'FontSize', 9, 'location', 'northwest')
% legend( 'Konfigurationen ', 'konst. Spreizung', 'FontSize', 9, 'location', 'northwest')
% legend('HA PSM 2 Gänge', 'HA ASM 2 Gänge', 'konst. Spreizung', 'FontSize', 9, 'location', 'northwest')
title(c5,sprintf('Übersetzung 1. Gang'), 'FontSize', 9)
set(gca, 'Position', [0.114 0.11 0.68 0.79])

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
%% Übersetzungen im 1. und 2. Gang
    w_fig = 14.5;
    h_fig = 10;
fig(407) = figure('Units','centimeters','Position',[1 1 w_fig h_fig]);
cla 
hold on
grid on

% scatter(i1_HA(G1_PSM), i1_HA(G1_PSM)./spreizung_HA(G1_PSM), [], Leistung_VA(G1_PSM), '+')
scatter(i1(G2_PSM), i1(G2_PSM)./spreizung(G2_PSM), 100, Leistung(G2_PSM), '.')
% scatter(i1_HA(G1_ASM), i1_HA(G1_ASM)./spreizung_HA(G1_ASM), [], Leistung_VA(G1_ASM), 'd')
% scatter(i1_HA(G2_ASM), i1_HA(G2_ASM)./spreizung_HA(G2_ASM), [], Leistung_VA(G2_ASM), 's')


colormap(TUM_CI_colormap_2c)        
c5=colorbar
caxis([50 180]);

xlabel('Übersetzung im ersten Gang', 'FontSize', 9)
ylabel('Übersetzung im zweiten Gang', 'FontSize', 9)
% xlim([2 5])
xline=7:16;
spreizungen=(2:0.5:5)';
yline=(1./spreizungen)*xline;
plot(xline, yline, '--', 'Color', graustufe50)


legend( 'Konfigurationen ', 'konst. Spreizung', 'FontSize', 9, 'location', 'northwest')
% legend('HA PSM 2 Gänge', 'HA ASM 2 Gänge', 'konst. Spreizung', 'FontSize', 9, 'location', 'northwest')
title(c5,sprintf('Verbaute Nennleistung in kW'), 'FontSize', 9)
set(gca, 'Position', [0.114 0.11 0.68 0.79])

    if strcmp(speichern, 'Ja')
        set(gcf, 'Renderer', 'painters');
        speichername=['Übersetzungen_im_1_und_2_Gang', name(1:2)];
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
scatter(i1(G2_ASM), i1(G2_ASM)./spreizung(G2_ASM),[], Verbrauch(G2_ASM),  'filled')
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
%     w_fig = 14.5;
%     h_fig = 10;
% fig(564) = figure('Units','centimeters','Position',[1 1 w_fig h_fig]);
% cla 
% hold on
% grid on
% 
% i12_HA_ASM = [i1_HA(G2_ASM), i1_HA(G2_ASM)./spreizung_HA(G2_ASM)];
% i12_VA_ASM = [i1_VA(G2_ASM), i1_VA(G2_ASM)];
% i12_HA_PSM = [i1_HA(G2_PSM), i1_HA(G2_PSM)./spreizung_HA(G2_PSM)];
% i12_VA_PSM = [i1_VA(G2_PSM), i1_VA(G2_PSM)];
% 
% for i=1:length(i12_VA_ASM)
%     plot(i12_VA_ASM(i,:), i12_HA_ASM(i,:), '--', 'Color', graustufe50)
% end
% for i=1:length(i12_VA_PSM)
%     plot(i12_VA_PSM(i,:), i12_HA_PSM(i,:), ':', 'Color', graustufe50)
% end
% 
% s1=scatter(i1_VA(G1_PSM), i1_HA(G1_PSM), [], Verbrauch(G1_PSM), '+')
% s2=scatter(i1_VA(G1_ASM), i1_HA(G1_ASM), [], Verbrauch(G1_ASM), 'd')
% s3=scatter(i1_VA(G2_PSM), i1_HA(G2_PSM), [], Verbrauch(G2_PSM), '*')
% s4=scatter(i1_VA(G2_PSM), i1_HA(G2_PSM)./spreizung_HA(G2_PSM), [], Verbrauch(G2_PSM), '*')
% s5=scatter(i1_VA(G2_ASM), i1_HA(G2_ASM), [], Verbrauch(G2_ASM), 's')
% s6=scatter(i1_VA(G2_ASM), i1_HA(G2_ASM)./spreizung_HA(G2_ASM), [], Verbrauch(G2_ASM), 's')
% 
% legend([s1, s3, s2, s5], 'HA PSM 1 Gang', 'HA PSM 2 Gänge', 'HA ASM 1 Gang', 'HA ASM 2 Gänge', 'FontSize', 9, 'location', 'southwest')
% 
% colormap(TUM_CI_colormap)        
% c5=colorbar
% xlabel('Übersetzungsverhältnis VA', 'FontSize', 9)
% ylabel('Übersetzungsverhältnis HA', 'FontSize', 9)
% title(c5,'Verbrauch in kWh/100km', 'FontSize', 9)
% 
%     if strcmp(speichern, 'Ja')
%         set(gcf, 'Renderer', 'painters');
%         speichername=['Übersetzungsverhältnisse VA und HA', name(1:2)];
%         print(gcf, speichername,'-dmeta')
%     end

