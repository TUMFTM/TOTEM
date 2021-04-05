function fid=setupLoggingOnWorkers(varargin)

switch nargin
    case 0
        %if we haven't been given a path use the current path
        basePath = pwd;
    case 1
        %otherwise save to the path we were given
        basePath = varargin{1};
    otherwise
        error("setupLoggingOnWorkers requires either 0 or 1 arguments");
end

        

%first we fetch the task id so we can use this to create an individual file
%for each worker
t=getCurrentTask();

%Now let's create a unique filename for each worker and give it a timestamp
%to help us find it in future if we do multiple runs
filename = ['worker_log.',num2str(t.ID),'.',datestr(datetime('now'),'yyyy_mm_dd_HHMM'),'.log'];

%finally create the file handle we need on each worker.
fid=fopen([basePath,filesep(),filename],'wt');
