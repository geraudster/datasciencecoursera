rankall <- function(outcome, num = "best") {
    ## Read outcome data
    data <- read.csv("data/outcome-of-care-measures.csv", colClasses = "character")
    names(data)[11] <- "heart attack"
    names(data)[17] <- "heart failure"
    names(data)[23] <- "pneumonia"
    
    colnames <- names(data)
    if(sum(colnames == outcome) == 0) {
        stop("invalid outcome")
    }    
    
    data[,outcome] <- as.numeric(data[,outcome])
    ## For each state, find the hospital of the given rank
    splitByState <- split(data, as.factor(data$State))
    hospitalNames <- c()
    states <- c()

    rankByState <- lapply(splitByState, function(stateData) {
        ranks <- order(stateData[,outcome], stateData$Hospital.Name, na.last=NA)
        num <- if(num == "best") {
            1
        } else if(num == "worst") {
            length(ranks)
        } else {
            num
        }
        str(num)
        stateData[ranks[num], "Hospital.Name"]
    })
    ## Return a data frame with the hospital names and the
    ## (abbreviated) state name
    data.frame(hospital = unlist(rankByState, use.names=FALSE), state = names(rankByState))
}