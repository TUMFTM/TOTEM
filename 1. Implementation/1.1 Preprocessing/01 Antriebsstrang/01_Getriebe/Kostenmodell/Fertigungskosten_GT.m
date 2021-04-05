function cpp=Fertigungskosten_GT(Standort, n_Gaenge, i_Gaenge, TV, OD, TS, Stkzahl)%in diesem Skript werden die Fertigungskosten des Getriebes berechnet

%% Initialisierung der Fertigungsparameter abhängig von der gewählten Stückzahl
%Quelle: Obermayer [14] und Batpac [17]

if Standort==1      %Deutschland
    Ko_MA=25.5;     %Stundenlohn
    Ko_BB=3152;     %Kosten für Bebauung
elseif Standort==2  %USA
    Ko_MA=18;       %Stundenlohn
    Ko_BB=3000;     %Kosten für Bebauung
elseif Standort==3  %Rumänien
    Ko_MA=2.7;      %Stundenlohn
    Ko_BB=1492;     %Kosten für Bebauung
elseif Standort==4  %Tschechien
    Ko_MA=6.7;      %Stundenlohn
    Ko_BB=1629;     %Kosten für Bebauung
end

%% Fertigungskostenstrukturen

%Getriebe mit OD (Achszentrale Anordnung)

if n_Gaenge==1 && i_Gaenge<=6 && TV==0 && OD==1
     
    Abs_GB=25;                      
    Abs_MA=15;                      
    Tage=220;                     
    Schichten=2;                    
    Stunden=8;                      
    MA=11;                          
    OV_MA=0.4;                    
    Flaeche=20000;                 
    OEE=0.8;                       
    Zins=0.02;                     
    Energie=0.05;                   
    Investitionen_GS_GT_1_1_OD_AD;  
       
elseif n_Gaenge==1 && i_Gaenge>6 && TV==0 && OD==1
    
    Abs_GB=25;                     
    Abs_MA=15;                      
    Tage=220;                      
    Schichten=2;                
    Stunden=8;                      
    MA=12;                       
    OV_MA=0.4;                     
    Flaeche=20000;              
    OEE=0.80;                     
    Zins=0.02;                    
    Energie=0.05;                  
    Investitionen_GS_GT_2_1_OD_AD;  
    
elseif n_Gaenge>=2 && TV==0 && OD==1
    
    Abs_GB=25;                     
    Abs_MA=15;                     
    Tage=220;                      
    Schichten=2;                
    Stunden=8;                      
    MA=15;                       
    OV_MA=0.4;                      
    Flaeche=20000;                  
    OEE=0.80;                      
    Zins=0.02;                    
    Energie=0.10;                  
    Investitionen_GS_GT_2_1_OD_AD; 
    
 %Getriebe ohne OD (Radnahe Anordnung)

elseif n_Gaenge==1 && i_Gaenge<=6 && TV==0 && OD==0
     
    Abs_GB=25;                      
    Abs_MA=15;                     
    Tage=220;                      
    Schichten=2;                   
    Stunden=8;                    
    MA=8;                          
    OV_MA=0.4;                      
    Flaeche=20000;                  
    OEE=0.8;                        
    Zins=0.02;                     
    Energie=0.05;                   
    Investitionen_GS_GT_1_1_AD;     
    
       
elseif n_Gaenge==1 && i_Gaenge>6 && TV==0 && OD==0
    
    Abs_GB=25;                      
    Abs_MA=15;                      
    Tage=220;                       
    Schichten=2;                 
    Stunden=8;                     
    MA=9;                           
    OV_MA=0.4;                     
    Flaeche=20000;                 
    OEE=0.80;                       
    Zins=0.02;                      
    Energie=0.05;                   
    Investitionen_GS_GT_2_1_AD;     
    
elseif n_Gaenge>=2 && TV==0 && OD==0
    
    Abs_GB=25;                      
    Abs_MA=15;                     
    Tage=220;                      
    Schichten=2;                    
    Stunden=8;                     
    MA=12;                          
    OV_MA=0.4;                     
    Flaeche=20000;                  
    OEE=0.80;                       
    Zins=0.02;                     
    Energie=0.10;                   
    Investitionen_GS_GT_2_2_AD;    
        
%Getriebe mit TV    

elseif n_Gaenge==1 && i_Gaenge<=6 && TV==1
    
    Abs_GB=25;                   
    Abs_MA=15;                    
    Tage=220;                      
    Schichten=2;                   
    Stunden=8;                      
    MA=19;                         
    OV_MA=0.4;                      
    Flaeche=20000;                 
    OEE=0.80;                       
    Zins=0.02;                    
    Energie=0.15;                  
    Investitionen_GS_GT_1_1_eTV_AD; 

