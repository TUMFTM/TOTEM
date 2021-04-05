figure(393)

farbgroesse=Gesamtleistung;

subplot(3,1,1)
cla
hold on
grid on
scatter(QD, QD_stat, [], farbgroesse)
colorbar
% xlim([0 50])
% ylim([0 15])
xlabel('QD')
ylabel('QD_stat')


subplot(3,1,2)
cla
hold on
grid on
scatter(QD, QD_inst, [], farbgroesse)
colorbar
% xlim([0 50])
% ylim([5 15])
xlabel('QD')
ylabel('QD_inst')


subplot(3,1,3)
cla
hold on
grid on
colorbar
scatter(QD, QD_komb, [], farbgroesse)
% xlim([0 50])
% ylim([0 75])
xlabel('QD')
ylabel('QD_komb')


%% LD und OD
farbgroesse=Leistung_HA;

figure(498)
subplot(3,1,1)
cla
hold on
grid on
scatter(FV, LD, [], farbgroesse)
colorbar
xlim([0 50])
ylim([0 100])
xlabel('FV')
ylabel('LD')

subplot(3,1,2)
cla
hold on
grid on
scatter(FV, QD, [], farbgroesse)
colorbar
xlim([0 50])
ylim([10 40])
xlabel('FV')
ylabel('QD')

subplot(3,1,3)
cla
hold on
grid on
scatter(FV, OD, [], farbgroesse)
colorbar
xlim([0 200])
ylim([20 40])
xlabel('FV')
ylabel('OD')