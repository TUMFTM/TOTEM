figure(1)
ax(1) = subplot(3,3,1);
hold on 
grid on
plot(sv_time, sv_FZG_Fs(:,1), '-r')
plot(sv_time, sv_FZG_Fs(:,2), '-g')
plot(sv_time, sv_FZG_Fs(:,3), '-b')
plot(sv_time, sv_FZG_Fs(:,4), '-k')
legend('RF','LF','RR','LR')
ylabel('F_S abgesetzte Seitenkraft')

ax(2) = subplot(3,3,2);
hold on 
grid on
plot(sv_time, sv_FZG_Fl(:,1), '-r')
plot(sv_time, sv_FZG_Fl(:,2), '-g')
plot(sv_time, sv_FZG_Fl(:,3), '-b')
plot(sv_time, sv_FZG_Fl(:,4), '-k')
plot(sv_time, sum(transpose(sv_FZG_Fl(:,1:4))), '-m')
legend('RF','LF','RR','LR', 'Summe')
ylabel('F_l abgesetzte Längskraft')

ax(3) = subplot(3,3,3);
hold on 
grid on
plot(sv_time, sv_FZG_Fz(:,1), '-r')
plot(sv_time, sv_FZG_Fz(:,2), '-g')
plot(sv_time, sv_FZG_Fz(:,3), '-b')
plot(sv_time, sv_FZG_Fz(:,4), '-k')
legend('RF','LF','RR','LR')
ylabel('F_z Normalkraft')

ax(4) = subplot(3,3,4);
hold on 
grid on
plot(sv_time, sv_FZG_wheel_Ms(:,1), '-r')
plot(sv_time, sv_FZG_wheel_Ms(:,2), '-g')
plot(sv_time, sv_FZG_wheel_Ms(:,3), '-b')
plot(sv_time, sv_FZG_wheel_Ms(:,4), '-k')
legend('RF','LF','RR','LR')
ylabel('M_s Reifenrollwiderstand')

% ax(5) = subplot(3,3,5)
% hold on 
% grid on
% plot(sv_time, sv_FZG_wheel_Ml(:,1), '-r')
% plot(sv_time, sv_FZG_wheel_Ml(:,2), '-g')
% plot(sv_time, sv_FZG_wheel_Ml(:,3), '-b')
% plot(sv_time, sv_FZG_wheel_Ml(:,4), '-k')
% legend('RF','LF','RR','LR')
% ylabel('M_l Reifensturzmoment')


ax(5) = subplot(3,3,5);
hold on 
grid on
plot(sv_time, sv_kappa(:,1), '-r')
plot(sv_time, sv_kappa(:,2), '-g')
plot(sv_time, sv_kappa(:,3), '-b')
plot(sv_time, sv_kappa(:,4), '-k')
legend('RF','LF','RR','LR')
ylabel('Längsschlupf')

ax(6) = subplot(3,3,6);
hold on 
grid on
plot(sv_time, sv_FZG_wheel_Mh(:,1), '-r')
plot(sv_time, sv_FZG_wheel_Mh(:,2), '-g')
plot(sv_time, sv_FZG_wheel_Mh(:,3), '-b')
plot(sv_time, sv_FZG_wheel_Mh(:,4), '-k')
legend('RF','LF','RR','LR')
ylabel('M_z Reifenrückstellmoment')

ax(7) = subplot(3,3,7);
hold on 
grid on
plot(sv_time, sv_FZG_M_antr(:,1), '-r')
plot(sv_time, sv_FZG_M_antr(:,2), '-g')
plot(sv_time, sv_FZG_M_antr(:,3), '-b')
plot(sv_time, sv_FZG_M_antr(:,4), '-k')
legend('RF','LF','RR','LR')
ylabel('Antriebsmoment')

ax(8) = subplot(3,3,8);
hold on 
grid on
plot(sv_time, sv_FZG_M_brems(:,1), '-r')
plot(sv_time, sv_FZG_M_brems(:,2), '-g')
plot(sv_time, sv_FZG_M_brems(:,3), '-b')
plot(sv_time, sv_FZG_M_brems(:,4), '-k')
legend('RF','LF','RR','LR')
ylabel('Bremsmoment')

ax(9) = subplot(3,3,9);
hold on 
grid on
plot(sv_time, rad2deg(sv_alpha(:,1)), '-r')
plot(sv_time, rad2deg(sv_alpha(:,2)), '-g')
plot(sv_time, rad2deg(sv_alpha(:,3)), '-b')
plot(sv_time, rad2deg(sv_alpha(:,4)), '-k')
legend('RF','LF','RR','LR')
ylabel('Schräglaufwinkel')

linkaxes(ax,'x');

clear ax