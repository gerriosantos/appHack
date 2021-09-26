library(shiny)
library(shinydashboard)


lista_turma_q <- readr::read_rds('produto1.rds') |>
  dplyr::distinct(nome_turma) |>
  dplyr::pull(var = nome_turma)

lista_questao <- readr::read_rds('produto1.rds') |>
  dplyr::distinct(q_oport_aprend) |>
  dplyr::pull(q_oport_aprend)

escalas_oportun_aprend <- readr::read_rds("escalas_oportun_aprend.rds")
descricao <- readr::read_csv2("descricao_questoes.csv", locale = locale(encoding = "Latin1"))[,c(1,2)]





ui <- dashboardPage(

  dashboardHeader(title = 'HackPI 2021'),


  dashboardSidebar(
    sidebarMenu(
      menuItem(text = 'Apresentação', tabName = 'apresentacao', icon = icon('home')),
      menuItem(text = 'Escola', tabName = 'escola', icon = icon('school')),
      menuItem(text = 'Turma', tabName = 'turma', icon = icon('chalkboard-teacher'))
    )
  ),



  dashboardBody(
    tabItems(
      tabItem(tabName = 'apresentacao',
              includeMarkdown('index.Rmd')
      ),
      tabItem(
        div(class = 'header', checked = NA,
            h1('Oportunidade de Aprendizagem')
        ),
        br(),
        tabName = 'turma',
        fluidRow(
          column(
            width = 6,
            selectizeInput(
              inputId = 'turma',
              label = 'Escolha a Turma',
              choices = lista_turma_q,
              width = '100%',
              selected = 'nome_turma 1',
            )
          ),
          column(
            width = 6,
            selectizeInput(
              inputId = 'questao',
              label = 'Escolha a Questão',
              choices = lista_questao,
              width = '25%',
              selected = 'od_q19',
            )
          ),
          textOutput("selected_var", ),
          tags$head(tags$style("#selected_var{color: black;
                                 font-size: 20px;
                                 font-style: bold;
                                 }"
          )
          ),
          hr(),
          infoBoxOutput("oportunidades_inadequadas"),
          infoBoxOutput("oportunidades_adequadas"),
          # box(
          #   width = 6,
          #   height = '100px',
          #   selectizeInput(
          #     inputId = 'turma',
          #     label = 'Escolha a Turma',
          #     choices = lista_turma_q,
          #     width = '25%',
          #     selected = 'nome_turma 1',
          #   )
          # ),
          # box(
          #   width = 6,
          #   height = '100px',
          #   selectizeInput(
          #     inputId = 'questao',
          #     label = 'Escolha a Questão',
          #     choices = lista_questao,
          #     width = '25%',
          #     selected = 'od_q19',
          #   )
          # )
        ),
      )
    )
  )
)




server <- function(input, output, session) {


  oportunidade_inadequada <- reactive({
    as.character(escalas_oportun_aprend[(escalas_oportun_aprend$nome_turma == input$turma & escalas_oportun_aprend$name == input$questao),][,"qual_indes"][[1]])
  })

  oportunidade_adequada <- reactive({
    as.character(escalas_oportun_aprend[(escalas_oportun_aprend$nome_turma == input$turma & escalas_oportun_aprend$name == input$questao),][,"qual_adeq"][[1]])
  })

  output$oportunidades_inadequadas <- renderInfoBox({


    infoBox(
      "Inadequadas",
      oportunidade_inadequada(),
      icon = icon("virus"),
      color = "red"
    )
    })

  output$oportunidades_adequadas <- renderInfoBox({


    infoBox(
      "Adequadas",
      oportunidade_adequada(),
      icon = icon("virus"),
      color = "blue"
    )
  })

  titulo_oportunidade <- reactive({

    as.character(descricao[descricao$name == input$questao,][,"descricao"][[1]])

  })


  output$selected_var <- renderText({
    titulo_oportunidade()
  })

}



shinyApp(ui = ui, server = server)




