function out = lm_lmmElecTime(T, indE, variables, iter, nIter, nElect, out)

    T.permuted = double(T.permuted);

    electrode = ['E', num2str(indE)];
    model     = ['permuted ~ ' , variables];
    thisLmm = fitlme(T, model);

    %   # If it don't converge, continue iterating
%   # https://rstudio-pubs-static.s3.amazonaws.com/33653_57fc7b8e5d484c909b615d8633c01d51.html
%   tt <- getME(thisLmm,"theta")
%   ll <- getME(thisLmm,"lower")
%   singularityCheck = min(tt[ll==0])
%   if (singularityCheck < 10e-8){
%     ss <- getME(thisLmm,c("theta","fixef"))
%     system.time(thisLmm <- update(thisLmm, start = ss, 
%                                   control = lmerControl(optCtrl=list(maxfun=2e4))))
%   }
   
    % Extract fixed effects from the model
    effectsNames     = thisLmm.Coefficients.Name;
    effectsEstimates = thisLmm.Coefficients.Estimate;
    effectsTVal      = thisLmm.Coefficients.tStat;    
    
%   # If it still don't converge after the first check, set t_val = 0 (NS)
%   tt <- getME(thisLmm,"theta")
%   ll <- getME(thisLmm,"lower")
%   singularityCheck = min(tt[ll==0])
%   if (singularityCheck < 10e-8){
% 	t_val = t_val * 0.0
%   }
 
    % Create out (struct) in the first iteration for the first electrode
    if (indE == 1 && iter == 1) 
        out = [];
        out.slopes    = nan(nIter, nElect, length(effectsEstimates));
        out.t_values  = nan(nIter, nElect, length(effectsTVal));
        out.AIC_mat   = nan(nIter, nElect);
        out.effects   = effectsNames;
        out.model     = thisLmm;
    end

    lngtEf = length(effectsEstimates);
    for iEf = 1:lngtEf
        out.slopes(iter, indE, iEf)   = effectsEstimates(iEf);
        out.t_values(iter, indE, iEf) = effectsTVal(iEf);
    end    
    out.AIC_mat(iter, indE) = thisLmm.ModelCriterion.AIC;
  
end