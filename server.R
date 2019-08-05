library(shiny)

partsYTK <- read.csv("data/toolkit.csv", row.names = 1)
partsCustom <- read.csv("data/user.csv", row.names = 1)

type1Parts <- as.character(partsYTK[,2][partsYTK$type == 1])
type2Parts <- c(as.character(partsYTK[,2][partsYTK$type == 2]), "None")
type3Parts <- c(as.character(partsYTK[,2][partsYTK$type == 3]), "None")
type3aParts <- c("None", as.character(partsYTK[,2][partsYTK$type == "3a"]))
type3bParts <- c("None", as.character(partsYTK[,2][partsYTK$type == "3b"]))
type4Parts <- c(as.character(partsYTK[,2][partsYTK$type == 4]), "None")
type4aParts <- c("None", as.character(partsYTK[,2][partsYTK$type == "4a"]))
type4bParts <- c("None", as.character(partsYTK[,2][partsYTK$type == "4b"]))
type5Parts <- as.character(partsYTK[,2][partsYTK$type == 5])
type6Parts <- c(as.character(partsYTK[,2][partsYTK$type == 6]), "None")
type7Parts <- c(as.character(partsYTK[,2][partsYTK$type == 7]), "None")
type8Parts <- c(as.character(partsYTK[,2][partsYTK$type == 8]), "None")
type8aParts <- c("None", as.character(partsYTK[,2][partsYTK$type == "8a"]))
type8bParts <- c("None", as.character(partsYTK[,2][partsYTK$type == "8b"]))
type234Parts <- c("None", as.character(partsYTK[,2][partsYTK$type == 234]))
type678Parts <- c("None", as.character(partsYTK[,2][partsYTK$type == 678]))

source("functions.R")

function (input,output) {
  
  output$type1Input <- renderUI({
    selectInput("type1", "Assembly Connector (1)", type1Parts, selected = type1Parts[1])
  })
  output$type2Input <- renderUI({
    selectInput("type2", "Promoter (2)", type2Parts, selected = type2Parts[1])
  })
  output$type3Input <- renderUI({
    selectInput("type3", "Coding Sequence (3)", type3Parts, selected = type3Parts[1])
  })
  output$type3aInput <- renderUI({
    selectInput("type3a", "N-terminal CDS (3a)", type3aParts, selected = type3aParts[1])
  })
  output$type3bInput <- renderUI({
    selectInput("type3b", "CDS (3b)", type3bParts, selected = type3bParts[1])
  })
  output$type4Input <- renderUI({
    selectInput("type4", "Terminator (4)", type4Parts, selected = type4Parts[1])
  })
  output$type4aInput <- renderUI({
    selectInput("type4a", "C-terminal CDS (4a)", type4aParts, selected = type4aParts[1])
  })
  output$type4bInput <- renderUI({
    selectInput("type4b", "Terminator (4b)", type4bParts, selected = type4bParts[1])
  })
  output$type5Input <- renderUI({
    selectInput("type5", "Assembly Connector (5)", type5Parts, selected = type5Parts[1])
  })
  output$type6Input <- renderUI({
    selectInput("type6", "S. cerevisiae marker (6)", type6Parts, selected = type6Parts[1])
  })
  output$type7Input <- renderUI({
    selectInput("type7", "S. cerevisiae origin / 3' homology (7)", type7Parts, selected = type7Parts[1])
  })
  output$type8Input <- renderUI({
    selectInput("type8", "E. coli marker and origin (8)", type8Parts, selected = type8Parts[1])
  })
  output$type8aInput <- renderUI({
    selectInput("type8a", "E. coli marker and origin (8a)", type8aParts, selected = type8aParts[1])
  })
  output$type8bInput <- renderUI({
    selectInput("type8b", "5' homology (8b)", type8bParts, selected = type8bParts[1])
  })
  output$type234Input <- renderUI({
    selectInput("type234", "Miscellaneous (234)", type234Parts, selected = type234Parts[1])
  })
  output$type678Input <- renderUI({
    selectInput("type678", "E. coli marker and origin (678)", type678Parts, selected = type678Parts[1])
  })
  
  output$validConstruct <- renderText({
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
      input$type678
    )
    
    
    if (isValid) {
      "It's Good :)"
    } else {
      "It's Bad :("
    }
    
  })
  
}