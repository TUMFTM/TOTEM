par_VEH.F_preload_F=par_VEH.mss*par_VEH.g*par_VEH.lR/par_VEH.l/2;
par_VEH.F_preload_R=par_VEH.mss*par_VEH.g*par_VEH.lF/par_VEH.l/2;

par_VEH.cF_front(:,1) =[-0.06:0.001:0.06];
par_VEH.cF_rear(:,1)  =[-0.06:0.001:0.06];

par_VEH.cF_front(:,2)=   polyval([par_VEH.csF, par_VEH.F_preload_F], par_VEH.cF_front(:,1));
par_VEH.cF_rear(:,2) =   polyval([par_VEH.csR, par_VEH.F_preload_R], par_VEH.cF_rear(:,1));


% plot(par_VEH.cF_rear(:,1), par_VEH.cF_rear(:,2))