library(httr)
library(rvest)
library(quantmod)

#Grab the website's html
spyop_url <- "https://finance.yahoo.com/quote/SPY/options?date=1703808000&p=SPY&straddle=false"
spy_page <- GET(spyop_url)

#Grab the html specific to the puts table or calls table.
root_node <- read_html(spy_page)
table_nod <- html_element(root_node, ".calls") # NOTE: .puts = Buy puts table OR .calls = Buy calls table

#Converts the table to a data frame 
data_tabl <- html_table(table_nod,header = NA,
                        trim = TRUE,
                        dec = ".",
                        na.strings = "NA",
                        convert = TRUE)
data_frame <- as.data.frame(data_tabl)

#summary(data_frame) Check the first stats of the table

#Function to clean the data, and change their data types
dat_frame <- function(data_frame) {
  
  shape <- dim(data_frame)
  
  # Convert column data types
  data_frame$'Contract Name' <- as.factor(data_frame$`Contract Name`)
  data_frame$'Last Trade Date' <- as.factor(data_frame$`Last Trade Date`)
  data_frame$Strike <- as.numeric(gsub(",","",data_frame$Strike))
  data_frame$'Last Price' <- as.numeric(gsub(",","",data_frame$`Last Price`))
  data_frame$Bid <- as.numeric(gsub(",","",data_frame$Bid))
  data_frame$Ask <- as.numeric(gsub(",","",data_frame$Ask))
  data_frame$Change <- as.numeric(gsub(",","",data_frame$Change))
  data_frame$`% Change` <- as.numeric(gsub("%","",data_frame$`% Change`))/100
  data_frame$Volume <- as.numeric(gsub(",","",data_frame$Volume))
  data_frame$`Open Interest` <- as.numeric(gsub(",","",data_frame$`Open Interest`))
  data_frame$`Implied Volatility` <- as.numeric(gsub("%","",data_frame$`Implied Volatility`))/100
  
  #Replace NA's with 0
  data_frame[is.na(data_frame)] <- 0
  
  #remove the index column or row names (1,2,3..)
  rownames(data_frame) <- NULL
  
  return(data_frame)
}
dat_frame(data_frame)
data_frame2 <- dat_frame(data_frame)
#Summary(data_frame2) Can show that na's were removed and data types are accurate

#Write it on a csv without index column
path_out <- 'C:/Users/Sebastian/Desktop/Portfolio Projects/Cert Projs/R/Black Scholes/csvs/SPY_BlackScholesModel.csv'
write.csv(data_frame2,path_out,row.names = FALSE)

#get stock price
getSymbols("SPY",
           from = "2023/11/29",
           to = "2023/11/30",
           periodicity = "daily")
head(SPY)
sprice <- SPY$SPY.Adjusted[1,]
data_price <- as.data.frame(sprice)
data_price

#Black-Scholes Model Price for previous data
for (y in data_frame2) {
  s <-  454.61 #stock price needed above
  x <- data_frame2$Strike #strike price
  t <-  0.083 #Expiration date in year format so 3 months is .25
  sigma <- data_frame2$`Implied Volatility` #volatility
  rfree <- 5.21 #Risk free rate
  d1 <- (log(s/x) + rfree * t)/(sigma*sqrt(t)) + sigma*sqrt(t)/2  #probability factor
  d2 <- d1 - sigma*sqrt(t)  #2nd probability factor
  c <- s*pnorm(d1)-exp(-rfree*t)*x*pnorm(d2) #Black-Scholes Model Equation
  av <- c() #make a vector
  actval <- append(av, c) #Add the results to a vector
}

data_frame2$BSOptionPrice <- actval #Add the vector to a column
data_frame2
#summary(data_frame2) #just to check
write.csv(data_frame2,path_out,row.names = FALSE) #Rewrite the csv with the new column

#Plot the data from the chunk above, using any of the columns
plot(data_frame2$Strike,data_frame2$Volume ,col="blue") #the interest in each put options by strike price

#Read the csv and pull up contacts with high interest
spycsv <- read.csv(path_out, header = TRUE, sep=",")
topints <- spycsv[which(spycsv$Volume>500),c("Contract.Name","Strike","Volume","Open.Interest","Implied.Volatility")]

