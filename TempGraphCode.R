##open data file
dat=read.csv('/Users/meganswanger/Documents/GitHub/NIX-project/Kalaloch data with Temp Stuff.csv')


attach(dat)

head(dat)
##call ggplot
library(ggplot2)

#define variables & call file
ggplot(dat, aes(x=YEAR,y=MEAN,color=SEASON))

#call plot with defined variables 
p <- ggplot(dat, aes(x=YEAR,y=MEAN,color=SEASON)) + 
  geom_point(shape="square")

#call plot as smooth lines and add regression lines 
p + stat_smooth(method = "lm", formula = y ~ poly(x,5), se = FALSE) +
  ##change font size for axes, legend, etc
  theme(axis.text.x = element_text(angle=45, vjust=0.5, size=12),
    axis.text.y = element_text(size=12),
    axis.title.y = element_text(size=14),
    axis.title.x = element_text(size=14),
    plot.title = element_text(size=18, face="bold"),
    legend.title = element_text(size=14, face="bold")) +
  ##add axes labels
  xlab("Year") +
  ylab("Mean Temperature") +
  ##add title 
  ggtitle("Temperature Variability at Brown's Point (2003-2018)")











