corr <- function(directory, threshold = 0) {
    ## 'directory' is a character vector of length 1 indicating
    ## the location of the CSV files
    
    ## 'threshold' is a numeric vector of length 1 indicating the
    ## number of completely observed observations (on all
    ## variables) required to compute the correlation between
    ## nitrate and sulfate; the default is 0
    
    ## Return a numeric vector of correlations
    result <- c()
    completes <- complete(directory)
    abovethreshold <- completes$nobs > threshold
    for(id in completes$id[abovethreshold]) {
        filename <- sprintf("%s/%03d.csv", directory, id)
        print(paste(c("In file ", filename)))
        data <- read.csv(filename)
        result <- c(result, cor(data$sulfate, data$nitrate, use="complete.obs"))
    }
    result
}
