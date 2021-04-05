function dc_grob=Zeitschritt_zyklus_aendern(samplerate, dc)
dc_grob.time=transpose(0:samplerate:max(dc.time));
dc_grob.speed=interpn(dc.time, dc.speed, dc_grob.time);
dc_grob.acc=interpn(dc.time, dc.acc, dc_grob.time);