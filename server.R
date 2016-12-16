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
    total.all <- data.frame()
    if(input$submit1 == 0){
      return()
    }
    isolate({
      dt <- c(as.character(input$selectinput2), as.character(input$selectinput1))
      for(i in 1:length(dt)){
        dat <- readRDS(file = paste0('data/',dt[i]))
        if(i == 1){
          total <- dat
          total.all <- unique(as.character(dat$GeneList))
        }
        if(i > 1){
          total <- unique(merge(dat, total, by = "GeneList"))
          total.all <- c(total.all, unique(as.character(dat$GeneList)))
        }
      }
      
      # count the number of datasets
      ct <<- length(dt)
      
      # custom list
      data <- fileInput()
      if(!is.null(data)){
        ct <<- ct + 1
        total <- unique(merge(data, total, by = "GeneList"))
        total.all <- c(total.all, unique(as.character(data$GeneList)))
      }
      
      print(ct)
      myDat <<- total
      forbar <<- data.frame(GeneList = total.all)
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
  
  # plot
  output$plot1 <- renderPlotly({
    if(input$submit1 == 0){
      return()
    }
    isolate({
      forbar <- as.data.frame(table(as.character(forbar$GeneList)))
      colnames(forbar)[2] <- 'dataset'
      forbar.plot <- plyr::count(forbar$dataset)
      forbar.plot <- forbar.plot[which(forbar.plot$x <= ct),]
      forbar <- merge(forbar, forbar.plot, by.x = 'dataset', by.y = 'x')
      forbar <- ddply(forbar, .(dataset, freq), summarize, Var1 = toString(Var1))
      forbar <- forbar[order(forbar$freq),]
      # p <- ggplot(data = forbar, aes(x = as.factor(freq),  y = dataset, label = Var1)) + 
      #   geom_bar(stat = "identity", position = "dodge") + 
      #   guides(fill = F) +
      #   xlab('Genes') + ylab('Datasets') 
      p <- ggplot(data = forbar, aes(x = as.factor(freq),  y = dataset, label = Var1)) + 
        geom_bar(stat = "identity", position = "dodge", aes(fill = dataset)) + theme_bw() +
        guides(fill = F) +
        xlab('Genes') + ylab('Datasets') + scale_fill_gradient(limits=c(1,ct), low="firebrick1", high="firebrick4", space="Lab")
      
      p <- plotly_build(p)
      p$x$layout$bargap <- 0.01
      p
    })
  })
  
})

