# Download and unzip file
url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(url,destfile='hh_power_consumption.zip',method="curl")
unzip(zipfile = "hh_power_consumption.zip")

# Check if required package is installed
if (!"data.table" %in% installed.packages()) {
  warning("Package data.table required for this script. Installing data.table now...")
  install.packages("data.table")
}
library(data.table)

# Tidying data
colnames <- names(fread("household_power_consumption.txt", nrows = 0))
hhpc <- fread(cmd = "grep -E '^1/2/2007|^2/2/2007' household_power_consumption.txt",
              col.names=colnames)
hhpc$datetime <- paste(hhpc$Date, hhpc$Time, sep = "-")
hhpc$datetime <- as.POSIXct(strptime(hhpc$datetime, "%d/%m/%Y-%H:%M:%S"))

# Generating plot4
par(mfrow = c(2,2))
with(hhpc, {
  plot(datetime,Global_active_power,type="l",ylab = "Global Active Power",xlab="")
  plot(datetime,Voltage, type = "l")
  plot(hhpc$datetime,hhpc$Sub_metering_1,type="l",ylab = "Energy sub metering",xlab="")
  lines(hhpc$datetime,hhpc$Sub_metering_2,col="red")
  lines(hhpc$datetime,hhpc$Sub_metering_3,col="blue")
  legend("topright", col= c("black","red","blue"), legend=c("Sub_metering_1     ","Sub_metering_2", "Sub_metering_3"),lwd=1,bty="n",inset = -0.15,cex=.9,y.intersp=c(.2,.2,.2))
  plot(datetime,Global_reactive_power, type = "l")
})
dev.copy(png, file="plot4.png")
dev.off()
