library(shiny)
library(DT)
library(stringr)
library(shinyjs)

fluidPage(
  
  useShinyjs(),
  
  titlePanel("MoClo-YTK Builder"),
  
  tabsetPanel(
    
    tabPanel(title = "Build Construct",
            div(style = "margin-top:1em", wellPanel(fluidRow(
               column(1, div(style = "margin-right:-2em", wellPanel(style = "padding:5px; background: #82C4DE", uiOutput("type1Input")))),
               column(1, div(style = "margin-right:-2em", wellPanel(style = "padding:5px; background: #A9D05E", uiOutput("type2Input")))),
               column(2, div(style = "margin-right:-2em", wellPanel(style = "padding:5px; background: #F1EB8F", uiOutput("type3Input")))),
               column(2, div(style = "margin-right:-2em", wellPanel(style = "padding:5px; background: #EE8C9C", uiOutput("type4Input")))),
               column(1, div(style = "margin-right:-2em", wellPanel(style = "padding:5px; background: #7F68AD", uiOutput("type5Input")))),
               column(1, div(style = "margin-right:-2em", wellPanel(style = "padding:5px; background: #F4CF8F", uiOutput("type6Input")))),
               column(1, div(style = "margin-right:-2em", wellPanel(style = "padding:5px; background: #8B6237", uiOutput("type7Input")))),
               column(2, div(style = "margin-right:-2em", wellPanel(style = "padding:5px; background: #7E7E7E", uiOutput("type8Input"))))
             ),
            fluidRow(
               column(2),
               column(1, div(style = "margin-right:-2em; margin-top:-2em", wellPanel(style = "padding:5px; background: #F1EB8F", uiOutput("type3aInput")))),
               column(1, div(style = "margin-right:-2em; margin-top:-2em", wellPanel(style = "padding:5px; background: #F1EB8F", uiOutput("type3bInput")))),
               column(1, div(style = "margin-right:-2em; margin-top:-2em", wellPanel(style = "padding:5px; background: #EE8C9C", uiOutput("type4aInput")))),
               column(1, div(style = "margin-right:-2em; margin-top:-2em", wellPanel(style = "padding:5px; background: #EE8C9C", uiOutput("type4bInput")))),
               column(3),
               column(1, div(style = "margin-right:-2em; margin-top:-2em", wellPanel(style = "padding:5px; background: #7E7E7E", uiOutput("type8aInput")))),
               column(1, div(style = "margin-right:-2em; margin-top:-2em", wellPanel(style = "padding:5px; background: #7E7E7E", uiOutput("type8bInput"))))
             ),
            fluidRow(
               column(1),
               column(5, div(style = "margin-right:-2em; margin-top:-2em; margin-bottom:-1em", wellPanel(style = "padding:5px; background: #EE8C9C", uiOutput("type234Input")))),
               column(1),
               column(4, div(style = "margin-right:-2em; margin-top:-2em; margin-bottom:-1em", wellPanel(style = "padding:5px; background: #7E7E7E", uiOutput("type678Input"))))
             ))),
            sidebarLayout(
              sidebarPanel(
                textInput("constructName", "Plasmid Name"),
                textInput("constructDescription", "Description"),
                fileInput("constructFile", "GenBank File (optional)"),
                shinyjs::hidden(actionButton("constructAction", "Add Cassette")),
                textOutput("validConstruct")
              ),
              mainPanel(
                wellPanel(tableOutput("pipetTable"), textOutput("validConstruct2"))
              )
             )
    ),
    
    tabPanel(title = "Add Parts",
            dateInput("date", "Date")
    ),
    
    tabPanel(title = "Parts List",
             sidebarLayout(
               sidebarPanel(DTOutput("partsTable") ),
               mainPanel(htmlOutput("partsMap"))
             )
    )
    
  )
)