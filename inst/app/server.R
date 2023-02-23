#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
# library(pid.pos)

is.not.numeric <- function(...) !is.numeric(...)

help_text <- div(
  p("To use this tool follow these steps:"),
  tags$ol(
    tags$li("Click 'Browse...' to select the CSV file for analysis.  Once loaded the data can be inspected via the 'User Data' tab."),
    tags$li("Select a column via the drop down menu for analysis."),
    tags$li("Click 'Produce Report'.  The PID report is viewable under the 'Noun Report' tab.")
  ),
  class="help_text"
)

PB <- R6::R6Class("PB", list(
  current = NA,
  max = NA,
  percent = NA,
  id = NA,
  session=NA,
  initialize = function(session,id="pb") {
    self$current = 0
    self$max = 100
    self$percent = 0
    self$id = id
    self$session = session
  },
  tick = function() {
    self$current <- self$current + 1
    self$percent <- floor(100*self$current / self$max)
    self$update_pb()
  },
  update_pb = function(session){
    updateProgressBar(
      session = self$session,
      id = self$id,
      value = self$percent, total = 100
    )
  }
))


shinyServer(function(input, output, session) {

  data <- data.frame()
  results <- data.frame()
  pb <- PB$new(session, id="report_progress")
  output$pos_tag_message <- renderText("")

  output$help_text <- renderUI(help_text)

  observeEvent(
    input$report_button,
    {
      output$pos_tag_message <- renderText("Applying tags..")

      col <- data[[input$variable_input]]

      chunk_size <- 10
      pb$current <- 0
      pb$max <- 2*ceiling(length(col) / chunk_size)

      pnr <- proper_noun_report(col, chunk_size = chunk_size, progress_bar = pb)
      results <<- pnr$`Proper Nouns`

      output$pos_tag_message <- renderText("Rendering results...")

      output$noun_table <- renderDataTable(results)
      output$pos_tag_message <- renderText("Report complete")
    }
  )

  observe({
    print(input$file_data)
    if (!is.null(input$file_data)){
      data <<- read.csv(input$file_data$datapath)
    }
    output$data_table <- renderDataTable(data)

    categorical.data <- select(data, where(is.not.numeric))
    updateSelectInput(
      session, "variable_input",
      choices = colnames(categorical.data)
    )
  })

  output$downloadData <- downloadHandler(
    filename = function() {
      paste("PID-report-", Sys.Date(), ".csv", sep="")
    },
    content = function(file) {
      write.csv(results, file)
    }
  )

})
