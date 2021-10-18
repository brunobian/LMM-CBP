function out = lm_predictEffects(T, indE, variables, iter, nIter, nElect, categoricals, out)

    T.permuted = double(T.permuted);
    for i = 1:length(categoricals)
        c = categoricals{i}; 
        T.(c) = categorical(T.(c));
    end

    electrode = ['E', num2str(indE)];
    model     = ['permuted ~ ' , variables];

    thisLmm = fitlme(T, model, 'DummyVarCoding', 'full');

    % Extract fixed effects from the model
    effectsNames     = thisLmm.Coefficients.Name;
    effectsEstimates = thisLmm.Coefficients.Estimate;
    effectsTVal      = thisLmm.Coefficients.tStat;    
    
    Intercept = effectsEstimates(1);
    beta_pred_Typ_0 = effectsEstimates(5);
    beta_pred_Typ_1 = effectsEstimates(6);
    beta_pred_Typ_2 = effectsEstimates(7);
    
    pred_Typ_0 = T.pred .* [T.sntTypePrePost=='0']; 
    pred_Typ_1 = T.pred .* [T.sntTypePrePost=='1']; 
    pred_Typ_2 = T.pred .* [T.sntTypePrePost=='2']; 

    predicho =  beta_pred_Typ_0 * pred_Typ_0 + ... 
                beta_pred_Typ_1 * pred_Typ_1 + ...
                beta_pred_Typ_2 * pred_Typ_2 + ...
                Intercept * ones(size(T,1),1);
    
    
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
        out.predicho  = nan(nElect, length(predicho));
        out.suj_id    = nan(1, length(predicho));
        out.Type      = nan(1, length(predicho));
        out.pred      = nan(1, length(predicho));
    end

    out.predicho(indE, :) = predicho;
    out.suj_id(indE, :)   = T.suj_id;
    out.Type(indE, :) = T.sntTypePrePost;
    out.pred(indE, :) = T.pred;
  
end