% parallel.internal.logging.enableClientLogging('C:\temp',6)  %set the location to a directory we can write files to safely.
% setSchedulerMessageHandler(@disp);
% setenv('MDCE_DEBUG','true');
% pctconfig('preservejobs',true);
options.c=parcluster('local');
disp(['Logs werden gespeichert unter ', options.c.JobStorageLocation])

% basePath = options.c.JobStorageLocation;
% options.c_log = parallel.pool.Constant(@()setupLoggingOnWorkers(basePath),@fclose);
% 
