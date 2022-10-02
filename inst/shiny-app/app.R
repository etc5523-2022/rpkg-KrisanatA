library(shiny)
library(dplyr)
library(plotly)
library(kableExtra)
library(shinythemes)
library(dislib)

disease_name <- unique(mortality$disease)
country_name <- unique(mortality$country)
continent_name <- unique(mortality$continent)


# UI ----------------------------------------------------------------------


ui <- fillPage(

  navbarPage("Disease Library", id = "top",

             theme = shinytheme("cerulean"),

             # Disease Information tab
             tabPanel("Disease Information", icon = icon("user-doctor"),

                      fluidRow(

                        column(4,

                               selectInput(
                                 inputId = "disease",
                                 label = "Which disease do you want to learn more about?",
                                 choices = disease_name
                               )

                               ),

                        column(5,

                               selectInput(
                                 inputId = "country",
                                 label = "Which country?",
                                 choices = country_name
                               )

                               ),

                        column(3,

                               sliderInput(
                                 inputId = "year",
                                 label = "Which year?",
                                 min = min(mortality$year),
                                 max = max(mortality$year),
                                 value = 2019,
                                 sep = ""
                               )

                               )
                      ),


                      fluidRow(

                        column(7,

                               mainPanel(
                                 htmlOutput("title_time")
                               ),

                               mainPanel(
                                 plotlyOutput("time_series", height = 500)
                               )


                               ),

                        column(5,

                               mainPanel(
                                 htmlOutput("title_rank")
                               ),

                               mainPanel(
                                 htmlOutput("ranking", height = 500)
                               )

                               )
                      )

                      ),

             # About tab
             tabPanel("About", icon = icon("circle-info"),

                      uiOutput("about")

             )

             )
)



# SERVER ------------------------------------------------------------------


server <- function(input, output){

  # Title
  output$title_time <- renderText(
    "<h4><b>Mortality Rate Over Time</b></h4>"
  )

  output$title_rank <- renderText(
    "<h4><b>Disease Ranking (mortality rate)</b></h4>"
  )

  # Time Series Plot
  observe({
    req(input$disease, input$country)

    output$time_series <- renderPlotly({

      ggplotly(mortality %>%
                 filter(country == input$country,
                        disease == input$disease) %>%
                 ggplot(aes(x = year, y = `mortality_rate`)) +
                 geom_line(color = "red") +
                 geom_point(color = "red") +
                 theme_bw() +
                 labs(x = "Year", y = "Mortality Rate (Percentage)") +
                 theme(axis.text.x = element_text(angle = 50, vjust = 1, hjust = 1))
      )

    })

  })


  # Ranking Table
  observe({
    req(input$country, input$year)

    output$ranking <- renderText({

      mortality %>%
        filter(country == input$country,
               year == input$year) %>%
        group_by(disease) %>%
        summarise(Mortality_rate = mean(`mortality_rate`), .groups = "drop") %>%
        arrange(-Mortality_rate) %>%
        select(-Mortality_rate) %>%
        mutate(Rank = paste0(1:21,".")) %>%
        relocate(disease, .after = Rank) %>%
        head(10) %>%
        kable() %>%
        kable_styling(bootstrap_options = c("striped", "hover"), full_width = FALSE)

    })

  })

  # Bar Plot
  observe({
    req(input$continent)

    output$barplot <- renderPlot({

      mortality %>%
        filter(continent == input$continent,
               year == 2019) %>%
        group_by(disease) %>%
        summarise(Mortality_rate = mean(`mortality_rate`), .groups = "drop") %>%
        arrange(-Mortality_rate) %>%
        ggplot(aes(x = reorder(Disease, Mortality_rate), y = `Mortality_rate`)) +
        geom_bar(stat = "identity", fill = "red") +
        theme_bw() +
        labs(x = "", y = "Mortality Rate (Percentage)") +
        theme(axis.text = element_text(size = 15)) +
        coord_flip()

    })

  })

  # About
  output$about <- renderUI({

    knitr::knit("about.Rmd", quiet = TRUE) %>%
      markdown::markdownToHTML(fragment.only = TRUE) %>%
      HTML()

  })

}

shinyApp(ui, server)
