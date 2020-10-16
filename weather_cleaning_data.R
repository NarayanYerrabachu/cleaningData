#load the weather data from excel file
#install.packages("readxl")
library("readxl")
weather <- read_excel("weather.xlsx")
View(weather)

dim(weather)

# we will do the cleaning using "tidyr" package- this was given by David
#It says variable should be in column
#Observation should be in row
# x1-x31 are observation
# temp and others are variable. But these are in row which is the problem
# x1-x31 seems to be the date as u can see for x29, x30, x31 are blank or NA for some value and for these month is feb. And we have just 28 days for feb
# NA's are other problem


# gather function is used to spread the data. Here we will take x1-x31 from columns 
#and will spread to rows
# name that x1-x31 field as "day" and then there will be values also which we name 
#as "value"

#install.packages("tidyr")
library("tidyr")
weather1<-gather(weather,"day","value",X1:X31)

weather1

#check for NA
which(is.na(weather1$value))

weather_1<-gather(weather,"day","value",X1:X31,na.rm=T)
dim(weather1) #8184 obs and 6 variables (264*31)
dim(weather_1)

#we will make our calculation with the NA values so that nothing will be removed later on


weather_2<- spread(weather1,measure,value)
dim(weather_2) # this is coming as 8184*26 bkz it is taking first col as argument and so remove that
head(weather_2)

#Remove first column from the dataframe weather2 and spread it after that
weather1<- weather1[-1]

weather_2<- spread(weather1,measure,value)
dim(weather_2) # now you can see this is 372*25 which is correct

#count the number of rows in the data after spreading that has day
#="X1" and month=12 and year=2014

nrow(filter(weather_2,weather_2$year== 2014 & weather_2$month == 12 & weather_2$day == "X1"))

#Change the coloumn name of 'year ' coloum to 'year'
names(weather_2)[2] <- "month" 

head(weather_2)


#Clean the day column into "Number"

#Using Stringr package for string manipulation
library(stringr)
# we need to remove X from x1 to x31 so that we can have correct day
weather_2$day<- str_replace(weather_2$day,"X","") 

head(weather_2) #removed X


#mutate
library("dplyr")
# create date using the mutate package
weather4<-mutate(weather_2,Date=as.Date(paste(year,month,day,sep="-"),format="%Y-%m-%d"))
head(weather4)

#remove rows which have NA values in all the columns
#Either pull the values which are not NA
B<-which(!is.na(weather4$Date))
weather5<-weather4[B,]

#OR pull the rows with all NA values and delete those rows
#A<-which(is.na(weather4$Date))
#weather5<- weather4[-A,]

glimpse(weather5)

#We see that Precipitation column has values "T" as well as numeric 
#data. COnvert "T" value to 0
weather5$PrecipitationIn[weather5$PrecipitationIn == "T"] <- 0

#delete the day_data,year,month column as you already have date now
weather5<- weather5[,-(1:3)]

str(weather5)

#Change the data types of the columns whose datatype is incorrect
weather5[,3:22]<-lapply(weather5[,3:22],as.numeric)

View(weather5)
class(weather5)
str(weather5)

#rearrange columns as required
finaldata<- weather5[,c(23,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22)]
View(finaldata)

#write this in a output file
#write.table(finaldata, file = "file path")
