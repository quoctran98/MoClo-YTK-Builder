assembleConstruct <- function(shinyInput, typesList = types) {
  usedParts <- parseParts(shinyInput = shinyInput, typesList = typesList)
  usedParts <- usedParts[!is.na(usedParts$name),]
  
  constructId <- paste(usedParts$id, ";")
}