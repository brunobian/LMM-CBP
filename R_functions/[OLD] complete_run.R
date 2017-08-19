#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)

tStart     = as.numeric(args[1])
tEnd       = as.numeric(args[2])
nIter      = as.numeric(args[3])
inPath     = args[4]
outPath    = args[5]
perType    = args[6]
rPath      = args[7]
fixEf      = args[8]
ranEf      = args[9]
model_type = 'continuo'

options(warn=-1)
require(lme4)
source(paste0(rPath, '/iter.within_words.R'))
source(paste0(rPath, '/iter.within_subject.R'))
source(paste0(rPath, '/iter.across_subject.R'))
source(paste0(rPath, '/run_lmm_electrode_time.R'))
source(paste0(rPath, '/run_lm_electrode_time.R'))
source(paste0(rPath, '/process.data.R'))
source(paste0(rPath, '/run_lmm.R'))
source(paste0(rPath, '/run_lm.R'))


if (perType == 'lm') {
  variables   <- fixEf
} else {
  variables   <- paste0(fixEf, '+', ranEf)
}
    
if (perType == 'within_words') {
  iteraciones <- iter.within_words(nIter, model, inPath, model_type)
  run_lmm(tStart, tEnd, variables, inPath, outPath)
} else if (perType == 'within_subjects') {
  iteraciones <- iter.within_subject(nIter, model, inPath, model_type)
  run_lmm(tStart, tEnd, variables, inPath, outPath)
} else if (perType == 'lm') {
  iteraciones <- iter.across_subject(nIter, model, inPath, model_type)
  run_lm(tStart, tEnd, variables, inPath, outPath)
} else {
  print('El modelo de permutaciones introducido no es correcto. Elegir entre "words" y "subjects"')
}

total.end <- Sys.time()
print(paste('Hice todo en ', total.end - total.start), sep='')




