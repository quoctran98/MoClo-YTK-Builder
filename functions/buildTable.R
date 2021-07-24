source("./functions/convertMoles.R")

buildTable <- function(shinyInput, typesList = types, partsList = parts) {
  
  usedParts <- parseParts(shinyInput = shinyInput, typesList = typesList)
  usedParts <- usedParts[!is.na(usedParts$name),]
  
  # parts of the same type in a kit should have unique names (descriptions can be the same)
  pipetTable <- partsList[partsList$name %in% usedParts$name & partsList$type %in% usedParts$type & partsList$kit %in% usedParts$kit,]
  pipetTable <- pipetTable[match(usedParts$name, pipetTable$name),] # reorder the table
  
  pipetTable$length <- nchar(pipetTable$sequence)

  # calculate mass needed for vectors and inserts
  vectorParts <- c("8a", "8", "678") # i shouldn't hardcode this
  pipetTable[pipetTable$type %in% vectorParts, "mass"] <- convertMoles(pipetTable[pipetTable$type %in% vectorParts, "length"], shinyInput$vectorAmt)
  pipetTable[!(pipetTable$type %in% vectorParts), "mass"] <- convertMoles(pipetTable[!(pipetTable$type %in% vectorParts), "length"], shinyInput$insertAmt)
  
  # calculate needed dilution
  pipetTable$dilution <- pipetTable$concentration / pipetTable$mass
  pipetTable$dilution <- paste0("1:", round(pipetTable$dilution))
  
  # add plasmid names and make final table
  pipetTable$name <- row.names(pipetTable)
  pipetTable <- pipetTable[, c("type", "kit", "name", "description", "concentration", "mass", "dilution")]
  colnames(pipetTable) <- c("Type", "Kit", "Part", "Description", "Conc. (ng/\U03BCL)", "Mass (ng)", "Dilution")
  return(pipetTable)
}
