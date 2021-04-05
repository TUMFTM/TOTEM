figure(3)
ax(1) = subplot(3,4,1);
plot(sv_time, sv_FZG_y(:,3), '-r')
hold on 

legend
grid on
xlabel('time [s]')
ylabel('a_y (m/s^2)')
xlim([0,simtime])
% hold off

ax(2) = subplot(3,4,2);
plot(sv_time, rad2deg(sv_FZG_phi(:,1)), '-r')
hold on

legend
grid on
xlabel('time [s]')
ylabel('phi (°)')
xlim([0,simtime])
% hold off

ax(3) = subplot(3,4,3);
plot(sv_time, rad2deg(sv_FZG_beta(:,1)), '-r')
hold on

legend
grid on
xlabel('time [s]')
ylabel('beta(°)')
xlim([0,simtime])
% hold off

% ax(4) = subplot(3,4,4);
% plot(sv_time, sum(sv_FZG_Fz,2), '-r');
% hold on
% grid on
% xlabel('time [s]')
% ylabel('sum(F_Z) (N)')
% xlim([0,simtime])
% % hold off

ax(4) = subplot(3,4,4);
plot(sv_time, rad2deg(sv_FZG_theta(:,1)), '-r');
hold on
grid on
xlabel('time (s)')
ylabel('theta (°)')
xlim([0,simtime])
% hold off

ax(5) = subplot(3,4,5);
plot(sv_time, sv_FZG_x(:,2), '-r');
hold on
grid on
xlabel('time [s]')
ylabel('v_x (m/s)')
xlim([0,simtime])
% hold off

ax(6) = subplot(3,4,6);
plot(sv_time, sv_FZG_x(:,3), '-r');
hold on
grid on
xlabel('time [s]')
ylabel('a_x (m/s^2)')
xlim([0,simtime])
% hold off

ax(7) = subplot(3,4,7);
plot(sv_time, rad2deg(sv_FZG_psi(:,2)), '-r');
hold on
grid on
xlabel('time [s]')
ylabel('psip(°/s)')
xlim([0,simtime])
% hold off

ax(8) = subplot(3,4,8);

hold on
plot(sv_time, rad2deg(sv_FZG_delta(:,1)), '-r');
plot(sv_time, rad2deg(sv_FZG_delta(:,2)), '-b');
plot(sv_time, rad2deg(0.5*(sv_FZG_delta(:,1)+ sv_FZG_delta(:,2))), '-g');
plot(sv_time, rad2deg(sv_FZG_delta(:,3)), '-m');
plot(sv_time, rad2deg(sv_FZG_delta(:,4)), '-k');
% plot(sv_time, rad2deg(sv_FAH_delta(:,1)), '--r');
% plot(sv_time, rad2deg(sv_FAH_delta(:,2)), '--b');
% plot(sv_time, rad2deg(0.5*(sv_FAH_delta(:,1)+ sv_FAH_delta(:,2))), '--g');
legend('rechts', 'links', 'Mittelwert', 'links hinten', 'rechts hinten', 'ohne kin/comp')
grid on
xlabel('time [s]')
ylabel('delta(°)')
xlim([0,simtime])
% hold off

ax(9) = subplot(3,4,9);

hold on
plot(sv_time, sv_FZG_M_antr(:,1), 'r-');
plot(sv_time, sv_FZG_M_antr(:,2), 'b-');
plot(sv_time, sv_FZG_M_antr(:,3), 'g-');
plot(sv_time, sv_FZG_M_antr(:,4), 'm-');
% plot(sv_time, sv_FZG_M_brems(:,1), 'r--');
% plot(sv_time, sv_FZG_M_brems(:,2), 'b--');
% plot(sv_time, sv_FZG_M_brems(:,3), 'g--');
% plot(sv_time, sv_FZG_M_brems(:,4), 'm--');
grid on
xlabel('time [s]')
ylabel('M_R (Nm)')
legend('RF', 'LF', 'RR' ,'LR')
xlim([0,simtime])
% hold off

ax(10) = subplot(3,4,10);

hold on
plot(sv_time, sv_FZG_omega(:,1), 'r-');
plot(sv_time, sv_FZG_omega(:,2), 'b-');
plot(sv_time, sv_FZG_omega(:,3), 'g-');
plot(sv_time, sv_FZG_omega(:,4), 'm-');
grid on
xlabel('time [s]')
ylabel('Omega (rad/s)')
legend('RF', 'LF', 'RR' ,'LR')
xlim([0,simtime])
% hold off

ax(11) = subplot(3,4,11);
hold on
plot(P_el.P_el_EM_az_VA./1000, 'r');
plot(P_el.P_el_EM_rn_VA./1000, 'b');
plot(P_el.P_el_EM_az_HA./1000, 'g');
plot(P_el.P_el_EM_rn_HA./1000, 'm');
grid on
xlabel('time [s]')
ylabel('P_m_o_t_ _e_l [kW]')
legend('vorne AZ', 'vorne RN', 'vorne RN', 'hinten AZ', 'hinten RN', 'hinten RN')
xlim([0,simtime])

ax(12) = subplot(3,4,12);
hold on
cla
plot(eta_EM_az_VA.*100, 'r');
plot(eta_EM_rn_VA.*100, 'b');
plot(eta_EM_az_HA.*100, 'g');
plot(eta_EM_rn_HA.*100, 'm');
grid on
xlabel('time [s]')
ylabel('eta_m_o_t [%]')
legend('vorne AZ', 'vorne RN', 'vorne RN', 'hinten AZ', 'hinten RN', 'hinten RN')
xlim([0,simtime])


linkaxes([ax(1), ax(2), ax(3), ax(4), ax(5), ax(6), ax(7), ax(8),ax(9), ax(10), ax(11), ax(12)], 'x');

clear ax