library(DT)
library(shiny)
library(leaflet)
library(dplyr)
library(shinydashboard)
library(shinythemes)
library(shinyalert)
library(shinyWidgets)
library(osrm)
library(rgdal)
library(sp)
library(sf)
library(viridis)
library(data.table)
library(reshape)
library(tidyverse)
library(ggmap)
library(knitr)
library(data.table)
library(chron)

#Load CSV data in Dataframe
#You'll have to update this path to wherever the Sample Data lives in your environment
df = read.csv("C:/Dev/Staking Isochrone/staking-appointments/Data/staking_data.csv", header=TRUE, sep=",") #C:\Dev\Staking Isochrone\bkm24-main\staking-appointments\Sample

#-----------------------------------------------------------------
#Ensure the lat & lon are Numeric Values
#Toss the NULLS
df$latitude <- as.numeric(df$latitude)
df$longitude <- as.numeric(df$longitude)

#-----------Here we format the Data Table-------------------
#Filter the main Staking Data Frame to only have Todays appointments
todays_Apps <- filter(df, df$day_class == "Today")
# Head shows us the DF in the console, it's a goodway to ensure the DF is formatted the way we want it

#This is somewhat on the right track but isn't working as needed
# The idea here is to say:
#   1) Hey I want todays appointments in a variable called X,
#   2) I Only want the Job Number, Staker Name and Appointment Time to come through
#   3) Group my data by Staker and Appointment Time
#   4) This pivot requires a data summary so I tell it just get the first Staking Time on the resolution I provided (Which won't change the format... just a seemingly reundant step)

# This should be pivoting the data but just isn't quite complete yet. so feel free to completely change this section up
x <- todays_Apps %>%
  select(jobnumber, staker, appointmenttime)
print("-----Data Frame Reduced------")
head(x)

#-----------------------------------------------
# Ordering the Appointment Times 
# John Lister - GIS Applications Developer

#Convert the values to a Time 
##appTime_conv <- chron(x$appointmenttime)

hourSubstr <- substr(x$appointmenttime, 0, 2)
hourSubstr <-gsub(":","", hourSubstr)

intHour <- as.numeric(hourSubstr)

orderVector <- sort(as.numeric(hourSubstr))

orderVector_STR <- unique(as.character(orderVector))

#Find Matching Hour 
##i <- match(substring(x$appointmenttime, 1, 1), orderVector_STR)
##o <- order(i)

#Melt Data
p <- melt(x, id.var = c("staker", "appointmenttime"))
print("-----Melting Dataset------")
head(p)

#DCAST Data to Data Table Format
sortedApps <- dcast(p, staker ~ appointmenttime, fun.aggregate = min, drop=FALSE, fill=NULL)
#sortedApps[timeCols]
#made a new table based off the output of the spread function so i can use this table to output the datatable in server.R
print("-----Data Table Formatted------")
head(sortedApps)
#----------------------------------------------------------

#Generate RDS file for fast mapping
saveRDS(df, "C:/Dev/Staking Isochrone/staking-appointments/stakingApp/staking_data.rds")
saveRDS(sortedApps, "C:/Dev/Staking Isochrone/staking-appointments/stakingApp/apt_table.rds")

data_file <- file.path(getwd(), "staking_data.rds")
pivottable <- file.path(getwd(), "apt_table.rds")
