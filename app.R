library(tidyverse)
library(shiny)
library(Rlab)
library(rsconnect)

eig<-read.csv('output.csv',sep=",")
nrow(eig)

colum_test<-rbern(4711, 0.5)
colum_test<- as.vector(colum_test)


eig <- eig %>%
  select(-c(letzte.berufliche.Tätigkeit.Kategorie,Erlernter.Beruf.Kategorie ,Grund.Teilzeit,Beschäftigungsgrad))


ui<-fluidPage(
  titlePanel("ReFund Intel"),
  mainPanel(
    dataTableOutput("Ztable")
  )
  
)

server <- shinyServer(function(input, output, session){
  
  output$Ztable <- renderDataTable({
    eig
    
  })})

# Run the application
shinyApp(ui = ui, server = server)
