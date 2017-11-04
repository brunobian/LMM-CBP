# This function run a LMM for a specific time and electrode.
lmmElecTime <- function(dataSet, indE, variables, iter, nIter, out){
  
  electrode = paste0('E', indE)
  model = paste0('permuted ~ ' , variables)
  thisLmm <- lmer(model , data = dataSet, REML = FALSE) 
              
  
  # If it don't converge, continue iterating
  # https://rstudio-pubs-static.s3.amazonaws.com/33653_57fc7b8e5d484c909b615d8633c01d51.html
  tt <- getME(thisLmm,"theta")
  ll <- getME(thisLmm,"lower")
  singularityCheck = min(tt[ll==0])
  if (singularityCheck < 10e-8){
    ss <- getME(thisLmm,c("theta","fixef"))
    system.time(thisLmm <- update(thisLmm, start = ss, 
                                  control = lmerControl(optCtrl=list(maxfun=2e4))))
  }
  
  # Extract fixed effects from the model
  effectsLmm = fixef(thisLmm)
  
  # Calculate t-values from the model
  t_val   = effectsLmm  / sqrt(diag(vcov(thisLmm)))

  # If it still don't converge after the first check, set t_val = 0 (NS)
  tt <- getME(thisLmm,"theta")
  ll <- getME(thisLmm,"lower")
  singularityCheck = min(tt[ll==0])
  if (singularityCheck < 10e-8){
	t_val = t_val * 0.0
  }

  # Create array in the first iteration for the first electrode
  if (indE == 1 & iter == 1) {
    out <- list()
    out$slopes      = array(NA, c(nIter, 128, length(effectsLmm)))
    out$t_values    = array(NA, c(nIter, 128, length(effectsLmm)))
    out$AIC_mat     = array(NA, c(nIter, 128))
    out$effects     = effectsLmm
    out$model       = thisLmm
  }
  
  lngtEf = length(effectsLmm)
  for (iEf in seq(1, lngtEf)) {
    out$slopes[iter, indE, iEf]     = effectsLmm[iEf]
    out$t_values[iter, indE, iEf]   = t_val[iEf]
  }
  out$AIC_mat[iter, indE] = extractAIC(thisLmm)[2]
  
  return(out)
  
}
