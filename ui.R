library(shiny)

fluidPage(
  
  titlePanel("MoClo-YTK Builder"),
  
  textOutput("validConstruct"),
  
  fluidRow(
    column(1, wellPanel(style = "background: #82C4DE", uiOutput("type1Input"))),
    column(1, wellPanel(style = "background: #A9D05E", uiOutput("type2Input"))),
    column(2, wellPanel(style = "background: #F1EB8F", uiOutput("type3Input"))),
    column(2, wellPanel(style = "background: #EE8C9C", uiOutput("type4Input"))),
    column(1, wellPanel(style = "background: #7F68AD", uiOutput("type5Input"))),
    column(1, wellPanel(style = "background: #F4CF8F", uiOutput("type6Input"))),
    column(1, wellPanel(style = "background: #8B6237", uiOutput("type7Input"))),
    column(2, wellPanel(style = "background: #7E7E7E", uiOutput("type8Input")))
  ),
  fluidRow(
    column(2),
    column(1, wellPanel(style = "background: #F1EB8F", uiOutput("type3aInput"))),
    column(1, wellPanel(style = "background: #F1EB8F", uiOutput("type3bInput"))),
    column(1, wellPanel(style = "background: #EE8C9C", uiOutput("type4aInput"))),
    column(1, wellPanel(style = "background: #EE8C9C", uiOutput("type4bInput"))),
    column(3),
    column(1, wellPanel(style = "background: #7E7E7E", uiOutput("type8aInput"))),
    column(1, wellPanel(style = "background: #7E7E7E", uiOutput("type8bInput")))
  ),
  fluidRow(
    column(1),
    column(5, wellPanel(style = "background: #CDBDAA", uiOutput("type234Input"))),
    column(1),
    column(4, wellPanel(style = "background: #7E7E7E", uiOutput("type678Input")))
  )
  
)