processData <- function(dataSet) {
 
  #dataSet[dataSet$palnum<=-1,]=-1
  #dataSet[dataSet$palnum>= 1,]= 1
 
  dataSet$tipo   <- as.factor(dataSet$tipo)
  dataSet$palnum <- as.factor(dataSet$palnum)
  
  
  return(dataSet)
  
}
