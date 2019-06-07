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
#Ensure the lat & lon are Numeric Values
df$Latitude <- as.numeric(df$Latitude)
df$Longitude <- as.numeric(df$Longitude)
#Call other Attribute Information for the Popups

#Construct The Appointment Table for Stakers

# 1: filter to keep three states.  
basic_summ = filter(df, business_days == 0)

# 2: set up data frame for by-group processing.  
basic_summ = group_by(basic_summ, staker, appointmenttime)

# 3: calculate summary metrics
basic_summ = summarise(basic_summ, 
                       jobnumber = first(jobnumber))

basic_summ <- cast(basic_summ, staker~appointmenttime, first, value = 'jobnumber')



#Generate RDS file for fast mapping
saveRDS(df, "C:/Dev/Staking Isochrone/staking-appointments/stakingApp/staking_data.rds")
saveRDS(basic_summ, "C:/Dev/Staking Isochrone/staking-appointments/stakingApp/apt_table.rds")







