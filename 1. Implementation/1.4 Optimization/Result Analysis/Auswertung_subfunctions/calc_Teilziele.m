istart=Anzahl_der_Ziele+Anzahl_der_Designvariablen;

QD_stat =   (((mean(B{n}(:,istart+2:istart+5    )')')-8)./5)*(-100)+40;
QD_inst =   (((mean(B{n}(:,istart+10:istart+12  )')')-8)./5)*(-100)+40;
QD_komb =   (((mean(B{n}(:,istart+13:istart+15  )')')-8)./5)*(-100)+40;
QD      =   mean([QD_stat'; QD_inst'; QD_komb'])';

LD      =   (((mean(B{n}(:,istart+6:istart+7)')')-8)./5)*(-100)+40;

OD   = (((mean(B{n}(:,[istart+8:istart+9, istart+16:istart+18, istart+21])')')-8)./5)*(-100)+40;

FV      =   mean([QD'; LD'; OD'])';