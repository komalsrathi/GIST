# source functions
source('R/viewDataTable.R')
shinyServer(function(input, output, session){
  
  # data description
  output$dt1 <- DT:: renderDataTable({
    data <- read.delim('data/data_desc.txt')
    viewDataTable(dat = data)
  })
  
  # update selectInput
  observe({
    if(is.null(input$selectall2))
      return(NULL)
    if(input$selectall2 > 0){
      choices <- c('IMPACT' = 'IMPACT.RDS',
                   'Transmembrane (Compartments)' = 'TMList.RDS',
                   'GTEx Normal Expression (95% of Samples < FPKM 5)' = 'Normals_Samples95FPKM5.RDS',
                   'GTEx Normal Expression (95% of Samples < FPKM 10)' = 'Normals_Samples95FPKM10.RDS',
                   'GTEx Normal Expression (95% of Samples < FPKM 1)' = 'Normals_Samples95FPKM1.RDS')
      updateSelectInput(session, inputId = 'selectinput2', choices = choices, selected = choices)
    }
  })
  
  # fileInput
  fileInput <- reactive({
    infile <- input$fi1
    if(is.null(infile))
      return(NULL)
    read.table(file = infile$datapath, check.names = F, header = TRUE, stringsAsFactors = F)
  })
  
  # update output data table
  output$dt2 <- DT::renderDataTable({
    total <- data.frame()
    if(input$submit1 == 0){
      return()
    }
    isolate({
      dt <- c(as.character(input$selectinput2), as.character(input$selectinput1))
      for(i in 1:length(dt)){
        dat <- readRDS(file = paste0('data/',dt[i]))
        if(i == 1){
          total <- dat
        }
        if(i > 1){
          total <- merge(dat, total, by = "GeneList")
        }
      }
      
      # custom list
      data <- fileInput()
      if(!is.null(data)){
        total <- merge(data, total, by = "GeneList")
      }
      myDat <<- total
      viewDataTable(dat = total)
    })
  })
  
  # download table
  output$downloadData <- downloadHandler(
    filename = function() { 
      paste('output.csv', sep='') 
    },
    content = function(file) {
      write.csv(myDat, file, row.names = F)
    }
  )
  
})

