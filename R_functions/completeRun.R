#!/usr/bin/env Rscript

# Read the arguments from bash call
args = commandArgs(trailingOnly=TRUE)

tStart  = as.numeric(args[1])
tEnd    = as.numeric(args[2])
print(tStart)
print(tEnd)

cfgPath = args[3]
df=read.csv(cfgPath,header=FALSE, col.names=c("var","value"),colClasses = "character")
for (i in 1:nrow(df)){assign(df$var[i], df$value[i])} 

nIter      = as.numeric(nIter)

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
#print(cstPath)
source(paste0(cstPath, '/processData.R'))
# source(paste0(cstPath, '/resample.r'))
# print("listo")


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

