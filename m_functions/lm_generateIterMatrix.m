function iterations = lm_generateIterMatrix(cfg)

% Check for previuos iterations matrices
% This is important when runing on prarallel, because it is necesarry to keep the permutations
fn = [cfg.perPath, 'perms_', cfg.perVar, num2str(cfg.nIter),'.mat'];

if exist(fn, 'file') ~= 2 
    fprintf('Generating a new permutation matrix\n')

    % Load t1.csv as example for calculating amount of rows
    file_name = [cfg.inPath, 't1.mat'];
	load(file_name)
 
    % Custom function for data preprocessing
    % It is important to apply same process here than in th final analysis, 
    % in order to have the same dataset
    % T <- processData(T)
    
    L = length(T.E1);
    fprintf('%d\n',L)
    
    % Create exmpty matrix with L rows
    iterations = nan(L, 0);  

    % Create a secuential vector [1:L] and add to "iterations" in the first column
    % Thus, first run will be without iterations 
    s = [1:L]';
	iterations = [iterations, s];

    % Generate permutations columns within the random effect in perVar
    % if perVar == 'across' -> permutate across all random Variables
  
    for iter = 1:cfg.nIter
        if strcmpi(cfg.perVar, 'across')
            thisIter = randperm(L)';
            iterations = [iterations, thisIter];
        else
            perVarUn = unique(T.(cfg.perVar));
            thisIter = nan(L, 1);
            for i = 1:length(perVarUn)
                iPerVar = perVarUn(i);
                indThisIter = s(T.(cfg.perVar) == iPerVar);
                thisIter(indThisIter) = shuffle(indThisIter);
            end
            iterations = [iterations, thisIter];
        end
    end
    
    save(fn, 'iterations') 
    
else
    fprintf('Loading a previously generated permutation matrix\n')

    load(fn)

end

end



















