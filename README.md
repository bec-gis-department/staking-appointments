# Staking Appointment Analysis

An interactive mapping application created in Rstudio, using Shiny, Leaflet, and OSRM. 

This product provides a spatial/temporal look of New Service Staking Appointments as well as OSRM Drive-time-Isochrone functionality.

For my people outside of my organization, this product is super tailored to our industry but maybe some source code could prove useful for you and your endeavors!

## What do we need?

Use R console with Rtools & and the Install Packages [command](https://www.r-bloggers.com/installing-r-packages/) to install the following:

```bash
install.packages('shiny')
install.packages('leaflet')
install.packages('dplyr')
install.packages('shinythemes')
install.packages('shinyalert')
install.packages('osrm')
install.packages('rgdal')
install.packages('sp')
install.packages('sf')
install.packages('viridis')
install.packages('tidyverse')
install.packages('ggmap')
install.packages('DT')
install.packages('knitr')
```

Check you have them in the R console like so:
```bash
library(shiny)
library(leaflet)
library(dplyr)
library(shinythemes)
library(shinyalert)
library(osrm)
library(rgdal)
library(sp)
library(sf)
library(viridis)
library(tidyverse)
library(ggmap)
library(DT)
library(knitr)

```
## Teams & Branches

This is a pretty small scale project, so if you find yourself assigned to a team pay attention to this!

**Teams**
* User Interface (UI)
    * The look and feel, anything aesthetic or layout related
* Application backend (R-Server)
    * The R coding that powers the application "The Javascript of the HTML"
* Data Source backend (GIS-Dev)
    * The Pythonic GIS for processing the staking data (There probably won't be a branch for this unless folks ask me tos hare the source code)

**Okay great but what does that mean?**

You'll be assigned to a team, your team abbreviation acts as the "extension" to your branch, your branch is a combination of your Username and Extension. So for ole-Mr. Me, I have a few branches:

* GISJohnECS-UI 
* GISJohnECS-R-Server
* GISJohnECS-GIS-Dev

**So what do I do?**

Your FIRST-PULL-EVER will be from the master branch! 

* Whenever you work on the User Interface, you'll push/pull those to/from *Username*-*UI*. 
* When you add functionality, you'll push/pull those to/from *Username*-*R-Server* 

## Contributing
* Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

* **Members of the Bluebonnet Electric Organization, Pull and Push from/to branches assigned to 
YOU ONLY!!** 

* Keep your global.R and process.R files on hand, they won't be available in the master branch due to local development path issues

* **Documentation Nation:**
   * If you don't add good descriptive comments and summaries to your Commits, I'm going to reject them
   * If you don't add in code documentation to your code, I'm going to delete it... talk to me, tell me what you were doing and WHY

  
```bash
    ## This is your brain as you develop:

    ##Generate Map display
    # I want to use our custom mapbox style
    #Token: *HAHA I'm not showing you my token*
    #Style ID: Swaggalishes
    #mapbox://styles/Not/Gonna/Happen
    #Found this example at https://rstudio.github.io/leaflet/choropleths.html:
    "
    addProviderTiles('MapBox', options = providerTileOptions(
    id = 'mapbox.light',
    accessToken = Sys.getenv('MAPBOX_ACCESS_TOKEN')))
    "
    output$map <- renderLeaflet({
        leaflet() %>%
            setView(-97.285944, 30.104740, 10) %>%
            addProviderTiles(providers$OpenStreetMap.BlackAndWhite)
    })

## Document your functions folks
        ########################################################
        # Name: getSize
        # Description: Read the day classification attribute and produce a Marker size variable
        # Created: 06/03/2019
        # Author: John R Lister - GIS Applications Developer
        getSize <- function(day_class) {
            sapply(df$day_class, function(type_) {
                if(type_ == 'Today') {
                    14
                } else if(type_ == 'Next Business Day') {
                    11
                } else if(type_ == '2 Business Days') {
                    9  
                } else if(type_ == '3 Business Days') {
                    7  
                } else if(type_ == '4 Business Days') {
                    6 
                } else if(type_ == '5 Business Days') {
                    4  
                } else if(type_ == 'More than 5 business days') {
                    2  
                }else {
                    2
                } })
        }

```

* Project admins have locked down access to the master branch, any attempts to push and pull directly from there without authorization from the Administrators will be denied/removed.

* Play nicely- rudeness, obscenities and general misconduct will result in the **BAN-HAMMER** coming into effect.

Please make sure to update tests as appropriate, do not push any network specific information, these requests will be deleted if there is any information deemed sensitive. Contact GISJohnECS@gmail.com for more questions on what we deem as sensitive.

## License
[MIT](https://choosealicense.com/licenses/mit/)
