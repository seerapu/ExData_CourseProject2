# Question 2:
# Have total emissions from PM2.5 decreased in the Baltimore City, Maryland
# (fips == "24510") from 1999 to 2008? Use the base plotting system to make a
# plot answering this question.

# Read the data file
NEI <- readRDS("data/summarySCC_PM25.rds")
SCC <- readRDS("data/Source_Classification_Code.rds")

BaltimoreCity_PM2.5 <- subset(NEI, fips == "24510")

BaltimoreCity_PM25ByYear <- tapply(BaltimoreCity_PM2.5$Emissions, BaltimoreCity_PM2.5$year, sum)

png("data/plot2.png")
plot(names(BaltimoreCity_PM25ByYear), BaltimoreCity_PM25ByYear, type="l",
     xlab="Year", ylab=expression("Total" ~ PM[2.5] ~ "Emissions (tons)"),
     main=expression("Total Baltimore City" ~ PM[2.5] ~ "Emissions by Year"))
dev.off()
