source("ReadData.R")
source("get_JSON.R")
parsePage <- function(url, paths, parse)
{
  # Downloads and parses one or multiple pages
  # with the passed parse function and returns them
  # as a data.frame
  # paths can be a vector
  
  data <- lapply(paths, get_JSON, url = url)
  result <- lapply(data, parse)
  
  df <- do.call("rbind", result)
  
  df
}

getData <- function() {
  # Downloads all the data about the measured concentrations of pollen
  # and joins them toghether into one data.frame
  
  header <- read_json("http://polen.sepa.gov.rs/api/opendata/pollens/")
  count <- header$count
  
  pollens <- parsePage(paste("http://polen.sepa.gov.rs/api/opendata/pollens/", 1:count), parsePollen)
  
  joinData(pollens)
}

downloadData <- function(){
  # Download and write the data into a file
  # Returns the downloaded data
  
  pollenDF <- getData()
  write.csv(pollenDF, file.path("WebApp", "data", "pollens.csv") )
  
  pollenDF
}