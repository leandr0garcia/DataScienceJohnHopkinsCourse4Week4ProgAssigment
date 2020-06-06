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
dev.new(din=c(480, 480)) # avoiding the R studio plot viewer.
this_device <- dev.cur()

coal_source_df <- SCC[grep("[Cc]oal", SCC$EI.Sector), ]
# View(coal_source_df)
to_plot <- NEI[NEI$SCC %in% coal_source_df$SCC, ]
# length(unique(to_plot$SCC))
# length(coal_source_df$SCC)
# to_plot$SCC %in% coal_source_df$SCC
to_plot <- select(.data = to_plot, year, Emissions)
to_plot <- group_by(.data = to_plot, year) %>% summarise_all(.funs = sum)
# View(head(to_plot))
this_plot <- ggplot(data = to_plot, aes(x = year , y = Emissions))
this_plot <- this_plot + geom_point() + geom_smooth(method = "lm") + labs(title = "Total Emmissions / Year for COAL sources", y = "Emmissions in TONs")
this_plot
## FINAL STEPS ... COPYING THE PLOTS AND CLOSING THE DEVICES
ggsave(filename = "plot4.png", device = png(width = 480, height=480), plot = this_plot)
png_device <- dev.cur()
dev.off(which = png_device)
dev.off(which = this_device)
dev.list()
