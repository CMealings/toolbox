sumMedia <- function(path, yearRange = 1980:2016, metaRange = c(11, 4)) {
  
  ## Sum per country adex totals by medium, based on WARC.com download (export to .csv first)
  
  version <- 1.1
  
  ## Dependencies
  if (!"package:data.table" %in% search())
    library(data.table)
  
  n.rows <- length(yearRange)
  
  ## Read in data
  data <- read.csv(path, skip = sum(metaRange), nrows = n.rows)
  meta <- read.csv(path, stringsAsFactors = FALSE, skip = metaRange[1], nrows = metaRange[2])
  
  ## Combine media and country to create variable names
  names(data)[-1] <- paste(meta[1,-1], meta[2,-1], sep = "_")
  
  ## Get vector of media channels
  medium <- unique(as.character(meta[2, ]))
  medium <- medium[medium != "NA"]
  
  ## Remove regex meta characters
  medium <- gsub("\\^|\\*", "", medium)
  
  ## Remove 1000s separator, where csv uses it
  data <- data.frame(apply(data, 1:2, gsub, pattern = ",", replacement = ""))
  data[, -1] <- apply(data[, -1], 1:2, as.numeric)
  
  ## Calculation log
  # log <- matrix(NA, ncol = length(medium), ncol = dim(data)[1])
  # colnames(log) <- medium
  
  ## Sum adex for all countries by media channel 
  totals <- t(apply(data[,-1], 1, function(x) {
    year <- NULL
    for (i in 1:length(medium)) {
      year <- append(year, sum(x[grep(medium[i], meta[2, -1])], na.rm = TRUE))
      # log[[medium[i]]] <- length(x[grep(medium[i], meta[2, -1])])
    }
    return(year)
  }))
  
  ## Clean up
  totals <- data.frame(totals)
  dimnames(totals) <- list(data[, 1], medium)
  
  return(totals)
}