best <- function(state, outcome) {
    ## Read outcome data
    data <- read.csv("data/outcome-of-care-measures.csv", colClasses = "character")
    names(data)[11] <- "heart attack"
    names(data)[17] <- "heart failure"
    names(data)[23] <- "pneumonia"

    ## Check that state and outcome are valid
    if(sum(data$State == state) == 0) {
        stop("invalid state")
    }
    colnames <- names(data)
    if(sum(colnames == outcome) == 0) {
        stop("invalid outcome")
    }
    
    ## Return hospital name in that state with lowest 30-day death
    ## rate
    stateData <- data[data$State == state,]
    stateData[,outcome] <- as.numeric(stateData[,outcome])
    
    ## Get all minimums
    mins <- which(stateData[[outcome]] == min(stateData[[outcome]], na.rm=TRUE))
    
    sort(stateData[mins,"Hospital.Name"])[1]
}