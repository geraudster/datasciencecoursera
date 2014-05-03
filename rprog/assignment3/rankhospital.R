rankhospital <- function(state, outcome, num = "best") {
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
    
    ## Return hospital name in that state with the given rank
    ## 30-day death rate
    stateData <- data[data$State == state,]
    stateData[,outcome] <- as.numeric(stateData[,outcome])
    
    ranks <- order(stateData[,outcome], stateData$Hospital.Name, na.last=NA)
    num <- if(num == "best") {
        1
    } else if(num == "worst") {
        length(ranks)
    } else {
        num
    }
    
    stateData[ranks[num], "Hospital.Name"]
}