elseif n_Gaenge==1 && i_Gaenge>6 && TV==1
    
    Abs_GB=25;                  
    Abs_MA=15;                     
    Tage=220;                     
    Schichten=2;                  
    Stunden=8;                    
    MA=20;                          
    OV_MA=0.4;                      
    Flaeche=20000;                  
    OEE=0.80;                      
    Zins=0.02;                      
    Energie=0.15;                  
    Investitionen_GS_GT_2_1_eTV_AD; 
    
elseif n_Gaenge>=2 && TV==1    
    
    Abs_GB=25;                      
    Abs_MA=15;                     
    Tage=220;                      
    Schichten=2;                   
    Stunden=8;                      
    MA=22;                         
    OV_MA=0.4;                     
    Flaeche=20000;                  
    OEE=0.80;                    
    Zins=0.02;                     
    Energie=0.15;                  
    Investitionen_GS_GT_2_2_eTV_AD; 
    
%Getriebe mit TS     

elseif n_Gaenge==1 && i_Gaenge<=6 && TS==1
    
    Abs_GB=25;                   
    Abs_MA=15;                    
    Tage=220;                      
    Schichten=2;                   
    Stunden=8;                      
    MA=13;                         
    OV_MA=0.4;                      
    Flaeche=20000;                 
    OEE=0.80;                       
    Zins=0.02;                    
    Energie=0.15;                  
    Investitionen_GS_GT_1_1_TS_AD;
    
elseif n_Gaenge==1 && i_Gaenge>6 TS==1
    
    Abs_GB=25;                  
    Abs_MA=15;                     
    Tage=220;                     
    Schichten=2;                  
    Stunden=8;                    
    MA=14;                          
    OV_MA=0.4;                      
    Flaeche=20000;                  
    OEE=0.80;                      
    Zins=0.02;                      
    Energie=0.15;                  
    Investitionen_GS_GT_2_1_TS_AD; 
    
elseif n_Gaenge>=2 && TS==1    
    
    Abs_GB=25;                      
    Abs_MA=15;                     
    Tage=220;                      
    Schichten=2;                   
    Stunden=8;                      
    MA=17;                         
    OV_MA=0.4;                     
    Flaeche=20000;                  
    OEE=0.80;                    
    Zins=0.02;                     
    Energie=0.15;                  
    Investitionen_GS_GT_2_2_TS_AD;    
end

%% Fertigungskostenstruktur berechnen

Ko_Personal=Schichten*Tage*Stunden*Ko_MA*MA*(1+OV_MA);
Ko_Maschinen=Invest/Abs_MA;
Ko_Instandhaltung=(1-OEE)*Ko_Maschinen;
Ko_Kapital=(Flaeche*0.8*Ko_BB+Invest)*Zins;
Ko_Abs=(Flaeche*Ko_BB)/Abs_GB;
Ko_Energie=Invest*Energie;

Ko_Fertigung=Ko_Personal+Ko_Maschinen+Ko_Instandhaltung+Ko_Kapital+Ko_Abs+Ko_Energie;

cpp=Ko_Fertigung/100000;

%%
%Skalierung der Fertigungskosten auf die Stückzahl der Maschine. Mit
%sinkenden Stückzahlen steigen die Fertigungskosten nach Ehrlenspiel [99]

if Stkzahl>=90000
        cpp=cpp;
elseif Stkzahl>=80000 && Stkzahl<90000
        cpp=cpp*1.1;  
elseif Stkzahl>=70000 && Stkzahl<80000
        cpp=cpp*1.15;  
elseif Stkzahl>=50000 && Stkzahl<70000
        cpp=cpp*1.2;  
elseif Stkzahl>=30000 && Stkzahl<50000
        cpp=cpp*2;   
elseif Stkzahl>=20000 && Stkzahl<30000
        cpp=cpp*3;  
elseif Stkzahl>=10000 && Stkzahl<20000
        cpp=cpp*3.5; 
elseif Stkzahl>=6000 && Stkzahl<10000
        cpp=cpp*4; 
elseif Stkzahl>=5000 && Stkzahl<6000
        cpp=cpp*4.5; 
elseif Stkzahl>=3000 && Stkzahl<5000
        cpp=cpp*5; 
elseif Stkzahl<3000
        cpp=cpp*6; 
end
