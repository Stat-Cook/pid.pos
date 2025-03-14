# Define UI for app that draws a histogram ----
report_ui <- fluidPage(
  sidebarPanel(
    fileInput(
      "file1", "Choose CSV File",
      accept = c(".csv")), 
    checkboxGroupInput("checkbox.remove", "Remove from data:", c()),
    checkboxGroupInput("checkbox.ignore", "Ignore:", c()),
    actionButton("button.clipboard", "Write to clipboard")
  ),
  mainPanel(
    dataTableOutput("tbl1")
  )
)