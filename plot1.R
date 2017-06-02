# Load relevant libraries
library(dplyr)
library(lubridate)

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

# Turn variables "Date" and "Time" to Date and Time formats from Character
dataset$Date = dmy(dataset$Date)
dataset$Time = format(dataset$Time, format = "%H:%M:%S")

# Plot 
hist(dataset$Global_active_power, 
     col = "red", 
     main = "Global Active Power", 
     xlab = "Global Active Power (kilowatts)")

# Copy plot to PNG and close device
dev.copy(png, file = "plot1.png", width = 480, height = 480)
dev.off()