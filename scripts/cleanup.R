library(tidyverse)

df <- read_csv("pollenData.csv")
df <- df %>% select(-c("X1", "id", "localized_name"))

df <- df %>% spread(allergen_name, value)
df[is.na(df)] <- 0

write.csv(df, "pollenDataWide.csv")