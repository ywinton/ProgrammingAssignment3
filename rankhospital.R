## Read outcome data
outcomedata <- read.csv("outcome-of-care-measures.csv",
                        colClasses="character")

rankhospital <- function(state, outcome, num= "best") {
 
    ## Intialize a with all the unique states
    u<-na.omit(outcomedata[!duplicated(outcomedata$State),])
    a<-u[,"State"]
    
    ## Set statecode=N, go through a if input state exists, set statecode=Y
    ## otherwise gives error and message
    statecode<-'N'
    for (i  in 1:length(u)) {
        if(state==a[i]){
            statecode<-'Y'
        }
    }
    if(statecode=='N'){
        stop("invalid state")
    }
    
    ## Check that if outcome input is valid otherwise gives an error and message
    if(!((outcome=="heart attack")|(outcome=="heart failure")|(outcome=="pneumonia"))){
        stop("invalid outcome")
    }
    ## Depening on the outcome input return dataframe z with 3 columns:hospital,
    ## state,mortality rate      
    if(outcome=="heart attack"){
        z<-na.omit(outcomedata[,c("Hospital.Name","State",
                                  "Hospital.30.Day.Death..Mortality..Rates.from.Heart.Attack")])
        statez <- subset(z,z[,2]==state)
    } else if(outcome=="heart failure"){
        z<-na.omit(outcomedata[,c("Hospital.Name","State",
                                  "Hospital.30.Day.Death..Mortality..Rates.from.Heart.Failure")])
        statez <- subset(z,z[,2]==state)        
    } else {
        z<-na.omit(outcomedata[,c("Hospital.Name","State",
                                  "Hospital.30.Day.Death..Mortality..Rates.from.Pneumonia")])
        statez <- subset(z,z[,2]==state)
            }
  
    ## Throw out all rows without valid mortality rates
    ## Set mortality rate as numeric for sorting
    ## Sort data by State, mortality rate, hospital into sortz
    zsub<-subset(statez,statez[,3] !="Not Available")
    zsub[,3]<- as.numeric(zsub[,3])
    sortz <- zsub[order(zsub[,3],zsub[,1]),]
    
    ## if num=best return the first row hospital
    ## if num=worst return the last row hospital
    ## for num input find row=num and return corresponding hospital
    if(num=="best"){
        sortz[1,1]
    } else if(num=="worst"){
        tail(sortz[,1],1)
    } else

        sortz[num,1]
}