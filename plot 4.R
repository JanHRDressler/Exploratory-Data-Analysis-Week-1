##create data folder in wd
dir.create("./data")

##download to data
download.file("https://archive.ics.uci.edu/ml/machine-learning-databases/00235/household_power_consumption.zip", "./data/data.zip")

##unzip to data
unzip("./data/data.zip",exdir = "./data")

##read rough range of dates
header = read.table("./data/household_power_consumption.txt", header=FALSE, skip=0, nrow = 1, sep =";")
data = read.table("./data/household_power_consumption.txt", header=FALSE, skip=66630, nrow = (69530-66630), sep =";")

##exclude the few wrong rows that were intentionally read to miss none of the right ones and combine with header
rows = which(data[,1]== "1/2/2007")
rows2 = which(data[,1]== "2/2/2007")
data1 = data[rows,]
data2 = data[rows2,]
data = rbind(data1,data2)
names(data) = header

##change weekdays to english
Sys.setlocale("LC_TIME", "English")

##merge date and time to datetime
data = cbind(as.Date(data$Date, "%d/%m/%Y"), data[,2:9])
data = cbind(strptime(data$Time,"%H:%M:%S"), data[,c(1,3:9)])
data = data[,c(2,1,3:9)]
time = format(data[,2],"%H:%M:%S")
data = cbind(time,data[,c(1,3:9)])
data = data[,c(2,1,3:9)]
names(data) = header
datetime = as.POSIXct(paste(data$Date, data$Time), format="%Y-%m-%d %H:%M:%S")
data = cbind(datetime,data[,3:9])
names(data) = c("DateTime",header[,3:9])

##create plot4.png
png("./plot4.png")
par(mfcol=c(2,2))
#2 again
plot(data$Global_active_power ~ data$DateTime, type = "n", xlab = "", ylab = "Global Active Power")
lines(data$Global_active_power ~ data$DateTime)
#3 again
plot(data$Sub_metering_1 ~ data$DateTime, type = "n", xlab = "", ylab = "Energy sub metering")
lines(data$Sub_metering_1 ~ data$DateTime)
lines(data$Sub_metering_2 ~ data$DateTime, col = "red")
lines(data$Sub_metering_3 ~ data$DateTime, col = "blue")
legend("topright", c("Sub_metering_1","Sub_metering_2","Sub_metering_3"), col = c("black","red","blue"), lty = 1, cex = 0.65)
#4
plot(data$Voltage ~ data$DateTime, type = "n", xlab = "datetime", ylab = "Voltage")
lines(data$Voltage ~ data$DateTime)
#5
plot(data$Global_reactive_power ~ data$DateTime, type = "n", xlab = "datetime", ylab = "Global_reactive_power", ylim=c(0.1,0.5))
lines(data$Global_reactive_power ~ data$DateTime)
dev.off()