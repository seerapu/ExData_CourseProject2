# Question 3:
# Of the four types of sources indicated by the type (point, nonpoint, onroad,
# nonroad) variable, 
# which of these four sources have seen decreases in emissions from 1999–2008 for Baltimore City? 
# Which have seen increases in emissions from 1999–2008? 
# Use the ggplot2 plotting system to make a plot answer this question.

library(plyr)
library(ggplot2)

# Read the data file
NEI <- readRDS("data/summarySCC_PM25.rds")
SCC <- readRDS("data/Source_Classification_Code.rds")

BaltimoreCity_PM2.5 <- subset(NEI, fips == "24510")

BaltimoreCity_typePM25ByYear <- ddply(BaltimoreCity_PM2.5, .(year, type), function(x) sum(x$Emissions))
colnames(BaltimoreCity_typePM25ByYear)[3] <- "Emissions"


qplot(year, Emissions, data=BaltimoreCity_typePM25ByYear, color=type, geom="line") +
  ggtitle(expression("Baltimore City" ~ PM[2.5] ~ "Emissions by Source Type and Year")) +
  xlab("Year") +
  ylab(expression("Total" ~ PM[2.5] ~ "Emissions (tons)"))
ggsave("data/plot3.png")
dev.off()
