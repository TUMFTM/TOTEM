dc.acc=[0; diff(dc.speed)]./[1;diff(dc.time)];
if dc.time(1)==0;
    dc.acc(1)=0;
end

% ax(1) = subplot(2,1,1)
% plot(dc.time, dc.speed)
% grid on
% grid minor
% ax(2) = subplot(2,1,2)
% plot(dc.time, dc.acc)
% grid on
% grid minor
% 
% 
% dcshort.time=dc.time(1:50000);
% dcshort.speed=dc.speed(1:50000);
% dcshort.acc=dc.acc(1:50000);
% 
% linkaxes(ax,'x');
% 
% save('Hinfahrt5_mit_Hoehe_und_acc.mat', 'dc', 'dcshort')