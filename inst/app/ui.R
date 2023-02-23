#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinyWidgets)


# Define UI for application that draws a histogram
shinyUI(fluidPage(
    tags$head(
      tags$link(rel = "stylesheet", type = "text/css", href = "style.css")
    ),

    # Application title
    titlePanel("Check for PID in a CSV file"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            fileInput(inputId = "file_data",
                      label = "Upload data. Choose csv file",
                      accept = c(".csv")),
            selectInput('variable_input', 'Choose Column', c("")),
            actionButton(inputId = "report_button",
                         label = "Produce report"),
            progressBar(
              id = "report_progress",
              value = 0,
              total = 100,
              title = "POS tag progress:",
              display_pct = TRUE
            ),
            textOutput("pos_tag_message"),
            downloadButton("downloadData", "Download")
        ),

        # Show a plot of the generated distribution
        mainPanel(
          tabsetPanel(
            tabPanel("How to", htmlOutput("help_text")),
            tabPanel("User Data", dataTableOutput("data_table")),
            tabPanel("Noun report", dataTableOutput("noun_table"))
          )
        )
    )
))
