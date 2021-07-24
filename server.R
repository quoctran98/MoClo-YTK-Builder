library(shiny)
library(DT)
library(stringr)
library(shinyjs)
library(purrr)

sapply(paste0("./functions/", list.files("./functions")), source)

# let's write something to put all the parts in one dataframe (prefix each part name with file name) BASE VS MOCLOYTK!!!
parts <- read.csv("./data/parts/MoClo-YTK.csv", row.names = 1, stringsAsFactors = FALSE)
parts$name <- rownames(parts) # we do this bc there's a weird issue with UTF-8 BOM encoding that prevents us from not having the row.names arg in read.csv (https://stackoverflow.com/questions/24568056/rs-read-csv-prepending-1st-column-name-with-junk-text/24568505)
parts$kit <- "MoClo-YTK"

for (file in list.files("./data/parts/kits")) {
  kit <- read.csv(paste0("./data/parts/kits/", file), row.names = 1, stringsAsFactors = FALSE)
  kit$name <- rownames(kit)
  kit$kit <- str_replace(file, ".csv", "")
  parts <- rbind(parts, kit)
  rm(file, kit)
}

# now we need to add concentrations to the parts df
parts <- merge(parts, read.csv("./data/stock.csv", row.names = 1), by = c("row.names", "kit"), all.x = TRUE) # i don't know if it does AND or OR for the columns
rownames(parts) <- parts$Row.names # i really don't get what this does?
parts <- parts[,!(names(parts) %in% c("Row.names"))] # this either???
parts$concentration[is.na(parts$concentration)] <- 0

# part types df
types <- read.csv("./data/types.csv")

function (input, output, session) {
  
  # populating dropdown menus (for loops have lazy eval here) 
  # make this reactive to update parts
  lapply(1:nrow(types), function (row) {
    typeInfo <- types[row,]
    typeParts <- getParts(typeInfo$type, defaultEmpty = !(typeInfo$type %in% 1:8))
    output[[paste0("type", typeInfo$type, "Input")]] <- renderUI({
      selectInput(inputId = paste0("type", typeInfo$type, "Select"), # each dropdown menu has ID "type[type]Select"
                  label = typeInfo$label,
                  choices = typeParts,
                  selected = typeParts[1])
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