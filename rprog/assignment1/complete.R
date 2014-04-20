complete <- function(directory, id = 1:332) {
  ## 'directory' is a character vector of length 1 indicating
  ## the location of the CSV files
  
  ## 'id' is an integer vector indicating the monitor ID numbers
  ## to be used
  
  ## Return a data frame of the form:
  ## id nobs
  ## 1  117
  ## 2  1041
  ## ...
  ## where 'id' is the monitor ID number and 'nobs' is the
  ## number of complete cases
  ids <- c()
  nobss <- c()
  # read.table(names = c("id", "nobs"))
  for(monitor in id) {
    #    print(sprintf("%s/%03d.csv", directory, monitor))
    data <- read.csv(sprintf("%s/%03d.csv", directory, monitor))
    complete <- !(is.na(data$sulfate)|is.na(data$nitrate))
    ids <- c(ids, monitor)
    nobss <- c(nobss, sum(complete))
  }
  data.frame(id=ids, nobs=nobss)
}