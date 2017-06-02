# Load relevant libraries
library(dplyr)
library(lubridate)
skip = 66637

# Download and unzip the files
if(!file.exists("./plot_assignment")){dir.create("./plot_assignment")}
fileurl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(fileurl,destfile="./plot_assignment/Dataset.zip")
unzip(zipfile = "./plot_assignment/Dataset.zip", exdir="./plot_assignment")

# Read in the dataset and rename variables
dataset <- read.table("./plot_assignment/household_power_consumption.txt", 
                      sep = ";", 
                      stringsAsFactors = FALSE,
                      # Need to skip to line 66637
                      skip = grep("1/2/2007", readLines("./plot_assignment/household_power_consumption.txt")) - 1,
                      nrows = 2880) %>%
  rename(Date = V1, 
         Time = V2, 
         Global_active_power = V3, 
         Global_reactive_power = V4, 
         Voltage = V5, 
         Global_intensity = V6, 
         Sub_metering_1 = V7, 
         Sub_metering_2 = V8, 
         Sub_metering_3 = V9) 

# Merge date and time variables
dataset$datetime = paste(dataset$Date, dataset$Time)
# Turn variables "Date" and "Time" to Date and Time formats from Character
dataset$datetime = dmy_hms(dataset$datetime)


# Set room for all 4 plots
par(mfrow = c(2,2))

# Plot 1
with(dataset, plot(datetime, Global_active_power, 
                   type = "l",
                   xlab = "",
                   ylab = "Global Active Power (kilowatts)"))
# Plot 2
with(dataset, plot(datetime, Voltage, 
                   type = "l",
                   xlab = "datetime",
                   ylab = "Voltage"))
# Plot 3
with(dataset, plot(datetime, Sub_metering_1,  
                   type = "l",
                   xlab = "",
                   ylab = "Energy sub metering"))
lines(dataset$datetime, dataset$Sub_metering_2, col = "red")
lines(dataset$datetime, dataset$Sub_metering_3, col = "blue")
legend("topright",
       lty = 1,
       col=c("black","red", "blue"),
       legend=c("Sub_metering_1","Sub_metering_2", "Sub_metering_3"))
# Plot 4
with(dataset, plot(datetime, Global_reactive_power, 
                   type = "l",
                   xlab = "datetime",
                   ylab = "Global_reactive_power"))


# Copy plot to PNG and close device
dev.copy(png, file = "plot4.png", width = 480, height = 480)
dev.off()