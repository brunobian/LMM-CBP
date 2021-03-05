function lm_lmmTimeWindow(variables, iterations, cfg)

fprintf('Starting to run form T%d to T%d\n',cfg.tStart,cfg.tEnd)
for iTime = cfg.tStart:cfg.tEnd
    tStart = tic;
    
    % Check if this time CSV file was alredy run
    destfile =  [cfg.outPath, 'AIC_T', iTime];
%     if  exist(destfile, 'file') == 2 
%         fprintf('T%d.csv already run\n', iTime); 
%         continue
%     end
    
    % Get data : Aca la data va a venir dada
    fileName = [cfg.inPath, 't', num2str(iTime), '.mat'];
    fprintf('Loading file T%d\n', iTime)
    load(fileName)

    % Find out the amount of electrodes in DataSet
    cols = T.Properties.VariableNames;
    electCols = cellfun(@(x) ~isempty(x), regexp(cols, '^E[0-9]+'));
    nElect    = sum(electCols);

    % Custom function for data preprocessing
    % tmp = processData(tmp)

    out = [];
    for indE = 1:nElect
        tStartElect = tic;
        electrode = ['E', num2str(indE)];
        fprintf('%s',electrode)
        nIter = size(iterations,2);

        % Iterate over permutations running the model for each electrode.
        for iter = 1:nIter
            T.permuted = T.(electrode)(iterations(:,iter));

            if strcmpi(cfg.modType,'lm')
                fprintf('TRADUCIR\n')
                break
%                 out = lmElecTime(T, indE, variables, iter, nIter, nElect, out);   
            elseif strcmpi(cfg.modType,'remef')
                if (iter == 1)
                    out = lm_predictEffects(T, indE, variables, iter, nIter, nElect, cfg.categoricals, out);   
                end
               
%                 fprintf('TRADUCIR\n')
%                 break
%               % For the remef approach, the first model (orignal data) is LMM
%               if (iter == 1) 
%                  out = lmmElecTime(tmp, indE, variables[1], iter, nIter, nElect, out)   
%     %            # After fitting that, remove random effects and store in original place
%                  tmp[electrode]  <- remef(out$model, fix = NULL, ran = "all")
%               else  
%     %            # Now on, treat them with classical Linear Models
%                  out = lmElecTime(tmp, indE, variables[2], iter, nIter, nElect, out)   
%               end
            elseif strcmpi(cfg.modType,'lmm')
                out = lm_lmmElecTime(T, indE, variables, iter, nIter, nElect, cfg.categoricals, out);   
            else 
                fprintf('perType incorrect: select lm, remef, or lmm\n')
            end
        end
        tEndElect = toc(tStartElect);

        fprintf('  finished in %.2f seconds\n', tEndElect);    
    end
    
    
    if strcmpi(cfg.modType,'remef')
        predichos   = squeeze(out.predicho);    
        keyboard

        f = [cfg.outPath, 'predichos_T', num2str(iTime)];
        writetable(array2table(predichos(:,:)), f, ...
                   'Delimiter', ',', ...
                   'WriteVariableNames', 0) 
    else
    
        % Extract results
        effectsLMM = out.effects;
        slopes     = out.slopes;      
        t_values   = out.t_values;    
        AIC_mat    = out.AIC_mat;     
        lEf        = length(effectsLMM);

        % Save slopes, t_values and AICs

        for iEf = 1:lEf 
            variable = effectsLMM{iEf};
            variable = strrep(variable,':','$');
            variable = strrep(variable,'_','');

            f = [cfg.outPath, 'p_', variable, '_T', num2str(iTime)];
            writetable(array2table(slopes(:,:,iEf)), f, ...
                       'Delimiter', ',', ...
                       'WriteVariableNames', 0) 

            f = [cfg.outPath, 't_', variable, '_T', num2str(iTime)];
            writetable(array2table(t_values(:,:,iEf)), f, ...
                       'Delimiter', ',', ...
                       'WriteVariableNames', 0) 
        end

        f = [cfg.outPath, 'AIC_T', num2str(iTime)];
        writetable(array2table(AIC_mat), f, ...
                   'Delimiter', ',', ...
                   'WriteVariableNames', 0) 

    end
    % Delelte data to save RAM space
    clear T
    
    tEnd = toc(tStart);

    fprintf('T%d.csv finished in %d minutes and %.0f seconds\n', iTime, floor(tEnd/60), rem(tEnd,60));    
end
end