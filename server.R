library(shiny)
library(DT)
library(stringr)
library(shinyjs)

typeDefinitions <- data.frame(
  c("t1", "t2", "t3", "t3a", "t3b", "t4", "t4a", "t4b", "t234", "t5", "t6", "t7", "t8", "t8a", "t8b", "t687"),
  row.names = 1)
typeDefinitions$type <- c("1", "2", "3", "3a", "3b", "4", "4a", "4b", "234", "5", "6", "7", "8", "8a", "8b", "687")
typeDefinitions$description <- c("Assembly Connector (1)", "Promoter (2)", "Coding Sequence (3)", "N-terminal CDS (3a)", "CDS (3)", "Terminator (4)", "C-terminal CDS (4a)", "Terminator (4b)", "Miscellaneous (234)", "Assembly Connector (5)", "S. cerevisiae marker (6)", "S. cerevisiae origin / 3' homology (7)", "E. coli marker and origin (8)", "E. coli marker and origin (8a)", "5' homology (8b)", "E. coli marker and origin (678)")
typeDefinitions$components <- list("t1","t2",c("t3a","t3b"),"t3a","t3b",c("t4a","t4b"),"t4a","t4b",c("t2","t3a","t3b","t4a","t4b"),"t5","t6","t7",c("t8a","t8b"),"t8a","t8b",c("t6","t7","t8a","t8b"))

parts <- read.csv("data/parts.csv", row.names = 1, stringsAsFactors = FALSE)
parts <- rbind(parts, read.csv("data/user.csv", row.names = 1))
parts <- merge(parts, read.csv("data/stock.csv", row.names = 1), by = "row.names", all.x = TRUE)
rownames(parts) <- parts$Row.names
parts <- parts[ , !(names(parts) %in% c("Row.names"))]
parts$concentration[is.na(parts$concentration)] <- 0

 type1Parts <- as.character(parts$description[parts$type == 1])
 type2Parts <- c(as.character(parts$description[parts$type == 2]), "None")
 type3Parts <- c(as.character(parts$description[parts$type == 3]), "None")
 type3aParts <- c("None", as.character(parts$description[parts$type == "3a"]))
 type3bParts <- c("None", as.character(parts$description[parts$type == "3b"]))
 type4Parts <- c(as.character(parts$description[parts$type == 4]), "None")
 type4aParts <- c("None", as.character(parts$description[parts$type == "4a"]))
 type4bParts <- c("None", as.character(parts$description[parts$type == "4b"]))
 type5Parts <- as.character(parts$description[parts$type == 5])
 type6Parts <- c(as.character(parts$description[parts$type == 6]), "None")
 type7Parts <- c(as.character(parts$description[parts$type == 7]), "None")
 type8Parts <- c(as.character(parts$description[parts$type == 8]), "None")
 type8aParts <- c("None", as.character(parts$description[parts$type == "8a"]))
 type8bParts <- c("None", as.character(parts$description[parts$type == "8b"]))
 type234Parts <- c("None", as.character(parts$description[parts$type == 234]))
 type678Parts <- c("None", as.character(parts$description[parts$type == 678]))

typeDefinitions$parts <- list(c(as.character(parts$description[parts$type == 1])),
                              c(as.character(parts$description[parts$type == 2]), ""),
                              c(as.character(parts$description[parts$type == 3]), ""),
                              c("", as.character(parts$description[parts$type == "3a"])),
                              c("", as.character(parts$description[parts$type == "3b"])),
                              c(as.character(parts$description[parts$type == 4]), ""),
                              c("", as.character(parts$description[parts$type == "4a"])),
                              c("", as.character(parts$description[parts$type == "4b"])),
                              c("", as.character(parts$description[parts$type == 234])),
                              c(as.character(parts$description[parts$type == 5])),
                              c(as.character(parts$description[parts$type == 6]), ""),
                              c(as.character(parts$description[parts$type == 7]), ""),
                              c(as.character(parts$description[parts$type == 8]), ""),
                              c("", as.character(parts$description[parts$type == "8a"])),
                              c("", as.character(parts$description[parts$type == "8b"])),
                              c("", as.character(parts$description[parts$type == 678]))
                            )

source("functions.R")

