library(shiny)
library(DT)
library(stringr)
library(shinyjs)

sapply(paste0("./functions/", list.files("./functions")), source)

# let's write something to put all the parts in one dataframe
parts <- read.csv("./data/parts/base.csv", row.names = 1, stringsAsFactors = FALSE)
for (file in list.files("./data/parts/kits")) {
  parts <- rbind(parts, read.csv(paste0("./data/parts/kits/", file), row.names = 1, stringsAsFactors = FALSE))
}

# now we need to add concentrations to the parts df
parts <- merge(parts, read.csv("./data/stock.csv", row.names = 1), by = "row.names", all.x = TRUE)
rownames(parts) <- parts$Row.names
parts <- parts[,!(names(parts) %in% c("Row.names"))]
parts$concentration[is.na(parts$concentration)] <- 0

# part types df
types <- read.csv("./data/types.csv")

function (input, output, session) {
  
  # populating dropdown menus (for loops have lazy eval here)
  lapply(1:nrow(types), function (row) {
    typeInfo <- types[row,]
    typeParts <- getParts(typeInfo$type, defaultEmpty = !(typeInfo$type %in% 1:8))
    output[[paste0("type", typeInfo$type, "Input")]] <- renderUI({
      selectInput(paste0("type", typeInfo$type, "Select"), # each dropdown menu has ID "type[type]Select"
                  typeInfo$name,
                  typeParts,
                  typeParts[1])
    })
  })
  
  # validate constructs
  # honestly i don't quite get what observe does but it works...
  observe({
    validateOutput <- validateConstruct(input)
    if (validateOutput$isValid) {
      shinyjs::show(id = "pipetTable", anim = TRUE)
      shinyjs::show(id = "constructAction", anim = TRUE, animType = "fade")
    } else {
      shinyjs::hide(id = "pipetTable", anim = TRUE)
      shinyjs::hide(id = "constructAction", anim = TRUE, animType = "fade")
    }
    
    output$validConstruct <- renderText({paste0("Extra parts: ", paste(validateOutput$extra, collapse = ", "), "\n",
                                                "Missing parts: ", paste(validateOutput$missing, collapse = ", "))})
  })
  
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
  
  output$pipetTable <- renderTable({
    buildTable(input)
    # selectedNames <- c(rownames(parts[parts$description == input$type1 & parts$type == "1",]),
    #     rownames(parts[parts$description == input$type2 & parts$type == "2",]),
    #     rownames(parts[parts$description == input$type3 & parts$type == "3",]),
    #     rownames(parts[parts$description == input$type3a& parts$type == "3a",]),
    #     rownames(parts[parts$description == input$type3b & parts$type == "3b",]),
    #     rownames(parts[parts$description == input$type4 & parts$type == "4",]),
    #     rownames(parts[parts$description == input$type4a & parts$type == "4a",]),
    #     rownames(parts[parts$description == input$type4b & parts$type == "4b",]),
    #     rownames(parts[parts$description == input$type5 & parts$type == "5",]),
    #     rownames(parts[parts$description == input$type6 & parts$type == "6",]),
    #     rownames(parts[parts$description == input$type7 & parts$type == "7",]),
    #     rownames(parts[parts$description == input$type8 & parts$type == "8",]),
    #     rownames(parts[parts$description == input$type8a & parts$type == "8a",]),
    #     rownames(parts[parts$description == input$type8b & parts$type == "8b",]),
    #     rownames(parts[parts$description == input$type234 & parts$type == "234",]),
    #     rownames(parts[parts$description == input$type678 & parts$type == "678",]))
    # selectedDescriptions <- as.character(parts[selectedNames, "description"])
    # selectedTypes <- as.character(parts[selectedNames, "type"])
    # selectedConcentrations <- (parts[selectedNames,"concentration"])
    # selectedLength <- str_length(parts[selectedNames,4])
    # selectedMoles <- rep.int(input$insertMole, length(selectedNames))
    # for (plasmid in selectedNames) {
    #   if (as.character(parts[plasmid,"type"]) == "8" | as.character(parts[plasmid,"type"]) == "8a" | as.character(parts[plasmid,"type"]) == "678") {
    #     selectedMoles[(selectedNames %in% plasmid)] <- input$vectorMole
    #   }
    # }
    # selectedMass <- molesToMass(selectedMoles, selectedLength)
    # selectedVolume <- selectedMass / selectedConcentrations
    # selectedDilutions <- paste("1:", round(1 / selectedVolume), sep = "")
    # finalTable <- cbind(selectedTypes, selectedNames, selectedDescriptions, paste(selectedLength, "bp"), paste(round(selectedConcentrations, digits = 2), "ng/uL"), paste(round(selectedVolume, digits = 2), "uL"), selectedDilutions)
    # colnames(finalTable) <- c("Type", "Plasmid", "Description", "Length", "Miniprepped Conc.", "Volume to Use", "Dilution for 1uL")
    # finalTable
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