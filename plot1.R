create_data_directory <- function() {
    if (!file.exists("data")) {
        dir.create("data")
    } 
}

download_and_unzip <- function(url, destfile) {
    if (!file.exists(destfile)) {
        download.file(url, destfile, method = "curl")
    }
    unzip(zipfile = destfile, exdir = "data")
}

plot1 <- function() {
    create_data_directory()
    download_and_unzip(
        url = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip",
        destfile = "data/exdata-data-NEI_data.zip")
    
    NEI <- readRDS("data/summarySCC_PM25.rds")

    NEI <- NEI[, c("Emissions", "year")]
    emissionsSumByYear <- with(NEI, aggregate(Emissions, list(year), sum))
    names(emissionsSumByYear) <- c("Year", "Emissions")

    png("plot1.png")

    opt <- options(scipen = 100)
    op <- par(mar = c(5, 7, 4, 2) + 0.1)

    with(emissionsSumByYear,
         plot(
             x = Year,
             y = Emissions,
             type = "b",
             main = "United States PM2.5 Emissions Trend",
             ylab = "",
             las = 1)
         )

    title(ylab = "Total Emissions", line = 5.5)
    par(op)
    options(opt)

    dev.off()
    
    rm(emissionsSumByYear)
}