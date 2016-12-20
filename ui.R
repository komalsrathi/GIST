library(shiny)
library(shinydashboard)
library(DT)
library(plotly)
library(reshape2)
library(ggplot2)
options(gsubfn.engine = "R")
library(ggthemes)
library(plyr)

dashboardPage(
  dashboardHeader(title = 'Gene InterSect Tool (GIST)', titleWidth = 300),
  dashboardSidebar(width = 300, div(style="overflow-y: scroll"),
                   sidebarMenu(
                     menuItem("Get Intersections", icon = icon("dashboard"), tabName = "dashboard",
                              badgeLabel = "new", badgeColor = "green"),
                     menuItem("Data Description", icon = icon("database"), tabName = "database")
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
      tabItem(tabName = "database",
              DT::dataTableOutput(outputId = "dt1", width = "100%", height = "auto")
              ),
      tabItem(tabName = "dashboard",
              fluidRow(
                box(title = "Datasets", status = "danger", width = 3, solidHeader = TRUE, collapsible = T,
                    selectInput(inputId = "selectinput1",
                                label = "Select one",
                                choices = c('TARGET NBL MYCN Amplified-Non Amplified (Upregulated)'='TARGETNBL_MYCN_AmplifiedvsNonAmplified_Upreg.RDS',
                                            'TARGET NBL MYCN Amplified-Non Amplified (Downregulated)'='TARGETNBL_MYCN_AmplifiedvsNonAmplified_Downreg.RDS',
                                            'TARGET NBL-GTEx Normals (Upregulated)'='TARGETNBLvsGTExNormals_upreg.RDS',
                                            'TARGET NBL-GTEx Normals (Downregulated)'='TARGETNBLvsGTExNormals_downreg.RDS',
                                            'TARGET NBL-GTEx Normals Primary (Upregulated)'='TARGETNBLPrimaryvsGTExNormals_upreg.RDS',
                                            'TARGET NBL-GTEx Normals Primary (Downregulated)'='TARGETNBLPrimaryvsGTExNormals_downreg.RDS',
                                            'TARGET NBL-GTEx Normals Primary HR (Upregulated)'='TARGETNBLPrimaryHRvsGTExNormals_upreg.RDS',
                                            'TARGET NBL-GTEx Normals Primary HR (Downregulated)'='TARGETNBLPrimaryHRvsGTExNormals_downreg.RDS'),
                                selected = NULL,
                                multiple = T)),
                box(title = "Lists", status = "danger", width = 3, solidHeader = TRUE, collapsible = T,
                    selectInput(inputId = "selectinput2", 
                                       label = "Select one or more",
                                       choices=c('IMPACT' = 'IMPACT.RDS',
                                                 'Transmembrane (Compartments)' = 'TMList.RDS',
                                                 'GTEx Normal Expression (95% of Samples < FPKM 5)' = 'Normals_Samples95FPKM5.RDS',
                                                 'GTEx Normal Expression (95% of Samples < FPKM 10)' = 'Normals_Samples95FPKM10.RDS',
                                                 'GTEx Normal Expression (95% of Samples < FPKM 1)' = 'Normals_Samples95FPKM1.RDS',
                                                 'Cancer Predisposition Genes (Germline)' = 'Cancer_Predisposition_Germline.RDS',
                                                 'COSMIC Frequently Mutated Genes (Autonomic Ganglia, NB)' = 'COSMIC_AutonomicGanglia_NB.RDS',
                                                 'Foundation One Panel (Cancer Related Genes)' = 'FoundationOne_Panel_CancerRelated.RDS',
                                                 'Foundation One Panel (Rearrangements)' = 'FoundationOne_Panel_Rearrangements.RDS',
                                                 'MYCN Signatures' = 'MYCN_Signatures.RDS',
                                                 'Genes Correlated with Poor Survival (NBL)' = 'Genes_OverExpression_Correlated_PoorSurvival.RDS',
                                                 'Genes around MYCN Locus' = 'MYCN_Locus.RDS',
                                                 '11q Deletion' = '11qDeletion.RDS',
                                                 '1p Deletion' = '1pDeletion.RDS'), 
                                       selected = NULL,
                                multiple = TRUE),
                    actionLink("selectall2","Select/Unselect All")),
                box(title = "Input your own list", status = "danger", width = 3, solidHeader = TRUE, collapsible = T, 
                    fileInput(inputId = "fi1", 
                              label = "Input one file (must have *GeneList* as column)", 
                              multiple = F, 
                              accept = c('csv','tsv','txt')))),
              fluidRow(column(5, actionButton(inputId = "submit1", label = "Update output"),
                              downloadButton('downloadData', 'Download'))), 
              br(),br(),
              # fluidRow(
              #   column(6,
              #   DT::dataTableOutput(outputId = "dt2", width = "100%", height = "auto")),
              #   column(6,plotlyOutput(outputId = 'plot1', width = "100%", height = "auto"))
              # )
              DT::dataTableOutput(outputId = "dt2", width = "100%", height = "auto"),
              plotlyOutput(outputId = 'plot1', width = "100%", height = "auto")
          )
      ) 
  ) 
)
