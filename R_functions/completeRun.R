#!/usr/bin/env Rscript

# Read the arguments from bash call
args = commandArgs(trailingOnly=TRUE)

tStart     = as.numeric(args[1])
tEnd       = as.numeric(args[2])
nIter      = as.numeric(args[3])
inPath     = args[4]
outPath    = args[5]
modType    = args[6]
rPath      = args[7]
fixEf      = args[8]
ranEf      = args[9]
perPath    = args[10]
perVar     = args[11]
cstPath    = args[12]

total.start <- Sys.time()
# Avoid warnnings
options(warn=-1)

# Load libraries and functions from CuBaPeTo
require(lme4)
source(paste0(rPath, '/generateIterMatrix.R'))
source(paste0(rPath, '/lmmElecTime.R'))
source(paste0(rPath, '/lmElecTime.R'))
source(paste0(rPath, '/lmmTimeWindow.R'))
source(paste0(rPath, '/remef.v0.6.9.R'))


# Load custim function for data processing
source(paste0(cstPath, '/processData.R'))

# Generate new permutation matrix or load an existing one
iterations <- generateIterMatrix(nIter, perVar, inPath, perPath)

if (modType == 'lm') {
  variables   <- fixEf
}else if (modType == 'remef') {
  variables   <- c(paste0(fixEf, '+', ranEf), fixEf)
} else {
  variables   <- paste0(fixEf, '+', ranEf)
}

# Running in parallel is running a hole time window (from tStart to tEnd) in each call
lmmTimeWindow(tStart, tEnd, variables, iterations, modType, inPath, outPath)

total.end <- Sys.time()
print(paste('Whole run finished in', total.end - total.start), sep=' ')

