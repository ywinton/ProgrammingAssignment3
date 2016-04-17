## Read outcome data
outcomedata <- read.csv("outcome-of-care-measures.csv",
                        colClasses="character")

rankall <- function(outcome, num="best") {

        ## intialize dataframe a that has unique state with label "States"    
        a <- as.data.frame(unique(outcomedata[,7]))
        colnames(a) <- "State"
    ## Check that if outcome input is valid otherwise gives an error and message
    if(!((outcome=="heart attack")|(outcome=="heart failure")|(outcome=="pneumonia"))){
        stop("invalid outcome")
    }
    ## Depening on the outcome input return dataframe z with 3 columns:hospital,state,mortality rate
    if(outcome=="heart attack"){
        z<-na.omit(outcomedata[,c("Hospital.Name","State",
                                  "Hospital.30.Day.Death..Mortality..Rates.from.Heart.Attack")])
    } else if(outcome=="heart failure"){
        z<-na.omit(outcomedata[,c("Hospital.Name","State",
                                  "Hospital.30.Day.Death..Mortality..Rates.from.Heart.Failure")])
        
    } else {
        z<-na.omit(outcomedata[,c("Hospital.Name","State",
                                  "Hospital.30.Day.Death..Mortality..Rates.from.Pneumonia")])
    }
    
    zsub<-subset(z,z[,3] !="Not Available")                                 ## Throw out all rows without valid mortality rates
    zsub[,3]<- as.numeric(zsub[,3])                                         ## Set mortality rate as numeric for sorting
    sortz <- zsub[order(zsub[,"State"],zsub[,3],zsub[,1]),]                 ## Sort data by State, mortality rate, hospital

    if(num=="best"){                                                        ## Assign rank in increasing mortality rate
        rankz<- transform(sortz, rank=ave(sortz[,3],sortz[,"State"], 
        FUN=function(rank) order (rank, decreasing=FALSE)))
        subrank<-subset(rankz,rankz[,4]==1)                                 ## Return rows with rank==1
    } else if(num=="worst"){                                                ## Assign rank in decreasing mortality rate
        rankz<- transform(sortz, rank=ave(sortz[,3],sortz[,"State"], 
        FUN=function(rank) order (rank, decreasing=TRUE)))
        subrank<-subset(rankz,rankz[,4]==1)                                 ## Return rows with rank==1
    } else {                                                                ## Assign rank in increasing mortality rate
        rankz<- transform(sortz, rank=ave(sortz[,3],sortz[,"State"], 
        FUN=function(rank) order (rank, decreasing=FALSE)))
        subrank<-subset(rankz,rankz[,4]==num)                               ## Return rows with rank==num input
    }
    rankmerge <-merge(x=a,y=subrank, by="State", all.x=TRUE)                ## Merge rank sorted dataframe with all states
    list<-rankmerge[,c("Hospital.Name","State")]                            ## List only columns hospital and states
    colnames(list) <- c("hospital","state")                                 ## Rename columns as requested
    return(list)                                    
}
