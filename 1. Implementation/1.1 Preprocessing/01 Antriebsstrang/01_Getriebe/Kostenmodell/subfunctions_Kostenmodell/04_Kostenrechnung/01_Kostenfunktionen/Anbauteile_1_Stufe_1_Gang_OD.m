% Anbauteilkosten f�r ein Einstufiges Eingang Getriebe mit offenem
% Differential.

%Getriebe
Oel=5;
Dichtungen=4;
Schrauben=2;
Lager=20;
Uebriges=10;

%Differential
Oel_OD=2;
Dichtungen_OD=2;
Schrauben_OD=2;
Lager_OD=10;
Uebriges_OD=5;

Anbauteile=Oel+Dichtungen+Schrauben+Lager+Uebriges+Oel_OD+Dichtungen_OD+Schrauben_OD+Lager_OD+Uebriges_OD;

clearvars  Oel Dichtungen Schrauben Lager Uebriges ...
    Oel_OD Dichtungen_OD Schrauben_OD Lager_OD Uebriges_OD