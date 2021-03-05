# This function run a LM for a specific time and electrode.
lmElecTime <- function(dataSet, indE, variables, iter, nIter, out) {

  electrode = paste0('E', indE)

  # model = paste0(electrode,' ~ ' , variables) Creo que esto esta mal
  model = paste0('permuted ~ ' , variables)
  
  
  thisLm <- lm(model , data = dataSet)
  
  # Extract fixed effects from the model
  effectsLm = thisLm$coef
  # Calculate t-values from the model
  t_val   = effectsLm  / sqrt(diag(vcov(thisLm)))
  
  # Create array in the first iteration for the first electrode
  if (indE == 1 & iter == 1) {
    out <- list()
    out$slopes = array(NA, c(nIter+1, 128, length(effectsLm)))
    out$t_values   = array(NA, c(nIter+1, 128, length(effectsLm)))
    out$AIC_mat    = array(NA, c(nIter+1, 128))
    out$effects    = effectsLm
    out$model      = thisLm
  }
  
  lngtEf = length(effectsLm)
  for (iEf in seq(1, lngtEf)) {
    out$slopes[iter, indE, iEf]     = effectsLm[iEf]
    out$t_values[iter, indE, iEf]   = t_val[iEf]
  }
  out$AIC_mat[iter, indE] = extractAIC(thisLm)[2]
  
  return(out)
  
}