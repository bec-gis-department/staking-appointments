library(tidyverse)
library(ggmap)
library(DT)
library(knitr)
#Load CSV data in Dataframe

#You'll have to update this path to wherever the Sample Data lives in your environment
df = read.csv("//BEC-HOME/Users/bmits002/My Documents/GitHub/staking-appointments/sample/sample_data.csv", header=TRUE, sep=",")

#Ensure the lat & lon are Numeric Values
df$Latitude <- as.numeric(df$Latitude)
df$Longitude <- as.numeric(df$Longitude)
#Call other Attribute Information for the Popups


#Generate RDS file for fast mapping
saveRDS(df, "//BEC-HOME/Users/bmits002/My Documents/GitHub/staking-appointments/stakingApp/staking_data.rds")




