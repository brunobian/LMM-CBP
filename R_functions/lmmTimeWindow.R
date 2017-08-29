# This function run a window of times. From tStart to tEnd
lmmTimeWindow <- function(tStart, tEnd, variables, iterations, perType, inPath, outPath){
  
  for (iTime in seq(tStart, tEnd)) {  
    time.start <- Sys.time() 
    
    # Check if this time CSV file was alredy run
    destfile =  paste0(outPath, 'AIC_T', iTime)
    if  (file.exists(destfile)) {
      
      # If so, return
      time.end <- Sys.time()
      print(paste0('T', iTime, '.csv alredy run.'))
      
    } else {
      
      # Load file
      fileName = paste(inPath, 't', iTime, '.csv', sep = '')
      print(paste0('Loading file T', iTime))
      tmp <- read.csv(fileName, comment.char = "", sep=";") 
      
      # Find out the amount of electrodes in DataSet
      ### [MEJORAR PARA QUE AGARRE SOLO LOS CAMPOS DE ELECTRODOS ###
      ### sin posibilidad de que agarre otra cosa] ###
      cols       <- colnames(tmp)
      electCols  <- grepl('E[0-9]+', cols)
      nElect     <- sum(electCols)
      
      # Custom function for data preprocessing
      tmp <- processData(tmp)
  
      # Iterate over electrodes
      out <- list()
      for (indE in 1:nElect) {
        electrode = paste0('E', indE)
	      print(electrode)
        nIter = dim(iterations)[2]
        
        # Iterate over permutations running the model for each electrode.
        for (iter in 1:nIter){ 
          tmp['permuted'] <- tmp[electrode][iterations[,iter], ]
          
          if (perType == 'lm'){
            out = lmElecTime(tmp, indE, variables, iter, nIter, out)   
          
          } else if (perType == 'remef'){
            # For the remef approach, the first model (orignal data) is LMM
            if (iter == 1) {
              print(variables[1])
              out = lmmElecTime(tmp, indE, variables[1], iter, nIter, out)   
              # After fitting that, remove random effects and store in original place
              tmp[electrode]  <- remef(out$model, fix = NULL, ran = "all")
            } else { 
              print(variables[2])
              # Now on, treat them with classical Linear Models
              out = lmElecTime(tmp, indE, variables[2], iter, nIter, out)   
            }
              
          } else {
            out = lmmElecTime(tmp, indE, variables, iter, nIter, out)   
          }
          
        }
        
      } 
      
      # Extract results
      effectsLMM = out$effects     
      slopes     = out$slopes      
      t_values   = out$t_values    
      AIC_mat    = out$AIC_mat     
      lEf        = length(effectsLMM)

      # Save slopes, t_values and AICs
      for (iEf in seq(1, lEf)) {
        variable = names(effectsLMM[iEf])
        f = paste0(outPath, 'p_', variable, '_T', iTime)
        write.table(slopes[,,iEf], f, sep = ",", row.names = FALSE, col.names = FALSE)  
        
        f = paste0(outPath, 't_', variable, '_T', iTime)
        write.table(t_values[,,iEf], f, sep = ",", row.names = FALSE, col.names = FALSE)
      }
      f = paste0(outPath, 'AIC', '_T', iTime)
      write.table(AIC_mat, f, sep = ",", row.names = FALSE, col.names = FALSE)
      
      # Delelte dataframe
      rm(tmp) 
      
      time.end <- Sys.time()
      print(paste('T', iTime, '.csv finished in ',time.end - time.start), sep=' ')
    }
  }
  # }
}
