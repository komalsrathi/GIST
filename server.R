# source functions
source('R/viewDataTable.R')
shinyServer(function(input, output, session){
  
  # update selectInput
  observe({
    if(is.null(input$selectall2))
      return(NULL)
    if(input$selectall2 > 0){
      choices <- c('IMPACT'='IMPACT.RDS',
                   'Transmembrane (Compartments)'='TMList.RDS',
                   'GTEx Normal Expression (95% of Samples < FPKM 5)'='Normals_Samples95FPKM5.RDS')
      updateSelectInput(session, inputId = 'selectinput2', choices = choices, selected = choices)
    }
  })
  
  # update output data table
  output$dt1 <- DT::renderDataTable({
    total <- data.frame()
    if(input$submit1 == 0){
      return()
    }
    isolate({
      dt <- as.character(input$selectinput2)
      for(i in 1:length(dt)){
        dat <- readRDS(file = paste0('data/',dt[i]))
        if(i == 1){
          total <- dat
        }
        if(i > 1){
          total <- merge(total, dat, by = "GeneList")
        }
      }
      DT::datatable(dat = total)
    })
  })
  
  
  
})

