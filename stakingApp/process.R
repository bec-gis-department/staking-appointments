library(reshape2)
library(tidyverse)
library(dplyr)
library(ggmap)
library(DT)
library(knitr)
library(data.table)
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
# 1) Hey I want todays appointments in a variable called X,
# 2) I Only want the Job Number, Staker Name and Appointment Time to come through
# 3) Group my data by Staker and Appointment Time
# 4) This pivot requires a data summary so I tell it just get the first Staking Time on the resolution I provided (Which won't change the format... just a seemingly reundant step)

# added in melt to breakdown the table to only these two variables
p <- melt(x, id.var = c("staker", "appointmenttime"))
head(p)
#sorted_Apps is created by cast, which puts staker as the row values and appointment time as the column values 
sorted_Apps <- dcast(p, staker ~ appointmenttime, fun.aggregate = mean, drop=FALSE, fill = NULL)

#Use head(sortedApps) to preview data
head(sorted_Apps)
#----------------------------------------------------------

#Generate RDS file for fast mapping
saveRDS(df, "C:/Dev/staking-appointments/stakingApp/staking_data.rds")
saveRDS(sorted_Apps, "C:/Dev/staking-appointments/stakingApp/apt_table.rds")






