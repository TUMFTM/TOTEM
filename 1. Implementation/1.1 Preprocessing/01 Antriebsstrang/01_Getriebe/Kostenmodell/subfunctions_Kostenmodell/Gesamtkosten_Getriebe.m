function Kosten_Getriebe=Gesamtkosten_Getriebe(MK_gesamt_GT, K_Anbauteile, cpp, Stkzahl)

Kosten_Getriebe=MK_gesamt_GT+K_Anbauteile+cpp;


if Stkzahl<=100000
    Kosten_Getriebe=Kosten_Getriebe;
elseif Stkzahl>100000 && Stkzahl<=250000
    x=(1-0.90)/(100001-250000);
    y=1-x*(100001-Stkzahl);
    Kosten_Getriebe=Kosten_Getriebe*y;
elseif Stkzahl>250000 && Stkzahl<=500000
    Kosten_Getriebe=Kosten_Getriebe*0.90;
    x=(1-0.90)/(250001-500000);
    y=1-x*(250001-Stkzahl);
    Kosten_Getriebe=Kosten_Getriebe*y;
elseif Stkzahl>500000
    Kosten_Getriebe=Kosten_Getriebe*0.81
    x=(1-0.92)/(500001-2000000);
    y=1-x*(500001-Stkzahl);
    Kosten_Getriebe=Kosten_Getriebe*y;
end