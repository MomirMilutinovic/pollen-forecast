getHTMLTable <- function(pollendf, longitude, lattitude)
{
   location_set <- pollendf %>% filter(long == longitude, lat == lattitude)
   
   result <- "<div class='leaflet-popup-scrolled' style='max-width:600px;max-height:100px'>"
   
   result <- paste(result, "<table class = \"table\">", "<tr><td>", "Location: ", "</td>",
                   "<td>", location_set$location_name[1], "</td></tr>", "</table>", collapse = "", sep = "")
   
   result <- paste(result, "<table class = \"table\"><tr><th> Allergen </th> <th> Concentration </th></tr>", sep = "")
   
     
   result <- paste(result, (paste("<tr><td>", 
         as.character(location_set$allergen_name), "</td>", 
         "<td>", location_set$value, "</td></tr>", collapse = '')))
   
   result <- paste(result, "</table>", sep = "")
   
   result <- paste(result, "</div>", sep = "")
   return(result)
}

getHTMLTables <- function(pollendf)
{
   result <- c()
   for(i in 1:nrow(pollendf))
   {
      result[i] <- getHTMLTable(pollendf, pollendf$long[i], pollendf$lat[i])
   }
   return(result)
}