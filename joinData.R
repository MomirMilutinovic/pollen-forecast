source("getData.R")
joinData <- function(pollens){
  # Joins all tables from the API with
  # an api/opendata/pollens table
  # and returns the resulting data.frame
  
  locations <- getAndParse("http://polen.sepa.gov.rs", "/api/opendata/locations/",
                           c("id", "location_name", "lat", "long", "desc") )
  allergens <- getAndParse("http://polen.sepa.gov.rs", "/api/opendata/allergens/",
                           c("id", "allergen_name", "localized_name", "margine_top", "margine_bottom", "type", 
                             "allergenitcity", "allergenitcity_display") )
  
  if(nrow(pollens) == 0)
  {
    return(pollens)
  }
  
  pagesToParse <- paste("/api/opendata/concentrations/?pollen=", unique(pollens$id) ,sep = "")
  
  concentrations <- parsePage("http://polen.sepa.gov.rs", pagesToParse, parseConcentrations)
  
  pollen_location <- merge(pollens, locations, by.x = "location", by.y="id")
  concentration_allergen <- merge(concentrations, allergens, by.x = "allergen", by.y="id")
  
  pollendf <- merge(pollen_location, concentration_allergen, by.x = "concentration_id", by.y="id")
  
  pollendf$lat <- as.numeric(as.character(pollendf$lat) )
  pollendf$long <- as.numeric(as.numeric(pollendf$long) )
  
  #Delete unnecessary columns
  pollendf <- subset(pollendf, select = -c(concentration_id, location, desc, allergen, margine_top, margine_bottom, type, pollen, allergenitcity, allergenitcity_display) )
  return(pollendf)
  
}
