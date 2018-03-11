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

##combine the date and time fields into a datetime field 

house_power_set$datetime <- as.Date(house_power_set$Date)

house_power_set$datetime <- update(house_power_set$datetime, 
                                   hour = hour(house_power_set$Time),  
                                   minute = minute(house_power_set$Time),  
                                   second = second(house_power_set$Time), 
                                   tz = "US/Eastern")
## setup 4 frames for the diagrams 
par(fig = c(0,0.8,0,0.8), mar = c(5,5,2,1), font = 1, family = "sans", mfrow = c(2,2))

## Print the first plot 
with(house_power_set, plot(Global_active_power~datetime, xlab = "", 
                           ylab = "Global Active Power", type = 'l'))

## Print the Second plot 
with(house_power_set, plot(Voltage~datetime, xlab = "datetime", 
                           ylab = "Voltage", type = 'l'))

## Print the third plot 
with(house_power_set, plot(Sub_metering_1~datetime, xlab = "", 
                           ylab = "Energy sub metering", 
                           type = 'S', 
                           col = "grey"))
## Add 2nd variable to the third plot 
with(house_power_set, points(Sub_metering_2~datetime,col="red", type = 'S'))

## Add 3nd variable to the third plot 
with(house_power_set, points(Sub_metering_3~datetime,col="blue", type = 'S'))

##add a legend to the third plot, reduce font size to fit neatly 
legend("topright", lwd = 1, col = c("grey", "red", "blue"), 
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), cex = 0.5)

##print the fourth plot 
with(house_power_set, plot(Global_reactive_power~datetime, xlab = "datetime", 
                           ylab = "Global_reactive_power", type = 'l'))

##copy the diagram into a png file 
dev.copy(png , ".\\ExData_Plotting1\\plot4.png")

dev.off()

