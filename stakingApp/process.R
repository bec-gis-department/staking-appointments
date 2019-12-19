library(reshape)
library(tidyverse)
library(dplyr)
library(ggmap)
library(DT)
library(knitr)
#Load CSV data in Dataframe
#You'll have to update this path to wherever the Sample Data lives in your environment
df = read.csv("C:/Dev/staking-appointments/Sample/sample_data.csv", header=TRUE, sep=",")
#head(df)

#-----------------------------------------------------------------
#Ensure the lat & lon are Numeric Values
#Toss the NULLS
df$Latitude <- as.numeric(df$latitude)
df$Longitude <- as.numeric(df$longitude)

#-----------Here we format the Data Table-------------------
#Filter the main Staking Data Frame to only have Todays appointments
todays_Apps <- filter(df, df$day_class == "Today")
# Head shows us the DF in the console, it's a goodway to ensure the DF is formatted the way we want it
head(todays_Apps)

#This is somewhat on the right track but isn't working as needed
# The idea here is to say:
#   1) Hey I want todays appointments in a variable called X,
#   2) I Only want the Job Number, Staker Name and Appointment Time to come through
#   3) Group my data by Staker and Appointment Time
#   4) This pivot requires a data summary so I tell it just get the first Staking Time on the resolution I provided (Which won't change the format... just a seemingly reundant step)

# This should be pivoting the data but just isn't quite complete yet. so feel free to completely change this section up
x <- todays_Apps %>%
  select(jobnumber, staker, appointmenttime)
group_by(staker, appointmenttime)
summarise(appointmenttime = first(appointmenttime))
#made a new table based off the output of the spread function so i can use this table to output the datatable in server.R
#the app now correctly displays the pivottable 
sorted_Apps <- x %>%
  spread(appointmenttime, jobnumber)

#Use head(sorted_Apps) to preview data
head(sorted_Apps)
#----------------------------------------------------------

#Generate RDS file for fast mapping
saveRDS(df, "C:/Dev/staking-appointments/stakingApp/staking_data.rds")
saveRDS(x, "C:/Dev/staking-appointments/stakingApp/apt_table.rds")






