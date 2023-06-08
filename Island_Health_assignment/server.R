library(shiny)
library(dplyr)
library(ggplot2)
library(DBI)
library(RSQLite)
library(gcookbook)

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
  
  hospital_data <- serverData
  treatment_data <- serverData
  
  observe({
    updateSelectInput(session, "disease", choices = c("All", unique(hospital_data$disease)))
    updateSelectInput(session, "hospital", choices = c("All", unique(hospital_data$hospital)))
    updateSelectInput(session, "age_group", choices = c("All", "0-3", "4-13", "14-17", "18-30", "31-40", "41-60", "60+"))
    updateSelectInput(session, "floor", choices = c("All", unique(hospital_data$floor)))
    updateSelectInput(session, "result", choices = c("All", unique(hospital_data$result)))
  })
  
  filteredData <- reactive({
    data <- hospital_data
    
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
  
  
  observe({
    updateSelectInput(session, "disease_filter", choices = c("All", unique(treatment_data$disease)))
    updateSelectInput(session, "hospital_filter", choices = c("All", unique(treatment_data$hospital)))
    updateSelectInput(session, "age_group_filter", choices = c("All", "0-3", "4-13", "14-17", "18-30", "31-40", "41-60", "60+"))
    updateSelectInput(session, "floor_filter", choices = c("All", unique(treatment_data$floor)))
    updateSelectInput(session, "result_filter", choices = c("All", unique(treatment_data$result)))
  })
  
  filteredData2 <- reactive({
    data2 <- treatment_data
    
    if (input$disease_filter != "All")
      data2<- data2[data2$disease == input$disease_filter, ]
    
    if (input$hospital_filter != "All")
      data2 <- data2[data2$hospital == input$hospital_filter, ]
    
    if (input$age_group_filter != "All")
      data2 <- data2[data2$age_group == input$age_group_filter, ]
    
    if (input$floor_filter != "All")
      data2 <- data2[data2$floor == input$floor_filter, ]
    
    if (input$result_filter != "All")
      data2 <- data2[data2$result == input$result_filter, ]
    
    data2
  })
  
  output$treatment_plot <- renderPlot({
    if (nrow(filteredData2()) == 0) {
      # Display an empty plot if no data is available
      plot(NULL, xlim = c(0, 1), ylim = c(0, 1),
           xlab = "Count", ylab = "Treatment",
           main = "Count of Unique Patients by Treatment")
    } else {
      df_count <- aggregate(patient_identifier ~ result + treatment, 
                            filteredData2(), FUN = function(x) length(unique(x)))
      df_count <- df_count %>%
                  arrange(desc(patient_identifier)) # Sort by max patients
      
      
      ggplot(df_count, aes(x = patient_identifier, y = treatment, fill = result)) +
        geom_col() +
        labs(title = "Count of Unique Patients by Treatment",
             x = "Treatment", y = "Count") +
        guides(fill = guide_legend(reverse = TRUE))
    }
  })
  
  output$treatment_100_plot <- renderPlot({
    if (nrow(filteredData2()) == 0) {
      # Display an empty plot if no data is available
      plot(NULL, xlim = c(0, 1), ylim = c(0, 1),
           xlab = "Treatment", ylab = "Percentage",
           main = "Percentage of Patients by Treatment")
    } else {
      df_count <- aggregate(patient_identifier ~ result + treatment, filteredData2(), FUN = function(x) length(unique(x)))
      
      df_count <- df_count %>%
        arrange(desc(patient_identifier))
      
      df_percent <- transform(df_count, percentage = patient_identifier / sum(patient_identifier) * 100)
      
      ggplot(df_percent, aes(x = treatment, y = percentage, fill = result)) +
        geom_bar(stat = "identity", position = "fill") +
        labs(title = "Percentage of Patients by Treatment",
             x = "Treatment", y = "Percentage") +
        theme(legend.position = "bottom") +
        coord_flip()
    }
  })
  
  output$patient_count_box <- renderValueBox({
    count <- length(unique(filteredData2()$patient_identifier))
    valueBox(count, "Count of Patients")
  })
  
  output$median_by_hospital_box <- renderValueBox({
    count_by_hospital <- aggregate(patient_identifier ~ hospital, filteredData2(),
                                   FUN = function(x) length(unique(x)))
    median_count <- median(count_by_hospital$patient_identifier, na.rm = TRUE)
    valueBox(median_count, "Median Count of Patients by Hospital")
  })
  
  output$median_by_disease_box <- renderValueBox({
    count_by_disease <- aggregate(patient_identifier ~ disease, filteredData2(), 
                                  FUN = function(x) length(unique(x)))
    median_count <- median(count_by_disease$patient_identifier, na.rm = TRUE)
    valueBox(median_count, "Median Count of Patients by Disease")
  })
  
}

#shinyApp(ui, server)
