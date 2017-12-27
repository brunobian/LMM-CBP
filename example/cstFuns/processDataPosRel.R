processData <- function(dataSet) {
  
  # Limpio palabras que no quiero analizar
  dataSet <- dataSet[dataSet$palnum <= 10,] # Elimino las pals que están dsp de la 10ma
  dataSet <- dataSet[dataSet$bad_epoch == 0,] # Elimino los malos trials
  
  # Me quedo solo con proverbs en MJ-1 hasta MJ+1
  dataSet = dataSet[dataSet$tipo ==  0,]

  # Para pre y postMj completos
  #dataSet[dataSet$MaxJump == 1,] = -1
  #dataSet[dataSet$MaxJump == 0,] =  1
  #dataSet[dataSet$MaxJump ==-1,] =  0

  # Para pre y post de una pal
  dataSet = dataSet[dataSet$MaxJump >= -1,]
  dataSet = dataSet[dataSet$MaxJump <=  1,]
  dataSet[dataSet$MaxJump ==  1,] = 2
  dataSet[dataSet$MaxJump == -1,] = 1


  dataSet$tipo <- as.factor(dataSet$tipo)
  dataSet$MaxJump <- as.factor(dataSet$MaxJump)
  
  # Transformo y centro variables
  dataSet$freq   <- log(dataSet$freq+1)
  dataSet$length <- 1/(dataSet$length)
  dataSet$freq   <- scale(dataSet$freq,   center = TRUE, scale = FALSE)
  dataSet$pred   <- scale(dataSet$pred,   center = TRUE, scale = FALSE)
  dataSet$palnum <- scale(dataSet$palnum, center = TRUE, scale = FALSE)
  dataSet$length <- scale(dataSet$length, center = TRUE, scale = FALSE)
  
  return(dataSet)
  
}
