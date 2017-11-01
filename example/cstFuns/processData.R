processData <- function(dataSet) {
  
  
  # Limpio palabras que no quiero analizar
  dataSet <- dataSet[dataSet$palnum <= 10,] # Elimino las pals que están dsp de la 10ma
  dataSet <- dataSet[dataSet$bad_epoch == 0,] # Elimino los malos trials
  
  # Me quedo con 2 categorías y los factorizo: 0=proverbs; 1=common sentences
  dataSet$tipo[dataSet$tipo >  0] = 1

  # Genero variable dummy para oraicones comunes y proverbios
  # dataSet$tipo_Dummy_common  = dataSet$tipo
  # dataSet$tipo_Dummy_common[dataSet$tipo_Dummy_common == 0] = NA
  # dataSet$tipo_Dummy_proverb = abs(1 - dataSet$tipo)
  # dataSet$tipo_Dummy_proverb[dataSet$tipo_Dummy_proverb == 0] = NA
  # 
  dataSet$tipo <- as.factor(dataSet$tipo)
  
  # Transformo y centro variables
  dataSet$freq   <- log(dataSet$freq+1)
  dataSet$length <- 1/(dataSet$lngth)
  dataSet$freq   <- scale(dataSet$freq,   center = TRUE, scale = FALSE)
  dataSet$pred   <- scale(dataSet$pred,   center = TRUE, scale = FALSE)
  dataSet$palnum <- scale(dataSet$palnum, center = TRUE, scale = FALSE)
  dataSet$length <- scale(dataSet$length, center = TRUE, scale = FALSE)
  
  
  # Uso las dummy de arriba para generar las pred de prov y oraciones comunes por separado
  # De esta forma me ahorro el contraste y puedo ver N400 de ambos efectos po sep.
  # dataSet$pred_common  <- dataSet$pred * dataSet$tipo_Dummy_common
  # dataSet$pred_proverb <- dataSet$pred * dataSet$tipo_Dummy_proverb
  # 
  return(dataSet)
  
}
