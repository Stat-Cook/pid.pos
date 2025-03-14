
#' @importFrom dplyr filter select
#' @import shiny
report_server <- function(input, output, session) {
  session$userData$data.loaded <- F
  #session$userData$app.data <- data.frame(Affected.Columns = character(0))
  session$userData$app.data <- data.frame(Affected.Columns = sample(letters))
  session$userData$app.columns <-  c()
  
  output$tbl1  <- renderDataTable({
    infile <- input$file1
    if (is.null(infile)) {
      return(NULL)
    }
    session$userData$app.data <- read.csv(infile$datapath, header = TRUE)
    
    session$userData$app.columns <- unique(session$userData$app.data$Affected.Columns)    
    
    session$userData$data.loaded <- T
    session$userData$app.data |> 
      filter(!Affected.Columns %in% input$checkbox.remove)|> 
      filter(!Affected.Columns %in% input$checkbox.ignore)
  })
  
  observe({
    input$file1
    session$userData$app.columns
    
    updateCheckboxGroupInput(
      session,
      "checkbox.remove",
      choices = session$userData$app.columns
    )
    
    updateCheckboxGroupInput(
      session,
      "checkbox.ignore",
      choices = session$userData$app.columns
    )
  })
  
  observe({
    input$checkbox.remove
    
    updateCheckboxGroupInput(
      session,
      "checkbox.ignore",
      choices = setdiff(session$userData$app.columns, input$checkbox.remove)
    )
  })
  
  observe({
    input$button.clipboard
    
    .text <- sprintf(
      ".f <- function(data){
        dplyr::select(
          data,
          -c(%s)
        )
      }",
      paste(input$checkbox.remove, collapse=", ")
    )
    
    writeClipboard(.text)
    
  })
  
}