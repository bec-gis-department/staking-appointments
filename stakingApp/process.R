library(reshape)
library(tidyverse)
library(dplyr)
library(ggmap)
library(DT)
library(knitr)
#Load CSV data in Dataframe
#You'll have to update this path to wherever the Sample Data lives in your environment
df = read.csv("C:/Dev/Staking Isochrone/staking-appointments/Sample/staking_data.csv", header=TRUE, sep=",")
head(df)

#-----------------------------------------------------------------
#Ensure the lat & lon are Numeric Values
#Toss the NULLS
df$Latitude <- as.numeric(df$latitude)
df$Longitude <- as.numeric(df$longitude)

todays_Apps <- filter(df, df$day_class == "Today")

head(todays_Apps)

x <- todays_Apps %>%
  select(jobnumber, staker, appointmenttime)
  group_by(staker, appointmenttime)
  summarise(appointmenttime = first(appointmenttime))

x %>%
  spread(appointmenttime, jobnumber)

#Generate RDS file for fast mapping
saveRDS(df, "C:/Dev/Staking Isochrone/staking-appointments/stakingApp/staking_data.rds")
saveRDS(basic_summ, "C:/Dev/Staking Isochrone/staking-appointments/stakingApp/apt_table.rds")







