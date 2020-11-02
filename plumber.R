library(caret)
library(xgboost)
library(plumber)
library(tidyverse)
library(magrittr)

model <- readRDS(file = "fit.xgbDART.rds")

#* @param value:numeric
#* @param Min_dew:numeric
#* @param Avg__humidity:numeric
#* @param Min_wind:numeric
#* @param Max_pressure:numeric
#* @param PRCP:numeric
#* @param delta_dew:numeric
#* @param delta_humid:numeric
#* @param delta_pressure:numeric
#* @param delta_wind:numeric
#* @param day_serial:numeric
#* @post /predict
function(value, Min_dew, Avg__humidity, Min_wind, Max_pressure, 
                                PRCP, delta_dew, delta_humid, delta_pressure, delta_wind, 
                                day_serial){
  
  value %<>% as.numeric
  Min_dew %<>% as.numeric
  Avg__humidity %<>% as.numeric
  Min_wind %<>% as.numeric
  Max_pressure %<>% as.numeric
  PRCP %<>% as.numeric
  delta_dew %<>% as.numeric
  delta_humid %<>% as.numeric
  delta_pressure %<>% as.numeric
  delta_wind %<>% as.numeric
  day_serial %<>% as.numeric
  
  X.new <<- tibble(value = value, Min_dew = Min_dew, Avg__humidity = Avg__humidity,
                  Min_wind = Min_wind, Max_pressure = Max_pressure, PRCP = PRCP,
                  delta_dew = delta_dew, delta_humid = delta_humid, delta_pressure = delta_pressure,
                  delta_wind = delta_wind, day_serial = day_serial)

  y.pred <<- predict(model, X.new)
  
  return(list(prediction=y.pred))
}