generateIterMatrix <- function(nIter, perVar, inPath, perPath){
  
  # Check for previuos iterations matrices
  # This is important when runing on prarallel, because it is necesarry to keep the permutations
  fn = paste0(perPath, 'perms_', perVar, nIter)
  if (!file.exists(fn)) {
    print('Generating a new permutation matrix')
    
    # Load t1.csv as example for calculating amount of rows
    fileName = paste(inPath, 't2.csv', sep = '')
    print(paste0('from file T2'))
    tmp <- read.csv(fileName, quote = "", sep=";") 
    
    # Custom function for data preprocessing
    # It is important to apply same process here than in th final analysis, 
    # in order to have the same dataset
    tmp <- processData(tmp)
    L = length(tmp$E1)
    print(L)
    # Create exmpty matrix with L rows
    iterations = matrix(NA, L, 0)  
    
    # Create a secuential vector [1:L] and add to "iterations" in the first column
    # Thus, first run will be without iterations 
    s = c(1:L)                      
    iterations <- cbind(iterations, s)  
    
    # Generate permutations columns within the random effect in perVar
    # if perVar == 'across' -> permutate across all random Variables
    
    if (nIter>0){
      for (iter in 1:nIter){ 
        if (perVar == 'across') {
          thisIter = sample(s)
          iterations <- cbind(iterations, thisIter)
        } else {
          perVarUn = unique(tmp[[perVar]])
          thisIter = matrix(NA, L, 1)
          for (i in 1:length(perVarUn)){	
            iPerVar = perVarUn[i]
            indThisIter = s[tmp[[perVar]] == iPerVar]
            thisIter[indThisIter] = sample(indThisIter)
          }
          iterations <- cbind(iterations, thisIter)
        }
      }
    }
    
    write.table(iterations, fn, sep = ",", row.names = FALSE, col.names = FALSE)  
  } else {
    iterations <- read.csv(fn, header = FALSE, comment.char = "", sep=",") 
  }
  return(iterations)
}
