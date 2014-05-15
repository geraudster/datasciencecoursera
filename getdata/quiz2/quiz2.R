library(httr)

#######################################
## Q1

# 1. Find OAuth settings for github:
# http://developer.github.com/v3/oauth/
oauth_endpoints("github")

# 2. Register an application at https://github.com/settings/applications
# Insert your values below - if secret is omitted, it will look it up in
# the GITHUB_CONSUMER_SECRET environmental variable. (Use Sys.setenv(GITHUB_CONSUMER_SECRET = "..."))
#
# Use http://localhost:1410 as the callback url
myapp <- oauth_app("github", "c001b0d7a4021fcefb53")

# 3. Get OAuth credentials
github_token <- oauth2.0_token(oauth_endpoints("github"), myapp)

# 4. Use API
req <- GET("https://api.github.com/repos/jtleek/datasharing", config(token = github_token))
stop_for_status(req)
response <- content(req)

response$created_at

#######################################
## Q2
#install.packages("sqldf")
library(sqldf)
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv", destfile="Q2.csv", method="curl")
acs <- read.csv("Q2.csv")
sqldf("select pwgtp1 from acs where AGEP < 50")

#######################################
## Q3
sqldf("select distinct AGEP from acs")

#######################################
## Q4
con = url("http://www.biostat.jhsph.edu/~jleek/contact.html")
page <- readLines(con)
close(con)
nchar(page[c(10,20,30,100)])

#######################################
## Q5
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fwksst8110.for"
download.file(url, destfile="Q5.csv", method="curl")
q5 <- read.fwf("Q5.csv", c(15,4,4,-5,4,4,-5,4,4,-5,4,4,-5), skip=4, header=FALSE)
sum(q5$V4)
