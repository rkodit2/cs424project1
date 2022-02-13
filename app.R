#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#


setwd("C:/College/CS 424 visualization and Visual Analytics/project1/cs424project1")
cityTable <- read.table(file = "CTA_-_Ridership_-__L__Station_Entries_-_Daily_Totals.tsv", sep = "\t", header = TRUE, quote = "\"")

uicHalsted <- subset(cityTable, stationname == "UIC-Halsted")
write.csv(uicHalsted,"uicHalstedData.csv", row.names = FALSE)
uicHalstedcsv <- read.csv("uicHalstedData.csv", header = TRUE)

ohare <- subset(cityTable, stationname == "O'Hare Airport")
rosemont <- subset(cityTable, stationname == "Rosemont")

library(lubridate)
uicHalstedcsv$newDate <- mdy(uicHalstedcsv$date)

#install.packages("ggplot2")
library(ggplot2)

uicHalstedcsv$year <- year(uicHalstedcsv$newDate)

#bar chart for uic halsted years and rides
chart1 <- ggplot(data=uicHalstedcsv, aes(x=year, y=rides)) + geom_bar(stat="identity" , color ="green" , width = .8) + ggtitle("UIC Halsted rides every year")



#bar chart for uic halsted everyday in 2021
uicHalsted2021 <- subset(uicHalstedcsv, year == "2021")
chart2 <- ggplot(data=uicHalsted2021, aes(x=newDate, y=rides)) + geom_bar(stat="identity" , color ="green")+ ggtitle("UIC Halsted rides in year 2021")

#bar chart for uic halsted every month in 2021
uicHalsted2021$month <- month(uicHalsted2021$newDate)
chart3 <- ggplot(data=uicHalsted2021, aes(x=month, y=rides)) + geom_bar(stat="identity" , color ="green")+ ggtitle("UIC Halsted rides each month in 2021")

#bar char for uic halsted every week day in 2021
uicHalsted2021$weekday <- wday(uicHalsted2021$newDate)
chart4 <- ggplot(data=uicHalsted2021, aes(x=weekday, y=rides)) + geom_bar(stat="identity" , color ="green")+ ggtitle("UIC Halsted rides every weekday in 2021")

library(shiny)
library(shinydashboard)

years<-c(2001:2021)

ui <- dashboardPage(
    dashboardHeader(),
    dashboardSidebar(),
    dashboardBody(
        fluidRow(
            selectInput("Year", "Select Year", years, selected = 2021),
            box(plotOutput("chart1", height = 500)),
            box(plotOutput("chart2", height = 500)),
            box(plotOutput("chart3", height = 500)),
            box(plotOutput("chart4", height = 500))
        )
    )
)

server <- function(input, output) {
    justOneYearReactive <- reactive({subset(uicHalstedcsv, year(uicHalstedcsv$newDate) == input$Year)})
    #  output$chart1 <- renderPlot({
    #    justOneYear <- justOneYearReactive()
    #ggplot(justOneYear, aes(x=newDate, color=justOneYear[,input$Room], y=Hour))
    #    ggplot(justOneYear, aes(x=newDate, y=justOneYear[,input$rides])) + geom_bar(color ="green" , width = .8) + ggtitle("UIC Halsted rides every year")
    
    #  })
    output$chart1 <- renderPlot(chart1)
    output$chart2 <- renderPlot(chart2)
    output$chart3 <- renderPlot(chart3)
    output$chart4 <- renderPlot(chart4)
    
}

shinyApp(ui = ui, server = server)