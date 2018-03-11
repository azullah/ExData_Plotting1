library(dplyr)
library(graphics)
library(grDevices)
library(lubridate)
## create data directory and download and unzip the data  
if (!file.exists('household_power_consumption')) {
        dir.create('household_power_consumption')
        ## Download the zip file and unzip into "household_power_consumption" folder        
        download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip", 
                      '.\\household_power_consumption\\household_power_consumption.zip')
        unzip('.\\household_power_consumption\\household_power_consumption.zip')
}

## read the input data into R 
house_power <- read.table(file = ".\\household_power_consumption\\household_power_consumption.txt", 
                          sep = ";", header = TRUE, na.strings = "?")

## Convert the date and time strings to R format 
house_power$Date = dmy(house_power$Date)

house_power$Time = hms(house_power$Time)

## select a subset of the data and remove the large input dataset 
house_power_set <- subset(house_power, Date >= "2007-02-01" & Date <= "2007-02-02")

rm(house_power)

## set the parameters for the figure 
par(fig = c(0,1,0,1), mar = c(5,5,3,2))

##combine the date and time fields into a datetime field 
house_power_set$datetime <- as.Date(house_power_set$Date)

house_power_set$datetime <- update(house_power_set$datetime, 
                                   hour = hour(house_power_set$Time),  
                                   minute = minute(house_power_set$Time),  
                                   second = second(house_power_set$Time), 
                                   tz = "US/Eastern")
## draw the figure 
with(house_power_set, plot(Global_active_power~datetime, xlab = "", 
                           ylab = "Global Active Power (Killowatts)", 
                           type = 'l'), cex = 1.5, font.lab = 2)
## copy the diagram to a png file 
dev.copy(png , ".\\ExData_Plotting1\\plot2.png")

dev.off()