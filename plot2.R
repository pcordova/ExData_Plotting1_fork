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

# Generating plot2
plot(hhpc$datetime,hhpc$Global_active_power,type="l",ylab = "Global Active Power (kilowatts)",xlab="")
dev.copy(png, file="plot2.png")
dev.off()
