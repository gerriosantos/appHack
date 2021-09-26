library(shiny)
library(shinydashboard)
#library(bs4Dash)


lista_turma_q <- readr::read_rds('produto1.rds') |>
  dplyr::distinct(nome_turma) |>
  dplyr::pull(var = nome_turma)

lista_questao <- readr::read_rds('produto1.rds') |>
  dplyr::distinct(q_oport_aprend) |>
  dplyr::pull(q_oport_aprend)







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
        tabName = 'escola'
      ),



      tabItem(
        div(class = 'header', checked = NA,
            h1('Oportunidades de Aprendizagens')
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
          )
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




server <- function(input, output, session){



}



shinyApp(ui = ui, server = server)




