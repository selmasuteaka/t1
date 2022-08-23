


library(shiny)
library(RMeCab)
library(tidyverse)
library(dplyr)
library(igraph)

shinyUI(fluidPage(

    titlePanel("COOCNET"),

    sidebarLayout(
        sidebarPanel(
          
          fileInput("file", label = h3("file"),         
                    accept = c(
                      "text/csv",
                      "text/comma-separated-values,text/plain",
                      ".csv")
                    )
          ),
  
    
            mainPanel(
            tabsetPanel(#type = "tabs",
                tabPanel("Table",tableOutput('table')),
                tabPanel(
                  "Co-0cNET", #共起ネット
                  div(
                    plotOutput('Coocnet',height = "100%"),
                    style = "height: calc(100vh  - 100px)"
                    ))                
          　　  )
      　　  )
    　　)
　　)
)


