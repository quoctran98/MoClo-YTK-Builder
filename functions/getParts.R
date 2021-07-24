getParts <- function(partType, partsList = parts, defaultEmpty = F) {
  partNames <- partsList[partsList$type == partType, "name"]
  partDescriptions <- partsList[partsList$type == partType, "description"]
  partID <- paste(partsList[partsList$type == partType, "kit"], partNames, sep = "$")
  
  if (defaultEmpty) {
    namedParts <- c(NA, partID)
    names(namedParts) <- c("None", partDescriptions)
  } else {
    namedParts <- c(partID, NA)
    names(namedParts) <- c(partDescriptions, "None")
  }
  
  return(namedParts)
}