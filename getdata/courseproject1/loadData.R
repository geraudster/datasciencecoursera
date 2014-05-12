## retrieve zip file if not already downloaded, then unzip it in the data/ directory
loadDataFile <- function() {
    ## Check data directory 
    if(!file.exists("data")) {
        dir.create("data")
    }
    
    ## Download file if needed
    if(!file.exists("data/household_power_consumption.zip")) {
        download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",
                      "data/UCI_HAR_Dataset.zip",
                      method='curl')
        
    }
    
    ## Unzip it in data dir
    unzip("data/UCI_HAR_Dataset.zip", exdir="data")
}

## Creates a data.table from the extracted data
## Adds a DateTime column in POSIXct format
## Then returns a copy of the data for 01/02/2007 and 02/02/2007
loadData <- function() {
    
    ## Create data.table
    ## It was faster to use data.table and fread than read.csv
    data <- fread("data/household_power_consumption.txt", na.strings="?")
    
    ## Create the subset
    subdata <- copy(data[Date == "1/2/2007" | Date == "2/2/2007",])
    
    ## Add a datetime column, converted in POSIXct (as data.table cannot handle POSIXlt)
    subdata[, DateTime := as.POSIXct(strptime(paste(Date, Time), format="%d/%m/%Y %H:%M:%S"))]
    
    ## Convert numeric column
    subdata[, Global_active_power := as.numeric(Global_active_power)]
    subdata[, Global_reactive_power := as.numeric(Global_reactive_power)]
    subdata[, Voltage := as.numeric(Voltage)]
    subdata[, Global_intensity := as.numeric(Global_intensity)]
    subdata[, Sub_metering_1 := as.numeric(Sub_metering_1)]
    subdata[, Sub_metering_2 := as.numeric(Sub_metering_2)]
    subdata[, Sub_metering_3 := as.numeric(Sub_metering_3)]
    
    # Return the subset
    subdata
}