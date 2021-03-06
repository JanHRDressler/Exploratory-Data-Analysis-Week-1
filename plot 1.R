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
rows = which(data[,1]==c("1/2/2007","2/2/2007"))
data = data[rows,]
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

##create plot1.png
png("./plot1.png")
hist(data$Global_active_power, col = "red", main = "Global Active Power", xlab = "Global Active Power (kilowatts)", ylab = "Frequency")
dev.off()