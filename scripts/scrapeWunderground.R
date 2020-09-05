library(rvest)
library(dplyr)
require(RSelenium)

scrape_month <- function (month, remDr) {

  paste("http://www.wunderground.com/history/monthly/LYBE/date/", month, sep="") %>% remDr$navigate()
  
  Sys.sleep(10)
  webElem <- remDr$findElement(using = 'css selector', "table.days")
  
  outer_table <- webElem$getElementAttribute('outerHTML')[[1]] %>% html
  table_nodes <- html_nodes(outer_table, 'tr')
  table_nodes <- html_nodes(table_nodes[[2]], 'table')
  
  dates <- html_table(table_nodes[[1]], header = TRUE)
  names(dates) <- c("day")
  dates <- dates %>%
    mutate(date = as.Date(paste(month, day, sep="-"))) %>% 
    select(date)
  
  temp <- html_table(table_nodes[[2]], header = TRUE)
  names(temp) <- paste(names(temp), "temp", sep="_")
  dew <- html_table(table_nodes[[3]], header = TRUE)
  names(dew) <- paste(names(dew), "dew", sep="_")
  
  humidity <- html_table(table_nodes[[4]], header = TRUE)
  names(humidity) <- paste(names(humidity), "_humidity", sep="_")
  
  wind <- html_table(table_nodes[[5]], header = TRUE)
  names(wind) <- paste(names(wind), "wind", sep="_")
  
  pressure <- html_table(table_nodes[[6]], header = TRUE)
  names(pressure) <- paste(names(pressure), "pressure", sep="_")
  
  percipitation <- html_table(table_nodes[[7]], header = TRUE)
  names(percipitation) <- paste(names(percipitation), "percipitation", sep="_")
  
  df <- cbind(dates, temp, dew, humidity, wind, pressure, percipitation)
  
  df
}

remDr <- remoteDriver(remoteServerAddr = "localhost"
                      , port = 4444
                      , browserName = "firefox"
)
remDr$open()
months <- read.csv("months.csv")
weather_df <- lapply(months$month, scrape_month, remDr=remDr)

df_wtr <- do.call("rbind", weather_df)
write.csv(df_wtr, "wunderground.csv")
