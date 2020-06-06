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
library(ggplot2)
dev.new(din=c(480, 800)) # avoiding the R studio plot viewer.
this_device <- dev.cur()

to_plot <- NEI[NEI$fips == "24510", ]
to_plot <- select(.data = to_plot, year, type, Emissions)
# to_plot <- tapply(X = to_plot$Emissions, INDEX = to_plot$year, FUN = sum, na.rm = TRUE )
to_plot <- group_by(.data = to_plot, year, type) %>% summarise_all(.funs = sum)
# View(head(to_plot))
this_plot <- qplot(x = year , y = Emissions, data = to_plot, facets = . ~ type, geom = c("point", "smooth"))
this_plot <- this_plot + labs(title = "Total.Emmissions/Year for each device TYPE - Baltimore.City@Maryland(fips:'24510')", y = "Emmissions in TON")
this_plot

## FINAL STEPS ... COPYING THE PLOTS AND CLOSING THE DEVICES
ggsave(filename = "plot3.png", device = png(width = 800, height=480), plot = this_plot)
png_device <- dev.cur()
dev.off(which = png_device)
dev.off(which = this_device)
dev.list()


# other_plot <- ggplot(data = to_plot, aes(x = year, y = Emissions))
# other_plot <- other_plot + facet_grid(rows = 2, facets = . ~ type)
# other_plot <- other_plot + geom_point() + geom_smooth(method = "lm")
# other_plot
