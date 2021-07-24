library(stringr)
library(purrr)

parseParts <- function(shinyInput, typesList = types) {
  
  usedParts <- typesList
  
  usedParts$id <- sapply(1:nrow(usedParts), function (row) {
    typeInfo <- usedParts[row,]
    return(shinyInput[[paste0("type", typeInfo$type, "Select")]])
  })
  
  usedParts$kit <- purrr::map(str_split(usedParts$id, "\\$"), 1)
  usedParts$name <- purrr::map(str_split(usedParts$id, "\\$"), 2) # returns NULL (as string? factor?) for things w/o $
  is.na(usedParts) <- usedParts == "NULL" # i didn't know that you could assign values to is.na()
  print(usedParts)
  return(usedParts)
}