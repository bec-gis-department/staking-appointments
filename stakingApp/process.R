library(tidyverse)
library(ggmap)
library(DT)
library(knitr)
#Load CSV data in Dataframe
#You'll have to update this path to wherever the Sample Data lives in your environment
df = read.csv("C:/Dev/Staking Isochrone/staking-appointments/Sample/sample_data.csv", header=TRUE, sep=",")

#Ensure the lat & lon are Numeric Values
df$Latitude <- as.numeric(df$Latitude)
df$Longitude <- as.numeric(df$Longitude)
#Call other Attribute Information for the Popups

#Generate RDS file for fast mapping
saveRDS(df, "C:/Dev/Staking Isochrone/staking-appointments/stakingApp/staking_data.rds")




