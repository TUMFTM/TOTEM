function [WKG_Last] = Lastkennfeld_WKG()

%Erzeugung des "leeren" 1-D Kennfeldes f?r den Pesce-WKG

WKG_Last = zeros(1,1001);
WKG_Last(151:1001) = 1;
WKG_Last(1) = 0.15;       %abgelesen aus M?ller98 S.13
for i=2:151
WKG_Last(i)=0.15+0.85*(i-1)*1/150;
end

% x = 1:1000;
% 
% close(figure(1));
% f = figure(1);
% set(f, 'Color', 'white');
% plot(x,WKG_Last,'b','LineWidth', 3);
% 
% xlabel(['Last [',char(8240),']'])
% ylabel('Wirkungsgrad aus Last [-]');
% grid on;
% set(gca, 'fontsize',36);

end