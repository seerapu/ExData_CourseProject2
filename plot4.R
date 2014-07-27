# Question 4:
# Across the United States, how have emissions from coal combustion-related
# sources changed from 1999–2008?

library(plyr)
library(ggplot2)

# Read the data file
NEI <- readRDS("data/summarySCC_PM25.rds")
SCC <- readRDS("data/Source_Classification_Code.rds")

# Find coal combustion-related sources
is.combustion.coal <- grepl("Fuel Comb.*Coal", SCC$EI.Sector)
combustion.coal.sources <- SCC[is.combustion.coal,]

CoalCombustion <- NEI[(NEI$SCC %in% combustion.coal.sources$SCC), ]
coalCombustionPM25ByYear <- ddply(CoalCombustion, .(year), function(x) sum(x$Emissions))
colnames(coalCombustionPM25ByYear)[2] <- "Emissions"

#png("plot4.png")
qplot(year, Emissions, data=coalCombustionPM25ByYear, geom="line") +
  ggtitle(expression("Coal Combustion" ~ PM[2.5] ~ "Emissions by Year")) +
  xlab("Year") +
  ylab(expression("Total" ~ PM[2.5] ~ "Emissions (tons)"))
ggsave("data/plot4.png")
dev.off()
