# Question 5:
# How have emissions from motor vehicle sources changed from 1999–2008 in Baltimore City?

library(plyr)
library(ggplot2)

# Read the data file
NEI <- readRDS("data/summarySCC_PM25.rds")
SCC <- readRDS("data/Source_Classification_Code.rds")

motorVehicleSourceDesc <- unique(grep("Vehicles", SCC$EI.Sector, ignore.case = TRUE, value = TRUE))
motorVehicleSourceCodes <- SCC[SCC$EI.Sector %in% motorVehicleSourceDesc, ]["SCC"]

# Assume "Motor Vehicles" only means on road
BaltimoreCityMV_PM2.5 <- NEI[NEI$SCC %in% motorVehicleSourceCodes$SCC & NEI$fips == "24510", ]

BaltimoreMVPM25ByYear_PM2.5 <- ddply(BaltimoreCityMV_PM2.5, .(year), function(x) sum(x$Emissions))
colnames(BaltimoreMVPM25ByYear_PM2.5)[2] <- "Emissions"

qplot(year, Emissions, data=BaltimoreMVPM25ByYear_PM2.5, geom="line") +
  ggtitle(expression("Baltimore City" ~ PM[2.5] ~ "Motor Vehicle Emissions by Year")) +
  xlab("Year") +
  ylab(expression("Total" ~ PM[2.5] ~ "Emissions (tons)"))
ggsave("data/plot5.png", width=6, height=4, dpi=300)
dev.off()
