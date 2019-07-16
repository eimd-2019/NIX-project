#### IMPORT DATA ####

popdata <- read.csv("data/Kalaloch data from Steve 1.csv") #Import population data
head(popdata) #Confirm import

#### FORMAT DATA ####

counts <- popdata[,c(2:3)] #Subset Adult and Juvenile count data
head(counts) #Confirm subset
barplotData <- t(counts) #Transpose dataframe for barplot
colnames(barplotData) <- popdata$Year #Set years as column names
head(barplotData) #Confrim changes

#### GROUPED BARPLOT WITHOUT A GAPPED AXIS ####

barplot(height = barplotData, 
        main="Adult and Juvenile Population Size", 
        xlab="Year", ylab="Abundance", 
        ylim = c(0,140000000),
        col=c("darkblue","red"), 
        beside=TRUE) #Create a barplot using the transposed counts (t(counts)). Add a title with main, and label x and y axes (xlab and ylab). Set the y axis limits with ylim. Use darkblue for Adults and red for Juveniles. Create a grouped plot with beside = TRUE. Add years as x-axis labels with names.arg.
legend("topleft",
       bty = "n",
       legend = c("Adult","Juvenile"),
               pch =15,
               col=c("darkblue","red")) #Add a legend in the topleft corner with no box (bty = "n").

#### GROUPED BARPLOT WITH A GAPPED AXIS ####

#Install relevant packages
#install.packages("plotrix") #Install plotrix package. Uncomment if you need to install the package
library(plotrix) #Load plotrix package

#Format data to coerce gap.barplot to create a grouped barplot similar to the original barplot command.
gap.barplotData <- rbind(NA,barplotData) #Add a row of NAs to manually plot spaces between groups. This row will be on top of the original data.
head(gap.barplotData) #Confirm changes

#Create the plot
#pdf("Adult-Juvenile-Clam-Abundance.pdf", height = 8.5, width = 11) #Save plot as a pdf. Uncomment this code if you want to save the plot as a pdf.
gap.barplot(gap.barplotData, beside = TRUE, 
            xaxt = "n",
            gap=c(10e+06,9e+07), 
            ytics = c(0, 2e+06, 4e+06, 6e+06, 8e+06, 100e+06, 120e+06, 140e+06), 
            yaxlab = c(0, 2, 4, 6, 8, 100, 120, 140), las = 2,
            col=rep(c("white", "darkblue", "red"), times = length(counts$Juveniles)), 
            xlab = "", ylab = "Abundance (x 100,000)") #Create grouped barplot with beside = TRUE. Specify an axis break with gap. Use rep to alternate between white, darkblue, and red colors for the bars. The white bars correspond to NAs added into the dataframe to coerce groupings.

#Modify broken axis
axis.break(axis = 2, 10e+06, breakcol = "white", style = "gap") #Add a gap axis break. Change color of horizontal lines where axis are broken
axis.break(axis = 2, 10e+06*(1+0.06), breakcol = "black", style = "zigzag") #Add an axis break. Add slashes on y-axis to indicate axis break
axis.break(axis = 4, 10e+06*(1+0.06), breakcol = "black", style = "zigzag") #Add an axis break. Add slashes opposite of y-axis to indicate axis break

#Label x axes.
axis(side = 1, at = seq(from = 2.5, to = 71.5, by = 3), labels = popdata$Year, las = 2) #Ad x-axis ticks between adult and juvenile bars, and label with Years. Rotate sideways with las.
mtext(side = 1, "Year", line = 3.5) #Add x-axis label
axis(side = 2, at = c(10e+06), label = c(10), las = 2) #Add y-axis tick where the break occurs

#Add a legend
legend("topleft",
       bty = "n",
       legend = c("Adult","Juvenile"),
       pch =15,
       col=c("darkblue","red")) #Add a legend in the topleft corner with no box (bty = "n"). Use squares for legend

#dev.off() #Uncomment and run after running the code to save plots.