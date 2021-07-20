getParts <- function(partType, partsList = parts, defaultEmpty = F) {
  partDescriptions <- partsList[partsList$type == partType, "description"]
  if (defaultEmpty) {
    return(c("None", partDescriptions))
  } else {
    return(c(partDescriptions, "None"))
  }
}