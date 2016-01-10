library(RCurl)
library(dplyr)
library(data.table)

URL<-"https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
temp <- tempfile()#designate a temporaryfile location
download.file(URL,temp, mode="wb")
list.files <- unzip(temp,list=TRUE)
placeholder<-unz(temp,"household_power_consumption.txt")
data = read.table("household_power_consumption.txt", header=TRUE, sep=";", stringsAsFactors=FALSE, dec=".")
unlink(temp)
ssdata <- data[data$Date %in% c("1/2/2007","2/2/2007") ,]
ssdata$Global_active_power <- as.numeric(as.character(ssdata$Global_active_power))

ssdata$Global_reactive_power <- as.numeric(as.character(ssdata$Global_reactive_power))

ssdata$Sub_metering_1 <- as.numeric(as.character(ssdata$Sub_metering_1))
ssdata$Sub_metering_2 <- as.numeric(as.character(ssdata$Sub_metering_2))
ssdata$Sub_metering_3 <- as.numeric(as.character(ssdata$Sub_metering_3))

ssdata$Voltage <- as.numeric(as.character(ssdata$Voltage))

#Creates new column that combines date and time data 
ssdata$Timestamp <-paste(ssdata$Date, ssdata$Time)
plot(strptime(ssdata$Timestamp, "%d/%m/%Y %H:%M:%S"), ssdata$Global_active_power, type = "l", xlab = "", ylab = "Global Active Power(kilowatts)")
dev.copy(png, file="plot2.png", height=480, width=480)
dev.off()