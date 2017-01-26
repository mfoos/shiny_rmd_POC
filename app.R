library(shiny)
library(rmarkdown)
library(knitr)

ui <- fluidPage(
   
   titlePanel("knit an rmd document"),
   
   # Sidebar with a slider input for number of bins 
   sidebarLayout(
      sidebarPanel(
         actionButton("goknit", "knit")
      ),
      
      mainPanel(
         uiOutput("buttonappear")
      )
   )
)


server <- function(input, output, session) {
   
  reportdone <- eventReactive(input$goknit, {
    render("whaling_report_v1.Rmd", 
           output_format = "html_document")
  })
  
  output$buttonappear <- renderUI({
    reportdone()
    downloadButton("knitdoc")
  })
  
  output$knitdoc <- downloadHandler(
      filename = function(){
        paste0("report",".html")
      },
      content = function(file){
        #out <- strsplit(reportdone(), "/")[[1]][8]
        #file.copy(out, file, overwrite = TRUE)
        file.copy(reportdone(), file, overwrite = TRUE)
      },
      contentType = "text/html"
    )
  
}

# Run the application 
shinyApp(ui = ui, server = server)

