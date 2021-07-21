library(stringr)

validateConstruct <- function(shinyInput, typesList = types) {
  
  reqTypes <- typesList[types$includes == "", "type"] # basic constitutive types
  
  typesList$part <- sapply(1:nrow(typesList), function (row) {
    typeInfo <- typesList[row,]
    return(shinyInput[[paste0("type", typeInfo$type, "Select")]])
  })
  
  usedTypes <- typesList[typesList$part != "None", "type"]

  # loop through types to break them down to reqTypes
  while (!all(usedTypes %in% reqTypes)) {  # keep going while there's a type that's not in reqType
    newTypes <- c()
    for (oldType in usedTypes) {
      includes <- typesList[typesList$type == oldType, "includes"]
      if (includes == "") {
        newTypes <- append(newTypes, oldType)
      } else {
        includes <- str_replace_all(includes, ",", "\",\"")
        newTypes <- append(newTypes, eval(parse(text = paste0("c(\"", includes, "\")"))))
      } 
    }
    usedTypes <- newTypes
  }
  
  return(list(
    isValid = setequal(usedTypes, reqTypes) & !any(duplicated(usedTypes)),
    extra = usedTypes[duplicated(usedTypes)],
    missing = setdiff(reqTypes, usedTypes)
  ))
}