function (input,output,session) {
  
  # output$partsTable <- renderDT({
  #   partsDisplay <- parts[,1:3]
  #   partsDisplay <- cbind(partsDisplay, rownames(partsDisplay))
  #   partsDisplay <- partsDisplay[,c(4,1,2,3)]
  #   partsDisplay <- cbind(partsDisplay, str_length(parts[,4]))
  #   colnames(partsDisplay) <- c("Plasmid", "Type", "Description", "E. coli Antibiotic Reisistance", "Length")
  #   partsDisplay
  # }, server = TRUE, selection = "single", rownames = FALSE)
  
  
  # output$partsMap = renderUI({
  #   rowNumber <- input$partsTable_rows_selected
  #   tags$img(src = generateAddgeneURL(rowNumber = rowNumber))
  # })
  
  # Cassette page
  
  # output$type1Input <- renderPartsList("t1")
  # output$type2Input <- renderPartsList("t2")
  # output$type3Input <- renderPartsList("t3")
  # output$type3aInput <- renderPartsList("t3a")
  # output$type3bInput <- renderPartsList("t3b")
  # output$type4Input <- renderPartsList("t4")
  # output$type4aInput <- renderPartsList("t4a")
  # output$type4bInput <- renderPartsList("t4b")
  # output$type234Input <- renderPartsList("t234")
  # output$type5Input <- renderPartsList("t5")
  # output$type6Input <- renderPartsList("t6")
  # output$type7Input <- renderPartsList("t7")
  # output$type8Input <- renderPartsList("t8")
  # output$type8aInput <- renderPartsList("t8a")
  # output$type8bInput <- renderPartsList("t8b")
  # output$type678Input <- renderPartsList("t678")
  
  output$type1Input <- renderUI({selectInput("type1", "Assembly Connector (1)", type1Parts, selected = type1Parts[1])})
  output$type2Input <- renderUI({selectInput("type2", "Promoter (2)", type2Parts, selected = type2Parts[1])})
  output$type3Input <- renderUI({selectInput("type3", "Coding Sequence (3)", type3Parts, selected = type3Parts[1])})
  output$type3aInput <- renderUI({selectInput("type3a", "N-terminal CDS (3a)", type3aParts, selected = type3aParts[1])})
  output$type3bInput <- renderUI({selectInput("type3b", "CDS (3b)", type3bParts, selected = type3bParts[1])})
  output$type4Input <- renderUI({selectInput("type4", "Terminator (4)", type4Parts, selected = type4Parts[1])})
  output$type4aInput <- renderUI({selectInput("type4a", "C-terminal CDS (4a)", type4aParts, selected = type4aParts[1])})
  output$type4bInput <- renderUI({selectInput("type4b", "Terminator (4b)", type4bParts, selected = type4bParts[1])})
  output$type5Input <- renderUI({selectInput("type5", "Assembly Connector (5)", type5Parts, selected = type5Parts[1])})
  output$type6Input <- renderUI({selectInput("type6", "S. cerevisiae marker (6)", type6Parts, selected = type6Parts[1])})
  output$type7Input <- renderUI({selectInput("type7", "S. cerevisiae origin / 3' homology (7)", type7Parts, selected = type7Parts[1])})
  output$type8Input <- renderUI({selectInput("type8", "E. coli marker and origin (8)", type8Parts, selected = type8Parts[1])})
  output$type8aInput <- renderUI({selectInput("type8a", "E. coli marker and origin (8a)", type8aParts, selected = type8aParts[1])})
  output$type8bInput <- renderUI({selectInput("type8b", "5' homology (8b)", type8bParts, selected = type8bParts[1])})
  output$type234Input <- renderUI({selectInput("type234", "Miscellaneous (234)", type234Parts, selected = type234Parts[1])})
  output$type678Input <- renderUI({selectInput("type678", "E. coli marker and origin (678)", type678Parts, selected = type678Parts[1])})
  
  
  output$validConstruct <- renderText({
    message <- ""
    isValid <- validConstruct(
      input$type1,
      input$type2,
      input$type3,
      input$type3a,
      input$type3b,
      input$type4,
      input$type4a,
      input$type4b,
      input$type5,
      input$type6,
      input$type7,
      input$type8,
      input$type8a,
      input$type8b,
      input$type234,
      input$type678, return = "numerical")
    if (isValid == 11) {
      message <- ""
      shinyjs::show(id = "pipetTable", anim = TRUE)
      shinyjs::show(id = "constructAction", anim = TRUE, animType = "fade")
    } else if (isValid > 11) {
      message <- "Cassette assembly will not work with too many parts. Please remove certain parts."
      shinyjs::hide(id = "pipetTable", anim = TRUE)
      shinyjs::hide(id = "constructAction", anim = TRUE, animType = "fade")
    } else if (isValid < 11) {
      message <- "Cassette assembly will not work with too few parts. Please add certain parts."
      shinyjs::hide(id = "pipetTable", anim = TRUE)
      shinyjs::hide(id = "constructAction", anim = TRUE, animType = "fade")
    }
    message
  })
  
  output$pipetTable <- renderTable({
    selectedNames <- c(rownames(parts[parts$description == input$type1 & parts$type == "1",]),
        rownames(parts[parts$description == input$type2 & parts$type == "2",]),
        rownames(parts[parts$description == input$type3 & parts$type == "3",]),
        rownames(parts[parts$description == input$type3a& parts$type == "3a",]),
        rownames(parts[parts$description == input$type3b & parts$type == "3b",]),
        rownames(parts[parts$description == input$type4 & parts$type == "4",]),
        rownames(parts[parts$description == input$type4a & parts$type == "4a",]),
        rownames(parts[parts$description == input$type4b & parts$type == "4b",]),
        rownames(parts[parts$description == input$type5 & parts$type == "5",]),
        rownames(parts[parts$description == input$type6 & parts$type == "6",]),
        rownames(parts[parts$description == input$type7 & parts$type == "7",]),
        rownames(parts[parts$description == input$type8 & parts$type == "8",]),
        rownames(parts[parts$description == input$type8a & parts$type == "8a",]),
        rownames(parts[parts$description == input$type8b & parts$type == "8b",]),
        rownames(parts[parts$description == input$type234 & parts$type == "234",]),
        rownames(parts[parts$description == input$type678 & parts$type == "678",]))
    selectedDescriptions <- as.character(parts[selectedNames, "description"])
    selectedTypes <- as.character(parts[selectedNames, "type"])
    selectedConcentrations <- (parts[selectedNames,"concentration"])
    selectedLength <- str_length(parts[selectedNames,4])
    selectedMoles <- rep.int(input$insertMole, length(selectedNames))
    for (plasmid in selectedNames) {
      if (as.character(parts[plasmid,"type"]) == "8" | as.character(parts[plasmid,"type"]) == "8a" | as.character(parts[plasmid,"type"]) == "678") {
        selectedMoles[(selectedNames %in% plasmid)] <- input$vectorMole
      }
    }
    selectedMass <- molesToMass(selectedMoles, selectedLength)
    selectedVolume <- selectedMass / selectedConcentrations
    selectedDilutions <- paste("1:", round(1 / selectedVolume), sep = "")
    finalTable <- cbind(selectedTypes, selectedNames, selectedDescriptions, paste(selectedLength, "bp"), paste(round(selectedConcentrations, digits = 2), "ng/uL"), paste(round(selectedVolume, digits = 2), "uL"), selectedDilutions)
    colnames(finalTable) <- c("Type", "Plasmid", "Description", "Length", "Miniprepped Conc.", "Volume to Use", "Dilution for 1uL")
    finalTable
  }, hover = TRUE, striped = TRUE, bordered = TRUE)
  
  # Parts page
  
  renderPartsTable <- function() {
    output$partsTable <- renderDT({
      partsDisplay <- parts[,c("type","description","antibiotic","concentration")]
      partsDisplay <- cbind(partsDisplay, rownames(partsDisplay))
      partsDisplay <- partsDisplay[,c(5,1,2,3,4)] # reording columns
      partsDisplay <- cbind(partsDisplay, str_length(parts[,"sequence"]))
      colnames(partsDisplay) <- c("Plasmid", "Type", "Description", "E. coli Antibiotic", "Miniprepped", "Length")
      partsDisplay
    }, server = TRUE, selection = "single", rownames = FALSE)
  }
  renderPartsTable()
  
  # Updates fields in the parts info
  observe({
    rowNumber <- input$partsTable_rows_selected
    updateTextInput(session, "partName", value = rownames(parts)[rowNumber])
    updateTextInput(session, "partType", value = parts[rowNumber,"type"])
    updateTextInput(session, "partDescription", value = parts[rowNumber,"description"])
    updateSelectInput(session, "partAntibiotic", selected = parts[rowNumber,"antibiotic"])
    updateNumericInput(session, "partMiniprep", value = parts[rowNumber, "concentration"])
  })
  
  # Checks to see if a new part is being added or an existing one updated
  observe({
    if ((input$partName != "") && !(input$partName %in% rownames(parts))) {
      shinyjs::show(id = "partAdd")
    } else {
      shinyjs::hide(id = "partAdd")
    }
  })
  
  observe({
    if ((input$partName %in% rownames(parts)) && ((input$partType != parts[input$partName,"type"]) || (input$partDescription != parts[input$partName,"description"]) || (input$partAntibiotic != parts[input$partName,"antibiotic"]) || (input$partMiniprep != parts[input$partName,"concentration"]))) {
      shinyjs::show(id = "partUpdate")
    } else {
      shinyjs::hide(id = "partUpdate")
    }
  })
  
  observeEvent(input$partUpdate, {
    shinyjs::hide(id = "partUpdate")
    parts[input$partName,"type"] <<- input$partType
    parts[input$partName,"description"] <<- input$partDescription
    parts[input$partName,"antibiotic"] <<- input$partAntibiotic
    parts[input$partName,"concentration"] <<- input$partMiniprep
    renderPartsTable()
    output$textTest <- renderText({as.character(parts["pYTK001","description"])})
  })
  
  observeEvent(input$partAdd, {
    shinyjs::hide(id = "partAdd")
    parts[input$partName,"type"] <<- input$partType
    parts[input$partName,"description"] <<- input$partDescription
    parts[input$partName,"antibiotic"] <<- input$partAntibiotic
    parts[input$partName,"concentration"] <<- input$partMiniprep
    renderPartsTable()
  })
  
}