get_JSON <- function(url, path)
{
  raw.result <- GET(url = url, path = path)
  this.raw.content <- rawToChar(raw.result$content)
  nchar(this.raw.content)
  this.content <- parse_json(this.raw.content)
  return(this.content)
}