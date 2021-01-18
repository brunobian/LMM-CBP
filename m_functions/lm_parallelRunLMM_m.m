% parallelRunLMM  run R scripts of LMM through a bash script that
% paralelize it in N cores. This script run nCores time a Rscript under 
% nohup, opening nCores independent processes. Each session will load only
% nFiles / nCores CSV files generated by lm_exportErpCsv.m.
%
% fixEf = char with the fixed effect section for the lmer function
%         i.e. '(freq + pos + pred) * type'  
%
% ranEf = char with the random effect section for the lmer function
%         i.e. '(1|suj) + (1|word)'  
%
% nIter = number of permutation for the Cluster-Based Permutation Test
%
% modType = Model type. 
%           'lmm': run everythin in lmm
%           'lm' : run everythin in lmm
%           'ranef': run original data un lmm, permutations in lm (not
%           implemented yet)
%
% nCores  = Number of cores to parallelize
%
% lm_Conf = config struct from the toolbox

function lm_parallelRunLMM_m(cfg)

for iCore = 1:cfg.nCores 
    
    fprintf('Starting on Core #%d\n', iCore)
    
    cfg.tStart  = 1 + (iCore-1)*cfg.timerPerCore;
    cfg.tEnd    = iCore * cfg.timerPerCore;
    if iCore==cfg.nCores; 
        cfg.tEnd = cfg.nTimes;
    end
    
    cfgpath = [cfg.cfgPath, num2str(iCore), '.mat'];
    save(cfgpath ,'cfg')

    matlab = [' ' matlabroot '/bin/matlab'];
    options = ' -nodisplay -nodesktop -nojvm -r ';
    functions = ['''load ' cfgpath ...
                 '; addpath(cfg.mPath); lm_completRun(cfg); exit;'''];
    output    = ['> ' cfg.nhoPath '/core' num2str(iCore) ' &'];
    
    command = ['nohup' matlab options functions output];
    system(command);

    if iCore==1; 
        pause(10);
    end
end


end
