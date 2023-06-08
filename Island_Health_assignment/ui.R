library(shiny)
library(shinydashboard)

# Define UI
ui <- dashboardPage(
  dashboardHeader(
    title = "Data Analyst Assignment"
  ),
  dashboardSidebar(sidebarMenu(
    menuItem("Treatment", tabName = "page1"),
    menuItem("Hospitals", tabName = "page2"),
    menuItem("Candidat info", tabName = "infopage")
  )),
  dashboardBody(
    includeCSS("fix.css"),
    tabItems(tabItem(
      tabName = "page1",
      h2("Treatment Overview"),
      fluidRow(
        column(
         width = 4,
          valueBoxOutput("patient_count_box")
        ),
        column(
         width = 4,
          valueBoxOutput("median_by_hospital_box")
        ),
        column(
          width = 4,
          valueBoxOutput("median_by_disease_box")
        )
      ),
      fluidRow(
        column(
          width = 2,
          selectInput("disease_filter", "Disease", choices = NULL),
          selectInput("hospital_filter", "Hospital", choices = NULL),
          selectInput("age_group_filter", "Age Group", choices = NULL),
          selectInput("floor_filter", "Floor", choices = NULL),
          selectInput("result_filter", "Result", choices = NULL)
        ),
        column(width = 5,
               plotOutput("treatment_plot")),
        column(width = 5,
               plotOutput("treatment_100_plot"))
      )
    ),
    tabItem(
      tabName = "page2",
      h2("Hospitals Overview"),
      fluidRow(
        column(
          width = 3,
          selectInput("disease", "Disease", choices = NULL),
          selectInput("hospital", "Hospital", choices = NULL),
          selectInput("age_group", "Age Group", choices = NULL),
          selectInput("floor", "Floor", choices = NULL),
          selectInput("result", "Result", choices = NULL)
        ),
        column(width = 9,
               plotOutput("plot"))
      ),
      
      fluidRow(column(
        width = 12,
        h4("Note:"),
        p(
          "Considering that the 2nd and 4th floors experience higher traffic and activity levels, it is important to factor this into future shift planning and explore the potential for increasing the frequency of cleaning. By doing so, you can ensure that these floors receive adequate attention and maintenance to meet the higher demand and maintain cleanliness standards."
        ),
        p(
          "On all floors within the same hospital, there is a consistent proportion of negative results. This indicates that sanitation standards are likely being maintained, as any deviations would result in a higher proportion of negative results on a specific floor. It is important to focus on hospitals where the proportion of negative results exceeds 80% on a particular floor."
        ),
        p(
          "For instance, at",
          HTML("<b>Goldvalley Medical Clinic</b>"),
          ", when treating ",
          HTML("<b>MRSA</b>"),
          ", the 3rd floor exhibits ",
          HTML("<b>a 82% proportion of negative results</b>"),
          ", while the remaining floors range from 58% to 75% in terms of negative results. This suggests the need for further investigation and potential improvement measures on those specific floors to ensure optimal treatment outcomes."
        )
      ))
    ),
    
    tabItem(tabName = "infopage",
            h2("Candidat info"),
            fluidRow(
              column(
                width = 12,
                style = "text-align: center;",
                h2("Alina Tkachenko"),
                tags$p("Location: Victoria, BC"),
                tags$p("Phone: 📞 250-986-4946"),
                tags$p("Email: 📧 alina.tkachenko.ca@gmail.com"),
                tags$p(tags$a("GitHub", href = "https://github.com/AlineCrawf")),
                tags$p(
                  tags$a("GitHub project repo", href = "https://github.com/AlineCrawf/Island_health_assignment")
                ),
                tags$p(
                  tags$a("LinkedIn", href = "https://www.linkedin.com/in/alina-tkachenko-ca")
                )
              )
            ))
  )
)
)
