function [VA, HA, Color, LineStyle, MarkerStyle] = set_plot_style(name)

TUM_CI_colors %Lade TUM CI farben

txt = name(1:2);
    if strcmp(txt(1),'1')       %Konzepte mit Heckantrieb
        VA = 'VA: kein Antrieb/';
        LineStyle = '-';
        if strcmp(txt(2),'2') %HA: RA
            Color = orange;
            LineStyle = ':';
            HA = 'HA: RA';
            MarkerStyle = '<';
        elseif strcmp(txt(2),'3') %HA: OD
            Color = dunkeldunkelblau;
            LineStyle = ':';
            HA = 'HA: OD';
            MarkerStyle = '^';
        elseif strcmp(txt(2),'4') %HA: eTV
            Color = beige;
            LineStyle = ':';
            HA = 'HA: eTV';
            MarkerStyle = '>';
        end
    elseif strcmp(txt(2),'1')   %Konzepte mit Frontantrieb
        HA = 'HA: kein Antrieb';
        Color = 'k';
        if strcmp(txt(1),'2') %HA: RA
            Color = orange;
            LineStyle = '--';
            VA = 'VA: RA/';
            MarkerStyle = '<';
        elseif strcmp(txt(1),'3') %HA: OD
            Color = dunkeldunkelblau;
            LineStyle = '--';
            VA = 'VA: OD/';
            MarkerStyle = '^';
        elseif strcmp(txt(1),'4') %HA: eTV
            Color = beige;
            LineStyle = '--';
            VA = 'VA: eTV/';
            MarkerStyle = '>';
        end
    else                         % Konzepte mit Allradantrieb
         if and(strcmp(txt(1),'2'), strcmp(txt(2),'2')) 
            Color = orange;
            LineStyle = '-';
            MarkerStyle = '+';
            VA = 'VA: RA/';
            HA = 'HA: RA';
        elseif and(strcmp(txt(1),'2'), strcmp(txt(2),'3')) 
            Color = dunkeldunkelblau;
            LineStyle = '--';
            MarkerStyle = 'x';
            VA = 'VA: RA/';
            HA = 'HA: OD';
        elseif and(strcmp(txt(1),'2'), strcmp(txt(2),'4')) 
            Color = orange;
            LineStyle = '-.';
            MarkerStyle = '+';
            VA = 'VA: RA/';
            HA = 'HA: eTV';
        elseif and(strcmp(txt(1),'3'), strcmp(txt(2),'2')) 
            Color = dunkeldunkelblau;
            LineStyle = '-.';
            MarkerStyle = 'p';
            VA = 'VA: OD/';
            HA = 'HA: RA';
        elseif and(strcmp(txt(1),'3'), strcmp(txt(2),'3')) 
            Color = dunkeldunkelblau;
            LineStyle = '-';
            MarkerStyle = 's';
            VA = 'VA: OD/';
            HA = 'HA: OD';
        elseif and(strcmp(txt(1),'3'), strcmp(txt(2),'4')) 
            Color = beige;
            LineStyle = '-.';
            MarkerStyle = 'v';
            VA = 'VA: OD/';
            HA = 'HA: eTV';
        elseif and(strcmp(txt(1),'4'), strcmp(txt(2),'2')) 
            Color = orange;
            LineStyle = '--';
            MarkerStyle = 'd';
            VA = 'VA: eTV/';
            HA = 'HA: RA';
        elseif and(strcmp(txt(1),'4'), strcmp(txt(2),'3')) 
            Color = beige;
            LineStyle = '--';
            MarkerStyle = '<';
            VA = 'VA: eTV/';
            HA = 'HA: OD';
        elseif and(strcmp(txt(1),'4'), strcmp(txt(2),'4')) 
            Color = beige;
            LineStyle = '-';
            MarkerStyle = '>';
            VA = 'VA: eTV/';
            HA = 'HA: eTV';
         end
    end