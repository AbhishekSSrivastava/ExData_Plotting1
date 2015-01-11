# set working directory (change this to fit your needs)
setwd("C:\\Users\\absrivastava\\Desktop\\Exp_data_analysis\\exdata-data-household_power_consumption")

# required packages
library(data.table)
library(lubridate)

# To check that folder named data source exist or not
if (!file.exists('data source')) {
  dir.create('data source')
}

# To check that required data set available in the folder or not
if (!file.exists('data source/power_consumption.txt')) {
  
  # download the zip file and unzip
  file.url<-'https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip'
  download.file(file.url,destfile='data source/power_consumption.zip')
  unzip('data source/power_consumption.zip',exdir='data source',overwrite=TRUE)
  
  # read the raw table and limit to 2 days
  variable.class<-c(rep('character',2),rep('numeric',7))
  power.consumption<-read.table('data source/power_consumption.txt',header=TRUE,
                                sep=';',na.strings='?',colClasses=variable.class)
  power.consumption<-power.consumption[power.consumption$Date=='1/2/2007' | power.consumption$Date=='2/2/2007']

  # clean up the variable names and convert date/time fields
  cols<-c('Date','Time','GlobalActivePower','GlobalReactivePower','Voltage','GlobalIntensity',
          'SubMetering1','SubMetering2','SubMetering3')
  colnames(power.consumption)<-cols
  power.consumption$DateTime<-dmy(power.consumption$Date)+hms(power.consumption$Time)
  power.consumption<-power.consumption[,c(10,3:9)]
  
  # write a clean data set to the directory
  write.table(power.consumption,file='data source/power_consumption.txt',sep='|',row.names=FALSE)
} else {
  
  power.consumption<-read.table('data source/power_consumption.txt',header=TRUE,sep='|')
  power.consumption$DateTime<-as.POSIXlt(power.consumption$DateTime)
  
}

# remove the large raw data set 
if (file.exists('data source/household_power_consumption.txt')) {
  x<-file.remove('data source/household_power_consumption.txt')
}