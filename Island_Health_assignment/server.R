library(shiny)
library(ggplot2)
library(DBI)
library(RSQLite)

get_sqlite_data <- function() {
  con <- dbConnect(RSQLite::SQLite(), "data/infection.db")
  query <- paste(readLines("sql_queries/all_diseases.sql"), collapse = " ")
  data <- dbGetQuery(con, query)
  dbDisconnect(con)
  return(data)
}

server <- function(input, output, session) {
  serverData <- get_sqlite_data()
  
  # Convert 'age' column to numeric
  serverData$age <- as.numeric(as.character(serverData$age))
  
  # Create age_group column based on age
  serverData$age_group <- cut(serverData$age, breaks = c(0, 4, 14, 18, 31, 41, 61, Inf),
                              labels = c("0-3", "4-13", "14-17", "18-30", "31-40", "41-60", "60+"),
                              include.lowest = TRUE, right = FALSE)
  observe({
    updateSelectInput(session, "disease", choices = c("All", unique(serverData$disease)))
    updateSelectInput(session, "hospital", choices = c("All", unique(serverData$hospital)))
    updateSelectInput(session, "age_group", choices = c("All", "0-3", "4-13", "14-17", "18-30", "31-40", "41-60", "60+"))
    updateSelectInput(session, "floor", choices = c("All", unique(serverData$floor)))
    updateSelectInput(session, "result", choices = c("All", unique(serverData$result)))
  })
  
  filteredData <- reactive({
    data <- serverData
    
    if (input$disease != "All")
      data <- data[data$disease == input$disease, ]
    
    if (input$hospital != "All")
      data <- data[data$hospital == input$hospital, ]
    
    if (input$age_group != "All")
      data <- data[data$age_group == input$age_group, ]
    
    if (input$floor != "All")
      data <- data[data$floor == input$floor, ]
    
    if (input$result != "All")
      data <- data[data$result == input$result, ]
    
    data
  })
  
  output$plot <- renderPlot({
    if (nrow(filteredData()) == 0) {
      # Display an empty plot if no data is available
      plot(NULL, xlim = c(0, 1), ylim = c(0, 1),
           xlab = "Floor", ylab = "Count",
           main = "Count of Unique Patient Identifiers by Floor and Bed")
    } else {
      df_count <- aggregate(patient_identifier ~ floor + bed, filteredData(), FUN = function(x) length(unique(x)))
      
      ggplot(df_count, aes(x = floor, y = patient_identifier, fill = bed)) +
        geom_bar(stat = "identity", position = "dodge") +
        scale_fill_manual(values = c("#00395B","#006AA8", "#66A6CB", "#99C3DC", "#00acba")) +
        labs(title = "Count of Unique Patient Identifiers by Floor and Bed",
             x = "Floor", y = "Count", fill = "Bed")
    }
  })
}

#shinyApp(ui, server)
