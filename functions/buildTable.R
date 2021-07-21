source("./functions/convertMoles.R")

buildTable <- function(shinyInput, typesList = types, partsList = parts) {
  
  usedParts <- data.frame(part = sapply(1:nrow(typesList), function (row) {
                                        typeInfo <- typesList[row,]
                                        return(shinyInput[[paste0("type", typeInfo$type, "Select")]])
                                      }),
                          type = sapply(1:nrow(typesList), function (row) {
                                        return(typeInfo <- typesList[row, "type"])
                                      }))
  usedParts <- usedParts[usedParts$part != "None",]
  
  pipetTable <- partsList[partsList$description %in% usedParts$part & partsList$type %in% usedParts$type,] # there definitely can be edge cases where this won't work
  pipetTable <- pipetTable[match(usedParts$part, pipetTable$description),] # reorder the table
  
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
  pipetTable <- pipetTable[, c("type", "name", "description", "concentration", "mass", "dilution")]
  colnames(pipetTable) <- c("Type", "Part", "Description", "Conc. (ng/\U03BCL)", "Mass (ng)", "Dilution")
  return(pipetTable)
}