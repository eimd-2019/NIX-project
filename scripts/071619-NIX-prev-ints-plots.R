#### Script for creating plots with NIX data
### Create prevalence over time (years) and intensity over time (years)
## July 16, 2019 FHL EIMD

#install packages
install.packages("plyr")
#load packages
library(ggplot2)
library(plyr)

#------------------------------------------------------
#read in NIX sample data
sample <- read.csv("data/NIX-FHL-sample-data-for-R.csv")
#read in NIX qPCR data
qPCR <- read.csv("data/NIX-qPCR-FHL-for-R.csv")

#merge files by "ID" column
master <- merge(qPCR, sample, by = "ID")

#------------------------------------------------------
#create a new column that tells prevalence
master$infected <- ifelse(master$AverageSQ_1ul > 0, 1, 0)

#create a new column that tells DNA/mg of tissue (DNA was eluted in 200ul water)
master$DNApmg <- (master$AverageSQ_1ul * 200)/master$Gill_Tissue_Weight_mg

#fix empty cells
master$SamplingMethod <- ifelse(master$SamplingMethod == "stock assessment", "stock assessment", ifelse(master$SamplingMethod == "moribund", "moribund", "stock assessment"))

#summarise data based on Avg starting quantity and year
mastersummary <- ddply(master, .(Year, SamplingMethod), summarize, Prevalence = sum(infected)/length(infected), Intensity = sum(DNApmg/sum(infected)))

#------------------------------------------------------
#create plots of prevalence over time (years) and intensity over time (years)

#create an x-y scatter plot for Prevalence over time
ggplot(mastersummary, aes(Year, Prevalence, colour = SamplingMethod)) + geom_point()

#create an x-y scatter plot for Intensity over time
ggplot(mastersummary, aes(Year, Intensity, colour = SamplingMethod)) + geom_point()

#create an x-y scatter plot for intensity vs prevalence
ggplot(mastersummary, aes(Prevalence, Intensity)) + geom_point()

#------------------------------------------------------
#Create new master without moribund sample data
master2 <- master[ master$SamplingMethod!= "moribund",]

#make new master summary
mastersummary2 <- ddply(master2, .(Year, SamplingMethod), summarize, Prevalence = sum(infected)/length(infected), Intensity = sum(DNApmg/sum(infected)))

#------------------------------------------------------
#create an x-y scatter plot for intensity and prevalence vs year
#code below from: https://stackoverflow.com/questions/6142944/how-can-i-plot-with-2-different-y-axes

## Plot first set of data and draw its axis
plot(mastersummary2$Year, mastersummary2$Prevalence, pch=16, axes=FALSE, ylim=c(0,1), xlab="", ylab="", 
     type="b",col="black", main="Prevalence and Intensity vs Year")
axis(2, ylim=c(0, 1),col="black",las=1)  ## las=1 makes horizontal labels
mtext("Prevalence",side=2,line=2.5)
box()

## Allow a second plot on the same graph
par(new=TRUE)

## Plot the second plot and put axis scale on right
plot(mastersummary2$Year, mastersummary2$Intensity, pch=15,  xlab="", ylab="", ylim=c(0,1600000), 
     axes=FALSE, type="b", col="blue")
## a little farther out (line=4) to make room for labels
mtext("Intensity",side=4,col="blue",line=4) 
axis(4, ylim=c(0,16000000), col="blue",col.axis="blue",las=1)

## Draw the time axis
axis(1,pretty(range(mastersummary2$Year), 10))
mtext("Years",side=1,col="black",line=2.5)  

## Add Legend
legend("topleft",legend=c("Prevalence","Intensity"),
       text.col=c("black","blue"),pch=c(16,15),col=c("black","blue"), bty = "n")

#save image! 