getAndParse <- function(url, path, nameVector) {
  # Downloads and parses a single list
  # with elements of the same type
  
  # Assings names to the columns of the resulting data.frame 
  # to the ones passed through nameVector
  
  # Used for downloading locations and
  # allergens
  
  data <- get_JSON(url, path)
  data <- data.frame(matrix(unlist(data), nrow=length(data), byrow=T), stringsAsFactors = FALSE)
  names(data) <- nameVector
  
  data
}



parseConcentrations <- function(concentrationList) {
  # Parses the concentration list JSONs
  
  data <- lapply(concentrationList$results, unlist)
  data <- bind_rows(lapply(data, as.data.frame.list))
  
  return(data)
}


parseConcentration <- function(concentration) {
  # Parses a single concentration object
  # Example parseConcentration(get_JSON("http://polen.sepa.gov.rs/api/opendata/concentrations/1/"))
  
  result <- data.frame(id = concentration$id, allergen = concentration$allergen, value = concentration$value, pollen = concentration$pollen )
  result
}

parsePollen <- function(pollenList){
  # Parses the pollen JSONs
  
  pollendf <- data.frame(id = integer(), location = integer(), date = as.Date(character() ), concentration = integer() )
  
  if(length(pollenList$results) == 0)
  {
    pollendf
  }
  else
  {
    for(i in 1:length(pollenList$results) ){
      element <- pollenList$results[[i]]
      
      id <- element$id
      location <- element$location
      date <- as.Date(element$date)
      
      if(length(element$concentrations) == 0){
        next
      }
      
      for(j in 1:length(element$concentrations) ){
        pollendf[nrow(pollendf) + 1,] <- list(id, location, date, element$concentrations[[j]])
      }
      
    }
    names(pollendf) <- c("id", "location", "date", "concentration_id")
    
    pollendf
  }
  
}


