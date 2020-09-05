library("shiny")
library("jsonlite")
library("leaflet")
library("dplyr")
library("RColorBrewer")
library("httr")
source("joinData.R")

path <- paste("/api/opendata/pollens/?date_after=", "2019-01-01", "&date_before=", "2019-01-02", sep = "")

pollendf <- parsePage("http://polen.sepa.gov.rs/", path, parsePollen)

start_date <- as.Date("2016-02-01")
end_date <- as.Date("2020-08-01")
date <- start_date

while(date <= end_date)
{
  path <- paste("/api/opendata/pollens/?date_after=", as.character(as.Date(date)), "&date_before=", as.character(as.Date(date)), sep = "")
  pollendf <- rbind(pollendf, parsePage("http://polen.sepa.gov.rs/", path, parsePollen))
  date <- date + 1
}

joined_df <- joinData(pollendf)