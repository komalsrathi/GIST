library(shiny)
library(shinydashboard)
library(DT)
library(plotly)
library(reshape2)
library(ggplot2)
options(gsubfn.engine = "R")
library(ggthemes)

dashboardPage(
  dashboardHeader(title = 'Gene InterSect Tool (GIST)', titleWidth = 300),
  dashboardSidebar(width = 300, div(style="overflow-y: scroll"),
                   sidebarMenu(
                     menuItem("Get Intersections", icon = icon("dashboard"), tabName = "dashboard",
                              badgeLabel = "new", badgeColor = "green")
                     )
                   ),
  dashboardBody(
    # tags$head(tags$style(HTML('
    #                           /* logo */
    #                           .skin-blue .main-header .logo {
    #                           background-color: black;
    #                           }
    #                           
    #                           /* navbar (rest of the header) */
    #                           .skin-blue .main-header .navbar {
    #                           background-color: black;
    #                           }        
    # 
    #                           /* other links in the sidebarmenu */
    #                           .skin-blue .main-sidebar .sidebar .sidebar-menu a{
    #                           background-color: black;
    #                           color: #000000;
    #                           }
    #                           
    #                           /* main sidebar */
    #                           .skin-blue .main-sidebar {
    #                           background-color: black;
    #                           }'))),
    div(style="overflow-x: scroll"),
    
    tabItems(
      tabItem(tabName = "dashboard",
              fluidRow(
                box(title = "Differential Expression", status = "danger", width = 3, solidHeader = TRUE, collapsible = T,
                    selectInput(inputId = "selectinput1",
                                label = "Select one or more",
                                choices = c('MYCN Amplified', 'TCGA vs Normals', 'None'),
                                selected = NULL,
                                multiple = TRUE),
                    actionLink("selectall1","Select All")),
                box(title = "External", status = "danger", width = 3, solidHeader = TRUE, collapsible = T,
                    selectInput(inputId = "selectinput2", 
                                       label = "Select one or more",
                                       choices=c('IMPACT'='IMPACT.RDS',
                                                 'Transmembrane (Compartments)'='TMList.RDS',
                                                 'GTEx Normal Expression (95% of Samples < FPKM 5)'='Normals_Samples95FPKM5.RDS'), 
                                       selected = NULL,
                                multiple = TRUE),
                    actionLink("selectall2","Select All")),
                box(title = "Input your own list", status = "danger", width = 3, solidHeader = TRUE, collapsible = T, 
                    fileInput(inputId = "fi1", 
                              label = "Input one file (must have *GeneList* as column)", 
                              multiple = T, 
                              accept = c('csv','tsv','txt')))),
                fluidRow(column(5, actionButton(inputId = "submit1", label = "Update output"))), 
                br(),br(),
                DT::dataTableOutput(outputId = "dt1", width = "100%", height = "auto")
          )
      ) 
  ) 
)