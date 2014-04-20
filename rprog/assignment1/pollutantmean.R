# data200 <- read.csv('specdata/200.csv')

pollutantmean <- function(directory, pollutant, id = 1:332) {
  ## 'directory' is a character vector of length 1 indicating
  ## the location of the CSV files
  
  ## 'pollutant' is a character vector of length 1 indicating
  ## the name of the pollutant for which we will calculate the
  ## mean; either "sulfate" or "nitrate".
  
  ## 'id' is an integer vector indicating the monitor ID numbers
  ## to be used
  
  ## Return the mean of the pollutant across all monitors list
  ## in the 'id' vector (ignoring NA values)
  all_data <- c();
  for(monitor in id) {
    print(sprintf("%s/%03d.csv", directory, monitor))
    data <- read.csv(sprintf("%s/%03d.csv", directory, monitor))
    all_data <- c(all_data, data[pollutant])
    }
  mean(all_data, na.rm=TRUE)
}