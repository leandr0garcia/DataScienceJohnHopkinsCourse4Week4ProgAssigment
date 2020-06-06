

## This first line will likely take a few seconds. Be patient!
# - fips: A five-digit number (represented as a string) indicating the U.S. county
# - SCC: The name of the source as indicated by a digit string (see source code classification table)
# - Pollutant: A string indicating the pollutant
# - Emissions: Amount of PM2.5 emitted, in tons
# - type: The type of source (point, non-point, on-road, or non-road)
# - The year of emissions recorded
NEI <- readRDS("./data/summarySCC_PM25.rds")

## Source Classification Code Table 
# (Source_Classification_Code.rds): This table provides a mapping from the SCC digit strings in 
#                                  the Emissions table to the actual name of the PM2.5 source. 
#                                  The sources are categorized in a few different ways from more 
#                                  general to more specific and you may choose to explore whatever
#                                  categories you think are most useful. 
#   For example, source “10100101” is known as “Ext Comb /Electric Gen /Anthracite Coal /Pulverized Coal”
# .
SCC <- readRDS("./data/Source_Classification_Code.rds")

library(dplyr)

dev.new(din=c(480, 480)) # avoiding the R studio plot viewer.
this_device <- dev.cur()

par(mfrow=c(1, 1), mar = c(4, 4, 4, 1))
to_plot <- filter(.data = NEI, Pollutant == "PM25-PRI")
to_plot <- select(.data = to_plot, year, Emissions)
# to_plot <- tapply(X = to_plot$Emissions, INDEX = to_plot$year, FUN = sum, na.rm = TRUE )
to_plot <- group_by(.data = to_plot, year) %>% summarise_all(.funs = sum)
# View(head(to_plot))
plot(x = to_plot$year, y = to_plot$Emissions, main = "TOTAL EMISSION / YEAR", xlab = "Year", ylab = "TOTAL Emissions in TON", ylim = c(min(to_plot$Emissions), max(to_plot$Emissions)))
linear_mode <- lm(Emissions ~ year, data = to_plot) # creating a Linear Model
abline(linear_mode, lwd = 2, col = "green") 


## FINAL STEPS ... COPYING THE PLOTS AND CLOSING THE DEVICES
png_device <- dev.copy(device = png, filename = "plot1.png")
dev.off(which = png_device)
dev.off(which = this_device)
dev.list()
