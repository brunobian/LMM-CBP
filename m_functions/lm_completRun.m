function lm_completRun(cfg)

if isa(cfg, 'char')
    load(cfg)
end

maxNumCompThreads(cfg.maxNumCompThreads);

tStart = tic;

% Generate new permutation matrix or load an existing one
iterations = lm_generateIterMatrix(cfg);

if strcmpi(cfg.modType, 'lm')
	variables = cfg.fixEf;
elseif strcmpi(cfg.modType, 'remef')
    variables = [[cfg.fixEf, '+', cfg.ranEf], cfg.fixEf];
elseif strcmpi(cfg.modType, 'lmm')
    variables = [cfg.fixEf, '+', cfg.ranEf];
else
    fprintf('Incorrect Mode\n')
end

% Running in parallel is running a hole time window (from tStart to tEnd) in each call
lm_lmmTimeWindow(variables, iterations, cfg)

tEnd = toc(tStart);

fprintf('Whole run finished in %d minutes and %.0f seconds\n', floor(tEnd/60), rem(tEnd,60));
 
end
