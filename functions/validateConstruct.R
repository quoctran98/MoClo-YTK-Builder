library(stringr)

validateConstruct <- function(shinyInput, typesList = types) {
  
  usedParts <- parseParts(shinyInput = shinyInput, typesList = typesList) # types df with parts assigned
  
  usedTypes <- usedParts[!is.na(usedParts$name), "type"]
  reqTypes <- usedParts[types$includes == "", "type"] # basic constitutive types (no redundancies)

  # loop through types to break them down to reqTypes
  while (!all(usedTypes %in% reqTypes)) {  # keep going while there's a type that's not in reqType
    newTypes <- c()
    for (oldType in usedTypes) {
      includes <- usedParts[usedParts$type == oldType, "includes"]
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