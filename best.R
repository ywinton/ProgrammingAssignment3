## Read outcome data
outcome <- read.csv("outcome-of-care-measures.csv",
                    colClasses="character")

best <- function(state,out) {
    
    ## Intialize a with all the unique states
    u<-na.omit(outcome[!duplicated(outcome$State),])
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
    if(!((out=="heart attack")|(out=="heart failure")|(out=="pneumonia"))){
        stop("invalid outcome")
    }
    ## Depening on the outcome input return dataframe z with 3 columns:hospital,
    ## state,mortality rate   
    if(out=="heart attack"){
        z<-na.omit(outcome[,c("Hospital.Name","State",
           "Hospital.30.Day.Death..Mortality..Rates.from.Heart.Attack")])
    } else if(out=="heart failure"){
        z<-na.omit(outcome[,c("Hospital.Name","State",
            "Hospital.30.Day.Death..Mortality..Rates.from.Heart.Failure")])
        
    } else {
        z<-na.omit(outcome[,c("Hospital.Name","State",
            "Hospital.30.Day.Death..Mortality..Rates.from.Pneumonia")])
    }
    ## Throw out all rows without valid mortality rates
    ## Set mortality rate as numeric for sorting
    ## Sort data by State, mortality rate, hospital into sortz
    zsub<-subset(z,z[,3] !="Not Available")
    zsub[,3]<- as.numeric(zsub[,3])
    sortz <- zsub[order(zsub[,"State"],zsub[,3]),]
    
    ## Only returns the first value of each state
    x<-na.omit(sortz[!duplicated(sortz$State),])
    ## with state input, return corresponding hospital name
    return(subset(x[,c("Hospital.Name")],x[,2]==state))
}
