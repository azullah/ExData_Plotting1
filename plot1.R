library(dplyr)
library(graphics)
library(grDevices)
library(lubridate)
## create directory and download file if not present
if (!file.exists('household_power_consumption')) {
        dir.create('household_power_consumption')
        ## Download the zip file and unzip into "household_power_consumption" folder        
        download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip", 
                      '.\\household_power_consumption\\household_power_consumption.zip')
        unzip('.\\household_power_consumption\\household_power_consumption.zip')
}

## read the input data 
house_power <- read.table(file = ".\\household_power_consumption\\household_power_consumption.txt", 
                          sep = ";", header = TRUE, na.strings = "?")
## Convert the strings date and Time 
house_power$Date = dmy(house_power$Date)

house_power$Time = hms(house_power$Time)

## select subset of the data and delete the large input file 

house_power_set <- subset(house_power, Date >= "2007-02-01" & Date <= "2007-02-02")

rm(house_power)

## set the figure parameters
par(fig = c(0,1,0,1), xaxp = c(0,6,3), xaxs = 'r', mar = c(5,5,3,2))

##draw the histogram 
hist(house_power_set$Global_active_power, freq = TRUE, main = "Global Active Power", 
     xlab = "Global Active Power (Kilowatts)", 
     ylab = "Frequency",col = "red", cex = 1.5, font.lab = 2)

## copy the diagram to a png file 
dev.copy(png , ".\\ExData_Plotting1\\plot1.png")

dev.off()
