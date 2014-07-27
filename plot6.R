# Question 6:
# Compare emissions from motor vehicle sources in Baltimore City with emissions
# from motor vehicle sources in Los Angeles County, California (fips == 06037).
# Which city has seen greater changes over time in motor vehicle emissions?

suppressWarnings(library(ggplot2))
suppressWarnings(library(grid))


# Read the data file
NEI <- readRDS("data/summarySCC_PM25.rds")
SCC <- readRDS("data/Source_Classification_Code.rds")

motorVehicleSourceDesc <- unique(grep("Vehicles", SCC$EI.Sector, ignore.case = TRUE, value = TRUE))
motorVehicleSourceCodes <- SCC[SCC$EI.Sector %in% motorVehicleSourceDesc, ]["SCC"]

emissionFromMotorVehiclesInBaltimore <- NEI[NEI$SCC %in% motorVehicleSourceCodes$SCC & 
                                              NEI$fips == "24510", ]
emissionFromMotorVehiclesInLosAngeles <- NEI[NEI$SCC %in% motorVehicleSourceCodes$SCC & 
                                               NEI$fips == "06037", ]
emissionFromMotorVehicles <- rbind(emissionFromMotorVehiclesInBaltimore, emissionFromMotorVehiclesInLosAngeles)

## Calculate the emissions due to motor vehicles in Baltimore and Los Angeles
## for every year
totalMotorVehicleEmissionsByYearAndByCounty <- aggregate(Emissions ~ fips * 
                                                           year, data = emissionFromMotorVehicles, FUN = sum)
totalMotorVehicleEmissionsByYearAndByCounty$county <- ifelse(totalMotorVehicleEmissionsByYearAndByCounty$fips == 
                                                               "06037", "Los Angeles", "Baltimore")

## Setup ggplot with data frame
q <- qplot(y = Emissions, x = year, data = totalMotorVehicleEmissionsByYearAndByCounty, 
           color = county)

## Add layers
r = q + scale_x_continuous(breaks = seq(1999, 2008, 3)) + theme_bw() + geom_point(size = 3) + 
  geom_line() + labs(y = expression("Total " * PM[2.5] * 
                                      " Emissions (in tons)")) + labs(x = "Year") + labs(title = expression("Motor  Vehicle Related " * 
                                                                                                              PM[2.5] * " Emissions in Baltimore & Los Angeles (1999 - 2008)")) + theme(axis.text = element_text(size = 4), 
                                                                                                                                                                                        axis.title = element_text(size = 8), panel.margin = unit(1, "lines"), plot.title = element_text(vjust = 2, 
                                                                                                                                                                                                                                                                                         hjust = 0.17, size = 8), legend.title = element_text(size = 4)) + 
  scale_colour_discrete(name = "County")
print(r)
ggsave("data/plot6.png", width=6, height=4, dpi=300)
dev.off()