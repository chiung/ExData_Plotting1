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
#Sets graphing parameters so that 4 graphs are drawn by column
par(mfcol = c(2,2))


# Creates graph of date/time vs global active power data
plot(strptime(ssdata$Timestamp, "%d/%m/%Y %H:%M:%S"), ssdata$Global_active_power, type = "l", 
     xlab = "", ylab = "Global Active Power(kilowatts)")


#Creates 2nd graph in column 1 
#Creates plot of date/time v Sub metering 1 data
plot(strptime(ssdata$Timestamp, "%d/%m/%Y %H:%M:%S"), ssdata$Sub_metering_1, type = "l", xlab = "", ylab = "Energy sub metering")

#Adds line graph for date/time v Sub metering 2 data in red
lines(strptime(ssdata$Timestamp, "%d/%m/%Y %H:%M:%S"), ssdata$Sub_metering_2, type = "l", col = "red" )

#Adds line graph for date/time v Sub metering 3 data in blue
lines(strptime(ssdata$Timestamp, "%d/%m/%Y %H:%M:%S"), ssdata$Sub_metering_3, type = "l", col = "blue" )

#Adds legend to graph
legend("topright", lty= 1, col = c("Black", "red", "blue"), legend = c( "Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))

#Creates first graph in column 2
#This graphs date/time v Voltage
plot(strptime(ssdata$Timestamp, "%d/%m/%Y %H:%M:%S"), ssdata$Voltage, type = "l", 
     xlab = "datetime", ylab = "Voltage")

#Creates second graph in column 2
#This plots datetime v global reactive power
plot(strptime(ssdata$Timestamp, "%d/%m/%Y %H:%M:%S"), ssdata$Global_reactive_power, type = "l", 
     xlab = "datetime", ylab = "Global_reactive_power")
dev.copy(png, file="plot4.png", height=480, width=960)
dev.off()
