library(shiny)
library(shinydashboard)

# Define UI
ui <- dashboardPage(
  dashboardHeader(
    title = "Island Health",
    tags$li(
      class = "dropdown",
      style = "float: left;",
      tags$img(src = "data:image/png;base64,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", height = "50px")
    )
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
        column(width = 6,
               plotOutput("treatment_plot")),
        column(width = 4,
               plotOutput("treatment_100_plot"))
      ),
      
      fluidRow(column(
        width = 12,
        h4("Note:"),
        p(
          "Considering the effectiveness of different treatments is crucial in providing optimal care for patients. By analyzing the treatment outcomes based on various factors such as disease, hospital, age group, floor, and result, healthcare providers can make informed decisions to improve treatment strategies and patient outcomes."
        ),
        p(
          "It is important to assess the effectiveness of treatments on different floors within the same hospital. Identifying any discrepancies in treatment outcomes can help pinpoint areas that require further attention and improvement."
        ),
        p(
          "For example, when treating",
          HTML("<b>MRSA</b>"),
          "at",
          HTML("<b>Goldvalley Medical Clinic</b>"),
          ", the 3rd floor shows",
          HTML("<b>an 82% proportion of negative results</b>"),
          ", while the remaining floors range from 58% to 75%. This suggests the need for further investigation and potential improvement measures on those specific floors to ensure optimal treatment outcomes."
        )
      ))
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
